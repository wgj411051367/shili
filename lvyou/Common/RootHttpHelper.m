#import "RootHttpHelper.h"
#import "AppDelegate.h"
#import "MessageHelper.h"
#import "JoDes.h"          // DES 解密（服务器响应加密）
#import "shili-Swift.h"
#import "GiftCateModel.h"

#pragma mark - Multipart Part

@implementation RootHttpMultipartPart
+ (instancetype)partWithData:(NSData *)data
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    mimeType:(NSString *)mimeType {
    RootHttpMultipartPart *p = [self new];
    p.data = data;
    p.name = name;
    p.fileName = fileName;
    p.mimeType = mimeType;
    return p;
}
@end

#pragma mark - 内部辅助：参数编码

// RFC 3986 / AFN 兼容的 percent escape：只编码 query 组件里需要保留的字符
static NSString *RHHPercentEscape(NSString *s) {
    static NSCharacterSet *allowed;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSMutableCharacterSet *set = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [set removeCharactersInString:@":#[]@!$&'()*+,;="];
        allowed = [set copy];
    });
    return [s stringByAddingPercentEncodingWithAllowedCharacters:allowed] ?: @"";
}

// 递归将 key/value 展开成 "encodedKey=encodedValue" 字符串数组
// 支持 dict 嵌套（key[child]=v）和 array（key[]=v）
static NSArray<NSString *> *RHHQueryPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *pairs = [NSMutableArray array];
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = value;
        NSArray *sortedKeys = [dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
        for (id k in sortedKeys) {
            NSString *nestedKey = [NSString stringWithFormat:@"%@[%@]", key, [k description]];
            [pairs addObjectsFromArray:RHHQueryPairsFromKeyAndValue(nestedKey, dict[k])];
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSString *nestedKey = [NSString stringWithFormat:@"%@[]", key];
        for (id item in (NSArray *)value) {
            [pairs addObjectsFromArray:RHHQueryPairsFromKeyAndValue(nestedKey, item)];
        }
    } else if (value == nil || [value isKindOfClass:[NSNull class]]) {
        [pairs addObject:[NSString stringWithFormat:@"%@=", RHHPercentEscape(key)]];
    } else {
        NSString *valueStr = [value description] ?: @"";
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",
                          RHHPercentEscape(key), RHHPercentEscape(valueStr)]];
    }
    return pairs;
}

static NSString *RHHQueryStringFromParameters(NSDictionary *parameters) {
    if (parameters.count == 0) return @"";
    NSMutableArray *pairs = [NSMutableArray array];
    NSArray *sortedKeys = [parameters.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (id k in sortedKeys) {
        [pairs addObjectsFromArray:RHHQueryPairsFromKeyAndValue([k description], parameters[k])];
    }
    return [pairs componentsJoinedByString:@"&"];
}

#pragma mark - 内部辅助：JSON 解析（含 DES 解密，对齐原 vendored AFN fork）

// 关键：服务器响应是 DES 加密的 base64 密文（Content-Type 谎称 application/json）。
// 原 vendored AFN 的 AFURLResponseSerialization 打了补丁：先试普通 JSON，失败
// （NSJSONSerialization 错误码 3840）就用 [JoDes decode:key:pwdConfig] 解密再解析。
// NSURLSession 重写时曾漏掉这一步，导致所有响应「JSON解析异常」。此处复刻。
id RHHParseJSON(NSData *data, NSError **outError) {
    if (data.length == 0) return nil;

    NSError *err = nil;
    // 1. 先按普通 JSON 解析（个别接口可能不加密）
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    if (obj) return obj;

    // 2. 失败 → 视为 DES 加密的 base64 密文，解密后再解析
    NSString *encryptStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (encryptStr.length > 0) {
        NSString *decryptStr = [JoDes decode:encryptStr key:pwdConfig];
        if (decryptStr.length > 0) {
            id decObj = [NSJSONSerialization JSONObjectWithData:[decryptStr dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:NSJSONReadingAllowFragments
                                                          error:&err];
            if (decObj) return decObj;
        }
    }
    if (outError) *outError = err;
    return nil;
}

#pragma mark - 内部辅助：multipart 拼装

static NSData *RHHMultipartBody(NSString *boundary,
                                NSDictionary *parameters,
                                NSArray<RootHttpMultipartPart *> *parts) {
    NSMutableData *body = [NSMutableData data];
    NSData *(^line)(NSString *) = ^NSData *(NSString *s) {
        return [s dataUsingEncoding:NSUTF8StringEncoding];
    };

    // 文本字段
    NSArray *sortedKeys = [parameters.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (id k in sortedKeys) {
        NSString *key = [k description];
        id raw = parameters[k];
        NSString *value = ([raw isKindOfClass:[NSNull class]] || raw == nil) ? @"" : [raw description];
        [body appendData:line([NSString stringWithFormat:@"--%@\r\n", boundary])];
        [body appendData:line([NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key])];
        [body appendData:line(value)];
        [body appendData:line(@"\r\n")];
    }

    // 二进制 parts
    for (RootHttpMultipartPart *part in parts) {
        if (part.data == nil) continue;
        [body appendData:line([NSString stringWithFormat:@"--%@\r\n", boundary])];
        [body appendData:line([NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                               part.name ?: @"", part.fileName ?: @""])];
        [body appendData:line([NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",
                               part.mimeType ?: @"application/octet-stream"])];
        [body appendData:part.data];
        [body appendData:line(@"\r\n")];
    }

    [body appendData:line([NSString stringWithFormat:@"--%@--\r\n", boundary])];
    return body;
}

#pragma mark - RootHttpHelper 实现

@interface RootHttpHelper ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSString *userToken;
@end

@implementation RootHttpHelper

+ (RootHttpHelper *)httpHelper {
    static RootHttpHelper *helper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [RootHttpHelper new];
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        cfg.timeoutIntervalForRequest = 8.0;
        cfg.HTTPAdditionalHeaders = @{
            @"Accept": @"application/json, text/json, text/javascript, text/plain, text/html, image/jpeg, image/png, application/octet-stream"
        };
        helper.session = [NSURLSession sessionWithConfiguration:cfg];
        helper.appDelegate = SharedAppDelegate;
    });
    return helper;
}

- (void)setUserToken:(NSString *)userToken {
    _userToken = [userToken copy];
}

- (NSMutableDictionary *)packageParameters:(NSMutableDictionary *)parameters {
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:parameters ?: @{}];
    NSString *lat, *lng;
    if ([SharedAppDelegate.nonceLat length] > 0 && [SharedAppDelegate.nonceLng length] > 0) {
        lat = SharedAppDelegate.nonceLat;
        lng = SharedAppDelegate.nonceLng;
    } else {
        lat = @"0.000";
        lng = @"0.000";
    }
    if (![p.allKeys containsObject:@"lat"]) {
        [p setValue:lat forKey:@"lat"];
        [p setValue:lng forKey:@"lng"];
    }
    return p;
}

#pragma mark - 核心调度

- (NSURLSessionDataTask *)dispatchMethod:(NSString *)method
                                     URL:(NSString *)urlString
                              parameters:(NSDictionary *)parameters
                               multipart:(NSArray<RootHttpMultipartPart *> *)multipart
                                 success:(void (^)(NSURLSessionDataTask *, id))success
                                 failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {

    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = method;
    request.timeoutInterval = 8.0;
    if (self.userToken.length > 0) {
        [request setValue:self.userToken forHTTPHeaderField:Authorization];
    }

    NSString *finalURL = urlString;
    NSString *query = RHHQueryStringFromParameters(parameters);

    if ([method isEqualToString:@"GET"]) {
        if (query.length > 0) {
            NSString *sep = [urlString containsString:@"?"] ? @"&" : @"?";
            finalURL = [urlString stringByAppendingFormat:@"%@%@", sep, query];
        }
        request.URL = [NSURL URLWithString:finalURL];
    } else {
        request.URL = [NSURL URLWithString:urlString];
        if (multipart != nil) {
            NSString *boundary = [NSString stringWithFormat:@"Boundary-%08x%08x",
                                  arc4random(), arc4random()];
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
            request.HTTPBody = RHHMultipartBody(boundary, parameters, multipart);
        } else {
            [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            request.HTTPBody = [query dataUsingEncoding:NSUTF8StringEncoding];
        }
    }

    if (request.URL == nil) {
        NSError *err = [NSError errorWithDomain:@"RootHttpHelper"
                                           code:NSURLErrorBadURL
                                       userInfo:@{NSLocalizedDescriptionKey:
                                                      [NSString stringWithFormat:@"Invalid URL: %@", finalURL ?: @""]}];
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{ failure(nil, err); });
        }
        return nil;
    }

    __block NSURLSessionDataTask *task = nil;
    task = [self.session dataTaskWithRequest:request
                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{ failure(task, error); });
            }
            return;
        }

        NSError *jsonError = nil;
        id obj = RHHParseJSON(data, &jsonError);
        if (jsonError || obj == nil) {
            // 诊断：dump 真实响应，定位「JSON解析异常」到底服务器返回了什么
            NSString *raw = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSHTTPURLResponse *http = [response isKindOfClass:[NSHTTPURLResponse class]] ? (NSHTTPURLResponse *)response : nil;
            NSLog(@"[RootHttpHelper] JSON解析失败\n  URL: %@\n  HTTP状态: %ld\n  Content-Type: %@\n  响应长度: %lu\n  原始响应: %@",
                  request.URL.absoluteString,
                  (long)http.statusCode,
                  http.allHeaderFields[@"Content-Type"],
                  (unsigned long)data.length,
                  raw.length > 2000 ? [raw substringToIndex:2000] : (raw ?: @"(非UTF8/nil)"));

            NSError *err = jsonError ?: [NSError errorWithDomain:@"RootHttpHelper"
                                                            code:-1
                                                        userInfo:@{NSLocalizedDescriptionKey:@"JSON解析异常"}];
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{ failure(task, err); });
            }
            return;
        }

        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{ success(task, obj); });
        }
    }];
    [task resume];
    return task;
}

#pragma mark - 错误处理（与原 AFN 路径一致）

- (void)reportNetworkError:(NSError *)error
              toController:(UIViewController *)targetVC
              withFallback:(void (^)(NSDictionary *))successBlock {
    NSString *msg = error.userInfo[NSLocalizedDescriptionKey] ?: @"JSON解析异常";
    if (successBlock) {
        successBlock(@{@"api_code":@"-1", @"api_msg": msg});
    }
    if (error.userInfo[NSLocalizedDescriptionKey] == nil) return;
    if (error.code == NSURLErrorTimedOut) {
        // 原代码也是不弹（注释掉的）
    } else if (error.code == NSURLErrorNotConnectedToInternet) {
        [[MessageHelper messageHelper] showWarnMessage:targetVC title:@"" sub:@"网络未连接"];
    } else {
        [[MessageHelper messageHelper] showWarnMessage:targetVC title:@"" sub:msg];
    }
}

#pragma mark - 基础 GET/POST（带 DATAAPI/APIVersion 前缀，失败有 toast）

- (void)basicGetURL:(NSString *)requestURL
      andController:(UIViewController *)targetVC
            andView:(UIView *)targetView
          andParams:(NSMutableDictionary *)requestParams
         andSuccess:(void (^)(NSDictionary *))successBlock {
    NSString *raw = [NSString stringWithFormat:@"%@%@/%@", DATAAPI, APIVersion, requestURL];
    NSString *URL = [raw stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ?: raw;
    [self dispatchMethod:@"GET"
                     URL:URL
              parameters:[self packageParameters:requestParams]
               multipart:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
        if (successBlock && [responseObject isKindOfClass:[NSDictionary class]]) {
            successBlock([NSDictionary dictionaryWithDictionary:responseObject]);
        }
    }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self reportNetworkError:error toController:targetVC withFallback:successBlock];
    }];
}

- (void)basicPostURL:(NSString *)requestURL
       andController:(UIViewController *)targetVC
             andView:(UIView *)targetView
           andParams:(NSMutableDictionary *)requestParams
          andSuccess:(void (^)(NSDictionary *))successBlock {
    NSString *raw = [NSString stringWithFormat:@"%@%@/%@", DATAAPI, APIVersion, requestURL];
    NSString *URL = [raw stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ?: raw;
    [self dispatchMethod:@"POST"
                     URL:URL
              parameters:[self packageParameters:requestParams]
               multipart:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
        if (successBlock && [responseObject isKindOfClass:[NSDictionary class]]) {
            successBlock([NSDictionary dictionaryWithDictionary:responseObject]);
        }
    }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self reportNetworkError:error toController:targetVC withFallback:successBlock];
    }];
}

- (void)basicPostURL2:(NSString *)URL
        andController:(UIViewController *)targetVC
              andView:(UIView *)targetView
            andParams:(NSMutableDictionary *)requestParams
           andSuccess:(void (^)(NSDictionary *))successBlock {
    [self dispatchMethod:@"POST"
                     URL:URL
              parameters:[self packageParameters:requestParams]
               multipart:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
        if (successBlock && [responseObject isKindOfClass:[NSDictionary class]]) {
            successBlock([NSDictionary dictionaryWithDictionary:responseObject]);
        }
    }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self reportNetworkError:error toController:targetVC withFallback:successBlock];
    }];
}

#pragma mark - 原样 URL 的 GET/POST（失败静默，与原代码一致）

- (void)basicGETURL2:(NSString *)URL
       andController:(UIViewController *)targetVC
             andView:(UIView *)targetView
           andParams:(NSMutableDictionary *)requestParams
          andSuccess:(void (^)(NSDictionary *))successBlock {
    [self dispatchMethod:@"GET"
                     URL:URL
              parameters:[self packageParameters:requestParams]
               multipart:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
        if (successBlock && [responseObject isKindOfClass:[NSDictionary class]]) {
            successBlock([NSDictionary dictionaryWithDictionary:responseObject]);
        }
    }
                 failure:nil];
}

- (void)basicPOSTURL2:(NSString *)URL
        andController:(UIViewController *)targetVC
              andView:(UIView *)targetView
            andParams:(NSMutableDictionary *)requestParams
           andSuccess:(void (^)(NSDictionary *))successBlock {
    [self dispatchMethod:@"POST"
                     URL:URL
              parameters:[self packageParameters:requestParams]
               multipart:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
        if (successBlock && [responseObject isKindOfClass:[NSDictionary class]]) {
            successBlock([NSDictionary dictionaryWithDictionary:responseObject]);
        }
    }
                 failure:nil];
}

#pragma mark - 次级方法（api_code 路由）

- (void)achieveCommonGetURL:(NSString *)path
              andController:(UIViewController *)targetVC
                    andView:(UIView *)targetView
                  andParams:(NSMutableDictionary *)params
                 andSuccess:(void (^)(NSDictionary *))successBlock {
    [self basicGetURL:path andController:targetVC andView:targetView andParams:params andSuccess:^(NSDictionary *successData) {
        NSInteger code = [successData[@"api_code"] integerValue];
        if (code == 598) {
            [self forceExit];
        } else if (code == 505) {
            [self loginout];
        } else if (successBlock) {
            successBlock(successData);
        }
    }];
}

- (void)achieveCommonGetURL2:(NSString *)path
               andController:(UIViewController *)targetVC
                     andView:(UIView *)targetView
                   andParams:(NSMutableDictionary *)params
                  andSuccess:(void (^)(NSDictionary *))successBlock {
    [self basicGETURL2:path andController:targetVC andView:targetView andParams:params andSuccess:^(NSDictionary *successData) {
        NSInteger code = [successData[@"api_code"] integerValue];
        if (code == 598) {
            [self forceExit];
        } else if (code == 505) {
            [self loginout];
        } else if (successBlock) {
            successBlock(successData);
        }
    }];
}

- (void)achieveCommonPostURL:(NSString *)path
               andController:(UIViewController *)targetVC
                     andView:(UIView *)targetView
                   andParams:(NSMutableDictionary *)params
                  andSuccess:(void (^)(NSDictionary *))successBlock {
    [self basicPostURL:path andController:targetVC andView:targetView andParams:params andSuccess:^(NSDictionary *successData) {
        NSInteger code = [successData[@"api_code"] integerValue];
        if (code == 598) {
            [self forceExit];
        } else if (code == 505) {
            [self loginout];
        } else {
            if (successBlock) successBlock(successData);
            if (code != 200) {
                [[MessageHelper messageHelper] showMessage:targetVC title:@"" sub:successData[@"api_msg"]];
            }
        }
    }];
}

- (void)achieveCommonPostURL2:(NSString *)path
                andController:(UIViewController *)targetVC
                      andView:(UIView *)targetView
                    andParams:(NSMutableDictionary *)params
                   andSuccess:(void (^)(NSDictionary *))successBlock {
    [self basicPostURL2:path andController:targetVC andView:targetView andParams:params andSuccess:^(NSDictionary *successData) {
        NSInteger code = [successData[@"api_code"] integerValue];
        if (code == 598) {
            [self forceExit];
        } else if (code == 505) {
            [self loginout];
        } else if (successBlock) {
            successBlock(successData);
        }
    }];
}

#pragma mark - Multipart 上传

- (void)uploadURL:(NSString *)url
       parameters:(NSDictionary *)params
            parts:(NSArray<RootHttpMultipartPart *> *)parts
          success:(void (^)(NSURLSessionDataTask *, id))success
          failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [self dispatchMethod:@"POST"
                     URL:url
              parameters:params
               multipart:parts ?: @[]
                 success:success
                 failure:failure];
}

#pragma mark - 用户资料

- (void)basicGetUserInfoURL:(NSString *)requestURL
                  andParams:(NSMutableDictionary *)requestParams
                 andSuccess:(void (^)(NSDictionary *))successBlock
                 andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failureBlock {
    [self dispatchMethod:@"GET"
                     URL:requestURL
              parameters:[self packageParameters:requestParams]
               multipart:nil
                 success:^(NSURLSessionDataTask *task, id responseObject) {
        if (successBlock && [responseObject isKindOfClass:[NSDictionary class]]) {
            successBlock([NSDictionary dictionaryWithDictionary:responseObject]);
        }
    }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failureBlock) failureBlock(task, error);
    }];
}

+ (NSDictionary *)getUserInfo:(NSString *)userid {
    NSString *token = SharedAppDelegate.userModel.token ?: @"";
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@%@?token=%@",
                           DATAAPI, APIVersion, @"users/detail/", userid, token];
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) return nil;

    __block NSData *data = nil;
    __block NSError *error = nil;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    cfg.timeoutIntervalForRequest = 8.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:cfg];

    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        data = d;
        error = e;
        dispatch_semaphore_signal(sema);
    }];
    [task resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    [session finishTasksAndInvalidate];

    if (error || data == nil) return nil;

    NSString *raw = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (raw == nil) return nil;

    // 保留原代码的 "null" → "\"\"" 替换 hack
    raw = [raw stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    NSData *cleaned = [raw dataUsingEncoding:NSUTF8StringEncoding];

    NSError *jsonError = nil;
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:cleaned options:0 error:&jsonError];
    if (jsonError || ![info isKindOfClass:[NSDictionary class]]) return nil;
    return info;
}

#pragma mark - 缓存：等级 / 配置

- (void)forceExit {
    // 原方法体为空（历史 TODO），保留
}

- (void)requestBalanceToBiLi {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [self basicGetURL:Config andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        NSInteger code = [successData[@"api_code"] integerValue];
        if (code != 200) {
            [self requestBalanceToBiLi];
            return;
        }

        NSMutableDictionary *rank = [NSMutableDictionary dictionary];
        for (NSDictionary *dic in (NSArray *)successData[@"data"]) {
            [rank setValue:dic forKey:dic[@"id"]];
        }
        SharedAppDelegate.rankDic = rank;

        NSMutableDictionary *zhuboRank = [NSMutableDictionary dictionary];
        for (NSDictionary *dic in (NSArray *)successData[@"data_show"]) {
            NSInteger rankid = [dic[@"id"] integerValue] - 100;
            [zhuboRank setValue:dic forKey:[NSString stringWithFormat:@"%ld", (long)rankid]];
        }
        SharedAppDelegate.zhuboRankDic = zhuboRank;

        [userDefaultes setObject:rank forKey:RankListKey];

        NSDictionary *config = successData[@"config"];

        BOOL isExist = [self isFileExistWithFilePath:[userDefaultes objectForKey:@"kaibo_title"]];
        if (isExist) {
            [self setObject:config[@"kaibo_title"] with:@"kaibo_title"];
        }

        NSString *chat = config[@"chat_address"];
        NSString *imageapi = config[@"cdn_domain"];
        NSString *dataapi = config[@"userlist_domain"];
        NSString *xmpp = config[@"im_domain"];
        NSString *shareAddress = config[@"room_share_address"];
        NSString *sharejumpurl = config[@"share_jump_url"];

        [self setObject:config[@"kefu_wx_1"] with:@"kefu_wx_1"];
        [self setObject:config[@"kefu_wx_2"] with:@"kefu_wx_2"];
        [self setObject:config[@"usernumber_name"] with:@"usernumber_name"];
        [self setObject:chat with:@"chat_address"];
        [self setObject:imageapi with:@"cdn_domain"];
        [self setObject:dataapi with:@"userlist_domain"];
        [self setObject:xmpp with:@"im_domain"];
        [self setObject:shareAddress with:@"room_share_address"];
        [self setObject:sharejumpurl with:@"share_jump_url"];
        [self getDataAndImageWithChat:chat andImage:imageapi andDATAAPITWO:dataapi andXMPPDOMAIN:xmpp andH5:shareAddress];

        [self setObject:config[@"pay_manual"] with:@"pay_manual"];
        [self setObject:config[@"home_tip"] with:@"home_tip"];
        [self setObject:config[@"upload_file_type"] with:@"upload_file_type"];
        [self setObject:config[@"upload_file_api_address"] with:@"upload_file_api_address"];
        [self setObject:config[@"upload_file_aliyun_oss_domain"] with:@"upload_file_aliyun_oss_domain"];
        [self setObject:config[@"upload_file_aliyun_oss_name"] with:@"upload_file_aliyun_oss_name"];
        [self setObject:config[@"upload_file_aliyun_access_id"] with:@"upload_file_aliyun_access_id"];
        [self setObject:config[@"upload_file_aliyun_access_key"] with:@"upload_file_aliyun_access_key"];
        [self setObject:config[@"phone_number"] with:@"phone_number"];
        [self setObject:config[@"flymsg_price"] with:@"flymsg_price"];
        [self setObject:config[@"announce_price"] with:@"announce_price"];
        [self setObject:config[@"show_info_level"] with:@"show_info_level"];
        [self setObject:config[@"money_name"] with:@"money_name"];
        [self setObject:config[@"money_name2"] with:@"money_name2"];
        [self setObject:config[@"person_verify"] with:@"person_verify"];
        [self setObject:config[@"RMB_XNB"] with:@"RMB_XNB"];
        [self setObject:config[@"pay_IPHONE_REDUCE"] with:@"pay_IPHONE_REDUCE"];
        [self setObject:config[@"quanfu_hongbao_price"] with:@"quanfu_hongbao_price"];
    }];
}

- (void)setObject:(NSString *)setObject with:(NSString *)setKey {
    if (setObject == nil || [setObject isKindOfClass:[NSNull class]]) return;
    [[NSUserDefaults standardUserDefaults] setObject:setObject forKey:setKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getDataAndImageWithChat:(NSString *)chat
                       andImage:(NSString *)imageapi
                  andDATAAPITWO:(NSString *)dataapi
                  andXMPPDOMAIN:(NSString *)xmpp
                          andH5:(NSString *)h5url {
    if (![chat isKindOfClass:[NSNull class]] && chat) CHAT = chat;
    if (![imageapi isKindOfClass:[NSNull class]] && imageapi) IMAGEAPI = imageapi;
    if (![h5url isKindOfClass:[NSNull class]] && h5url) ShareURL = h5url;
    if (![dataapi isKindOfClass:[NSNull class]] && dataapi) DATAAPITWO = dataapi;
    if (![xmpp isKindOfClass:[NSNull class]] && xmpp) {
        XMPPDOMAIN = xmpp;
        [[NSUserDefaults standardUserDefaults] setObject:xmpp forKey:@"xmppurl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SharedAppDelegate setupStream];
    }
}

- (BOOL)isFileExistWithFilePath:(NSString *)title {
    if (title.length == 0) return NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths.firstObject stringByAppendingPathComponent:title];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

- (void)requestHorseList {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"page"];
    [params setValue:@"1000" forKey:@"num"];
    [self basicGetURL:horse_list andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
        NSInteger code = [successData[@"api_code"] integerValue];
        if (code != 200) {
            [self requestHorseList];
            return;
        }
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:successData[@"data"]];
        [userDefaultes setValue:data forKey:HorseListKey];
        [userDefaultes synchronize];
        NSMutableDictionary *horse = [NSMutableDictionary dictionary];
        NSArray *dataArr = successData[@"data"];
        if (dataArr.count > 0) {
            for (NSDictionary *dic in (NSArray *)[dataArr.firstObject objectForKey:@"horses"]) {
                [horse setValue:dic forKey:dic[@"id"]];
            }
        }
        SharedAppDelegate.horseDic = horse;
    }];
}

- (void)requestGiftList {
    NSMutableArray *catenameArr = [NSMutableArray array];
    [self basicGetURL:@"gift/cate" andController:nil andView:nil andParams:[@{@"test":@"1"} mutableCopy] andSuccess:^(NSDictionary *successData) {
        NSInteger code = [successData[@"api_code"] integerValue];
        [catenameArr removeAllObjects];
        if (code != 200) return;
        for (NSDictionary *cate in (NSArray *)successData[@"data"]) {
            NSError *err = nil;
            GiftCateModel *giftcate = [[GiftCateModel alloc] initWithDictionary:cate error:&err];
            if (giftcate) [catenameArr addObject:giftcate];
        }
        SharedAppDelegate.giftCateArray = catenameArr;
    }];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"page"];
    [params setValue:@"1000" forKey:@"num"];
    [self basicGetURL:gift_list andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
        NSInteger code = [successData[@"api_code"] integerValue];
        if (code != 200) {
            [self requestGiftList];
            return;
        }
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:successData[@"data"]];
        [userDefaultes setValue:data forKey:RequestGiftListKey];
        [userDefaultes synchronize];
        NSMutableDictionary *gift = [NSMutableDictionary dictionary];
        for (NSDictionary *dic in (NSArray *)successData[@"data"]) {
            [gift setValue:dic forKey:dic[@"id"]];
        }
        SharedAppDelegate.giftDic = gift;
    }];
}

#pragma mark - 退出登录

- (void)loginout {
    if (![AppDelegate appDelegate].isLogin) return;
    [AppDelegate appDelegate].isLogin = NO;

    [[RootHttpHelper httpHelper] achieveCommonPostURL:users_logout andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        NSLog(@"%@", successData);
    }];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"" forKey:@"apnsdevice"];
    [params setValue:@"" forKey:@"apnstoken"];
    [[RootHttpHelper httpHelper] achieveCommonPostURL:update_apnstoken andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {}];

    [[RootHttpHelper httpHelper] setUserToken:@""];
    SharedAppDelegate.userModel.token = nil;
    [SharedAppDelegate removeAllDefaultData];

    if (SharedAppDelegate.window.rootViewController) {
        SharedAppDelegate.window.rootViewController = nil;
    }
    LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
    BaseNavigationController *navigationView = [[BaseNavigationController alloc] initWithRootViewController:loginView];
    loginView.isOut = YES;
    SharedAppDelegate.window.rootViewController = navigationView;
}

@end

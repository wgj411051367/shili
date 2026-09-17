#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "HttpMacro.h"

// AppDelegate.h 是「上帝头文件」（拖入 Tencent/GPUImage/KSY/BaseViewController→ALAsset），
// 这里只用它作属性类型，改为前向声明，让本头文件可安全进 Swift bridging header。
@class AppDelegate;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Multipart 上传分片

@interface RootHttpMultipartPart : NSObject
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *mimeType;
+ (instancetype)partWithData:(NSData *)data
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    mimeType:(NSString *)mimeType;
@end

#pragma mark - 主 HTTP 封装

@interface RootHttpHelper : NSObject

@property (weak, nonatomic, nullable) AppDelegate *appDelegate;

/// 单例。Swift 里必须用 `RootHttpHelper.shared()` 拿到它——直接 `RootHttpHelper()`
/// 会被 Swift 当成 NSObject 的 -init 创建一个 session/token 都为 nil 的空实例，
/// 请求根本发不出去（详见 2026-07-11 手机绑定发验证码排查）。
+ (RootHttpHelper *)httpHelper NS_SWIFT_NAME(shared());

- (void)setUserToken:(NSString *)userToken;

#pragma mark - GET 方法
- (void)basicGetURL:(NSString *)requestURL
      andController:(nullable UIViewController *)targetVC
            andView:(nullable UIView *)targetView
          andParams:(nullable NSMutableDictionary *)requestParams
         andSuccess:(void (^)(NSDictionary *successData))successBlock;

#pragma mark - POST 方法
- (void)basicPostURL:(NSString *)requestURL
       andController:(nullable UIViewController *)targetVC
             andView:(nullable UIView *)targetView
           andParams:(nullable NSMutableDictionary *)requestParams
          andSuccess:(void (^)(NSDictionary *successData))successBlock;

- (void)basicPostURL2:(NSString *)URL
        andController:(nullable UIViewController *)targetVC
              andView:(nullable UIView *)targetView
            andParams:(nullable NSMutableDictionary *)requestParams
           andSuccess:(void (^)(NSDictionary *successData))successBlock;

#pragma mark - 次级 GET 方法（带 api_code 路由）
- (void)achieveCommonGetURL:(NSString *)path
              andController:(nullable UIViewController *)targetVC
                    andView:(nullable UIView *)targetView
                  andParams:(nullable NSMutableDictionary *)params
                 andSuccess:(void (^)(NSDictionary *successData))successBlock;

- (void)achieveCommonGetURL2:(NSString *)path
               andController:(nullable UIViewController *)targetVC
                     andView:(nullable UIView *)targetView
                   andParams:(nullable NSMutableDictionary *)params
                  andSuccess:(void (^)(NSDictionary *successData))successBlock;

#pragma mark - 次级 POST 方法
- (void)achieveCommonPostURL:(NSString *)path
               andController:(nullable UIViewController *)targetVC
                     andView:(nullable UIView *)targetView
                   andParams:(nullable NSMutableDictionary *)params
                  andSuccess:(void (^)(NSDictionary *successData))successBlock;

- (void)achieveCommonPostURL2:(NSString *)path
                andController:(nullable UIViewController *)targetVC
                      andView:(nullable UIView *)targetView
                    andParams:(nullable NSMutableDictionary *)params
                   andSuccess:(void (^)(NSDictionary *successData))successBlock;

#pragma mark - 原样 URL 的 GET/POST（不拼 DATAAPI/APIVersion）
- (void)basicGETURL2:(NSString *)URL
       andController:(nullable UIViewController *)targetVC
             andView:(nullable UIView *)targetView
           andParams:(nullable NSMutableDictionary *)requestParams
          andSuccess:(void (^)(NSDictionary *successData))successBlock;

- (void)basicPOSTURL2:(NSString *)URL
        andController:(nullable UIViewController *)targetVC
              andView:(nullable UIView *)targetView
            andParams:(nullable NSMutableDictionary *)requestParams
           andSuccess:(void (^)(NSDictionary *successData))successBlock;

#pragma mark - Multipart 上传（替代原 AFN manager.POST:constructingBodyWithBlock:）
- (void)uploadURL:(NSString *)url
       parameters:(nullable NSDictionary *)params
            parts:(NSArray<RootHttpMultipartPart *> *)parts
          success:(void (^_Nullable)(NSURLSessionDataTask *task, id responseObject))success
          failure:(void (^_Nullable)(NSURLSessionDataTask *_Nullable task, NSError *error))failure;

#pragma mark - 缓存接口
- (void)requestBalanceToBiLi;
- (void)requestGiftList;
- (void)requestHorseList;

#pragma mark - 用户资料
- (void)basicGetUserInfoURL:(NSString *)requestURL
                  andParams:(nullable NSMutableDictionary *)requestParams
                 andSuccess:(void (^)(NSDictionary *successData))successBlock
                 andFailure:(void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

#pragma mark - 同步取用户信息（保留原阻塞语义，主线程慎用）
+ (nullable NSDictionary *)getUserInfo:(NSString *)userid;

@end

NS_ASSUME_NONNULL_END

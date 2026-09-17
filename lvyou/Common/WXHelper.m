// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  WXHelper.m
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "WXHelper.h"
#import "RootHttpHelper.h"
#import "AppDelegate.h"
#import "HUDHelper2.h"
#import <WebKit/WebKit.h>

@interface WXHelper ()
{
    NSString *access_token;
    NSString *openid;
    //1.4
    NSMutableDictionary *uniondic;
    NSString *unionidStr;
}
@property (nonatomic, strong) WKWebView* webView;
@end

@implementation WXHelper
-(id)init
{
    if (self = [super init]) {
        __weak typeof(self)weakself =self;
        SharedAppDelegate.wxGetAccess_token = ^(NSString *wxCode){
            [weakself getAccess_token:wxCode];
        };
    }
    return self;
}

#pragma mark - 初始化方法
+ (WXHelper*)wxHelper
{
    static WXHelper *wxHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wxHelper = [[WXHelper alloc] init];
        
    });
    return wxHelper;
}

//2018.1.4  获取unionid
//- (NSMutableDictionary*)uniondic{
//    if (uniondic == nil) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"Register" ofType:@"plist"];
//        uniondic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//        unionidStr=uniondic[@"unionid"];
//    }
//    return uniondic;
//}

#pragma mark - 登录方法
- (void)getWXOauth:(UIViewController *)viewController
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendAuthReq:req viewController:viewController delegate:[AppDelegate appDelegate] completion:nil];
    //1.4获取plist文件中的值
//    [self uniondic];
}
-(void)getAccess_token:(NSString *)wxCode
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kwxAppId,kwxSecret,wxCode];    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                NSLog(@"wx  ==dict %@",dic);
                access_token = [dic objectForKey:@"access_token"];
                openid = [dic objectForKey:@"openid"];
                [self getUserInfo];
            }
        });
    });
}
-(void)getUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (SharedAppDelegate.isBandWX) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setValue:@"4" forKey:@"type"];
                [params setValue:openid forKey:@"external_uid"];
                [params setValue:[dic objectForKey:@"nickname"] forKey:@"external_name"];
                [params setValue:access_token forKey:@"token"];
                [params setValue:[dic objectForKey:@"unionid"] forKey:@"other"];
                //2019.1.2获取免邀请码的uid
                NSString *unionidString=[SharedAppDelegate unionidStr];
                if (unionidString!=nil) {
                    [params setValue:unionidString forKey:@"u"];
                }
                [[RootHttpHelper httpHelper] achieveCommonPostURL:users_bind
                                                            andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData)
                {
                        [[HUDHelper2 sharedInstance] syncStopLoadingMessage:[successData objectForKey:@"data"]];
                    for (NSMutableDictionary *dic in successData[@"data"][@"oauths"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatInfo" object:nil userInfo:dic];
                    }
                }];
            } else {
                self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
                // iOS 26+：脱离视图层级的 WKWebView 其 WebContent 进程会被立即回收，
                // evaluateJavaScript 的 completion 永不触发 → 微信登录卡死。
                // 把它加进 window（0 尺寸、隐藏）让渲染进程存活到 JS 执行完。
                self.webView.hidden = YES;
                [SharedAppDelegate.window addSubview:self.webView];
                [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError * _Nullable error) {
                    [self.webView removeFromSuperview];
                    NSString* secretAgent = result;
                    if ([dic objectForKey:@"unionid"]==nil)
                    {
                        UIAlertController *control =[UIAlertController alertControllerWithTitle:@"" message:@"获取登录信息出错了，请检查" preferredStyle:UIAlertControllerStyleAlert];
                        [SharedAppDelegate.window.rootViewController presentViewController:control animated:YES completion:nil];
                        UIAlertAction *sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [control addAction:sure];
                        return;
                    }
                    ///5.15修改
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    [param setValue:@"4" forKey:@"type"];
                    if ([dic objectForKey:@"unionid"]!=nil) {
                        [param setValue:[dic objectForKey:@"unionid"] forKey:@"external_uid"];
                    }
                    if (openid!=nil) {
                      [param setValue:openid forKey:@"openid"];
                    }
                    if ([dic objectForKey:@"nickname"]!=nil) {
                        [param setValue:[dic objectForKey:@"nickname"] forKey:@"external_name"];
                    }
                    if (access_token!=nil) {
                       [param setValue:access_token forKey:@"token"];
                    }
                    if ([dic objectForKey:@"unionid"]!=nil) {
                       [param setValue:[dic objectForKey:@"unionid"] forKey:@"other"];
                    }
                    if ([dic objectForKey:@"headimgurl"]!=nil) {
                        NSMutableArray *temp = [NSMutableArray arrayWithArray:[[dic objectForKey:@"headimgurl"] componentsSeparatedByString:@"/"]];
                        [temp removeLastObject];
                        [temp addObject:@"0"];
                        NSString *avatar = [temp componentsJoinedByString:@"/"];
                        [param setValue:avatar forKey:@"avatar"];
                    }
                    if ([dic objectForKey:@"sex"]!=nil) {
                        if ([[dic objectForKey:@"sex"] intValue] == 1) {
                            [param setValue:@"1" forKey:@"gender"];
                        } else {
                            [param setValue:@"0" forKey:@"gender"];
                        }
                    }
                    if (secretAgent!=nil) {
                        [param setValue:secretAgent forKey:@"agent"];
                    }
                    //登录成功之后更新apnstoken
                   NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:param];
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                    [params setValue:[userDefaults objectForKey:@"apnstoken"] forKey:@"apnstoken"];
                    [params setValue:MyAppBuilder forKey:@"version_app"];
                    //2019.1.2获取免邀请码的uid
                    NSString *unionidString=[SharedAppDelegate unionidStr];
                    if (unionidString!=nil) {
                        [params setValue:unionidString forKey:@"u"];
                    }
                     [[RootHttpHelper httpHelper] achieveCommonPostURL:users_oauth andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
                        
                        //NSLog(@"+++++++++++++请求到的数据users_oauth: %@",successData);
                         if ([[successData objectForKey:@"api_code"] intValue]!=200) {
                             if (successData[@"ios_add_address"]) {
                                 UIAlertController *control =[UIAlertController alertControllerWithTitle:@"" message:successData[@"api_msg"] preferredStyle:UIAlertControllerStyleAlert];
                                 [SharedAppDelegate.window.rootViewController presentViewController:control animated:YES completion:nil];
                                 UIAlertAction *sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:successData[@"ios_add_address"]]];
                                 }];
                                 [control addAction:sure];
                             }
                             return;
                         }
                        NSError *err = nil;
                        UserModel *userModel = [[UserModel alloc] initWithDictionary:successData error:&err];
                        SharedAppDelegate.userModel = userModel;
                        [[RootHttpHelper httpHelper] setUserToken:userModel.token];

                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCommounicate"];
                         if (SharedAppDelegate.userModel.user.id!=nil) { // 5.30登录的时候保存自己的userid以及启动时间
                             [[NSUserDefaults standardUserDefaults] setObject:SharedAppDelegate.userModel.user.id forKey:@"userid"];
                             [[NSUserDefaults standardUserDefaults] setObject:SharedAppDelegate.launchTime forKey:@"time"];
                         }
                        [userDefaults setObject:userModel.token forKey:@"token"];
                         //3.22存market
                        [userDefaults setObject:SharedAppDelegate.userModel.user.market forKey:@"market"];
                        [userDefaults synchronize];
                        // 创建tabbarController
                        BaseTabBarController * tabBarVC = [[BaseTabBarController alloc] init];
                        // 设置跟控制器
                        SharedAppDelegate.window.rootViewController = tabBarVC;

                         //登录之后获取等级列表和比例
                         [[RootHttpHelper httpHelper] requestBalanceToBiLi];
                         //6.26 获取礼物列表
                         [[RootHttpHelper httpHelper] requestGiftList];
                         //8.1 获取座驾列表
                         [[RootHttpHelper httpHelper] requestHorseList];
                        //1.10 切换账号再次登录的时候链接聊天xmpp
                        //    连接私信
                        [SharedAppDelegate setupStream];
                    }];
                }];
              }
            }
        });
    });
}
#pragma mark - 向微信分享(朋友圈和好友)
- (void)shareLinkToWx:(NSString *)url atIndex:(NSInteger)index andTitle:(NSString *)titleStr andInfo:(NSString *)messageStr andImage:(UIImage *)avatar
{
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;           //不使用文本信息
    sendReq.scene = (int)index;      //0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = titleStr;                     //分享标题
    if(messageStr.length > 20)
    {
        messageStr = [messageStr substringToIndex:20];
    }
    urlMessage.description = messageStr;             //分享描述

    NSData * data = UIImageJPEGRepresentation([avatar imageByScalingAndCroppingForSize:CGSizeMake(100, 100)],1);
    
    [urlMessage setThumbImage:[[UIImage alloc] initWithData:data]]; //分享图片,使用SDK的setThumbImage方法可压缩图片大小

    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;      //分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq completion:nil];
}

// 微信支付已整体下线（虚拟币充值走苹果内购 IAP）：
// weChatPayOrderTitle / wxPayWithOrder / generateTradeNO + payRequsestHandler + WeChatOrder 已删。
// 本类只保留微信登录(getWXOauth) 与 分享(shareLinkToWx)。

@end

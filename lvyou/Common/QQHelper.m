// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  QQHelper.m
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "QQHelper.h"
#import "AppDelegate.h"
#import "RootHttpHelper.h"
#import <WebKit/WebKit.h>

@interface QQHelper ()

@property (nonatomic, strong) WKWebView* webView;
@end

@implementation QQHelper
@synthesize
tencentOauth;

#pragma mark - 初始化方法
+ (QQHelper*)qqHelper
{
    static QQHelper *qqHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        qqHelper = [[QQHelper alloc] init];
    });
    return qqHelper;
}
- (void)getUnionid
{
    NSString *url=[NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@&unionid=1",tencentOauth.accessToken];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       if (error == nil) {
          //4.解析服务器返回的数据
           NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           if ([string containsString:@"callback"]) {
               NSRange startrange=[string rangeOfString:@"callback("];
               NSRange endrange=[string rangeOfString:@")"];
               NSRange range=NSMakeRange(startrange.location+startrange.length, endrange.location-startrange.location-startrange.length);
               NSString *result=[string substringWithRange:range];
               NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
               NSError *err;
               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                 options:NSJSONReadingMutableContainers error:&err];
//               unionidstr=dic[@"unionid"];
//               NSLog(@"unionidstr===%@",unionidstr);
           }
         }
       }];
       //5.执行任务
       [dataTask resume];
}
//2018.1.4  获取unionid
- (NSMutableDictionary*)uniondic{
    if (uniondic == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Register" ofType:@"plist"];
        uniondic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        unionidStr=uniondic[@"unionid"];
    }
    return uniondic;
}
#pragma mark - 登录方法
// getQQOauth（QQ 登录入口）已废弃删除——QQ 登录不再使用，仅保留 QQ 分享。

#pragma mark - 向QQ分享(空间和好友)
- (void)shareLinkToQQ:(NSString*)url atIndex:(NSInteger)index andTitle:(NSString *)titleStr andInfo:(NSString *)messageStr andImage:(UIImage *)avatar
{
    tencentOauth = [[TencentOAuth alloc]initWithAppId:kqqAppId andDelegate:self];
    
    NSString *utf8String = url;
    NSString *title = titleStr;
    NSString *description = messageStr;
    if(description.length > 20)
    {
        description = [messageStr substringToIndex:20];
    }
    
    NSData *previewImageData = UIImageJPEGRepresentation([avatar imageByScalingAndCroppingForSize:CGSizeMake(100, 100)],1);
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageData:previewImageData];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    if(index == 3)
    {
        //将内容分享到qzone
        [QQApiInterface SendReqToQZone:req];
        
    }else if (index == 2)
    {
        //将内容分享到qq
        [QQApiInterface sendReq:req];
        
    }
}
#pragma mark - QQ回调
#pragma mark   登录成功
- (void)tencentDidLogin
{
    //NSLog(@"+++++++++++++++用户授权成功");
    AppDelegate * appDelegate = SharedAppDelegate;
    //获取用户信息
    if (tencentOauth.accessToken && 0 != [tencentOauth.accessToken length])
    {
//      [self getUnionid];//2018.3.14获取unionid
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [tencentOauth getUserInfo]; //延迟2s执行此操作以便能获取到unionid
//        });
      [[HudHelper hudHepler]showShortTips:appDelegate.window tips:@"授权成功,QQ登录中"];
        
    }
    else
    {
      [[HudHelper hudHepler]showShortTips:appDelegate.window tips:@"用户授权失败"];
    }
}
#pragma mark   登录失败
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    AppDelegate * appDelegate = SharedAppDelegate;
    if(cancelled)
    {
        //NSLog(@"++++++++++++++++用户取消授权");
        [[HudHelper hudHepler]showShortTips:appDelegate.window tips:@"用户取消授权"];
    }
    else
    {
        //NSLog(@"+++++++++++++++++用户授权失败");
        [[HudHelper hudHepler]showShortTips:appDelegate.window tips:@"用户授权失败"];
    }
}
#pragma mark   网络出现问题
- (void)tencentDidNotNetWork
{
    //NSLog(@"+++++++++++++++网络出现问题");
    AppDelegate * appDelegate = SharedAppDelegate;
    [[HudHelper hudHepler]showShortTips:appDelegate.window tips:@"网络出现问题"];
}

#pragma mark - QQ登录成功获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response
{
    if (URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode)
    {
        NSLog(@"===%@",response.jsonResponse);
        NSString *gender =@"0";
        if ([response.jsonResponse[@"gender"]isEqualToString:@"男"])
        {
            gender=@"1";
        }
        //8.23  返回的数据赋值给一个字典
        NSDictionary *userinfo=[response jsonResponse];
        NSString *nickname;
        if (userinfo[@"nickname"]!=nil)
        {
            nickname=userinfo[@"nickname"];
        }
        else
        {
           nickname=@"";
        }
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError * _Nullable error) {
            NSString* secretAgent = result;
            
            NSMutableDictionary *param2 = [NSMutableDictionary dictionary];
            [param2 setValue:[NSString stringWithFormat:@"%ld",(long)NSDataRrquestUserOauthTypeQQ] forKey:@"type"];
            [param2 setValue:tencentOauth.openId forKey:@"external_uid"];
            [param2 setValue:nickname forKey:@"external_name"];
            [param2 setValue:response.jsonResponse[@"figureurl_qq_2"] forKey:@"avatar"];
            [param2 setValue:gender forKey:@"gender"];
            [param2 setValue:secretAgent forKey:@"agent"];
//            if (unionidstr==nil) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取配置信息失败,请重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                [alertView show];
//                return;
//            }
//            //3.12添加
//            [param2 setValue:unionidstr forKey:@"qq_unionid"];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [param2 setValue:[userDefaults objectForKey:@"apnstoken"] forKey:@"apnstoken"];
            [param2 setValue:MyAppBuilder forKey:@"version_app"];
           //2019.1.2获取免邀请码的uid
            NSString *unionidString=[SharedAppDelegate unionidStr];
            if (unionidString!=nil) {
                [param2 setValue:unionidString forKey:@"u"];
            }
            [[RootHttpHelper httpHelper] achieveCommonPostURL:users_oauth andController:nil andView:nil andParams:param2 andSuccess:^(NSDictionary *successData) {
                
                //NSLog(@"+++++++++++++请求到的数据users_oauth: %@",successData);
                if ([[successData objectForKey:@"api_code"] intValue]!=200) {
                    //8.16 登陆账号或密码不对时添加提示 显示后台返回信息
                    UIAlertController *control =[UIAlertController alertControllerWithTitle:@"" message:successData[@"api_msg"] preferredStyle:UIAlertControllerStyleAlert];
                    [SharedAppDelegate.window.rootViewController presentViewController:control animated:YES completion:nil];
                    UIAlertAction *sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [control addAction:sure];
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
                //3.22存market
                [userDefaults setObject:SharedAppDelegate.userModel.user.market forKey:@"market"];
                [userDefaults setObject:userModel.token forKey:@"token"];
                [userDefaults synchronize];
                // 创建tabbarController
                BaseTabBarController * tabBarVC = [[BaseTabBarController alloc] init];
                // 设置根控制器
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

- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

-(void)getsharecode
{
//     AppDelegate * appDelegate = SharedAppDelegate;
//    [[RootHttpHelper httpHelper] achieveCommonPostURL:[NSString stringWithFormat:@"%@%@",live_share,SharedAppDelegate.roomNumber] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData)
    
    //1021
//    [[RootHttpHelper httpHelper] achieveCommonPostURL2:[NSString stringWithFormat:@"%@%@",ShareLiveURL,SharedAppDelegate.roomNumber] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData)
//    {
//        
//        NSLog(@"+++++++++++++请求到的数据live_share: %@",successData);
//        if ([successData objectForKey:@"data"]) {
//            [[HudHelper hudHepler]showShortTips:appDelegate.window tips:[successData objectForKey:@"data"]];
//        }
//    }];
}
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req{
    NSLog(@" ----req %@",req);
}
#pragma mark ------------------------ qq回调 ---------------------------
#pragma mark 处理来至QQ的响应
- (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegate_ReceiveResponse" object:nil];
            if (self.liveShare) {
                self.liveShare();
            }
            if (self.endLiveShare) {
                self.endLiveShare();
            }
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            if ([sendResp.result isEqualToString:@"0"])
            {
                if (SharedAppDelegate.isshareGetCode) {
                    if (SharedAppDelegate.isSignSuccess) {
                        [[RootHttpHelper httpHelper] achieveCommonPostURL2:[NSString stringWithFormat:@"%@%@",DATAAPI,@"ajax/room.php?action=sign&type=sign"] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
                            if ([successData[@"code"] integerValue]==200||[successData[@"api_code"] integerValue]==200) {

                            }
                        }];
                    }
                    if (SharedAppDelegate.hongbaoID!=nil) {
                        [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"share_success_qianghongbao?sid=%@",SharedAppDelegate.hongbaoID] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
                            if ([successData[@"api_code"] intValue]==200)
                            {
                                if (SharedAppDelegate.currentUserID!=nil) {
                                    if ([SharedAppDelegate.userModel.user.id isEqualToString:SharedAppDelegate.currentUserID])
                                    {
                                        if (SharedAppDelegate.currentBalance!=nil) {
                                            SharedAppDelegate.userModel.user.balance=SharedAppDelegate.currentBalance;
                                            if (successData[@"api_msg"]!=nil) {
                                                [[HudHelper hudHepler]showShortTips:SharedAppDelegate.window tips:successData[@"api_msg"]];
                                            }
                                        }
                                    }
                                }
                            }
                        }];
                    }
                    if (SharedAppDelegate.roomNumber==nil) {//4.28
                        return;
                    }
                    if (SharedAppDelegate.showID!=nil) {
                        AppDelegate * appDelegate = SharedAppDelegate;
                        [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"%@?roomnumber=%@&showid=%@",live_share_success,SharedAppDelegate.roomNumber,SharedAppDelegate.showID] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
                            if ([successData[@"api_code"] intValue]==200)
                            {
                                [[HudHelper hudHepler]showShortTips:appDelegate.window tips:@"QQ分享成功"];
                            }
                        }];
                    }
                    if (SharedAppDelegate.taskID!=nil)
                    {
                        [self shareWithUrl:[NSString stringWithFormat:@"%@?id=%@",live_share_success,SharedAppDelegate.taskID]];
                    }
                }else
                {
                    if (SharedAppDelegate.shareGetWitgdraw) { //6.11 添加判断
                       SharedAppDelegate.shareGetWitgdraw();
                    }
                }
            }
            else
            {
                // [[HudHelper hudHepler]showShortTips:appDelegate.window tips:@"QQ分享失败"];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}
- (void)shareWithUrl:(NSString *)shareur
{
    [[RootHttpHelper httpHelper] achieveCommonGetURL:shareur andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue]==200)
        {
        }
    }];
}
#pragma mark 处理QQ在线状态的回调
- (void)isOnlineResponse:(NSDictionary *)response
{
    //NSLog(@"+++++++++++++++处理QQ在线状态的回调");
}

@end

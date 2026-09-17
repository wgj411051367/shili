//
//  LoginBridge.m
//  这里 import 所有「脏头文件」并做实际工作；Swift 只看 LoginBridge.h。
//

#import "LoginBridge.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "UserInfoModel.h"
#import "RootHttpHelper.h"
#import "BaseTabBarController.h"
#import "WXApi.h"
#import "WXHelper.h"
#import "Constants.h"

@implementation LoginBridge

+ (void)handleAuthSuccess:(NSDictionary *)response {
    NSError *err = nil;
    UserModel *userModel = [[UserModel alloc] initWithDictionary:response error:&err];
    userModel.user.jusi_token = response[@"token"];
    userModel.user.jusi_userid = userModel.user.id;
    userModel.user.jusi_usernumber = userModel.user.haoma;

    SharedAppDelegate.userModel = userModel;
    [[RootHttpHelper httpHelper] setUserToken:userModel.token];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:userModel.token forKey:@"token"];
    if (SharedAppDelegate.userModel.user.market) {
        [ud setObject:SharedAppDelegate.userModel.user.market forKey:@"market"];
    }
    [ud synchronize];

    // 注册/登录成功后刷新基础缓存
    [[RootHttpHelper httpHelper] requestBalanceToBiLi];
    [[RootHttpHelper httpHelper] requestGiftList];
    [[RootHttpHelper httpHelper] requestHorseList];

    // 连接 IM
    [SharedAppDelegate setupStream];
}

+ (NSString *)unionId {
    return [SharedAppDelegate unionidStr];
}

+ (NSString *)apnsToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"apnstoken"];
}

+ (NSString *)currentToken {
    return [AppDelegate appDelegate].userModel.token;
}

+ (void)enterMainApp {
    BaseTabBarController *tab = [[BaseTabBarController alloc] init];
    [AppDelegate appDelegate].window.rootViewController = tab;
}

+ (void)revampUserInfo:(NSDictionary *)params
            completion:(void (^)(NSString *, NSString *, NSString *))completion {
    NSMutableDictionary *p = params ? [params mutableCopy] : [NSMutableDictionary dictionary];
    [[RootHttpHelper httpHelper] achieveCommonPostURL:revamp_users
                                        andController:nil
                                              andView:nil
                                            andParams:p
                                           andSuccess:^(NSDictionary *successData) {
        NSError *err = nil;
        UserInfoModel *m = [[UserInfoModel alloc] initWithDictionary:successData error:&err];
        NSString *sexText = [m.gender isEqualToString:@"0"] ? @"女" : @"男";
        NSString *birthday = (m.birthday.length > 0) ? m.birthday : @"";
        NSString *role = (m.role.length > 0) ? m.role : @"";
        if (completion) completion(sexText, birthday, role);
    }];
}

+ (void)handleLoginSuccess:(NSDictionary *)response {
    AppDelegate *app = [AppDelegate appDelegate];
    NSError *err = nil;
    UserModel *userModel = [[UserModel alloc] initWithDictionary:response error:&err];
    app.userModel = userModel;
    [[RootHttpHelper httpHelper] setUserToken:userModel.token];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (app.userModel.user.id != nil) {
        [ud setObject:app.userModel.user.id forKey:@"userid"];
        [ud setObject:app.launchTime forKey:@"time"];
    }
    [ud setBool:NO forKey:@"isCommounicate"];
    [ud setObject:userModel.token forKey:@"token"];
    if (app.userModel.user.market) {
        [ud setObject:app.userModel.user.market forKey:@"market"];
    }
    [ud synchronize];

    BaseTabBarController *tab = [[BaseTabBarController alloc] init];
    app.window.rootViewController = tab;

    [[RootHttpHelper httpHelper] requestBalanceToBiLi];
    [[RootHttpHelper httpHelper] requestGiftList];
    [[RootHttpHelper httpHelper] requestHorseList];
    [app updateMyApnsToken];
    [app setupStream];
}

+ (BOOL)isWeChatAvailable {
    return [WXApi isWXAppInstalled] || [WXApi isWXAppSupportApi];
}

+ (void)startWeChatLogin:(UIViewController *)vc {
    [[WXHelper wxHelper] getWXOauth:vc];
}

@end

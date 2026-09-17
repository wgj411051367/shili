//
//  CurrentUserBridge.m
//  当前登录用户资料门面实现（脏依赖关在此处）。
//

#import "CurrentUserBridge.h"
#import "AppDelegate.h"      // userModel（脏头）
#import "Constants.h"        // SharedAppDelegate / IMAGEAPI
#import "RootHttpHelper.h"
#import "HttpMacro.h"        // users_logout
#import "shili-Swift.h"      // LoginEntryViewController（Swift）

@implementation CurrentUserBridge

+ (NSString *)nickname
{
    return SharedAppDelegate.userModel.user.nickname;
}

+ (NSString *)userId
{
    return SharedAppDelegate.userModel.user.id;
}

+ (NSString *)rankId
{
    return SharedAppDelegate.userModel.user.rank_id;
}

+ (NSString *)avatarFrame
{
    return SharedAppDelegate.userModel.user.avatar_frame;
}

+ (UserInfoModel *)applyUserInfoResponse:(NSDictionary *)response
{
    NSError *err = nil;
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:response error:&err];
    if (!model) return nil;
    SharedAppDelegate.userModel.user = model;
    if ([model.isblock integerValue] == 1) {
        [[RootHttpHelper httpHelper] achieveCommonPostURL:users_logout andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *d) {
            [[RootHttpHelper httpHelper] setUserToken:@""];
            SharedAppDelegate.userModel.token = nil;
            [SharedAppDelegate removeAllDefaultData];
            LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
            SharedAppDelegate.window.rootViewController = nav;
        }];
        return nil;
    }
    return model;
}

+ (NSURL *)avatarURL
{
    NSString *uid = SharedAppDelegate.userModel.user.id;
    NSString *update = SharedAppDelegate.userModel.user.update_avatar_time ?: @"";
    NSString *urlStr;
    if (uid.length > 0) {
        urlStr = [NSString stringWithFormat:@"%@/apis/avatar.php?uid=%@&update=%@", IMAGEAPI, uid, update];
    } else {
        urlStr = [NSString stringWithFormat:@"%@/images/2456_120x120.jpg", IMAGEAPI];
    }
    NSString *encoded = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:encoded ?: urlStr];
}

@end

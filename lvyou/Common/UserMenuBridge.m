//
//  UserMenuBridge.m
//  「我的」页菜单路由实现。
//

#import "UserMenuBridge.h"
#import "Constants.h"
#import "PersonInfoModel.h"
#import "shili-Swift.h"
#import "AppSettingsViewController.h"

@implementation UserMenuBridge

static UserInfoModel *CurrentUser(void) {
    return SharedAppDelegate.userModel.user;
}

+ (void)handleMenuTap:(PersonInfoModel *)model
           navigation:(UINavigationController *)nav
                 host:(UIViewController *)host
{
    if ([model.tag isEqualToString:@"setting"]) {
        [nav pushViewController:[self settingsViewController] animated:YES];
    }
}

+ (UIViewController *)editUserInfoViewController
{
    ProfileEditViewController *vc = [[ProfileEditViewController alloc] init];
    vc.navigationItem.title = @"编辑资料";
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}

+ (UIViewController *)settingsViewController
{
    AppSettingsViewController *vc = [[AppSettingsViewController alloc] init];
    vc.navigationItem.title = @"设置";
    vc.hidesBottomBarWhenPushed = YES;
    for (OauthModel *oauth in CurrentUser().oauths) {
        if (oauth.type == 1) { vc.isbandPhone = @"1"; vc.bandPhone = oauth.external_name; }
        if (oauth.type == 4) { vc.isbandWeChat = @"4"; vc.clickWeChat = oauth.force; vc.weNick = oauth.external_name; }
    }
    return vc;
}

@end

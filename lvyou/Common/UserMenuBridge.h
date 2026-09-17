//
//  UserMenuBridge.h
//  「我的」页菜单跳转的统一干净门面。
//
//  ProfileTabViewController 迁 Swift 后，菜单/头部按钮要 push 一堆仍是 OC 上帝头的子页
//  （编辑资料/设置/收益/发布/道具/认证/账户…）。把整段路由 setDataWithModel + 各
//  push 方法原样搬到本类 .m（脏头全在 .m import），Swift 只调一个入口。
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PersonInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface UserMenuBridge : NSObject

/// 菜单项/头部顶栏点击的总路由（按 model.tag 分发），等价原 setDataWithModel。
+ (void)handleMenuTap:(PersonInfoModel *)model
           navigation:(nullable UINavigationController *)nav
                 host:(UIViewController *)host;

/// 头部「编辑资料」入口。
+ (UIViewController *)editUserInfoViewController;

/// 头部「设置」入口（读当前用户 oauths 配好绑定态）。
+ (UIViewController *)settingsViewController;

@end

NS_ASSUME_NONNULL_END

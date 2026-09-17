//
//  LoginBridge.h
//  Swift 登录/注册模块的「干净门面」。
//
//  Swift 侧无法直接 import AppDelegate.h / UserModel.h / ProfileSetupViewController.h
//  这些「脏头文件」（拖入 Tencent/GPUImage/KSY/BaseViewController→iOS26 已移除的
//  ALAsset）。把这些脏活封在本类的 .m 里（.m 走 pch、可 import 脏头），
//  只把干净的 .h 暴露给 Swift bridging header。
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginBridge : NSObject

/// 登录 / 注册成功后的会话落地：
/// 用响应构造 UserModel、写入 token、刷新等级/礼物/座驾缓存、连接 IM。
/// （对应原 OC 里散落在各登录 VC 里那段重复逻辑）
+ (void)handleAuthSuccess:(NSDictionary *)response;

/// 免邀请码 unionid（来自 AppDelegate）
+ (nullable NSString *)unionId;

/// APNs token（注册接口需要的参数）
+ (nullable NSString *)apnsToken;

/// 当前登录用户 token（头像上传 URL 需要）
+ (nullable NSString *)currentToken;

/// 完善资料完成 → 建主 App 的 TabBar 并设为 root（BaseTabBarController 是脏头）
+ (void)enterMainApp;

/// 更新用户资料（revamp_users），解析 UserInfoModel（脏依赖），
/// 回传三个用于界面展示的字符串：性别文案 / 生日 / 角色。
+ (void)revampUserInfo:(nullable NSDictionary *)params
            completion:(void (^)(NSString *sexText, NSString *birthday, NSString *role))completion;

/// 主登录（密码/验证码）成功后的完整落地：建 UserModel、存 token/userid/time、
/// 建主 TabBar 设为 root、刷缓存、更新 APNs、连 IM。
+ (void)handleLoginSuccess:(NSDictionary *)response;

#pragma mark - 三方登录（仅微信；QQ 登录已废弃删除，QQ 分享仍保留在 QQHelper）
+ (BOOL)isWeChatAvailable;
+ (void)startWeChatLogin:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END

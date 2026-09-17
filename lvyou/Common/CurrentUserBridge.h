//
//  CurrentUserBridge.h
//  当前登录用户资料的「干净门面」。
//
//  Swift 侧无法直接 import AppDelegate.h（脏头）。当前用户资料存在
//  SharedAppDelegate.userModel.user 里，把取值封在 .m，只暴露干净 .h。
//  （User 模块后续多数页面都要读当前用户，故单列一个门面复用）
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UserInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface CurrentUserBridge : NSObject

/// 当前用户昵称
+ (nullable NSString *)nickname;

/// 当前用户 id
+ (nullable NSString *)userId;

/// 当前用户等级 id（rank_id）
+ (nullable NSString *)rankId;

/// 当前用户头像 URL（由 uid + update_avatar_time 拼 avatar.php）
+ (nullable NSURL *)avatarURL;

/// 当前用户已装备的头像框 id（avatar_frame）
+ (nullable NSString *)avatarFrame;

/// 用 users_info 响应刷新全局用户模型；若被封禁(isblock)则登出回登录页并返回 nil，
/// 否则返回解析出的 UserInfoModel（供头部展示）。
+ (nullable UserInfoModel *)applyUserInfoResponse:(NSDictionary *)response;

@end

NS_ASSUME_NONNULL_END

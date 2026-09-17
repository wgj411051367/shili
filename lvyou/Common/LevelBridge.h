//
//  LevelBridge.h
//  等级徽章展示的「干净门面」。
//
//  Swift 侧无法直接 import AppDelegate.h（脏头，拖入 Tencent/KSY/BaseViewController
//  → iOS26 已移除的 ALAsset）。等级图来自 AppDelegate 缓存的 rankDic / zhuboRankDic，
//  把这段脏活封在 .m 里，只暴露干净的 .h 给 bridging header。
//  （对应原 BaseViewController 的 -showThelevel:and:and:isZhuBo:）
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LevelBridge : NSObject

/// 按 rankId 从 AppDelegate 等级缓存取徽章图，异步加载进 image；label 置隐藏。
/// rankId 形如 "12" 或 "12_xxx"（取下划线前段）。isZhuBo 决定用主播榜还是用户榜。
+ (void)showLevel:(nullable NSString *)rankId
            image:(UIImageView *)image
            label:(UILabel *)label
          isZhuBo:(BOOL)isZhuBo;

@end

NS_ASSUME_NONNULL_END

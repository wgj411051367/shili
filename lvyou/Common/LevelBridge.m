//
//  LevelBridge.m
//  等级徽章展示门面的实现（脏依赖关在此处）。
//

#import "LevelBridge.h"
#import "AppDelegate.h"          // rankDic / zhuboRankDic（脏头）
#import "Constants.h"            // SharedAppDelegate / IMAGEAPI
#import "RankPeopleModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LevelBridge

+ (void)showLevel:(NSString *)rankId
            image:(UIImageView *)image
            label:(UILabel *)label
          isZhuBo:(BOOL)isZhuBo
{
    NSString *realLevel = rankId ?: @"";
    if ([realLevel containsString:@"_"]) {
        NSArray *parts = [realLevel componentsSeparatedByString:@"_"];
        if (parts.count > 0) {
            realLevel = parts[0];
        }
    }

    NSDictionary *dic = isZhuBo ? SharedAppDelegate.zhuboRankDic : SharedAppDelegate.rankDic;
    RankPeopleModel *rankModel = [[RankPeopleModel alloc] initWithDictionary:[dic objectForKey:realLevel] error:nil];
    [image sd_setImageWithURL:[self imageURL:rankModel.img] placeholderImage:nil];
    label.text = realLevel;
    label.hidden = YES;
}

/// 头像/图片地址拼接：全路径(http/https)直接用，否则拼 IMAGEAPI 前缀。
+ (NSURL *)imageURL:(NSString *)addr
{
    if (![addr isKindOfClass:[NSString class]] || addr.length == 0) {
        return nil;
    }
    if ([addr hasPrefix:@"http://"] || [addr hasPrefix:@"https://"]) {
        return [NSURL URLWithString:[addr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    NSString *full = [NSString stringWithFormat:@"%@%@", IMAGEAPI, addr];
    return [NSURL URLWithString:[full stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

@end

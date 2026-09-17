//
//  UIColor+Master.h
//  Patoo
//
//  Created by jinghao on 15/12/24.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIColor (Master)
/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

+ (UIColor *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

+ (UIColor *)colorSolidWith:(NSInteger)integer;

+ (UIColor *)colorSolidWith:(NSInteger)integer alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(UInt32)hex;

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (NSString *)HEXString;

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UInt32)fromHexColorStr toColor:(UInt32)toHexColorStr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
@end

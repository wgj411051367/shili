//
//  UIImage+Resample.m
//  doudou
//
//  Created by mac on 17/7/20.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "UIImage+Resample.h"

@implementation UIImage (Resample)


- (UIImage*)imageCompressWithSimpleScale:(float)scale
{
    CGSize size = self.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaledWidth, scaledHeight), NO,[UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

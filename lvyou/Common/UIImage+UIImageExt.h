//
//  UIImage+UIImageExt.h
//  tenbear
//
//  Created by mac on 16/7/11.
//  Copyright © 2016年 fengyibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end

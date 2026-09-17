//
//  CustomWKWebView.m
//
//  Created by mac on 17/6/16.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "CustomWKWebView.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseLiveViewController.h"
@implementation CustomWKWebView

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    
    UIView* subview = [super hitTest:point withEvent:event];  // this should always be a webview
    
    if (![self inBottom:[self convertPoint:point toView:subview]]) // if point is transparent then let superview deal with it
    {
        return nil;
    }
    return subview; // return webview
}
-(BOOL) inBottom:(CGPoint)point{
    if([_bottomHeight floatValue]==0){
        return true;
    }
    double height=SCREEN_HEIGHT-[_bottomHeight floatValue];
    if (point.y>=height) {
        return true;
    }
    return false;
}
- (BOOL) isTransparent:(CGPoint)point fromView:(CALayer*)layer
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y );
    UIGraphicsPushContext(context);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIGraphicsPopContext();
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return (pixel[0]/255.0 == 0) &&(pixel[1]/255.0 == 0) &&(pixel[2]/255.0 == 0) &&(pixel[3]/255.0 == 0) ;
}
@end

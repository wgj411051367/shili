//
//  UIView+Layout.h
//  CommonLibrary
//
//  Created by Alexi Chen on 2/28/13.
//  Copyright (c) 2013 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layout)

// 添加子控件
- (void)addOwnViews;

// 配置子控件参数
- (void)configOwnViews;

//- (void)configWith:(NSMutableDictionary *)jsonDic;

// isAutoLayoutr返回YES时，使用此方法进行布局
- (void)autoLayoutSubViews;

// 是否使用自动布局
- (BOOL)isAutoLayout;

// 外部通过此功能进行设置
// 只在布局时使用
- (void)setFrameAndLayout:(CGRect)rect;

// 对于一些自定义的UIView，在设置Frame后，如需要重新调整局的话
// 作为所以控修改其自身内部子控件的入口
// 所有的自定义View最好不要从initWithFrams里面进行设置其子View的frame,
// 统一在些处进行设置
- (void)relayoutFrameOfSubViews;

- (void)addBottomLine:(CGRect)rect;

- (void)addBottomLine:(UIColor *)color inRect:(CGRect)rect;

//ZLCamera
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;

- (double)width;
- (void)setWidth:(double)width;

- (double)height;
- (void)setHeight:(double)height;

- (CGFloat)bottomPosition;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)point;

- (double)xPosition;
- (double)yPosition;
- (double)baselinePosition;

- (void)positionAtX:(double)xValue;
- (void)positionAtY:(double)yValue;
- (void)positionAtX:(double)xValue andY:(double)yValue;

- (void)positionAtX:(double)xValue andY:(double)yValue withWidth:(double)width;
- (void)positionAtX:(double)xValue andY:(double)yValue withHeight:(double)height;

- (void)positionAtX:(double)xValue withHeight:(double)height;

- (void)removeSubviews;

- (void)centerInSuperView;
- (void)aestheticCenterInSuperView;

- (void)bringToFront;
- (void)sendToBack;

//ZF

- (void)centerAtX;

- (void)centerAtXQuarter;

- (void)centerAtX3Quarter;


@end

@interface UIView (ShakeAnimation)

// 左右shake
- (void)shake;

@end

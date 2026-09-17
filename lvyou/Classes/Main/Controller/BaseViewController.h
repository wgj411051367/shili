// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  BaseViewController.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "HMSegmentedControl.h"
#import "Constants.h"
#import "UIView+Layout.h"   // .height/.width 等 frame 便利属性（原经 LGPhoto.h 传递引入，LGPhotoPicker 移除后直引）
#import "SDWebImage.h"
#import "ToolHelper.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "HudHelper.h"
#import "MessageHelper.h"

#import "QQHelper.h"
#import "WXHelper.h"
#import "UISailorTextView.h"
#import "RootHttpHelper.h"
#import "BaseModel.h"
#import "BannerModel.h"
#import "HttpMacro.h"
#import "SailorPopMenuView.h"
#import "SailorPopMenuViewModel.h"
#import "SailorPopMenuViewSingleton.h"
#import "NSTimer+Pluto.h"
// AlipayHelper.h 已移除：支付宝 SDK 下线（充值走 IAP）
#define ScreenBiLi [UIScreen mainScreen].bounds.size.width/375

@interface BaseViewController : UIViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic)AppDelegate *appDelegate;

- (NSString *)stringTheme:(NSString*)title;
- (NSURL *)placeCorpsImg:(NSString*)addr;
- (NSURL *)placeImg:(NSString*)addr;
+ (NSURL *)placeImg2:(NSString*)addr;
- (UIImage *)placeDefaultImg;
- (void)dismiss;
- (void)closeVC;
- (NSString *)getApplicationName;
- (NSString *)getApplicationScheme;
- (BOOL)isBlankString:(NSString *)string;
//3.2
- (NSString *)livingname;
- (NSString *)moneyname;
- (NSString *)jiFenNum;
- (void)showThePiao:(UILabel *)madouLab With:(NSString *)totalPoint;
- (void)showTheGuiZu:(UIImageView *)imgView With:(NSString *)guizu;
//显示vip
- (void)showTheVip:(UIImageView *)imgView With:(NSString *)vip_util With:(NSString *)viplevel;
// 对于界面上有输入框的，可以选择性调用些方法进行收起键盘
- (void)addTapBlankToHideKeyboardGesture;

//显示等级部分
- (void)showThelevel:(NSString *)randid and:(UIImageView *)levelimg and:(UILabel *)levelLab isZhuBo:(BOOL)isZhuBo;
- (void)pushToBannerWebWithLoadUrl:(NSString *)loadurl withTitle:(NSString *)titlelab andShareUrl:(NSString *)imgurl;//2.14


// 根据所定义的id获取渐变颜色数组
- (NSArray *)gradientColorImageFromColorsWith:(NSInteger)index;
-(CGFloat)getWidthWithString:(NSString*)str font:(UIFont*)font;

-(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;
-(float)widthForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
// 缓存关注列表
- (void)setFollowListIsRemove:(BOOL)isRemove andUserid:(NSString *)userid;

-(NSString *)notRounding:(double)price afterPoint:(int)position;
@end

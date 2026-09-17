// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  WXHelper.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "Constants.h"
// 微信支付已下线（虚拟币充值走 IAP）：WeChatOrder / payRequsestHandler 已删
@protocol WXApiManagerDelegate <NSObject>

@optional

@end

@interface WXHelper : NSObject<WXApiDelegate>
@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;
//初始化方法
+ (WXHelper*)wxHelper;

//登录方法
- (void)getWXOauth:(UIViewController *)viewController;

//向微信分享(朋友圈和好友)
- (void)shareLinkToWx:(NSString *)url atIndex:(NSInteger)index andTitle:(NSString *)titleStr andInfo:(NSString *)messageStr andImage:(UIImage *)avatar;
@end

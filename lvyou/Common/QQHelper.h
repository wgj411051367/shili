// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  QQHelper.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "ToolHelper.h"
#import "HudHelper.h"

@interface QQHelper : NSObject<TencentSessionDelegate,TencentLoginDelegate,QQApiInterfaceDelegate>
{
    NSMutableDictionary *uniondic;
    NSString *unionidStr;
}
@property (strong, nonatomic) TencentOAuth * tencentOauth;

@property (copy, nonatomic) void (^ liveShare)();
@property (copy, nonatomic) void (^ endLiveShare)();
//初始化方法
+ (QQHelper*)qqHelper;

// QQ 登录（getQQOauth）已废弃删除，仅保留下方分享。

//向QQ分享(空间和好友)
- (void)shareLinkToQQ:(NSString*)url atIndex:(NSInteger)index andTitle:(NSString *)titleStr andInfo:(NSString *)messageStr andImage:(UIImage *)avatar;

@end

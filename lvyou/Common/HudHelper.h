// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  HudHelper.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HudHelper : NSObject

+(HudHelper*)hudHepler;
-(void)ShowHUDAlert:(UIView*)view;
-(void)HideHUDAlert:(UIView*)view;
-(void)showStillShortTips:(UIView *)view tips:(NSString*)message;
-(void)showShortTips:(UIView*)view tips:(NSString*)message;
-(void)showTips:(UIView*)view tips:(NSString*)message;
-(void)showLongTips:(UIView*)view tips:(NSString*)message;
-(void)showUIAlert:(NSString*)title;

@end

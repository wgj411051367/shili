// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  MessageHelper.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMessageView.h"
#import "RMessage.h"
#import "Constants.h"

@interface MessageHelper : NSObject

+(MessageHelper*)messageHelper;

-(void)hideMessage;
-(void)showMessage:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub;
-(void)showErrMessage:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub;
-(void)showErrMessageEndLess:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub;
-(void)showWarnMessage:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub;

-(void)showSuccessMessage:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub;
-(void)showWarnForShortTime:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub;

@end

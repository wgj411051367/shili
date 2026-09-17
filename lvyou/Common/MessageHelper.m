// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  MessageHelper.m
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "MessageHelper.h"

@implementation MessageHelper
//单例
+(MessageHelper*)messageHelper
{
    static MessageHelper *messageHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        messageHelper = [[MessageHelper alloc] init];
    });
    return messageHelper;
}
-(void)hideMessage{
    [RMessage dismissActiveNotification];
}
-(void)showMessage:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub
{
    [RMessage showNotificationInViewController:vc.navigationController title:title subtitle:sub type:RMessageTypeNormal customTypeName:nil callback:nil];
}
-(void)showErrMessageEndLess:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub{
    [RMessage showNotificationInViewController:vc.navigationController title:title subtitle:sub iconImage:nil type:RMessageTypeError customTypeName:nil duration:2.0 callback:nil buttonTitle:nil buttonCallback:nil atPosition:RMessagePositionNavBarOverlay canBeDismissedByUser:YES];
}
-(void)showErrMessage:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub
{
    [RMessage showNotificationInViewController:vc.navigationController title:title subtitle:sub iconImage:nil type:RMessageTypeError customTypeName:nil duration:2.0 callback:nil buttonTitle:nil buttonCallback:nil atPosition:RMessagePositionNavBarOverlay canBeDismissedByUser:YES];
}

-(void) showWarnMessage:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub;
{
    [RMessage showNotificationInViewController:vc.navigationController title:title subtitle:sub iconImage:nil type:RMessageTypeWarning customTypeName:nil duration:2.0 callback:nil buttonTitle:nil buttonCallback:nil atPosition:0 canBeDismissedByUser:YES];
}

-(void)showSuccessMessage:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub
{
    [RMessage showNotificationInViewController:vc.navigationController title:title subtitle:sub iconImage:nil type:RMessageTypeSuccess customTypeName:nil duration:2.0 callback:nil buttonTitle:nil buttonCallback:nil atPosition:0 canBeDismissedByUser:YES];
}

-(void)showWarnForShortTime:(UIViewController*)vc title:(NSString*)title sub:(NSString*)sub
{
    [RMessage showNotificationInViewController:vc.navigationController title:title subtitle:sub type:RMessageTypeWarning customTypeName:nil duration:2.0 callback:nil canBeDismissedByUser:YES];
}

@end

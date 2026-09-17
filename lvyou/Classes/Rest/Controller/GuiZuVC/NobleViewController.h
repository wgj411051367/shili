// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://company.zaoing.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  XYViewerUserLiveViewController.h
//  beibei
//
//  Created by dev on 16/7/16.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseViewController.h"

@interface NobleViewController : BaseViewController

@property (nonatomic,assign) CGRect rect;
@property(nonatomic,assign)BOOL searchpush;
@property(nonatomic,assign)BOOL tabPush;
@property (strong, nonatomic) BeginLiveModel *beginModel;

@property (assign, nonatomic) BOOL userPush;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aliHeight;
@property (weak, nonatomic) IBOutlet UIView *PayView;
@property (weak, nonatomic) IBOutlet UIView *weView;
@property (weak, nonatomic) IBOutlet UIView *aliView;


@end

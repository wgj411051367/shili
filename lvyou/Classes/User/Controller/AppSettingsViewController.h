// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  AppSettingsViewController.h
//  beibei
//
//  Created by dev on 16/7/7.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseViewController.h"

@interface AppSettingsViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *cache;
@property(strong,nonatomic)NSString *bandPhone;
@property(strong,nonatomic)NSString *isbandPhone;
@property(strong,nonatomic)NSString *weNick;
@property(strong,nonatomic)NSString *clickWeChat;
@property(strong,nonatomic)NSString *isbandWeChat;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) UserInfoModel *userInfoModel;

@property (weak, nonatomic) IBOutlet UILabel *wechatNick;
@property (weak, nonatomic) IBOutlet UILabel *adolescentStateLab;

@end

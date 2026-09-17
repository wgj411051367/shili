// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  HorseModel.h
//  beibei
//
//  Created by dev on 16/7/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol HorseModel
@end

@interface HorseModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *images;
@property (strong, nonatomic) NSString<Optional> *icon;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *price;
@property (strong, nonatomic) NSString<Optional> *aging;
@property (strong, nonatomic) NSString<Optional> *aging_unit;

@property (strong, nonatomic) NSString<Optional> *active;
@property (strong, nonatomic) NSString<Optional> *expiration;
@property (strong, nonatomic) NSString<Optional> *need_exp;
@property (strong, nonatomic) NSString<Optional> *need_vip;
@property (strong, nonatomic) NSString<Optional> *horseId;
@property (strong, nonatomic) NSString<Optional> *uptime;
@property (strong, nonatomic) NSString<Optional> *newpwd;

@property (strong, nonatomic) NSString<Optional> *json_address;
@property (strong, nonatomic) NSString<Optional> *is_selected;
@property (strong, nonatomic) NSString<Optional> *is_show;
@end

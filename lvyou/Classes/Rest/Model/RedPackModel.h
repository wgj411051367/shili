// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  RedPackModel.h
//  beibei
//
//  Created by dev on 16/8/14.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserInfoModel.h"
#import "PackModel.h"

@protocol RedPackModel
@end

@interface RedPackModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) UserInfoModel<Optional> *user;
@property (strong, nonatomic) PackModel<Optional> *redpack;
@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *got_ticket;

@end

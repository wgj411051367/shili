// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  PackModel.h
//  beibei
//
//  Created by dev on 16/8/14.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserInfoModel.h"

@protocol PackModel
@end

@interface PackModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) UserInfoModel<Optional> *user;
@property (strong, nonatomic) NSString<Optional> *number;
@property (strong, nonatomic) NSString<Optional> *desc;
@property (strong, nonatomic) NSString<Optional> *shell;
@property (strong, nonatomic) NSString<Optional> *is_global;

@end

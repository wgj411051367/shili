// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  UserModel.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserInfoModel.h"

@interface UserModel : JSONModel

@property (assign, nonatomic) NSInteger api_code;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) UserInfoModel *user;

@end

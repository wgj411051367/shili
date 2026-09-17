// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveGuardListModel.h
//  beibei
//
//  Created by dev on 16/8/3.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserInfoModel.h"
#import "LiveGuardModel.h"

@interface LiveGuardListModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) UserInfoModel<Optional> *anchor;
@property (strong, nonatomic) LiveGuardModel<Optional> *guard;

@end

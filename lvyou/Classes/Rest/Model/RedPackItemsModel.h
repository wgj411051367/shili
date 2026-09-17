// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  RedPackItemsModel.h
//  beibei
//
//  Created by dev on 16/8/14.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RedPackModel.h"

@interface RedPackItemsModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *all_count;
@property (strong, nonatomic) NSString<Optional> *remain_count;
@property (strong, nonatomic) NSString<Optional> *rob_count;
@property (strong, nonatomic) NSMutableArray<RedPackModel> *items;

@property (strong, nonatomic) NSString<Optional> *avatar;
@property (strong, nonatomic) NSString<Optional> *money;
@property (strong, nonatomic) NSString<Optional> *nickname;
@property (strong, nonatomic) NSString<Optional> *userid;

@end

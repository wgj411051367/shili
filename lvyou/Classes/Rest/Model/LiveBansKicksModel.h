// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveBansKicksModel.h
//  beibei
//
//  Created by dev on 16/8/3.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LiveKicksModel.h"
#import "LiveBansModel.h"

@interface LiveBansKicksModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *api_code;
@property (strong, nonatomic) NSMutableArray<LiveBansModel> *bans;
@property (strong, nonatomic) NSMutableArray<LiveKicksModel> *kicks;

@end

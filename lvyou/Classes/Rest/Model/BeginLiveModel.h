// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  BeginLiveModel.h
//  beibei
//
//  Created by dev on 16/7/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserInfoModel.h"
#import "UserHorseModel.h"

@interface BeginLiveModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *ended;
@property (strong, nonatomic) NSString<Optional> *im_group_id;
@property (strong, nonatomic) NSString<Optional> *lat;
@property (strong, nonatomic) NSString<Optional> *lng;
@property (strong, nonatomic) NSString<Optional> *location;
@property (strong, nonatomic) NSString<Optional> *people_num;
@property (strong, nonatomic) NSString<Optional> *av_room_id;
@property (strong, nonatomic) NSString<Optional> *started;

@property (strong, nonatomic) UserHorseModel<Optional> *user_horse;
@property (strong, nonatomic) UserInfoModel<Optional> *anchor;

@end

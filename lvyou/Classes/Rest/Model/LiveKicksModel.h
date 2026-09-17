// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveKicksModel.h
//  beibei
//
//  Created by dev on 16/8/3.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol LiveKicksModel

@end

@interface LiveKicksModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *anchor_rank_id;
@property (strong, nonatomic) NSString<Optional> *avatar;
//2017.6.13
@property (strong, nonatomic) NSString<Optional> *update_avatar_time;
@property (strong, nonatomic) NSString<Optional> *birthday;
@property (strong, nonatomic) NSString<Optional> *constellation;
@property (strong, nonatomic) NSString<Optional> *fans_num;
@property (strong, nonatomic) NSString<Optional> *follow_num;
@property (strong, nonatomic) NSString<Optional> *haoyou_num;
@property (strong, nonatomic) NSString<Optional> *gender;
@property (strong, nonatomic) NSString<Optional> *haoma;
@property (strong, nonatomic) NSString<Optional> *hometown_city;
@property (strong, nonatomic) NSString<Optional> *hometown_province;
@property (strong, nonatomic) NSString<Optional> *im_uid;
@property (strong, nonatomic) NSString<Optional> *is_follow;
@property (strong, nonatomic) NSString<Optional> *job;
@property (strong, nonatomic) NSString<Optional> *nickname;
@property (strong, nonatomic) NSString<Optional> *rank_id;
@property (strong, nonatomic) NSString<Optional> *reg_time;
@property (strong, nonatomic) NSString<Optional> *summary;
@property (strong, nonatomic) NSString<Optional> *total_send_gift;
@property (strong, nonatomic) NSString<Optional> *total_ticket;
@property (strong, nonatomic) NSString<Optional> *unique_id;
@property (strong, nonatomic) NSString<Optional> *vip_util;

@end

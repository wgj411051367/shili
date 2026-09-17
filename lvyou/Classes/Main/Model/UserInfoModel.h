// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  UserInfoModel.h
//  beibei
//
//  Created by dev on 16/7/7.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DeviceModel.h"
#import "OauthModel.h"
#import "SwitchsModel.h"
#import "YinXiangModel.h"   
@protocol UserInfoModel
@end

@interface UserInfoModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *userid;
@property (strong, nonatomic) NSString<Optional> *avatar;
//6.13
@property (strong, nonatomic) NSString<Optional> *update_avatar_time;
@property (strong, nonatomic) NSString<Optional> *birthday;
@property (strong, nonatomic) NSString<Optional> *gender;
@property (strong, nonatomic) NSString<Optional> *nickname;
@property (strong, nonatomic) NSString<Optional> *reg_time;
@property (strong, nonatomic) NSString<Optional> *anchor_rank_id;
@property (strong, nonatomic) NSString<Optional> *balance;
//12.6  添加商城
@property (strong, nonatomic) NSString<Optional> *shop_point;
@property (strong, nonatomic) NSString<Optional> *constellation;
@property (strong, nonatomic) NSString<Optional> *emotion;
@property (strong, nonatomic) NSString<Optional> *exp;
@property (strong, nonatomic) NSString<Optional> *hometown_city;
@property (strong, nonatomic) NSString<Optional> *hometown_province;
@property (strong, nonatomic) NSString<Optional> *job;
@property (strong, nonatomic) NSString<Optional> *rank_id;
@property (strong, nonatomic) NSString<Optional> *summary;
@property (strong, nonatomic) NSString<Optional> *ticket;
@property (strong, nonatomic) NSString<Optional> *total_send_gift;
@property (strong, nonatomic) NSString<Optional> *total_ticket;
@property (strong, nonatomic) NSString<Optional> *vip_util;
//添加vip等级  1，2，3，分别是黄色，紫色，黑色vip
@property (strong, nonatomic) NSString<Optional> *viplevel;
@property (strong, nonatomic) NSString<Optional> *haoma;
@property (strong, nonatomic) NSString<Optional> *roomnumber;
@property (strong, nonatomic) NSString<Optional> *follow_num;
@property (strong, nonatomic) NSString<Optional> *haoyou_num;
@property (strong, nonatomic) NSString<Optional> *fans_num;
@property (strong, nonatomic) NSString<Optional> *is_follow;
@property (strong, nonatomic) NSString<Optional> *person_verify;
@property (strong, nonatomic) NSString<Optional> *beibei_verify;
@property (strong, nonatomic) NSString<Optional> *live_banner;
@property (strong, nonatomic) NSString<Optional> *orderlevel;
//1023
@property (strong, nonatomic) NSString<Optional> *JF_XNB;
//12.4  添加分享语句
@property (strong, nonatomic) NSString<Optional> *room_share_name;
@property (strong, nonatomic) NSString<Optional> *room_share_des;

///2017.6.28新增密码房字段
@property (strong, nonatomic) NSString<Optional> *pwd;
///2017.7.27新增印象字段
@property (strong, nonatomic) NSMutableArray<YinXiangModel,Optional> *yinxiang;

//2017.6.20  推荐人提示标识
@property (strong, nonatomic) NSString<Optional> *tuijianrentip;
@property (strong, nonatomic) NSString<Optional> *tuijianren;
//粉丝团剩余天数
@property (strong, nonatomic) NSString<Optional> *guard_time;
//2017.6.1  新增佣金
@property (strong, nonatomic) NSString<Optional> *yongjin;
//二维码
@property (strong, nonatomic) NSString<Optional> *qr_code;
//推广链接
@property (strong, nonatomic) NSString<Optional> *qr_link;

@property (strong, nonatomic) NSString<Optional> *market;
//1031
@property (strong, nonatomic) NSString<Optional> *isblock;

//0929
@property (strong, nonatomic) NSString<Optional> *push_video_add;
//im账号 登入密码
@property (strong, nonatomic) NSString<Optional> *unique_id;
@property (strong, nonatomic) NSString<Optional> *im_sig;
@property (strong, nonatomic) NSString<Optional> *im_uid;

@property (strong, nonatomic) SwitchsModel<Optional> *switchs;
@property (strong, nonatomic) NSMutableArray<DeviceModel,Optional> *devices;
@property (strong, nonatomic) NSMutableArray<OauthModel,Optional> *oauths;

//2018.3.7 添加开关以及1v1的价格
@property (strong, nonatomic) NSString<Optional> *onetoone_open;
@property (strong, nonatomic) NSString<Optional> *onetoone_money;

@property (strong, nonatomic) NSString<Optional> *jusi_token;
@property (strong, nonatomic) NSString<Optional> *jusi_usernumber;
@property (strong, nonatomic) NSString<Optional> *jusi_userid;
//12.21 添加贵族字段
@property (strong, nonatomic) NSString<Optional> *guizhu;
@property (strong, nonatomic) NSString<Optional> *guizhu_vailddate;
//12.22 是否收费
@property (strong, nonatomic) NSString<Optional> *isPayMode;

//距离 单位km
@property (strong, nonatomic) NSString<Optional> *distance;

//在线时间
@property (strong, nonatomic) NSString<Optional> *onlinetime;

//年龄
@property (strong, nonatomic) NSString<Optional> *age;

//角色
@property (strong, nonatomic) NSString<Optional> *role;
//身高
@property (strong, nonatomic) NSString<Optional> *shengao;
//体重
@property (strong, nonatomic) NSString<Optional> *tizhong;

//我找（我想要的体型）
@property (strong, nonatomic) NSString<Optional> *like_physique;
//我找（我想要的特点）
@property (strong, nonatomic) NSString<Optional> *like_character;
//我找（我想）
@property (strong, nonatomic) NSString<Optional> *want_to;
//我是（体型）
@property (strong, nonatomic) NSString<Optional> *physique;
//我是（特点）
@property (strong, nonatomic) NSString<Optional> *character;

//蓝V认证
@property (strong, nonatomic) NSString<Optional> *pass3;

// 头像框id
@property (strong, nonatomic) NSString<Optional> *avatar_frame;

@property (strong, nonatomic) NSString<Optional> *yinshen;

@property (strong, nonatomic) NSString<Optional> *young_pwd;
@end

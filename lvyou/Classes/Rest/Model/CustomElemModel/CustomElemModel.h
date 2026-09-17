// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  CustomElemModel.h
//  beibei
//
//  Created by dev on 16/8/9.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CustomElemModel : JSONModel

@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString<Optional> *s_uid;
@property (strong, nonatomic) NSString<Optional> *s_nick;
@property (strong, nonatomic) NSString<Optional> *s_avatar;
@property (strong, nonatomic) NSString<Optional> *s_level;
@property (strong, nonatomic) NSString<Optional> *t_uid;
@property (strong, nonatomic) NSString<Optional> *t_nick;
@property (strong, nonatomic) NSString<Optional> *r_id;
@property (strong, nonatomic) NSString<Optional> *extra;
@property (strong, nonatomic) NSString<Optional> *s_vip;
@property (strong, nonatomic) NSString<Optional> *message;
@property (strong, nonatomic) NSString<Optional> *ishost;
@property (strong, nonatomic) NSString<Optional> *r_num;

@property (strong, nonatomic) NSNumber<Optional> *time;

//7.28 新加字段 比如粉丝团图标
@property (strong, nonatomic) NSString<Optional> *uimg;
@property (strong, nonatomic) NSString<Optional> *uimgh;

@property (strong, nonatomic) NSString<Optional> *guizu;
@property (strong, nonatomic) NSString<Optional> *chat_bg_color;
@property (strong, nonatomic) NSMutableArray<Optional> *content;
@end

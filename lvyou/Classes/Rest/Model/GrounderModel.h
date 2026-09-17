// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  GrounderModel.h
//  beibei
//
//  Created by dev on 16/7/13.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SFMContentModel.h"
@interface GrounderModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *type;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSString<Optional> *headImage;
@property (strong, nonatomic) NSString<Optional> *roomnumber;
@property (strong, nonatomic) NSString<Optional> *shower_userid;
@property (strong, nonatomic) NSString<Optional> *userid;

//7.20背景图片
@property (strong, nonatomic) NSString<Optional> *bg;
//字体颜色
@property (strong, nonatomic) NSString<Optional> *color;
//飞屏位置
@property (strong, nonatomic) NSString<Optional> *pos;
//动画停留时间
@property (strong, nonatomic) NSString<Optional> *staytime;
//pr文字右边间距
@property (strong, nonatomic) NSString<Optional> *pr;
//pl文字左边间距
@property (strong, nonatomic) NSString<Optional> *pl;
//文字距离顶部间距
@property (strong, nonatomic) NSString<Optional> *sizetop;
//size 文字尺寸
@property (strong, nonatomic) NSString<Optional> *fontSize;
//colors 文字不同颜色
@property (strong, nonatomic) NSArray<Optional> *fontColors;
//asize 头像大小
@property (strong, nonatomic) NSString<Optional> *avatar_size;
//atop 头像距离顶部
@property (strong, nonatomic) NSString<Optional> *avatar_y;
//aleft 头像距离左边
@property (strong, nonatomic) NSString<Optional> *avatar_x;
//九宫格的数据
@property (strong, nonatomic) NSString<Optional> *scale9_top;
@property (strong, nonatomic) NSString<Optional> *scale9_bottom;
@property (strong, nonatomic) NSString<Optional> *scale9_left;
@property (strong, nonatomic) NSString<Optional> *scale9_right;
@property (strong, nonatomic) NSNumber<Optional> *screen_height;
@property (strong, nonatomic) NSNumber<Optional> *screen_top;

//2017.12.7 添加跳转房间
@property (strong, nonatomic) NSString<Optional> *toroomnumber;
//2017.12.7 图片比例
@property (strong, nonatomic) NSString<Optional> *imgscale;
@property (strong, nonatomic) NSString<Optional> *textscroll;

@property (strong, nonatomic) NSString<Optional> *version;
@property (strong, nonatomic) NSMutableArray<SFMContentModel,Optional> *content;
@property (strong, nonatomic) NSString<Optional> *content_left;
@property (strong, nonatomic) NSString<Optional> *content_right;

// 飘屏起始位置
@property (strong, nonatomic) NSString<Optional> *hor_ini_pos;

@property (strong, nonatomic) NSString<Optional> *sfm_info;

@end

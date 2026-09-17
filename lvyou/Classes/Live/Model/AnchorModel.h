// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  AnchorModel.h
//  beibei
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UserInfoModel.h"
@interface AnchorModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *lat;
@property (strong, nonatomic) NSString<Optional> *lng;
@property (strong, nonatomic) NSString<Optional> *location;
@property (strong, nonatomic) NSString<Optional> *people_num;
@property (strong, nonatomic) NSString<Optional> *endtime;
@property (strong, nonatomic) UserInfoModel<Optional>* anchor;
//0929
@property (strong, nonatomic) NSString<Optional> *download_video_add;
///2017.6.28新增密码房字段
@property (strong, nonatomic) NSString<Optional> *pwd;
//标题
//@property (strong, nonatomic) NSString<Optional> *showtitle;
@property (strong, nonatomic) NSString<Optional> *isPayMode;
/// 2017.04.20
@property (strong, nonatomic) NSString<Optional> *bottom_url;
@property (strong, nonatomic) NSString<Optional> *bottom_url_height;

/// 4.24
@property (strong, nonatomic) NSString<Optional> *img1;
@property (strong, nonatomic) NSString<Optional> *img2;
//9.14 热门添加印象标签
@property (strong, nonatomic) NSMutableArray<Optional> *yinxiang;

//2018.9.5 全屏还是半屏
@property (strong, nonatomic) NSString<Optional> *isphone;
@property (strong, nonatomic) NSString<Optional> *showtitle;

@property (strong, nonatomic) NSString<Optional> *placeholder_img;

@end

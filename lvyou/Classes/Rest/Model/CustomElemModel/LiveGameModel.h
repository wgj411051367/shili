//
//  LiveGameModel.h
//  aibei
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LiveGameModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *url;
@property (strong, nonatomic) NSString<Optional> *http_address;
@property (strong, nonatomic) NSString<Optional> *height;
@property (strong, nonatomic) NSString<Optional> *online;
@property (strong, nonatomic) NSString<Optional> *icon;
@property (strong, nonatomic) NSString<Optional> *img;
@property (strong, nonatomic) NSString<Optional> *full;
@property (strong, nonatomic) NSString<Optional> *gameid;
@property (strong, nonatomic) NSString<Optional> *roomnumber;

//9.4 新增字段 游戏可触摸区域
@property (strong, nonatomic) NSString<Optional> *touch_height;

@end


//
//  GiftModel.h
//  beibei
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GiftModel : JSONModel
//animation = "<null>";
//exp = 10;
//icon = "/0/gift/Banana.png";
//id = 37pg7;
//name = "\U9999\U8549";
//"need_exp" = 0;
//"need_vip" = 0;
//price = 10;

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *icon;
@property (strong, nonatomic) NSString<Optional> *animation;
@property (strong, nonatomic) NSString<Optional> *price;
@property (strong, nonatomic) NSString<Optional> *exp;
@property (strong, nonatomic) NSString<Optional> *giftcateid;
@property (strong, nonatomic) NSString<Optional> *need_vip;
@property (strong, nonatomic) NSString<Optional> *need_exp;
@property (strong, nonatomic) NSString<Optional> *is_star;
@property (strong, nonatomic) NSString<Optional> *is_activity;
// 3.1
@property (strong, nonatomic) NSString<Optional> *intr;
@property (strong, nonatomic) NSString<Optional> *tag;
//7.28
@property (strong, nonatomic) NSString<Optional> *uptime;
//2018.8.14
@property (strong, nonatomic) NSString<Optional> *newpwd;
//2017.12.6 支付类型
@property (strong, nonatomic) NSString<Optional> *paytype;
@property (strong, nonatomic) NSString<Optional> *filename;

@property (strong, nonatomic) NSString<Optional> *tag_bg_color;

@property (strong, nonatomic) NSString<Optional> *is_show;
@property (strong, nonatomic) NSString<Optional> *to_userid;
@end

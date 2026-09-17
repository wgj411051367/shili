//
//  BagModel.h
//  beibei
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BagModel : JSONModel
//"id": "1",
//"type": 1,
//"name": "VIP充值送礼包测试",
//"icon": "/6/14703661694831.jpg",
//"animation": "",
//"price": 0,
//"exp": 0,
//"source": 0,
//"continuous": 1,
//"desc": "",
//"use_count": 0,
//"status": 1,
//"need_vip": 0,
//"need_exp": 0,
//"created_at": 1470366230,
//"updated_at": 1470366473
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *type;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *icon;
@property (strong, nonatomic) NSString<Optional> *animation;
@property (strong, nonatomic) NSString<Optional> *price;
@property (strong, nonatomic) NSString<Optional> *exp;
@property (strong, nonatomic) NSString<Optional> *source;
@property (strong, nonatomic) NSString<Optional> *continuous;
@property (strong, nonatomic) NSString<Optional> *desc;
@property (strong, nonatomic) NSString<Optional> *use_count;
@property (strong, nonatomic) NSString<Optional> *status;
@property (strong, nonatomic) NSString<Optional> *need_vip;
@property (strong, nonatomic) NSString<Optional> *need_exp;
@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *updated_at;
@property (strong, nonatomic) NSString<Optional> *is_star;
@property (strong, nonatomic) NSString<Optional> *is_activity;
@end

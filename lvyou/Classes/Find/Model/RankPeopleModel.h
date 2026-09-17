//
//  RankPeopleModel.h
//  beibei
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RankPeopleModel : JSONModel
//"id": "1",
//"name": "1级",
//"img": "/5/1468897641.png",
//"type": "0",
//"min": "1",
//"max": "100",
//"created_at": "1468893656",
//"updated_at": "1468893656"
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *name;//昵称
@property (strong, nonatomic) NSString<Optional> *gender;//性别
@property (strong, nonatomic) NSString<Optional> *img;
@property (strong, nonatomic) NSString<Optional> *type;//类型
@property (strong, nonatomic) NSString<Optional> *min;
@property (strong, nonatomic) NSString<Optional> *max;
@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *updated_at;
@property (strong, nonatomic) NSString<Optional> *level;//等级

@end

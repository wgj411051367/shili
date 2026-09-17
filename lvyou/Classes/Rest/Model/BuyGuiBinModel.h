//
//  LiveGameModel.h
//  aibei
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BuyGuiBinModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *xufei;
@property (strong, nonatomic) NSString<Optional> *xufei_id;
@property (strong, nonatomic) NSString<Optional> *isusing;
@property (strong, nonatomic) NSString<Optional> *shouyue;
@property (strong, nonatomic) NSString<Optional> *shouyue_id;
@property (strong, nonatomic) NSString<Optional> *level;
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *intr;
@property (strong, nonatomic) NSString<Optional> *giftname;
@property (strong, nonatomic) NSString<Optional> *dihuang_recommend;

@end

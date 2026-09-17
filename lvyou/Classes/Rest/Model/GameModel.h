//
//  BagModel.h
//  beibei
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GameModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *icon;
@property (strong, nonatomic) NSString<Optional> *online;
@property (strong, nonatomic) NSString<Optional> *http_address;

@end

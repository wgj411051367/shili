//
//  LiveGameModel.h
//  aibei
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface shouHuModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *price;
@property (strong, nonatomic) NSString<Optional> *validity;
@property (strong, nonatomic) NSString<Optional> *extra;
@end

//
//  LiveGameModel.h
//  aibei
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NobleModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *anum;
@property (strong, nonatomic) NSString<Optional> *clantype;
@property (strong, nonatomic) NSString<Optional> *guizhu;
@property (strong, nonatomic) NSString<Optional> *medalname;
@property (strong, nonatomic) NSString<Optional> *medalvalid;
@property (strong, nonatomic) NSString<Optional> *nickname;
@property (strong, nonatomic) NSString<Optional> *richlevel;
@property (strong, nonatomic) NSString<Optional> *tietiao;
@property (strong, nonatomic) NSString<Optional> *totalcost;
@property (strong, nonatomic) NSString<Optional> *update_avatar_time;
@property (strong, nonatomic) NSString<Optional> *userid;
@property (strong, nonatomic) NSString<Optional> *usernumber;
@property (strong, nonatomic) NSString<Optional> *usertype;
@property (strong, nonatomic) NSString<Optional> *viplevel;

@end

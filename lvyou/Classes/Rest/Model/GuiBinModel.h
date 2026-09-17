//
//  LiveGameModel.h
//  aibei
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GuiBinModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *guibinlevel;
@property (strong, nonatomic) NSString<Optional> *nickname;
@property (strong, nonatomic) NSString<Optional> *rank_id;
@property (strong, nonatomic) NSString<Optional> *update_avatar_time;
@property (strong, nonatomic) NSString<Optional> *userid;

@end

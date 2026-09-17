//
//  RankingLiistModel.h
//  beibei
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RankingLiistModel : JSONModel

@property(nonatomic,copy)  NSString<Optional>* id;
@property(nonatomic,copy)  NSMutableDictionary<Optional>* consumer;
@property(nonatomic,copy)  NSMutableDictionary<Optional>* item;
@property(nonatomic,copy)  NSString<Optional>* item_num;
@property(nonatomic,copy)  NSMutableDictionary<Optional>* receiver;
@property(nonatomic,copy)  NSString<Optional>* receiver_got_ticket;
@property(nonatomic,copy)  NSString<Optional>* created_at;
@property(nonatomic,copy)  NSString<Optional>* total;

@end

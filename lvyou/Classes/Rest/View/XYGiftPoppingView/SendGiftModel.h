//
//  SendGiftModel.h
//  beibei
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendGiftModel : NSObject
@property (nonatomic,strong) NSString *headImage; // 头像图片
@property (nonatomic,strong) NSString *giftImage; // 礼物图片
@property (nonatomic,copy) NSString *name; // 送礼物者
@property (nonatomic,copy) NSString *toname; // 收礼礼物者
@property (nonatomic,copy) NSString *giftName; // 礼物名称
@property (nonatomic,copy) NSString *giftId; // 礼物id
@property (nonatomic,copy) NSString *giftVersion; // 礼物版本
@property (nonatomic,copy) NSString *newpwd; // 礼物新的密码 2018.8.17
@property (nonatomic,copy) NSString *filename; // 礼物新id 2018.8.17
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,assign) int attach; // 连送数量
@property (nonatomic,copy)NSString *award_mulit;//中奖倍数
@property (nonatomic,assign) BOOL isHaoHuaGift;//是否豪华礼物

@end

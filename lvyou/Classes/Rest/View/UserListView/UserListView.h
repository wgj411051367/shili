// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// 
//
// ///////////////////////////////////////////////////////////////////////////
//
//  UserListView
//  beibei
//
//  Created by dev on 16/6/28.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingLiistModel.h"
@interface UserListView : UICollectionReusableView
{
    BOOL type;
    NSString *firstTotal,*secondTotal,*thirdTotal;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *jiangbeiView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIImageView *firstAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *secondAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *threeAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *firstLevel;
@property (weak, nonatomic) IBOutlet UIImageView *secondLevel;
@property (weak, nonatomic) IBOutlet UIImageView *threeLevel;
@property (weak, nonatomic) IBOutlet UIImageView *firstSex;
@property (weak, nonatomic) IBOutlet UIImageView *secondSex;
@property (weak, nonatomic) IBOutlet UIImageView *threeSex;
@property (weak, nonatomic) IBOutlet UIImageView *firstBackImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondBackImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeBackImg;
@property (weak, nonatomic) IBOutlet UILabel *firstNick;
@property (weak, nonatomic) IBOutlet UILabel *secondNick;
@property (weak, nonatomic) IBOutlet UILabel *threeNick;
@property (weak, nonatomic) IBOutlet UILabel *firstListLab;
@property (weak, nonatomic) IBOutlet UILabel *secondListLab;
@property (weak, nonatomic) IBOutlet UILabel *threeListLab;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *circleImg;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

@property (weak, nonatomic) IBOutlet UIButton *firstAttentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondAttentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeAttentionBtn;

//第一名关注
@property(nonatomic,copy)void (^firstAttentionClick)(UIButton *btn);
//第二名关注
@property(nonatomic,copy)void (^secondAttentionClick)(UIButton *btn);
//第三名关注
@property(nonatomic,copy)void (^threeAttentionClick)(UIButton *btn);
//第一名
@property(nonatomic,copy)void (^firstAvatarClick)(NSInteger ,BOOL);
//第二名
@property(nonatomic,copy)void (^secondAvatarClick)(NSInteger ,BOOL);
//第三名
@property(nonatomic,copy)void (^threeAvatarClick)(NSInteger ,BOOL);

-(void)setUserInfo:(NSMutableArray *)dataArr andType:(BOOL)iszhubo;

@end

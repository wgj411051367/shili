// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://m.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  PersonalView.h
//  beibei
//
//  Created by dev on 16/6/28.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoModel;

@interface PersonalView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn1;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIImageView *seximg;
@property (weak, nonatomic) IBOutlet UIImageView *levelImg;
@property (weak, nonatomic) IBOutlet UILabel *levelNum;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;

//送出
@property (strong, nonatomic) IBOutlet UILabel *send;
@property (strong, nonatomic) IBOutlet UILabel *follownum;
//粉丝
@property (strong, nonatomic) IBOutlet UILabel *fansnum;
//贡献榜
@property (strong, nonatomic) IBOutlet UIImageView *imagView1;
@property (strong, nonatomic) IBOutlet UIImageView *imagView2;
@property (strong, nonatomic) IBOutlet UIImageView *imagView3;

@property (strong, nonatomic) IBOutlet UIImageView *blueV;

//编辑资料回调
@property (copy, nonatomic) void (^exitBtnClick)();
//设置回调
@property (copy, nonatomic) void (^setBtnClick)();
//头像点击回调
@property (copy, nonatomic) void (^headimgBtnClick)();
//我的关注回调
@property (copy, nonatomic) void (^attentionBtnClick)();
//我的粉丝回调
@property (copy, nonatomic) void (^fansBtnClick)();
//送出回调
@property (copy, nonatomic) void (^sendBtnClick)();
//贡献榜回调
@property (copy, nonatomic) void (^listBtnClick)();
//个人主页
@property (copy, nonatomic) void (^userInfoClick)();


@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDataLayout;
@property (weak, nonatomic) IBOutlet UIView *topDataView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewLayout;

@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (nonatomic, strong) LOTAnimationView *animation;


@property (copy, nonatomic) void (^topBtn1Click)();
@property (copy, nonatomic) void (^topBtn2Click)();
@property (copy, nonatomic) void (^topBtn3Click)();
@property (copy, nonatomic) void (^topBtn4Click)();
- (void)setUserTopBtn:(NSArray *)array;


-(void)setUserInfo:(UserInfoModel *)userModel;
-(void)initAvatarImages:(NSMutableArray *)images;

@end

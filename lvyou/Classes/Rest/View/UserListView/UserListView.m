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

#import "UserListView.h"
#import "BaseViewController.h"
#import "RankPeopleModel.h"
#import "Constants.h"
#import "BaseViewController.h"
@implementation UserListView

- (void)awakeFromNib
{
    [super awakeFromNib];
    //gradient
}

- (void)setCAGradientLayer:(UIView *)view
{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = view.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1.12, 0.98);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:72/255.0 green:207/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:34/255.0 green:162/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [view.layer insertSublayer:gl atIndex:0];
}
- (void)hiddenView
{
//    self.firstView.hidden=YES;
    self.firstSex.hidden=YES;
    self.firstNick.hidden=YES;
    self.firstListLab.hidden=YES;
    self.firstLevel.hidden=YES;
    self.firstAttentionBtn.hidden = YES;
//    self.firstAvatar.hidden=YES;
//    self.firstBackImg.hidden=YES;
//    self.secondView.hidden=YES;
//    self.threeView.hidden=YES;
    self.secondSex.hidden=YES;
    self.secondNick.hidden=YES;
    self.secondListLab.hidden=YES;
    self.secondLevel.hidden=YES;
    self.secondAttentionBtn.hidden = YES;
//    self.secondAvatar.hidden=YES;
//    self.secondBackImg.hidden=YES;
    self.threeSex.hidden=YES;
    self.threeNick.hidden=YES;
    self.threeLevel.hidden=YES;
    self.threeListLab.hidden=YES;
    self.threeAttentionBtn.hidden = YES;
//    self.threeAvatar.hidden=YES;
//    self.threeBackImg.hidden=YES;
    self.circleImg.hidden=YES;
    self.backImg.hidden=YES;
}
-(void)setUserInfo:(NSMutableArray *)dataArr andType:(BOOL)iszhubo
{
    [self hiddenView];
    type=iszhubo;
    RankingLiistModel *userModel;
    RankPeopleModel * rankPeopleModel;
    self.backView.backgroundColor = colorHead;
//    if (dataArr.count>0) {
        
        self.backView.layer.hidden=NO;
//    }
//    else{
//        self.backView.layer.hidden=YES;
//    }
    [self.firstAvatar setImage:[UIImage imageNamed:@"icon_live_list_second_kong"]];
    [self.secondAvatar setImage:[UIImage imageNamed:@"icon_live_list_second_kong"]];
    [self.threeAvatar setImage:[UIImage imageNamed:@"icon_live_list_second_kong"]];
    NSMutableDictionary*dic;
    if (dataArr.count>0) {
        userModel=dataArr[0];
        
        self.firstView.hidden=NO;
        self.firstSex.hidden=NO;
        self.firstNick.hidden=NO;
        self.firstListLab.hidden=NO;
        self.firstLevel.hidden=NO;
        self.firstAttentionBtn.hidden = NO;
//        self.firstAvatar.hidden=NO;
//        self.firstBackImg.hidden=NO;
        self.backImg.hidden=NO;
        
        [self setData:userModel and:dic and:rankPeopleModel andType:type and:self.firstListLab and:self.firstAvatar and:self.firstLevel and:self.firstSex and:self.firstNick and:self.firstAttentionBtn];
    }
    if (dataArr.count>1) {
        userModel=dataArr[1];
        self.secondView.hidden=NO;
        self.secondSex.hidden=NO;
        self.secondNick.hidden=NO;
        self.secondListLab.hidden=NO;
        self.secondLevel.hidden=NO;
//        self.secondAvatar.hidden=NO;
        self.secondBackImg.hidden=NO;
        self.secondAttentionBtn.hidden = NO;
        
        self.backImg.hidden=NO;
        [self setData:userModel and:dic and:rankPeopleModel andType:type and:self.secondListLab and:self.secondAvatar and:self.secondLevel and:self.secondSex and:self.secondNick and:self.secondAttentionBtn];
    }
    if (dataArr.count>2) {
        userModel=dataArr[2];
        self.threeView.hidden=NO;
        self.threeSex.hidden=NO;
        self.threeNick.hidden=NO;
        self.threeLevel.hidden=NO;
        self.threeListLab.hidden=NO;
//        self.threeAvatar.hidden=NO;
//        self.threeBackImg.hidden=NO;
        self.backImg.hidden=NO;
        self.threeAttentionBtn.hidden = NO;
        
        [self setData:userModel and:dic and:rankPeopleModel andType:type and:self.threeListLab and:self.threeAvatar and:self.threeLevel and:self.threeSex and:self.threeNick and:self.threeAttentionBtn];
    }
    if (dataArr.count>3){
        self.circleImg.hidden=NO;
    }
}

- (void)setData:(RankingLiistModel *)userModel and:(NSMutableDictionary *)dic and:(RankPeopleModel *)rankModel andType:(BOOL)iszhubo and:(UILabel *)userTotal and:(UIImageView *)avatarImg and:(UIImageView *)userlevel and:(UIImageView *)usersex and:(UILabel *)userNick and:(UIButton *)attentionBtn
{
    UserInfoModel *personModel;
    if(iszhubo == YES)
    {
        personModel= [[UserInfoModel alloc]initWithDictionary:userModel.receiver error:nil];
    }
    else
    {
        personModel= [[UserInfoModel alloc]initWithDictionary:userModel.consumer error:nil];
        
    }
    if (iszhubo==YES) {
        dic=userModel.receiver;
    }
    else{
        dic=userModel.consumer;
    }
    [avatarImg sd_setImageWithURL:[[[BaseViewController alloc] init] placeCorpsImg:[[ToolHelper toolHelper] realAvatarUrl:dic[@"id"] andUpdate:dic[@"update_avatar_time"]]]];
    rankModel = [[RankPeopleModel alloc] initWithDictionary:[SharedAppDelegate.rankDic objectForKey:dic[@"rank_id"]] error:nil];
    if (rankModel.img!=nil) {
        [userlevel sd_setImageWithURL:[[[BaseViewController alloc] init] placeCorpsImg:rankModel.img]];
    }
    if([dic[@"gender"] isEqualToString:@"0"]){
        [usersex setImage:[UIImage imageNamed:@"icon_live_sex"]];
    }else{
        [usersex setImage:[UIImage imageNamed:@"icon_live_sex_boy"]];
    }
    if (dic) {
        userNick.text=dic[@"nickname"];
    } else {
        userNick.text=userModel.receiver[@"nickname"];
    }
    
    if (iszhubo) {
        userTotal.text= [NSString stringWithFormat:@"共收到%@%@",userModel.total,[[BaseViewController alloc]jiFenNum]];
    } else {
        userTotal.text= [NSString stringWithFormat:@"共贡献%@%@",userModel.total,[[BaseViewController alloc]moneyname]];
    }
    if ([personModel.is_follow isEqualToString:@"0"]) {
        [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
//        [attentionBtn setImage:[UIImage imageNamed:@"icon_message_follow"] forState:UIControlStateNormal];
        //        self.attentionBtn.layer.borderColor=RGBACOLOR(204, 204, 204, 1).CGColor;
        //        [self.attentionBtn setTitle:@"已关注" forState:0];
        //        [self.attentionBtn setTitleColor:RGBACOLOR(204, 204, 204, 1) forState:0];
    }else{
//        [attentionBtn setImage:[UIImage imageNamed:@"icon_message_followed"] forState:UIControlStateNormal];
        [attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        //        self.attentionBtn.layer.borderColor=colorHead.CGColor;
        //        [self.attentionBtn setTitle:@"关注" forState:0];
        //        [self.attentionBtn setTitleColor:colorHead forState:0];
    }
}

- (IBAction)firstImgBtn:(id)sender {
    UIButton *btn=(UIButton *)sender;
    if (self.firstAvatarClick) {
        self.firstAvatarClick(btn.tag, type);
    }
}
- (IBAction)secondImgBtn:(id)sender {
    UIButton *btn=(UIButton *)sender;
    if (self.secondAvatarClick) {
        self.secondAvatarClick(btn.tag, type);
    }
}
- (IBAction)threeImgBtn:(id)sender {
    UIButton *btn=(UIButton *)sender;
    if (self.threeAvatarClick) {
        self.threeAvatarClick(btn.tag, type);
    }
}

- (IBAction)firstAttentionBtnAction:(id)sender {
    if (self.firstAttentionClick) {
        self.firstAttentionClick(self.firstAttentionBtn);
    }
}

- (IBAction)secondAttentionBtnAction:(id)sender {
    if (self.secondAttentionClick) {
        self.secondAttentionClick(self.secondAttentionBtn);
    }
}

- (IBAction)threeAttentionBtnAction:(id)sender {
    if (self.threeAttentionClick) {
        self.threeAttentionClick(self.threeAttentionBtn);
    }
}


@end

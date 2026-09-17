// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://m.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveHotHeaderView.m
//  beibei
//
//  Created by dev on 16/6/28.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "PersonalView.h"
#import "BaseViewController.h"
#import "RankPeopleModel.h"
#import "Constants.h"
#import "PersonInfoModel.h"
@implementation PersonalView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
- (NSString *)moneyname
{
    NSString *moneyName;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"money_name"]==nil)
    {
        moneyName=[NSString stringWithFormat:@"%@",@"金币"];
    }
    else
    {
        moneyName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"money_name"]];
    }
    return moneyName;
}

-(void)setUserInfo:(UserInfoModel *)userModel
{
    //赋值展示
    self.nickname.text = userModel.nickname;
    //3.7 当数量大于1万时 显示x万
    NSString *numbers =userModel.total_send_gift;
    if ([numbers intValue]>10000)
    {
        NSString *ticket=[NSString stringWithFormat:@"%.2f万",[numbers floatValue]/10000];
        self.send.text=ticket;
        if ([numbers intValue]>100000000)
        {
            NSString *ticket=[NSString stringWithFormat:@"%.2f亿",[numbers floatValue]/100000000];
            self.send.text=ticket;
            
        }
    }
    else
    {
        self.send.text =numbers;
    }
    
    self.send.text = userModel.haoyou_num;
//    self.account
    self.avatarImg.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImg.clipsToBounds = YES;
    self.avatarImg.layer.borderWidth = 1;
    self.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.avatarImg sd_setImageWithURL:[[[BaseViewController alloc] init] placeCorpsImg:[[ToolHelper toolHelper] realAvatarUrl:userModel.id andUpdate:userModel.update_avatar_time]]];
    
     
    if (userModel.avatar_frame) {
        if (![userModel.avatar_frame isEqualToString:@""]) {
            NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [directoryPaths objectAtIndex:0];
            NSString *filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",userModel.avatar_frame]];
            if (self.animation) {
                [self.animation stop];
                [self.animation removeFromSuperview];
                self.animation = nil;
            }
            if (!self.animation) {
                CGFloat width = (self.avatarImg.width * 42) / 30;
                self.animation = [LOTAnimationView animationWithFilePath:filePath];
                self.animation.loopAnimation = YES;
                [self.animationView addSubview:self.animation];
                [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.animationView);
                    make.width.height.equalTo(@(width));
                }];
                [self.animation playWithCompletion:^(BOOL animationFinished) {
                }];
            }
        }
    } else {
        if (self.animation) {
            [self.animation stop];
            [self.animation removeFromSuperview];
            self.animation = nil;
        }
    }
    
    

    
    
    
    if([userModel.gender isEqualToString:@"0"]){
        [self.seximg setImage:[UIImage imageNamed:@"icon_live_sex"]];
    }else{
        [self.seximg setImage:[UIImage imageNamed:@"icon_live_sex_boy"]];
    }
    NSString *usernumber_name=[[NSUserDefaults standardUserDefaults]objectForKey:@"usernumber_name"];
    if (![self isBlankString:usernumber_name]) {
        if([userModel.haoma isEqualToString:@"0"]){
            self.account.text = [NSString stringWithFormat:@"直播号:%@",userModel.unique_id];
        }else{
            self.account.text = [NSString stringWithFormat:@"%@:%@",usernumber_name,userModel.haoma];
        }
    }
    
    [self showTheGuiZu:self.vipImg With:userModel.guizhu];
    
//    if ([userModel.pass3 isEqualToString:@"1"]) {
//        self.blueV.image = [UIImage imageNamed:@"icon_bluevip_v_se"];
//    } else {
//        self.blueV.image = [UIImage imageNamed:@"icon_bluevip_v_un"];
//    }
    
    //2018.10.31显示等级
    [self showThelevel:userModel.rank_id and:self.levelImg and:self.levelNum];

    if(userModel.fans_num!=nil){
        _fansnum.text=[NSString stringWithFormat:@"%@",userModel.fans_num];
    }else{
        _fansnum.text=[NSString stringWithFormat:@"%@",@"0"];
    }
    if(userModel.follow_num!=nil){
        _follownum.text=[NSString stringWithFormat:@"%@",userModel.follow_num];
    }else{
        _follownum.text=[NSString stringWithFormat:@"%@",@"0"];
    }
}

- (void)setUserTopBtn:(NSArray *)array {
    
    if (array.count == 0) {
        _topDataLayout.constant = 0;
        _headViewLayout.constant = _headViewLayout.constant - 77;
        self.size = CGSizeMake(SCREEN_WIDTH, _headViewLayout.constant);
        _topDataView.hidden = YES;   // 当data_top的数据为空时，隐藏顶部TopView
    } else if (array.count > 3) {
        self.size = CGSizeMake(SCREEN_WIDTH, _headViewLayout.constant);
        PersonInfoModel *model1 = array[0];
        PersonInfoModel *model2 = array[1];
        PersonInfoModel *model3 = array[2];
        PersonInfoModel *model4 = array[3];
        
        _label1.text = model1.name;
        _label2.text = model2.name;
        _label3.text = model3.name;
        _label4.text = model4.name;
        
        [_image1 sd_setImageWithURL:[self placeCorpsImg:model1.icon]];
        [_image2 sd_setImageWithURL:[self placeCorpsImg:model2.icon]];
        [_image3 sd_setImageWithURL:[self placeCorpsImg:model3.icon]];
        [_image4 sd_setImageWithURL:[self placeCorpsImg:model4.icon]];
    }
    
    
//
//    [_btn2 setTitle:model2.name forState:UIControlStateNormal];
//    [_btn3 setTitle:model3.name forState:UIControlStateNormal];
//    [_btn4 setTitle:model4.name forState:UIControlStateNormal];
//
//
//    [_btn1.imageView sd_setImageWithURL:[self placeCorpsImg:model1.icon]];
//    [_btn2.imageView sd_setImageWithURL:[self placeCorpsImg:model2.icon]];
//    [_btn3.imageView sd_setImageWithURL:[self placeCorpsImg:model3.icon]];
//    [_btn4.imageView sd_setImageWithURL:[self placeCorpsImg:model4.icon]];
}

- (NSURL *)placeCorpsImg:(NSString*)addr
{
    //判断是不是全路径
    if([[ToolHelper toolHelper] ReplacingCharActer:addr]){
        //全路径
        return [NSURL URLWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
    }else{
        //        拼接路径
        return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",IMAGEAPI,addr]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
}
//显示等级部分
- (void)showThelevel:(NSString *)randid and:(UIImageView *)levelimg and:(UILabel *)levelLab
{
    NSString *realLevel=randid;
    if ([randid containsString:@"_"]) {
        NSArray *tempArr=[randid componentsSeparatedByString:@"_"];
        if (tempArr.count>0) {
            realLevel=tempArr[0];
        }
    }
    RankPeopleModel *rankModel = [[RankPeopleModel alloc] initWithDictionary:[SharedAppDelegate.rankDic objectForKey:realLevel] error:nil];
                [levelimg sd_setImageWithURL:[[[BaseViewController alloc] init] placeCorpsImg:rankModel.img] placeholderImage:nil];
            levelLab.text = realLevel;

    levelLab.hidden=YES;
}
//显示贵族
- (void)showTheGuiZu:(UIImageView *)imgView With:(NSString *)guizu
{
    if (![self isBlankString:guizu]) {
        int i = [guizu intValue];
        if (i > 0 && i < 7) {
            imgView.hidden = NO;
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_gui%d",i]];
        } else {
            imgView.hidden = YES;
        }
    } else {
        imgView.hidden = YES;
    }
}
//显示vip
- (void)showTheVip:(UIImageView *)imgView With:(NSString *)vip_util With:(NSString *)viplevel
{
    double vipTime = [vip_util doubleValue];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970] / 1000;
    if (now > vipTime) {
        //vip已过期
        imgView.hidden = YES;
    }
    else{
        imgView.hidden =NO;
        //vip未过期  显示vip
        if ([viplevel intValue]==1)
        {
            imgView.image=[UIImage imageNamed:@"icon_yellowvip"];
        }
        else if ([viplevel intValue]==2)
        {
            imgView.image=[UIImage imageNamed:@"icon_purplevip"];
        }
        else if ([viplevel intValue]==3)
        {
            imgView.image=[UIImage imageNamed:@"icon_blackvip"];
        }
    }
}
- (BOOL)isBlankString:(NSString *)string
{
    if (!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
-(void)initAvatarImages:(NSMutableArray *)images
{
    self.imagView1.contentMode=UIViewContentModeScaleAspectFill;
    self.imagView1.clipsToBounds = YES;
    self.imagView2.contentMode=UIViewContentModeScaleAspectFill;
    self.imagView2.clipsToBounds = YES;
    self.imagView3.contentMode=UIViewContentModeScaleAspectFill;
    self.imagView3.clipsToBounds = YES;
    if(images.count == 0)
    {
        self.imagView1.image = self.imagView2.image = self.imagView3.image = [UIImage imageNamed:@"icon_devote_images_zero"];
    }
    if (images.count >= 1)
    {
        self.imagView1.image = self.imagView2.image = [UIImage imageNamed:@"icon_devote_images_zero"];
        [self.imagView1 sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"icon_devote_images_zero"]];
    }
    if (images.count >= 2)
    {
        self.imagView3.image = [UIImage imageNamed:@"icon_devote_images_zero"];
        [self.imagView1 sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"icon_devote_images_zero"]];
        [self.imagView2 sd_setImageWithURL:[NSURL URLWithString:images[1]] placeholderImage:[UIImage imageNamed:@"icon_devote_images_zero"]];
    }
    if (images.count >= 3)
    {
        [self.imagView1 sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"icon_devote_images_zero"]];
        [self.imagView2 sd_setImageWithURL:[NSURL URLWithString:images[1]] placeholderImage:[UIImage imageNamed:@"icon_devote_images_zero"]];
        [self.imagView3 sd_setImageWithURL:[NSURL URLWithString:images[2]] placeholderImage:[UIImage imageNamed:@"icon_devote_images_zero"]];
    }
}
//编辑
- (IBAction)exitBtnAction:(id)sender {
    if (self.exitBtnClick) {
        self.exitBtnClick();
    }
}
//设置
- (IBAction)setBtnAction:(id)sender {
    if (self.setBtnClick) {
        self.setBtnClick();
    }
}
//点击头像
- (IBAction)headImgAction:(id)sender {
    if (self.headimgBtnClick) {
        self.headimgBtnClick();
    }
}
//关注
- (IBAction)attentionAction:(id)sender {
    if (self.attentionBtnClick) {
        self.attentionBtnClick();
    }
}
//粉丝
- (IBAction)fansAction:(id)sender {
    if (self.fansBtnClick) {
        self.fansBtnClick();
    }
}
//送出
- (IBAction)sendAction:(id)sender {
    if (self.sendBtnClick) {
        self.sendBtnClick();
    }
}

// 个人主页
- (IBAction)userInfoAction:(id)sender {
    if (self.userInfoClick) {
        self.userInfoClick();
    }
}
//贡献榜
- (IBAction)listAction:(id)sender {
    if (self.listBtnClick) {
        self.listBtnClick();
    }
}
- (IBAction)topBtn1Action:(id)sender {
    if (self.topBtn1Click) {
        self.topBtn1Click();
    }
}
- (IBAction)topBtn2Action:(id)sender {
    if (self.topBtn2Click) {
        self.topBtn2Click();
    }
}
- (IBAction)topBtn3Action:(id)sender {
    if (self.topBtn3Click) {
        self.topBtn3Click();
    }
}
- (IBAction)topBtn4Action:(id)sender {
    if (self.topBtn4Click) {
        self.topBtn4Click();
    }
}

@end

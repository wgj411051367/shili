//
//  nbPackView.m
//  RedPacketDemo
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GuanZhuHostView.h"
#import "UserInfoModel.h"
#import "SDWebImage.h"
#import "ToolHelper.h"
#import "BaseLiveViewController.h"
#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface GuanZhuHostView ()

@end
@implementation GuanZhuHostView
@synthesize backImg,content,nickname,guanzhuBtn,delegate;

-(instancetype)initWithFrame:(CGRect)frame andHeadImage:(NSString *)image andNickname:(NSString *)nick
{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        bgview.backgroundColor = [UIColor whiteColor];
        bgview.layer.cornerRadius = 20*ScreenBiLi;
        bgview.layer.masksToBounds = YES;
        [self addSubview:bgview];
        //头像
        self.backImg=[[UIImageView alloc]init];
        self.backImg.frame=CGRectMake(self.frame.size.width/2-40*ScreenBiLi, -40*ScreenBiLi ,80*ScreenBiLi,80*ScreenBiLi);
        self.backImg.layer.borderWidth = 1;
        self.backImg.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backImg.layer.cornerRadius=40*ScreenBiLi;
        self.backImg.layer.masksToBounds=YES;
        [self.backImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",image]] placeholderImage:[UIImage imageNamed:@"icon_login_head"]];
        self.backImg.userInteractionEnabled=NO;
        [self addSubview:self.backImg];
        
        
        
        
        //昵称
        self.nickname=[[UILabel alloc] initWithFrame:CGRectMake(0, self.backImg.frame.size.height/2+10*ScreenBiLi, self.frame.size.width, 22*ScreenBiLi)];
        self.nickname.text = nick;
        self.nickname.textAlignment=NSTextAlignmentCenter;
        self.nickname.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
        self.nickname.textColor = [UIColor colorWithHex:0x333333];
        [self addSubview:self.nickname];

        //内容
//        self.content=[[UILabel alloc] initWithFrame:CGRectMake(0, self.backImg.frame.size.height/2+22*ScreenBiLi+10*ScreenBiLi, self.frame.size.width, 17*ScreenBiLi)];
//        self.content.text = @"喜欢主播点关注,关注主播不迷路";
//        self.content.textAlignment=NSTextAlignmentCenter;
//        self.content.font = [UIFont systemFontOfSize:12.0f];
//        self.content.textColor = [UIColor blackColor];
//        [self addSubview:self.content];
        
        //关注按钮
        self.guanzhuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        self.guanzhuBtn.frame=CGRectMake(self.frame.size.width/2-50*ScreenBiLi,self.frame.size.height-30*ScreenBiLi-25*ScreenBiLi, 100*ScreenBiLi, 30*ScreenBiLi);
        [self.guanzhuBtn setBackgroundColor:colorHead];
        self.guanzhuBtn.layer.cornerRadius=20*ScreenBiLi;
        self.guanzhuBtn.layer.masksToBounds=YES;
        [self.guanzhuBtn setTitle:@"+ 关注" forState:0];
        [self.guanzhuBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self.guanzhuBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.guanzhuBtn addTarget:self action:@selector(guanzhuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.guanzhuBtn];
        
        [self.guanzhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickname.mas_bottom).offset(36*ScreenBiLi);
            make.centerX.equalTo(self.nickname);
            make.height.equalTo(@(40*ScreenBiLi));
            make.width.equalTo(@(158*ScreenBiLi));
        }];
        
//        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void)guanzhuBtnClick:(UIButton *)btn
{
    if(delegate &&[delegate respondsToSelector:@selector(attentionBtnAction:)]) {
        [((BaseLiveViewController *)delegate) attentionBtnAction:btn];
        //点击关注按钮之后移除btn
        [self hide];
    }
}

- (void)hide
{
    [self dismiss];
}
- (void)dismiss {
    [UIView animateWithDuration:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
@end

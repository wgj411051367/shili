//
//  InviteView.m
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "DaShangView.h"
#import "Constants.h"
#import "BaseLiveViewController.h"
@implementation DaShangView
@synthesize backImg,closeBtn,giftImg,priceLabel,dashangBtn,delegate;

- (instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)img  andPrice:(NSString *)price andGiftid:(NSString *)giftid
{
    
    if (self = [super initWithFrame:frame]) {
        //背景图片
        if(backImg==nil)
        {
            backImg=[[UIImageView alloc] init];
            backImg.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            backImg.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            backImg.image=[UIImage imageNamed:@"dashangBack"];
            backImg.userInteractionEnabled=YES;
        }
        //叉号按钮
        if (closeBtn==nil) {
            closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            closeBtn.frame=CGRectMake(self.backImg.frame.size.width-60*ScreenBiLi, 0, 60*ScreenBiLi, 60*ScreenBiLi);
            [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
            [self.backImg addSubview:self.closeBtn];
        }
        //礼物图标
        if (giftImg==nil) {
            giftImg=[[UIImageView alloc] init];
            giftImg.frame=CGRectMake((self.backImg.frame.size.width-60*ScreenBiLi)/2, 75*ScreenBiLi, 60*ScreenBiLi, 60*ScreenBiLi);
            giftImg.contentMode = UIViewContentModeScaleAspectFill;
            giftImg.clipsToBounds = YES;
            [giftImg sd_setImageWithURL:[self placeImg:img] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
            [self.backImg addSubview:giftImg];
        }
        //价格
        if (priceLabel==nil) {
            priceLabel=[[UILabel alloc] init];
            priceLabel.font =  [UIFont systemFontOfSize:12.0f];
            priceLabel.textColor =  [UIColor colorWithRed:242/255.0 green:92/255.0 blue:90/255.0 alpha:1/1.0];
            priceLabel.textAlignment=NSTextAlignmentCenter;
            priceLabel.frame=CGRectMake(0, self.giftImg.frame.origin.y+self.giftImg.frame.size.height+8*ScreenBiLi, self.frame.size.width, 17*ScreenBiLi);
            NSString *jindou=[[NSUserDefaults standardUserDefaults]objectForKey:@"money_name"];
            if (price!=nil) {
                priceLabel.text =[NSString stringWithFormat:@"%@%@",price,jindou];
            }
            else
            {
                priceLabel.text =[NSString stringWithFormat:@"%@%@",@"0",jindou];
            }
            [self.backImg addSubview:self.priceLabel];
        }
        
        //打赏按钮
        if (dashangBtn==nil) {
            dashangBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [dashangBtn setBackgroundImage:[UIImage imageNamed:@"dashangbtn"] forState:0];
            [dashangBtn addTarget:self action:@selector(dashangBtnClick) forControlEvents:UIControlEventTouchUpInside];
            dashangBtn.frame=CGRectMake(37*ScreenBiLi, self.backImg.size.height-9*ScreenBiLi-33*ScreenBiLi, 150*ScreenBiLi, 33*ScreenBiLi);
            [self.backImg addSubview:self.dashangBtn];
        }
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.57];
        [self addSubview:self.backImg];
        
        giftID=giftid;
    }
    return self;
}
#pragma mark -------打赏主播
- (void)dashangBtnClick
{
    if(delegate  &&[delegate respondsToSelector:@selector(sendGiftF:andLianSongNum:)])
    {
      [(BaseLiveViewController *)delegate sendGiftF:[giftID intValue] andLianSongNum:1];
    }
   [self closeView];
}
#pragma mark -------移除页面
- (void)closeView
{
    [UIView animateWithDuration:0.2 animations:^{
        [self removeFromSuperview];
    }];
}

- (NSURL *)placeImg:(NSString*)addr
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
- (void)dealloc
{
    
}

@end

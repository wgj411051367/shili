//
//  nbPackView.m
//  RedPacketDemo
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "nbPackView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation nbPackView
@synthesize imageHB,clickBtn,timer,closeBtn;

-(instancetype)initWithFrame:(CGRect)frame withSecond:(int)sec
{
    self=[super initWithFrame:frame];
    if (self) {
        second =sec;
        timer = [NSTimer pltScheduledTimerWithTimeInterval:1 target:self selector:@selector(showFullRedPackView) userInfo:nil];
        imageHB =[[UIImageView alloc] init];
        imageHB.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        imageHB.bounds=CGRectMake(0, 0, 86, 95);
        imageHB.image =[UIImage imageNamed:@"icon_live_purse_nb_red"];
        imageHB.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageHB];
        
        clickBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        clickBtn.center=imageHB.center;
        clickBtn.bounds=CGRectMake(0, 0, 38, 38);
        [clickBtn setTitle:[NSString stringWithFormat:@"%ld", (long)second] forState:UIControlStateNormal];
        [clickBtn setBackgroundImage:[UIImage imageNamed:@"icon_live_purse_nb_opentime"] forState:UIControlStateNormal];
        [self addSubview:clickBtn];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(self.frame.size.width-30, 0, 40, 40);
        [closeBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        [self addSubview:closeBtn];

    }
    return self;
}

- (void)showFullRedPackView
{
    second = second - 1;
    if (second == 0)
    {
        clickBtn.userInteractionEnabled = NO;
        [clickBtn setTitle:@"拆" forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
       
    }
    else
    {
        [clickBtn setTitle:[NSString stringWithFormat:@"%ld", (long)second] forState:UIControlStateNormal];
        clickBtn.userInteractionEnabled = NO;
    }
}



@end

//
//  nbPackView.m
//  RedPacketDemo
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MoreDetailView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation MoreDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-40)/2, 30, 40, 40)];
//        self.headImg.layer.masksToBounds = YES;
//        self.headImg.layer.cornerRadius = 25;
//        [self.headImg setCenter:CGPointMake(self.frame.size.width / 2, 25)];//h=40
        self.headImg.contentMode = UIViewContentModeScaleAspectFit;
        self.headImg.clipsToBounds = YES;
        [self addSubview:self.headImg];
        
        self.nickname = [[UILabel alloc]initWithFrame:CGRectMake(0, self.headImg.frame.origin.y + self.headImg.frame.size.height+15, self.frame.size.width, 12)];
        self.nickname.textAlignment=NSTextAlignmentCenter;
        self.nickname.textColor=[UIColor colorWithHex:0x9B9B9B];
        self.nickname.font = [UIFont systemFontOfSize:10.0f];
         [self addSubview:self.nickname];
        
        self.btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];//x==50
        //[self.btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self addSubview:self.btn];
        
    }
    return self;
}

@end

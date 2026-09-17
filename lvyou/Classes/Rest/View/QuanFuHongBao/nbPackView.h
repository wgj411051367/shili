//
//  nbPackView.h
//  RedPacketDemo
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTimer+Pluto.h"
@interface nbPackView : UIView
{
    int second;
}
@property(nonatomic,strong)UIImageView *imageHB;
@property(nonatomic,strong)NSString *hbid;
@property(nonatomic,strong)UIButton *clickBtn;

@property(nonatomic,strong)UIButton *closeBtn;
@property (nonatomic, strong) NSTimer *timer;

-(instancetype)initWithFrame:(CGRect)frame withSecond:(int)sec;

@end

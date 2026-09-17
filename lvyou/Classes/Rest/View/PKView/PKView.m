//
//  InviteView.m
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "PKView.h"
#import "Constants.h"
#import "BaseLiveViewController.h"

@implementation PKView
@synthesize backView,redView,blueView,redAndBlue,delegate,zhuboname,guestname,pkimgView,pkview;
-(void)setPKValueBlue:(float)faqiren andRed:(float)jieshouren{
    int total1=faqiren+jieshouren;
    faqiren += total1 * 0.25;
    jieshouren += total1 * 0.25;
    int total=faqiren+jieshouren;
    float totalWidth = 0.0;
    totalWidth=self.frame.size.width;
    float blueWidth;
    float redWidth;
    //2017.11.15 修改
    if (faqiren==0&&jieshouren==0)
    {
        blueView.frame=CGRectMake(5*ScreenBiLi, 4*ScreenBiLi, (self.frame.size.width-10*ScreenBiLi)/2, self.frame.size.height-8*ScreenBiLi);
                redAndBlue.frame=CGRectMake(blueView.frame.size.width,4*ScreenBiLi, 24*ScreenBiLi, 20*ScreenBiLi);
                redView.frame=CGRectMake(blueView.frame.size.width+blueView.x, 4*ScreenBiLi, (self.frame.size.width-10*ScreenBiLi)/2, self.frame.size.height-8*ScreenBiLi);
        
    }
    else
    {
        float bluePercent;
        float redPercent;
        if (self.num==1)  //发起人是当前房间主播
        {
            bluePercent=faqiren/total;
            redPercent=jieshouren/total;
            zhuboname.text=[NSString stringWithFormat:@"%@  %.0f",faqi,fabs(faqiren-total1 * 0.25)];
            guestname.text=[NSString stringWithFormat:@"%.0f  %@",fabs(jieshouren-total1 * 0.25),jieshou];
        }
        else  //发起人是对方房间主播
        {
            bluePercent=jieshouren/total;
            redPercent=faqiren/total;
            zhuboname.text=[NSString stringWithFormat:@"%@  %.0f",faqi,fabs(jieshouren-total1 * 0.25)];
            guestname.text=[NSString stringWithFormat:@"%.0f  %@",fabs(faqiren-total1 * 0.25),jieshou];
        }
        blueWidth=totalWidth*bluePercent;
        redWidth=totalWidth*redPercent;
        blueView.frame=CGRectMake(5*ScreenBiLi, 4*ScreenBiLi, blueWidth-5*ScreenBiLi, self.frame.size.height-8*ScreenBiLi);
//                redAndBlue.frame=CGRectMake(blueView.frame.size.width,0*ScreenBiLi, 20*ScreenBiLi, 28*ScreenBiLi);
                redView.frame=CGRectMake(blueView.frame.size.width+5*ScreenBiLi, 4*ScreenBiLi, redWidth-5*ScreenBiLi, self.frame.size.height-8*ScreenBiLi);
        
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:blueView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc ] init];
        cornerRadiusLayer.frame = blueView.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        blueView.layer.mask = cornerRadiusLayer;
        
        UIBezierPath *cornerRadiusPath1 = [UIBezierPath bezierPathWithRoundedRect:redView.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *cornerRadiusLayer1 = [[CAShapeLayer alloc ] init];
        cornerRadiusLayer1.frame = redView.bounds;
        cornerRadiusLayer1.path = cornerRadiusPath1.CGPath;
        redView.layer.mask = cornerRadiusLayer1;
        
        if (self.num==1)
        {
            //                blueView.backgroundColor=RGBACOLOR(78, 207, 253, 1);//蓝色
            blueView.backgroundColor = [UIColor colorWithHexString:@"#4FB6FA"];
            redView.backgroundColor = [UIColor colorWithHexString:@"#FF5B87"];
        }
        else
        {
            //                blueView.backgroundColor=RGBACOLOR(248, 110, 112, 1);//红色
            blueView.backgroundColor = [UIColor colorWithHexString:@"#FF5B87"];
            redView.backgroundColor = [UIColor colorWithHexString:@"#4FB6FA"];
        }
        
    }
}

- (instancetype)initWithFrame:(CGRect)frame withzhubo:(NSString *)faqiren withguest:(NSString *)jieshouren withNumber:(int)number
{
    if (self = [super initWithFrame:frame]) {
        //背景view
        if(backView==nil)
        {
            backView=[[UIView alloc] init];
            backView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
            backView.backgroundColor=[UIColor colorWithHexString:@"#061E3D"];
            backView.userInteractionEnabled=YES;
            [self addSubview:backView];
            
            UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc ] init];
            cornerRadiusLayer.frame = backView.bounds;
            cornerRadiusLayer.path = cornerRadiusPath.CGPath;
            backView.layer.mask = cornerRadiusLayer;
        }
        if(blueView==nil)
        {
            blueView=[[UIView alloc] init];
            blueView.frame=CGRectMake(5*ScreenBiLi, 4*ScreenBiLi, (frame.size.width-10*ScreenBiLi)/2, frame.size.height-8*ScreenBiLi);
            
            
            if (number==1)
            {
                //                blueView.backgroundColor=RGBACOLOR(78, 207, 253, 1);//蓝色
                blueView.backgroundColor = [UIColor colorWithHexString:@"#4FB6FA"];
            }
            else
            {
                //                blueView.backgroundColor=RGBACOLOR(248, 110, 112, 1);//红色
                blueView.backgroundColor = [UIColor colorWithHexString:@"#FF5B87"];
            }
            [backView addSubview:blueView];
            
            UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:blueView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc ] init];
            cornerRadiusLayer.frame = blueView.bounds;
            cornerRadiusLayer.path = cornerRadiusPath.CGPath;
            blueView.layer.mask = cornerRadiusLayer;
        }
        
        
        if(redView==nil)
        {
            redView=[[UIView alloc] init];
            redView.frame=CGRectMake(blueView.frame.size.width+blueView.x, 4*ScreenBiLi, (frame.size.width-10*ScreenBiLi)/2, frame.size.height-8*ScreenBiLi);
            if (number==1)
            {
                //               redView.backgroundColor=RGBACOLOR(248, 110, 112, 1);//红色
                redView.backgroundColor = [UIColor colorWithHexString:@"#FF5B87"];
            }
            else
            {
                
                //               redView.backgroundColor=RGBACOLOR(78, 207, 253, 1);//蓝色
                redView.backgroundColor = [UIColor colorWithHexString:@"#4FB6FA"];
                
            }
            [backView addSubview:redView];
            
            UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:redView.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc ] init];
            cornerRadiusLayer.frame = redView.bounds;
            cornerRadiusLayer.path = cornerRadiusPath.CGPath;
            redView.layer.mask = cornerRadiusLayer;
        }
        
        if (redAndBlue==nil) {
            redAndBlue=[[UIImageView alloc] init];
//            redAndBlue.frame=CGRectMake(blueView.frame.size.width,0*ScreenBiLi, 20*ScreenBiLi, 28*ScreenBiLi);
            redAndBlue.image=[UIImage imageNamed:@"pkcenter"];
            [backView addSubview:redAndBlue];
            
            [redAndBlue mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(blueView.mas_right);
                make.centerY.equalTo(self);
            }];
        }
        if (guestname==nil) {
            guestname=[[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-10*ScreenBiLi)/2-2, 3*ScreenBiLi, (frame.size.width-10*ScreenBiLi)/2, blueView.frame.size.height)];
            jieshou=@"对方";
            guestname.text=[NSString stringWithFormat:@"%@  %@",@"0",jieshou];//对方
            
            guestname.textColor=[UIColor whiteColor];
            guestname.textAlignment=NSTextAlignmentRight;
            guestname.font=[UIFont systemFontOfSize:15.0f];
            [self addSubview:guestname];
        }
        if (zhuboname==nil) {
            zhuboname=[[UILabel alloc] initWithFrame:CGRectMake(2+5*ScreenBiLi, 3*ScreenBiLi, (frame.size.width-10*ScreenBiLi)/2, redView.frame.size.height)];
            faqi=@"己方";
            zhuboname.text=[NSString stringWithFormat:@"%@  %@",faqi,@"0"]; //自己
            
            zhuboname.textColor=[UIColor whiteColor];
            zhuboname.textAlignment=NSTextAlignmentLeft;
            zhuboname.font=[UIFont systemFontOfSize:15.0f];
            [self addSubview:zhuboname];
        }
        self.num=number;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withzhubo:(NSString *)faqiren withguest:(NSString *)jieshouren withNumber:(int)number withTime:(NSString *)time
{
    if (self = [super initWithFrame:frame]) {
        //背景图片
        if(self.backImg==nil)
        {
            self.backImg=[[UIImageView alloc] init];
            self.backImg.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
            self.backImg.image=[UIImage imageNamed:@"pkback"];
            [self addSubview:self.backImg];
        }
        if (self.pk==nil) {
            self.pk=[[UIImageView alloc] init];
            self.pk.frame=CGRectMake(120*ScreenBiLi, 13*ScreenBiLi, 27*ScreenBiLi/2, 14*ScreenBiLi/2);
            self.pk.image=[UIImage imageNamed:@"pk"];
            [self.backImg addSubview:self.pk];
        }
        //        if (self.time==nil) {
        //            self.time=[[UILabel alloc] init];
        //            self.time.frame=CGRectMake(frame.size.width-180*ScreenBiLi, 5*ScreenBiLi, 160*ScreenBiLi, 20*ScreenBiLi);
        //            self.time.text=[NSString stringWithFormat:@"剩余: %@",time];
        //            self.time.textAlignment=NSTextAlignmentRight;
        //            self.time.textColor=[UIColor redColor];
        //            self.time.font=[UIFont systemFontOfSize:12.0f];
        //            [self.backImg addSubview:self.time];
        //        }
        //发起人
        if (zhuboname==nil) {
            zhuboname=[[UILabel alloc] initWithFrame:CGRectMake(15*ScreenBiLi, 30*ScreenBiLi, (frame.size.width-15*ScreenBiLi)/2, 20*ScreenBiLi)];
            zhuboname.text=[NSString stringWithFormat:@"%@ %@",faqiren,@"0"]; //自己
            faqi=faqiren;
            zhuboname.textColor=[UIColor whiteColor];
            zhuboname.textAlignment=NSTextAlignmentLeft;
            zhuboname.font=[UIFont systemFontOfSize:12.0f];
            [self.backImg addSubview:zhuboname];
        }
        //接收人
        if (guestname==nil) {
            guestname=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-(frame.size.width-15*ScreenBiLi)/2-15*ScreenBiLi, 30*ScreenBiLi, (frame.size.width-15*ScreenBiLi)/2, 20*ScreenBiLi)];
            guestname.text=[NSString stringWithFormat:@"%@ %@",@"0",jieshouren];//对方
            jieshou=jieshouren;
            guestname.textColor=[UIColor whiteColor];
            guestname.textAlignment=NSTextAlignmentRight;
            guestname.font=[UIFont systemFontOfSize:12.0f];
            [self.backImg addSubview:guestname];
        }
        pkview=[[UIView alloc] init];
        pkview.frame=CGRectMake(30*ScreenBiLi, self.backImg.frame.size.height-27*ScreenBiLi/2-15*ScreenBiLi, frame.size.width-60*ScreenBiLi, 27*ScreenBiLi/2);
        pkview.layer.cornerRadius=27*ScreenBiLi/4;
        pkview.layer.masksToBounds=YES;
        pkview.backgroundColor=[UIColor clearColor];
        [self.backImg addSubview:pkview];
        
        if(blueView==nil)
        {
            blueView=[[UIView alloc] init];
            blueView.frame=CGRectMake(0*ScreenBiLi, 0, pkview.frame.size.width/2, 27*ScreenBiLi/2);
            if (number==1)
            {
                //                blueView.backgroundColor=RGBACOLOR(78, 207, 253, 1);//蓝色
                blueView.backgroundColor = [UIColor gradientColorImageFromColors:@[[UIColor colorWithHex:0x0759E6],[UIColor colorWithHex:0x0CB8FD]] gradientType:GradientTypeLeftToRight imgSize:blueView.size];
            }
            else
            {
                //                blueView.backgroundColor=RGBACOLOR(248, 110, 112, 1);//红色
                blueView.backgroundColor = [UIColor gradientColorImageFromColors:@[[UIColor colorWithHex:0xB42424],[UIColor colorWithHex:0xF56051]] gradientType:GradientTypeLeftToRight imgSize:blueView.size];
            }
            [pkview addSubview:blueView];
        }
        if (redAndBlue==nil) {
            redAndBlue=[[UIImageView alloc] init];
            redAndBlue.frame=CGRectMake(blueView.frame.size.width,0, 24*ScreenBiLi, 27*ScreenBiLi/2);
            if (number==1)
            {
                redAndBlue.image=[UIImage imageNamed:@"pkcenter"];
            }
            else
            {
                redAndBlue.image=[UIImage imageNamed:@"pkcentertwo"];
            }
            [pkview addSubview:redAndBlue];
        }
        if(redView==nil)
        {
            redView=[[UIView alloc] init];
            redView.frame=CGRectMake(blueView.frame.size.width, 0, pkview.frame.size.width/2, 27*ScreenBiLi/2);
            if (number==1)
            {
                //               redView.backgroundColor=RGBACOLOR(248, 110, 112, 1);//红色
                redView.backgroundColor = [UIColor gradientColorImageFromColors:@[[UIColor colorWithHex:0xF56051],[UIColor colorWithHex:0xB42424]] gradientType:GradientTypeLeftToRight imgSize:redView.size];
            }
            else
            {
                
                //               redView.backgroundColor=RGBACOLOR(78, 207, 253, 1);//蓝色
                redView.backgroundColor = [UIColor gradientColorImageFromColors:@[[UIColor colorWithHex:0x0CB8FD],[UIColor colorWithHex:0x0759E6]] gradientType:GradientTypeLeftToRight imgSize:redView.size];
                
            }
            [pkview addSubview:redView];
        }
        if (self.redvsimg==nil)
        {
            self.redvsimg=[[UIImageView alloc] init];
            self.redvsimg.frame=CGRectMake((self.backImg.frame.size.width-121*ScreenBiLi/2)/2, self.backImg.frame.size.height-75*ScreenBiLi/2-13*ScreenBiLi, 121*ScreenBiLi/2, 75*ScreenBiLi/2);
            self.redvsimg.image=[UIImage imageNamed:@"pkvs"];
            [self.backImg addSubview:self.redvsimg];
        }
        self.num=number;
    }
    return self;
}
-(void)showPKResult:(NSString *)name{
    if (pkimgView) {
        [pkimgView removeFromSuperview];
        pkimgView=nil;
    }
    pkimgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [pkimgView setFrame:CGRectMake((self.frame.size.width-68*ScreenBiLi)/2, 0, 68*ScreenBiLi, 37*ScreenBiLi)];
    [self addSubview:pkimgView];
    [self animationWithImage:pkimgView];
}

- (void)removeTheView
{
    //移除pk条
    [self normalAnimationWithImage:pkimgView];
    [self removeFromSuperview];
}

//2018.8.15 添加图片缩放动画
- (void)animationWithImage:(UIImageView *) image{
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 1.0; // 动画持续时间
    animation.repeatCount = HUGE_VALF; // 重复次数 无限重复
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:0.8]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.2]; // 结束时的倍率
    // 添加动画
    [image.layer addAnimation:animation forKey:@"scale-layer"];
}

- (void)normalAnimationWithImage:(UIImageView *)image
{
    [image.layer removeAnimationForKey:@"scale-layer"];
}

@end

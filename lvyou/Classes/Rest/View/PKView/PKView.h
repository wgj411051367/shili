//
//  InviteView.h
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKView : UIView
{
    NSString *faqi,*jieshou;
}
@property(assign)int num;
//背景img
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIImageView *backImg;
@property(nonatomic,strong)UIImageView *timeimg;//倒计时图标
@property(nonatomic,strong)UIImageView *pk;//pk
@property(nonatomic,strong)UILabel *time;//倒计时
@property(nonatomic,strong)UILabel *zhuboname;
@property(nonatomic,strong)UIImageView *pkimg;  //中间pk条
@property(nonatomic,strong)UIImageView *redvsimg;  //中间vs条
@property(nonatomic,strong)UIView*pkview;
@property(nonatomic,strong)UIView *redView;
@property(nonatomic,strong)UIView *blueView;
@property(nonatomic,strong)UILabel *redValue;  //红方数字
@property(nonatomic,strong)UILabel *guestname;
@property(nonatomic,strong)UILabel *blueValue;  //蓝方数字
@property(nonatomic,strong)UIImageView *redAndBlue; //中间的图
@property(nonatomic,strong)UIImageView *pkimgView;
- (instancetype)initWithFrame:(CGRect)frame withzhubo:(NSString *)faqiren withguest:(NSString *)jieshouren withNumber:(int)number withTime:(NSString *)time;
- (instancetype)initWithFrame:(CGRect)frame withzhubo:(NSString *)faqiren withguest:(NSString *)jieshouren withNumber:(int)number;
-(void)setPKValueBlue:(float)faqiren andRed:(float)jieshouren;
-(void)showPKResult:(NSString *)name;
- (void)removeTheView;
@property (nonatomic,weak)id delegate;

@end

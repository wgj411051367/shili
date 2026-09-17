//
//  nbPackView.h
//  RedPacketDemo
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GuanZhuHostView : UIView

@property(nonatomic,strong)UIImageView *backImg;//头像
@property(nonatomic,strong)UILabel *nickname;//昵称
@property(nonatomic,strong)UILabel *content;//内容
@property (nonatomic, strong)UIButton *guanzhuBtn;//关注按钮
@property (nonatomic,weak)id delegate;

-(instancetype)initWithFrame:(CGRect)frame andHeadImage:(NSString *)image andNickname:(NSString *)nick;

- (void)hide;
@end

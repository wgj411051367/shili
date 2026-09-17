//
//  InviteView.h
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaShangView : UIView
{
    NSString *giftID;
}
//背景图片
@property(nonatomic,strong)UIImageView *backImg;
//叉号按钮
@property(nonatomic,strong)UIButton *closeBtn;
//礼物图片
@property(nonatomic,strong)UIImageView *giftImg;
//礼物价格
@property(nonatomic,strong)UILabel *priceLabel;
//打赏按钮
@property(nonatomic,strong)UIButton *dashangBtn;

- (instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)img  andPrice:(NSString *)price andGiftid:(NSString *)giftid;

@property (nonatomic,weak)id delegate;

@end

//
//  PresentView.h
//  presentAnimation
//
//  Created by 杲杲 on 16/7/14.
//  Copyright © 2016年 杲杲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeLabel.h"
#import "SendGiftModel.h"


typedef void(^completeBlock)(BOOL finished,NSInteger finishCount);

@interface PresentView : UIView{
    NSArray *numImageWidths;
    NSArray *awardImages;
    NSArray *numImages;
    UIView *awardLayer;
    UIImageView *awardAniLayer;
    NSTimer *hideAwardTimer;
}

@property (nonatomic,strong) SendGiftModel *giftmodel;
@property (nonatomic,strong) UIImageView *headImageView; // 头像
@property (nonatomic,strong) UIImageView *giftImageView; // 礼物
@property (nonatomic,strong) UILabel *nameLabel; // 送礼物者
@property (nonatomic,strong) UILabel *giftLabel; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,assign)BOOL isHide;//1.2 是否是神秘人隐身
@property (nonatomic,strong) ShakeLabel *skLabel;
@property (nonatomic,assign) NSInteger animCount; // 动画执行到了第几次
@property (nonatomic,assign) CGRect originFrame; // 记录原始坐标
@property (nonatomic,assign) float showtime;
@property (assign) BOOL finished;
- (void)animateWithCompleteBlock:(completeBlock)completed;
-(void)addAwardLayer:(NSString *)awardNum;
- (void)shakeNumberLabel;
//- (void)shakeNumberLabel2;
- (void)hidePresendView;
- (void)addAwardLayerFromVar;
- (void)shakeNumberLabelWithNum:(int)num andMulit:(NSString *)mulit;
@end

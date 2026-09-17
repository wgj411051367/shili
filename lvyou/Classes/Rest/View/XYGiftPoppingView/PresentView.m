//
//  PresentView.m
//  presentAnimation
//
//  Created by 杲杲 on 16/7/14.
//  Copyright © 2016年 杲杲. All rights reserved.
//

#import "PresentView.h"
#import "SDWebImage.h"
#import "SLGiftAnimationView.h"
#import "AppDelegate.h"

@interface PresentView ()
{
    SLGiftAnimationView*smallAnimationView;
    UIImageView *_bgImageView;
    AVAudioPlayer *avPlayer;
}
@property (strong, nonatomic) UIButton * headBtn;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,copy) void(^completeBlock)(BOOL finished,NSInteger finishCount); // 新增了回调参数 finishCount， 用来记录动画结束时累加数量，将来在3秒内，还能继续累加
@end

@implementation PresentView

// 根据礼物个数播放动画
- (void)animateWithCompleteBlock:(completeBlock)completed{

    __weak typeof (self)weakself =self;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [weakself shakeNumberLabel];
    }];
    self.completeBlock = completed;
}

- (void)shakeNumberLabelWithNum:(int)num andMulit:(NSString *)mulit{
    _animCount =num;
    [self.skLabel setText:[NSString stringWithFormat:@"X %d",num]];
    [self addAwardLayer:mulit];
}
- (void)shakeNumberLabel{
    [self.skLabel setText:[NSString stringWithFormat:@"X %ld",_animCount]];
}

- (void)hidePresendView
{
    __weak typeof (self)weakself =self;
    [UIView animateWithDuration:0.30 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y-20, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        if (weakself.completeBlock) {
            weakself.completeBlock(finished,_animCount);
        }
        [weakself reset];
        _finished = finished;
        [weakself removeFromSuperview];
    }];
}

// 重置
- (void)reset {
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
}
-(void)addAwardLayer:(NSString *)awardNum{
    if (awardNum==nil) {
        return;
    }
    if ([awardNum isEqualToString:@"0"]) {
        return;
    }
    if (awardLayer!=nil) {
        [awardLayer removeFromSuperview];
        awardLayer=nil; 
    }
    if (hideAwardTimer!=nil) {
        [hideAwardTimer invalidate];
        hideAwardTimer = nil;
    }
    if ([awardNum intValue]<200) {
        awardLayer=[[UIView alloc] initWithFrame:CGRectMake(15, 45, 100, 15)];
        awardLayer.layer.cornerRadius=7.5;
        awardLayer.layer.borderWidth = 1;
        awardLayer.layer.borderColor = [[UIColor colorWithRed:1.0 green:207/255.0f blue:50/255.0f alpha:1.0f] CGColor];
        UILabel *awardTxt=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        [awardTxt setText:[NSString stringWithFormat:@"中奖%@倍",awardNum]];
        [awardTxt setTextColor:[UIColor colorWithRed:1.0 green:207/255.0f blue:50/255.0f alpha:1.0f]];
        [awardTxt setFont:[UIFont systemFontOfSize:11.0f]];
        awardTxt.textAlignment=NSTextAlignmentCenter;
        [awardLayer addSubview:awardTxt];
    }
    else{
        //恭喜中奖的动画
        awardLayer=[[UIView alloc] initWithFrame:CGRectMake(20, -20, 132, 132)];
        awardAniLayer=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 132, 132)];
        [awardLayer addSubview:awardAniLayer];
        awardAniLayer.animationImages=awardImages;
        awardAniLayer.animationDuration=14/24;
        awardAniLayer.animationRepeatCount=2;
        [awardAniLayer startAnimating];
        UIView *numView=[self getNumView:awardNum];
        CGFloat numX=((58.0f-numView.frame.size.width)/2.0f)+36.0f;
        CGFloat numY=75.5f;
        [numView setFrame:CGRectMake(numX, numY, numView.frame.size.width, numView.frame.size.height)];
        [awardLayer addSubview:numView];
        if (![AppDelegate appDelegate].isWinningMusicOFF) {
            if (!avPlayer) {
                NSString *musicName = [[NSBundle mainBundle]pathForResource:@"money" ofType:@"mp3"];
                avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicName] error:nil];// AVAudioPlayer对象要设置成全局的
                avPlayer.numberOfLoops = 0;//播放次数 0代表1次
                avPlayer.volume = 1;//音量
                [avPlayer prepareToPlay];
                [avPlayer play];
            } else {
                [avPlayer prepareToPlay];
                [avPlayer play];
            }
        }
        
        
    }
    [self addSubview:awardLayer];
    
    
    
    hideAwardTimer=[NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(hideAward) userInfo:nil repeats:NO];
    //[hideAwardTimer fire];
}
-(void)hideAward{
    [hideAwardTimer invalidate];
     hideAwardTimer = nil;
    [awardLayer removeFromSuperview];
     awardLayer = nil;
}
-(UIView *)getNumView:(NSString *)num{
    float startX=0;
    UIView *numView=[[UIView alloc] init];
    for (int i=0; i< [num length]; i++) {
        NSString *num_char=[num substringWithRange:NSMakeRange(i, 1)];
        UIImageView *numImageView=[[UIImageView alloc] initWithImage:numImages[[num_char intValue]]];
        [numImageView setFrame:CGRectMake(startX, 0, [numImageWidths[[num_char intValue]] floatValue], 12.5f)];
        startX+=[numImageWidths[[num_char intValue]] floatValue];
        [numView addSubview:numImageView];
    }
    UIImageView *numImageView=[[UIImageView alloc] initWithImage:numImages[10]];
    [numImageView setFrame:CGRectMake(startX, 0, [numImageWidths[10] floatValue], 12.5f)];
    startX+=[numImageWidths[10] floatValue];
    [numView addSubview:numImageView];
    [numView setFrame:CGRectMake(0, 0, startX, 12.5f)];
    return numView;
}
-(void) initNumPng{
    numImageWidths=[NSArray arrayWithObjects:[NSNumber numberWithFloat:8.5f],[NSNumber numberWithFloat:6.0f],[NSNumber numberWithFloat:8.0f],[NSNumber numberWithFloat:7.5f],[NSNumber numberWithFloat:9.0f],[NSNumber numberWithFloat:8.0f],[NSNumber numberWithFloat:8.5f],[NSNumber numberWithFloat:8.0f],[NSNumber numberWithFloat:8.0f],[NSNumber numberWithFloat:8.5f],[NSNumber numberWithFloat:12.5f], nil];
    awardImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"award_ani_0"],[UIImage imageNamed:@"award_ani_1"],[UIImage imageNamed:@"award_ani_2"],[UIImage imageNamed:@"award_ani_3"],[UIImage imageNamed:@"award_ani_4"],[UIImage imageNamed:@"award_ani_5"],[UIImage imageNamed:@"award_ani_6"],[UIImage imageNamed:@"award_ani_7"],[UIImage imageNamed:@"award_ani_8"],[UIImage imageNamed:@"award_ani_9"],[UIImage imageNamed:@"award_ani_10"],[UIImage imageNamed:@"award_ani_11"],[UIImage imageNamed:@"award_ani_12"],[UIImage imageNamed:@"award_ani_13"], nil];
    numImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"0ani"],[UIImage imageNamed:@"1ani"],[UIImage imageNamed:@"2ani"],[UIImage imageNamed:@"3ani"],[UIImage imageNamed:@"4ani"],[UIImage imageNamed:@"5ani"],[UIImage imageNamed:@"6ani"],[UIImage imageNamed:@"7ani"],[UIImage imageNamed:@"8ani"],[UIImage imageNamed:@"9ani"],[UIImage imageNamed:@"10ani"], nil];
}
- (instancetype)init {
    if (self = [super init]) {
        _originFrame = self.frame;
        [self initNumPng];
        [self setUI];
    }
    return self;
}
-(void)addAwardLayerFromVar{
    [self addAwardLayer:_giftmodel.award_mulit];
}
#pragma mark 布局 UI
- (void)layoutSubviews {
    
    [super layoutSubviews];
    //10.16
    [self layoutSubviewUI];
}
- (void)layoutSubviewUI
{
    //送礼人头像
    if (self.isHide==YES) {//神秘人
        _headImageView.frame = CGRectMake(15, 0, 0, self.frame.size.height);
        
    }
    else{
        _headImageView.frame = CGRectMake(15, 0, self.frame.size.height, self.frame.size.height);
    }
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [UIColor cyanColor].CGColor;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height / 2;
    _headImageView.layer.masksToBounds = YES;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_giftmodel.headImage]];//placeholderImage:[UIImage imageNamed:placeHolderImageName]
    CGSize titleSize = [_giftmodel.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    //    送礼人
    _nameLabel.text = _giftmodel.name;
    _nameLabel.frame = CGRectMake(_headImageView.frame.size.width+15+5, 5, titleSize.width, 10);
    //    礼物图片
    _giftImageView.frame = CGRectMake(self.frame.size.width-30, self.frame.size.height - 50, 50, 50);
    //    礼物名字
    _giftLabel.frame = CGRectMake(_nameLabel.frame.origin.x, self.frame.size.height-15, self.frame.size.width, 10);//CGRectGetMaxY(_headImageView.frame) - 10 -5
    _giftLabel.text = [NSString stringWithFormat:@"送了%@",_giftmodel.giftName];
    _giftCount = _giftmodel.giftCount;
    
    _bgImageView.frame = CGRectMake(self.bounds.origin.x + 15, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    _bgImageView.layer.cornerRadius = self.frame.size.height / 2;
    _bgImageView.layer.masksToBounds = YES;
    // 1.22 送礼个数太大显示不完全 修改50宽度为160
    _skLabel.frame = CGRectMake(_bgImageView.frame.origin.x+_bgImageView.frame.size.width+20,0, 160, 30);//CGRectGetMaxX(self.frame)
    _skLabel.clipsToBounds=YES;
    [_skLabel initLabel];
    // 弹出礼物点击事件
    _headBtn.frame = CGRectMake(15, 0, CGRectGetMaxX(self.frame) + 5 + 15, self.frame.size.height);
    if (_giftmodel.giftImage!=nil) {
        [_giftImageView sd_setImageWithURL:[NSURL URLWithString:_giftmodel.giftImage]];
    }
}
#pragma mark 初始化 UI
- (void)setUI
{
    if (_bgImageView) {
        [_bgImageView removeFromSuperview];
        _bgImageView=nil;
    }
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor blackColor];
    _bgImageView.alpha = 0.2;
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    if (_headImageView) {
        [_headImageView removeFromSuperview];
         _headImageView=nil;
    }
    _headImageView = [[UIImageView alloc] init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.clipsToBounds = YES;
    if (_giftImageView) {
        [_giftImageView removeFromSuperview];
        _giftImageView=nil;
    }
    _giftImageView = [[UIImageView alloc] init];
    _giftImageView.frame = CGRectMake(_nameLabel.frame.size.width+5+15+5, self.frame.size.height - 50, 50, 50);
    _giftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _giftImageView.clipsToBounds = YES;
    if (_nameLabel) {
        [_nameLabel removeFromSuperview];
         _nameLabel=nil;
    }
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor  = [UIColor whiteColor];
//    _nameLabel.clipsToBounds
    _nameLabel.font = [UIFont systemFontOfSize:10];
    if (_giftLabel) {
        [_giftLabel removeFromSuperview];
        _giftLabel=nil;
    }
    _giftLabel = [[UILabel alloc] init];
    _giftLabel.textColor  = [UIColor yellowColor];
    _giftLabel.font = [UIFont systemFontOfSize:10];
    
    // 初始化动画label
    _skLabel =  [[ShakeLabel alloc] init];

    _animCount = 0;
    if (_headBtn) {
        [_headBtn removeFromSuperview];
        _headBtn=nil;
    }
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headBtn.backgroundColor = [UIColor clearColor];
    
    //按钮点击事件
    //[_headBtn addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgImageView];
    [self addSubview:_headImageView];
    [self addSubview:_giftImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_giftLabel];
    [self addSubview:_skLabel];
    [self addSubview:_headBtn];
}

- (void)setModel:(SendGiftModel *)model
{
    return;
    _giftmodel = model;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"icon_login_head"]];
    _nameLabel.text = model.name;
    _giftLabel.text = [NSString stringWithFormat:@"送了%@",model.giftName];
    _giftCount = model.giftCount;
    //[self layoutSubviews];
    //10.16
    [self layoutSubviewUI];
}

#pragma mark - 按钮点击事件
- (void)headBtnAction:(UIButton *)sender
{

}
- (void)dealloc
{
    if (hideAwardTimer) {
        [hideAwardTimer invalidate];
        hideAwardTimer=nil;
    }
    if (awardLayer) {
        [awardLayer removeFromSuperview];
         awardLayer = nil;
    }
    
    
    NSLog(@"Presentview  dealloc");
}
@end

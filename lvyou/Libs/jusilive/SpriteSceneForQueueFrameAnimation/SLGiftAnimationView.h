//
//  AnimationView.h
//  AnimationFramework
//
//  Created by 金颖 on 17/7/22.
//  Copyright © 2017年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScene.h"
#import <AVFoundation/AVFoundation.h>

@interface SLGiftAnimationView : UIView{
    //SKView *skView; ///序列帧view
    MyScene *scene;
    NSMutableArray *queue;
    UIImageView *giftimgView;
}
@property(assign)BOOL aniPlaying; //9.5添加播放礼物

@property(assign)BOOL isPlaying;
@property(assign)BOOL isQueue;
@property(assign)BOOL removeSelf;
@property(assign)BOOL repeatForever;
@property(assign)BOOL isSwitchSoundOn;
@property(nonatomic,strong)AVAudioPlayer *backgroundMusicPlayer;
- (void)playgame:(NSDictionary *)dic;
-(void)initAniView;
-(void)playstop;
-(void)playstart;

//停止动画声音
-(void)stop;
// 播放涂鸦礼物
-(void)customDrawWithImage:(NSString *)img andRoadpoints:(NSArray *)roadpoints;
-(void)customDrawWithRoadpoints:(NSArray *)roadpoints;
@end

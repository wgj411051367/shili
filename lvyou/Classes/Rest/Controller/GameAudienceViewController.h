// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2017 Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com.cn
//
// ///////////////////////////////////////////////////////////////////////////
//
//  XYViewerUserLiveViewController.h
//  beibei
//
//  Created by dev on 16/7/16.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseLiveViewController.h"
#import "JoinRoomView.h"
#import "YinXiangViewController.h"
#import "YinXiangModel.h"

#import "GuanZhuHostView.h"
@class GameAudienceViewController;

@protocol XYGameViewerUserLiveViewControllerDelegate <NSObject>

- (void)viewerController:(GameAudienceViewController*)VC withNickname:(NSString *)nickname withheadimg:(NSString *)avatar withUserid:(NSString *)userid;

@end

@interface GameAudienceViewController : BaseLiveViewController<WKNavigationDelegate>

{
    NSMutableDictionary *showinfo;
    BOOL reloading;
    BOOL isFlash,isBeauty,pc_live;
    /// 3.29来电暂停直播背景图片
    UIImageView *stopBgImg;
    UILabel *stopLab;
    NSInteger delaySecond;
   
    UIButton *fullscreenBtn;
    NSString *room_top,*room_top_upload_cover, *room_bottom,*room_bottom_upload_cover,*userPwd;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottom;

@property (weak, nonatomic) id<XYGameViewerUserLiveViewControllerDelegate> delegate;
//7.26昵称距右的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PlayerViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PlayerViewBottom;
//2018.3.6 收费价格
@property (strong, nonatomic)NSString *videoPrice;
@property (nonatomic, strong) NSTimer *delayTimer;
//7.20添加回放和录制的标识
@property (assign, nonatomic)BOOL Record;
@property (strong, nonatomic)NSString *viewUrl;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) CADisplayLink *link;

@property (strong, nonatomic)NSMutableArray *viewArr;

//8.14 关注view
@property (strong, nonatomic) GuanZhuHostView *guanzhuView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (strong, nonatomic)JoinRoomView *joinRoomView;
//背景
@property (strong, nonatomic) UIImageView *backImgView;
@property (strong, nonatomic) UIImageView *backImgView0;
@property (strong, nonatomic) UIImageView *backImgView2;
//举报按钮点击事件
- (IBAction)reportBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *videoRecordView;
//1.17
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yinxiangWidth1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yinxiangWidth2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yinxiangWidth3;

@property (strong, nonatomic) IBOutlet UIImageView *backImgView3;
@end

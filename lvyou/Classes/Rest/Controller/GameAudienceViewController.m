// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  XYViewerUserLiveViewController.m
//  beibei
//
//  Created by dev on 16/7/16.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "GameAudienceViewController.h"
#import "HeartFlyView.h"
#import "GrounderModel.h"
#import "RankPeopleModel.h"
#import "GiftModel.h"
#import "BagListModel.h"
#import "BagModel.h"
#import "GSPChatMessage.h"
#import "SendGiftModel.h"

#import "LiveContributionViewController.h"
#import "LiveGuardianViewController.h"
#import "WXApi.h"

#import "OpenShouHuView.h"
#import "shouHuModel.h"
//#import "FirstPayView.h"

@interface GameAudienceViewController ()<V2TXLivePlayerObserver>
{
    UIImage *backimg;
    NSString *sendGiftId;
    //好友列表分页
    int friendPage;
    NSString *friendStart;
    //自定义消息
    CustomElemModel *customElemModel;
    NSInteger num;   //当前人数
    RedPackItemsModel *redPackItemsModel;
    RedPackModel *redPackRobModel;

    //管理员列表
    LiveGuardListModel *liveGuardListModel;
    NSMutableArray <LiveGuardListModel *>*guardLists;
    //判断用户是不是管理员
    BOOL isLiveGuard;

    LiveBansKicksModel * liveBansKicksModel;
    //判断是否被禁言
    BOOL isBanCommounicate;

    OpenShouHuView *openShouHuView;
    NSMutableArray *shouhuArr;
    
    //FirstPayView *firstPay;
    NSInteger kadunCount; // 卡顿次数，3次后重新拉下流
    
    BOOL isEndLive;
    
}

@property (nonatomic, strong) V2TXLivePlayer *txPlayer;
//关注
@property (nonatomic, strong) NSTimer *attentionTimer;
@property (nonatomic, strong) NSTimer *attentionTimer2;

@end

static NSString * XYUserLiveViewCollentionName = @"XYUserLiveViewCollention";

@implementation GameAudienceViewController

@synthesize beginLiveModel,backImgView,backImgView0,backImgView2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //2018.11.8添加
    if (![self.appDelegate.userModel.user.id isKindOfClass:[NSNull class]]) {
        if ([self isBlankString:self.appDelegate.userModel.user.id]){
            [[HudHelper hudHepler]showShortTips:self.view tips:@"获取昵称异常5秒后将退出"];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self exitUserLive];
            });
        }
    }

    self.backScrollView.scrollsToTop=NO;//2018.12.10修改 不让点击状态栏回到顶部
     //8.17 添加参数区分是从游戏界面跳转过来还是从列表点击进入的
    [self loadRoom];
    self.LayerView.userInteractionEnabled = YES;
    self.liveShowView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    if (self.gamePush==YES)//8.17
    {
        self.reviewBtn.hidden=YES;
        self.shareBtn.hidden=YES;
        self.upBtn.hidden=YES;
        self.shouHuBtn.hidden=YES;
        self.zhenzhuCountView.hidden=YES;
        self.ticket.hidden = YES;
        self.moreBtn.hidden=YES;
    }
    if (self.chatPush==YES)////2018.3.6  1对1连线
    {
        self.backScrollView.scrollEnabled=NO;//12.25 不能滑动
        [self initVideoView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataGuard) name:@"buyGuardSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeBalance) name:@"rechargeBalance" object:nil];
    
    
    [self getUserinfo];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    isHideFlyPing = [[defaults objectForKey:@"isHideFlyPing"] boolValue];
    bigAnimationView.aniPlaying = bigAnimationView.isSwitchSoundOn = isHideAnimation = [[defaults objectForKey:@"isHideAnimation"] boolValue];
    
    self.pkAvatarView_1 = [[RoomAvatarView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.zhuboPKView addSubview:self.pkAvatarView_1];
    
}

- (void)getUserinfo {
    [[RootHttpHelper httpHelper] achieveCommonGetURL:users_info andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        
        NSError *err = nil;
        userInfoModel = [[UserInfoModel alloc] initWithDictionary:successData error:&err];
        self.appDelegate.userModel.user = userInfoModel;
        
//        BOOL allowShow;
//        NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstPayViewTime"];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
//        if (![date isToday]) {
//            NSLog(@"不是今天，弹起弹窗");
//            allowShow = YES;
//        } else {
//            NSLog(@"是今天，不弹弹窗");
//            allowShow = NO;
//        }
//
//        if (allowShow && [self.appDelegate.userModel.user.totalpay integerValue] == 0) {
//
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)([[NSDate new] timeIntervalSince1970])] forKey:@"FirstPayViewTime"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//
//            firstPay = [[NSBundle mainBundle] loadNibNamed:@"FirstPayView" owner:self options:nil].lastObject;
//            firstPay.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            [self.appDelegate.window addSubview:firstPay];
//            __weak typeof(self) weakself = self;
//            firstPay.firstPayClick = ^{
//                [weakself cancelFirstPayView];
//                [weakself rechargeBtnAction];
//            };
//            firstPay.cancelPayClick = ^{
//                [weakself cancelFirstPayView];
//            };
//
//        }
        
    }];
}

- (void)cancelFirstPayView {
    
//    [firstPay removeFromSuperview];
//    firstPay = nil;
    
}

- (void)updataGuard {
    self.attentionBtn.hidden = YES;
    self.nickNameTrailing.constant=6;
    [self initTotalView:@"&guard=1" type:0];
//    self.shouhuNum.text = [NSString stringWithFormat:@"ld",[self.shouhuNum.text int]];
}

- (void)rechargeBalance
{
}

///切换直播中的房间
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    if (scrollView==self.backScrollView) {
        if (scrollView.contentOffset.y==0) {
            roomnumber=room_top;//上一个房间
//            backimg = backImgView0.image;
//            self.backImgView3.backgroundColor = backImgView0.backgroundColor;
            isLianMai = NO;
            self.isSendGift = NO;
            [self.txPlayer stopPlay];
            [self.playerView removeFromSuperview];
            self.playerView = nil;
            [self get_room_infoStatus];
        }
        if (scrollView.contentOffset.y==SCREEN_HEIGHT*2) {
            
            roomnumber=room_bottom;
//            backimg = backImgView2.image;
//            self.backImgView3.backgroundColor = backImgView2.backgroundColor;
            isLianMai = NO;
            self.isSendGift = NO;
            [self.txPlayer stopPlay];
            [self.playerView removeFromSuperview];
            self.playerView = nil;
            [self get_room_infoStatus];
        }      
//        self.backScrollView.contentOffset=CGPointMake(0, SCREEN_HEIGHT);
    }
}
- (void)endCurrentPlayer
{
    [self stopCocos2d];//移除特效
//    if (self.appDelegate.player) {
//        if (SharedAppDelegate.player.view) {
//            SharedAppDelegate.player.scalingMode = MPMovieScalingModeAspectFill;//竖屏
//            SharedAppDelegate.player.view.frame=[UIScreen mainScreen].bounds;
//        }
//        [self.appDelegate.player reset:NO];
//        [self.appDelegate.player stop];
//        [self releaseObservers:self.appDelegate.player];
//        [self.playerView removeFromSuperview];
//        self.appDelegate.player=nil;
//    }
    [self.txPlayer stopPlay];
    [self.txPlayer setObserver:nil];
    [self.playerView removeFromSuperview];
    self.playerView = nil;
    self.txPlayer = nil;
}

- (void)initVideoView
{
    videoback=[[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    videoback.userInteractionEnabled=YES;
    videoback.image=[UIImage imageNamed:@"onetoBack"];
    [self.LayerView addSubview:videoback];
    [self.LayerView bringSubviewToFront:videoback];
    UIImageView *avatarImg=[[UIImageView alloc] init];
    avatarImg.frame=CGRectMake((SCREEN_WIDTH-80*ScreenBiLi)/2, SCREEN_HEIGHT/3, 80*ScreenBiLi, 80*ScreenBiLi);
    avatarImg.layer.cornerRadius=40*ScreenBiLi;
    avatarImg.layer.masksToBounds=YES;
    [avatarImg sd_setImageWithURL:[self placeImg:self.beginLiveModel.anchor.avatar] placeholderImage:[self placeDefaultImg]];
    [videoback addSubview:avatarImg];
    UILabel *nickLab=[[UILabel alloc] initWithFrame:CGRectMake(0, avatarImg.frame.origin.y+avatarImg.frame.size.height+5*ScreenBiLi, SCREEN_WIDTH, 30*ScreenBiLi)];
    nickLab.text=self.beginLiveModel.anchor.nickname;
    nickLab.textColor=[UIColor whiteColor];
    nickLab.textAlignment=NSTextAlignmentCenter;
    nickLab.font=[UIFont systemFontOfSize:20.0f];
    [videoback addSubview:nickLab];
    UILabel *textLab=[[UILabel alloc] initWithFrame:CGRectMake(0, nickLab.frame.origin.y+nickLab.frame.size.height+10*ScreenBiLi, SCREEN_WIDTH, 20*ScreenBiLi)];
    textLab.text=@"正在连通视频聊天";
    textLab.textColor=[UIColor whiteColor];
    textLab.textAlignment=NSTextAlignmentCenter;
    textLab.font=[UIFont systemFontOfSize:16.0f];
    [videoback addSubview:textLab];
    UIButton *priceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    priceBtn.frame=CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/2)/2, textLab.frame.origin.y+textLab.frame.size.height+10*ScreenBiLi, SCREEN_WIDTH/2, 20*ScreenBiLi);
    priceBtn.backgroundColor=RGBACOLOR(0, 0, 0, 0.6);
    priceBtn.layer.cornerRadius=10*ScreenBiLi;
    priceBtn.layer.masksToBounds=YES;
    [priceBtn setTitle:[NSString stringWithFormat:@"每分钟支出%@%@",self.videoPrice,[self moneyname]] forState:0];
    priceBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    [priceBtn setTitleColor:[UIColor whiteColor] forState:0];
    [videoback addSubview:priceBtn];
    
    UIButton *downBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame=CGRectMake((SCREEN_WIDTH-60*ScreenBiLi)/2, SCREEN_HEIGHT-80*ScreenBiLi, 60*ScreenBiLi, 60*ScreenBiLi);
    [downBtn addTarget:self action:@selector(downThePhone) forControlEvents:UIControlEventTouchUpInside];
    [downBtn setImage:[UIImage imageNamed:@"phonedown"] forState:0];
    [videoback addSubview:downBtn];
    
    //3.13 添加播放背景音乐
    NSError *error;
    NSString *musicName = [[NSBundle mainBundle]pathForResource:@"backmusic" ofType:@"mp3"];
    if(self.backgroundMusic){
        [self.backgroundMusic stop];
        self.backgroundMusic=nil;
    }
    self.backgroundMusic = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:musicName] error:&error];// AVAudioPlayer对象要设置成全局的
    self.backgroundMusic.numberOfLoops = -1;//播放次数 0代表1次 -1为一直循环
    self.backgroundMusic.volume = 1.0;//音量
    [self.backgroundMusic prepareToPlay];
    [self.backgroundMusic play];
     delaySecond=120;
    _delayTimer = [NSTimer pltScheduledTimerWithTimeInterval:1.0 target:self selector:@selector(leaveTheRoom) userInfo:nil];
}
- (void)leaveTheRoom
{
    if (delaySecond==1)
    {
        if (_delayTimer!=nil)
        {
            [_delayTimer invalidate];
             _delayTimer = nil;
        }
        [[HudHelper hudHepler]showShortTips:self.view tips:@"对方可能在忙"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downThePhone];
        });
    }
    delaySecond--;
}
//挂断视频
- (void)downThePhone
{   //离开房间
    [self exitUserLive];
}
#pragma mark - 单击屏幕事件
- (void)screenClick{
    [self showTheLove];
}
#pragma mark - 单击屏幕事件
- (void)showTheLove
{
    [super sendKickback];
}

- (void)loadRoom
{
    self.selfInV2=NO;
    isBlockChat=NO;
    //全服
    hongBaoModel = [[GrounderModel alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification            //键盘将出现事件监听
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification            //键盘将出现事件监听
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification            //键盘将隐藏事件监听
                                               object:nil];
    //推到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //回到前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.callCenter = [[CTCallCenter alloc] init];
    __weak typeof(self) weakSelf = self;
    self.callCenter.callEventHandler = ^(CTCall *call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected]) {
            //断开电话继续直播
            [weakSelf applicationDidDisconnectCall];
        }
        else if([call.callState isEqualToString:CTCallStateIncoming]){
            //来电停播
            [weakSelf applicationDidReceiveCall];
        }
    };
    roomnumber=beginLiveModel.anchor.haoma;
    [self createBackImg];
    //0929
    [self get_room_infoStatus];
    if (self.chatPush==YES) {//2018.3.6
        return;
    }
    //获取管理员列表
    [self getMansgeList];
    [self loadGame];
}
/// 12.20 添加
- (void)loadGameView:(NSString *)type andHeight:(CGFloat)height andGameUrl:(NSString *)url
{
    [super loadGameView:type andHeight:height andGameUrl:url];
    [self.view addSubview:gameWebView];
}
- (void)removebackimg
{
    if (backImgView)
    {
        [backImgView removeFromSuperview];
        backImgView=nil;
    }
}
- (void)createBackImg
{
    if (backImgView) {
        [self removebackimg];
    }
    //1031 预览图片加载
    backImgView =[[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backImgView=[self processBlurBackground:backImgView];
    if (self.isPhone==YES)
    {
        backImgView.image=[UIImage imageNamed:@"stopBgImage"];
    }
    [self.liveShowView insertSubview:backImgView atIndex:0];
}
-(UIImageView *)processBlurBackground:(UIImageView *)backImgView{
    backImgView.contentMode =UIViewContentModeScaleAspectFill;
    return backImgView;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, backImgView.size.width,backImgView.size.height);
    ///4.5 透明度设置
    effectview.alpha = 0.9f;
    [backImgView addSubview:effectview];
    return backImgView;
}
-(void)removeBlurBackground:(UIImageView *)backImgView{
    [backImgView removeSubviews];
}
#pragma mark - 全屏---显示
- (void)rightSwip:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.Record==YES) {
        return;
    }
    if (self.gamePush==YES) {
        return;
    }
    else
    {
      [super rightSwip:gestureRecognizer];
    }
    self.backScrollView.scrollEnabled=NO;
}
#pragma mark - 全屏---隐藏
-(void)leftSwip:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.Record==YES) {
        return;
    }
    if (self.gamePush==YES) {
        return;
    }
    else
    {
       [super leftSwip:gestureRecognizer]; 
    }
    self.backScrollView.scrollEnabled=YES;
}
- (void)topSwip:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.Record==YES) {
        
    }
    [super topSwip:gestureRecognizer];
    //8.17
    if (self.gamePush==YES) {
        self.upBtn.selected=NO;
    }
    self.backScrollView.scrollEnabled=NO;
}

- (void)bottomSwip:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.Record==YES) { //回放或录制过来的不执行向下的手势
    }
    if (self.gamePush==YES || isLianMai) {
        return;
    }
    [super bottomSwip:gestureRecognizer];
    self.backScrollView.scrollEnabled=YES;
}

-(void)showDefaultTab{
    if(self.messageBtn.selected==NO && self.friendBtn.selected==NO){
        [self messageBtnClick:nil];
    }
//    [self friendBtnClick:nil];
}
-(void)applicationDidEnterBackground:(NSNotification *)notify{
    /// 7.21 判断是直播还是录制或回放
    if (self.Record==YES)
    {
    }
    else if (self.gamePush==YES)
    {
    }
    else
    {
        [self stopCocos2d];//因为回来不走viewwillappear方法 所以此处停止 等回来时再开始
    }
}
-(void)applicationWillEnterForeground:(NSNotification *)notify{
    
    if (self.Record==YES)
    {
    }
    else if (self.gamePush==YES)
    {
    }
    else
    {
        [self startCocos2d];
        //4.9 禁止休眠
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}
//回到前台
-(void)applicationDidDisconnectCall{
    
    if (self.Record==YES)
    {
    }
    else if (self.gamePush==YES)
    {
    }
}
-(void)applicationDidReceiveCall{

    if (self.Record==YES)
    {
    }
    else if (self.gamePush==YES)
    {
    }
}

//点击退出键盘
- (void)singleTap
{
    [super singleTap];
    [self cleanUpData];
}
- (void)moreClick
{
    [super moreClick];
    //实例化弹出框
    [self initMenuView];
}
- (void)initMenuView
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < theTitles.count; i++)
    {
        SailorPopMenuViewModel *model = [[SailorPopMenuViewModel alloc] init];
        model.title = theTitles[i];
        [arr addObject:model];
    }
    //弹出框的宽度
    CGFloat menuViewWidth = 80;//120
    //弹出框的右下中角起点坐标
    CGPoint startPoint = CGPointMake(-70, SCREEN_HEIGHT - self.chatBtn.frame.size.height);//SCREEN_WIDTH - menuViewWidth*3/2 - 30
    [[SailorPopMenuViewSingleton shareManager] creatPopMenuWithFrame:startPoint popMenuWidth:menuViewWidth popMenuItems:arr action:^(NSInteger index) {
        ////NSLog(@"+++++++++++++++点击的index=%ld",(long)index);
        switch (index)
        {
            case 0:
                [self chatAction:nil];
                break;
            case 1:
                [self exitUserLive];
                break;
            default:
                break;
        }
    }];
}
#pragma mark - View从superView中移除时
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //9.28 页面消失移除动画
    [self stopCocos2d];
    //9.28 隐藏底部弹出的关注view
    [self hideAttentionLive];
}
#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //9.28显示动画界面
    [self startCocos2d];
    pushToRedBag=NO;
}

//给观众送礼礼物按钮点击事件
- (void)giftUserAction:(UIButton *)sender{
    /// 2.17 隐藏manageview
    [self hideManageView];
}

//私信按钮点击
- (IBAction)privateAction:(UIButton *)sender
{
    [super privateAction:sender];
    [self.liveShowView bringSubviewToFront:self.ChatViewInLive];
}
//点击充值跳转页面frame回到最初的位置
-(void)rechargeBtnAction
{
    [super rechargeBtnAction];
}
//点击红包跳转页面frame回到最初的位置
-(void)sendGiftBtn:(UIButton *)btn
{
    [super sendGiftBtn:btn];
    if(giftSign == NSDataLiveGiftSignTypeGift || giftSign == NSDataLiveGiftSignTypeBag)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:sendGiftNum forKey:@"gift_num"];
        [params setValue:self.beginLiveModel.id forKey:@"live_id"];
        if([chooseGiftModel.name isEqualToString:@"红包"]){
            return;
        }
    }
}

#pragma mark - 观看直播界面
- (void)initTCShow:(NSString *)url
{
    if (![self isBlankString:url]) {
        [self createPlayerViewWithUrl:url];
    }
    // 连接聊天服务器
    [self loadChat];
}

//连接聊天服务器
- (void)loadChat
{
    [super doConnect:self andUrl:CHAT];//1.19
}
- (void)createPlayerViewWithUrl:(NSString *)url
{
    [_loadingView startAnimating];
     _loadingView.hidden=NO;

    isEndLive = NO;
//    [self checkPlaybackState];
    
    
    if (!_txPlayer) {
        self.txPlayer = [[V2TXLivePlayer alloc] init];
        [self.txPlayer setCacheParams:1 maxTime:5];
        [self.txPlayer setObserver:self];
        [self.txPlayer setRenderFillMode:V2TXLiveFillModeFill];
    }
    
    if (self.playerView == nil) {
        self.playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.liveShowView insertSubview:self.playerView atIndex:1];//2017.11.15修改
    }
    
    [self.txPlayer setRenderView:self.playerView];
    [self.txPlayer startLivePlay:url];
    
    
}

- (void)onError:(id<V2TXLivePlayer>)player code:(V2TXLiveCode)code message:(NSString *)msg extraInfo:(NSDictionary *)extraInfo {
    NSLog(@"V2TXLivePlayer error code =%ld,msg = %@ info = %@",(long)code,msg,extraInfo);
    if (code == V2TXLIVE_ERROR_DISCONNECTED) {
        [self.txPlayer startLivePlay:[showinfo objectForKey:@"download_video_add"]];
    }
}

- (void)onWarning:(id<V2TXLivePlayer>)player code:(V2TXLiveCode)code message:(NSString *)msg extraInfo:(NSDictionary *)extraInfo {
    NSLog(@"V2TXLivePlayer Warning code =%ld,msg = %@ info = %@",(long)code,msg,extraInfo);
}



- (void)onVideoResolutionChanged:(id<V2TXLivePlayer>)player width:(NSInteger)width height:(NSInteger)height {
    if (isPKing) {
        if (self.pkPeople == 4) {
            return;
        }
//        int wBili = 1280.0/720 * SCREEN_WIDTH;
//        int hBili = 720.0/1280 * SCREEN_HEIGHT;
//        float h = (hBili == SCREEN_WIDTH)?SCREEN_HEIGHT:wBili;
//        float y = (hBili == SCREEN_WIDTH)?0:(SCREEN_HEIGHT-h)/2;
//        self.playerView.frame = CGRectMake(0, CGRectGetMaxY(self.zhenzhuCountView.frame)+40-h/4, SCREEN_WIDTH, h);
//        self.pk3ViewHeight.constant = h/2;
//        [self addMaskView:-((SCREEN_HEIGHT-SCREEN_WIDTH*8/9)/2-(self.zhenzhuCountView.frame.size.height+self.zhenzhuCountView.frame.origin.y+33*ScreenBiLi-20*ScreenBiLi))];
    }
    else {
        [self.playerView setFrame: self.view.bounds];
    }
}

- (void)checkPlaybackState {
//    NSLog(@"2秒后检查播放器状态");
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.appDelegate.player.playbackState != MPMoviePlaybackStatePlaying) {
//            NSLog(@"重新启动拉流");
//            if (self.appDelegate.player) {
//                [self.appDelegate.player reload:[NSURL URLWithString:[showinfo objectForKey:@"download_video_add"]] flush:NO mode:MPMovieReloadMode_Accurate];//重新启动拉流
//                [self checkPlaybackState];
//            }
//        }
//    });
}


- (void)pcLivingViewFrame
{
    [self.playerView setFrame: CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_WIDTH*3/4)];
}
- (void)createFullBtn
{
    if (self.isPhone==YES)
    {
        //全屏显示的按钮
        if (fullscreenBtn) {
            [fullscreenBtn removeFromSuperview];
            fullscreenBtn=nil;
        }
        fullscreenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        fullscreenBtn.frame=CGRectMake(SCREEN_WIDTH-40*ScreenBiLi, self.playerView.frame.size.height-40*ScreenBiLi, 40*ScreenBiLi, 40*ScreenBiLi);
        [fullscreenBtn addTarget:self action:@selector(fullScreenShowAction:) forControlEvents:UIControlEventTouchUpInside];
        [fullscreenBtn setImage:[UIImage imageNamed:@"fullScreen"] forState:0];
        [self.playerView addSubview:fullscreenBtn];
        [self.playerView bringSubviewToFront:fullscreenBtn];
    }
}
- (void)fullScreenShowAction:(UIButton *)btn
{
    btn.selected=!btn.selected;
    if (btn.selected) {
        [self.playerView setFrame: self.view.bounds];
        fullscreenBtn.frame=CGRectMake(SCREEN_WIDTH-40*ScreenBiLi, SCREEN_HEIGHT-40*ScreenBiLi, 40*ScreenBiLi, 40*ScreenBiLi);
        [self rightSwip:nil];
    }
    else
    {
        [self pcLivingViewFrame];
        fullscreenBtn.frame=CGRectMake(SCREEN_WIDTH-40*ScreenBiLi, self.playerView.frame.size.height-40*ScreenBiLi, 40*ScreenBiLi, 40*ScreenBiLi);
        [self leftSwip:nil];
    }
}
- (void)showAlertViewOnViewWithMessage:(NSString *)mess
{
    UIAlertController* alertMsg =[UIAlertController alertControllerWithTitle:@"温馨提示" message:mess preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertMsg animated:YES completion:nil];
    UIAlertAction *sure =[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exitUserLive];//5.7
    }];
    [alertMsg addAction:sure];
}

- (void)setSecretRoom{
    if (self.joinRoomView) {
        self.joinRoomView.delegate=nil;
        [self.joinRoomView removeFromSuperview];
        self.joinRoomView=nil;
    }
    self.joinRoomView=[[JoinRoomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.joinRoomView.delegate=self;
    [self.liveShowView addSubview:self.joinRoomView];
}
-(void)onPwdInput:(NSString *)pwd{
    if([pwd isEqualToString:userPwd]){
        [self.joinRoomView removeFromSuperview];
        [self initTCShow:[showinfo objectForKey:@"download_video_add"]];
        [self loadTiePian:showinfo[@"img_list"]];
    }
    else{
        [[MessageHelper messageHelper]showErrMessage:self title:@"密码没蒙对啊" sub:@"再问问主播要密码吧。"];
    }
}
- (void)addTiePianView
{
//    [self.LayerView addSubview:self.tiePianBannerScrol];
    [self belowSubView:self.zhenzhuCountView withView:self.tiePianBannerScrol];
}
-(void)get_room_infoStatus
{
    if (self.chatRecordView) {
        [self.chatRecordView.chatRecordMessageView.liveMessages removeAllObjects];
        [self.chatRecordView.chatRecordMessageView.tableView reloadData];
    }
    if (self.appDelegate.winningSFMArray) {
        [self.appDelegate.winningSFMArray removeAllObjects];
    }
    if (self.appDelegate.otherSFMArray) {
        [self.appDelegate.otherSFMArray removeAllObjects];
    }
    
    if (self.liveWishScrollView) {
        [self.liveWishScrollView removeFromSuperview];
        self.liveWishScrollView = nil;
    }
    
    
    [self.pkPlayer stopPlay];
    [self.pkPlayer setRenderView:nil];
    self.pkPlayer = nil;
    if (self.playerPKView) {
        [self.playerPKView removeFromSuperview];
        self.playerPKView = nil;
    }
    self.kit.isPK = NO;
    self.kit.txKit.isPK = NO;
    
    [self overMultiPK:NO];
    
    [self changeRoom];
//    if (isLianMai) {
//        self.zhuboPKView.hidden = YES;
//        [self.pkAvatarView_1.hostView removeFromSuperview];
//        self.pkAvatarView_1.hostView = nil;
//        self.pkAvatarView_1.canvas = nil;
//        self.pkAvatarView_1.canvas.view = nil;
//    }
//
//    if (self.pkAvatarOwnView) {
//        [self.pkAvatarOwnView removeFromSuperview];
//        self.pkAvatarOwnView = nil;
//    }
    
    //切换房间清空游戏状态
    gameType=nil;
    giftAndGameSelected=NO;
    for (UIView *view in self.liveShowView.subviews) {
        if ([[view class] isEqual:[PublicChatView class]]) {
            [view removeFromSuperview];
        }
    }
    sendUserId = @"";
    if(self.flyView!=nil){//移除飞屏
        [self.flyView removeFromSuperview];
        self.flyView=nil;
    }
    if (self.flyawardView!=nil) {
        self.flyawardView.hidden = YES;
//        for (UIView *view in self.flyawardView.subviews) {
//            [view removeFromSuperview];
//        }
//        [self.flyawardView.layer removeAllAnimations];
//        [self.flyawardView removeFromSuperview];
//        self.flyawardView = nil;
    }
    for (nbPackView *view in hongBaoArray) {
        [view removeFromSuperview];
    }
    [hongBaoArray removeAllObjects];
    if (stopBgImg) {
        [stopBgImg removeFromSuperview];
         stopBgImg=nil;
    }
    if (self.moreView) {
        [self.moreView removeFromSuperview];
        self.moreView=nil;
    }
    [self cancelShareBtnClick:nil];//隐藏分享
    [self hideAttentionLive];//关注弹框
    [self hideManageView];//隐藏个人信息弹框
    [self removeDelayTime];//pk条
    //添加特效
    [self startCocos2d];//特效
    if (self.joinRoomView) {
        self.joinRoomView.delegate=nil;
        [self.joinRoomView removeFromSuperview];
        self.joinRoomView=nil;
    }
    if (self.msgView.liveMessages) {
        [self.msgView.liveMessages removeAllObjects];
        [self.msgView.tableView reloadData];
    }
    for (SDCycleScrollView *view in self.bannerTiePianArr){
        [view removeFromSuperview];
    }
    if (self.bannerTiePianArr) {
        [self.bannerTiePianArr removeAllObjects];
    }
    if (self.bannerInLiveDic) {
        [self.bannerInLiveDic removeAllObjects];
    }
    if (showinfo[@"img_list"]!=nil) {
        [showinfo removeAllObjects];//先清空数据
    }
    
    self.pkLeftView.hidden = YES;
    self.pkSofaBGImg.hidden = YES;
    self.pkRightView.hidden = YES;
    self.pkBgBottomImg.hidden = YES;
    self.pkBgTopImg.hidden = YES;
    self.pkProphetBtn.hidden = YES;
    
    
    [self lianmaiEndLive];
    
    if (self.kit.pusher) {
        [self lianmaiEndPusher];
    }
    
    self.playerView.frame = [UIScreen mainScreen].bounds;
    if(self.playerView) {
        @try {
//            [self.appDelegate.player.view removeObserver:self forKeyPath:@"frame1"];
            self.playerView.frame = [UIScreen mainScreen].bounds;
        } @catch (NSException *exception) {
            NSLog(@"%s exception:%@", __func__, exception);
        }
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:@"ios" forKey:@"platform"];
    if ([roomnumber isKindOfClass:[NSNull class]]) {
        roomnumber=@"";
    }
    
     NSString *requestUrl=[NSString stringWithFormat:@"%@iumobile/apis/index.php?languages=zh_cn&action=get_room_info&roomnumber=%@&token=%@",DATAAPI,roomnumber,self.appDelegate.userModel.token];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:requestUrl andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
        showinfo=[NSMutableDictionary dictionaryWithDictionary:successData];
        self.zhuboshowid = showinfo[@"showid"];
        showerNickname=showinfo[@"nickname"];
        showerUserid=showinfo[@"userid"];
        
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        self.avatarUploadDate = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        
    [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"users/detail/%@",showerUserid] andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData_user) {
            NSError *err;
            UserInfoModel *zhuboModel=[[UserInfoModel alloc]initWithDictionary:successData_user error:&err];
            beginLiveModel.anchor=zhuboModel;
            //赋值页面主播信息
            [self assignmentLiveUserInfo];
            beginLiveModel.anchor.total_ticket =successData_user[@"totalpoint"];
            userPwd=beginLiveModel.anchor.pwd;
            if (userPwd!=nil&&![userPwd isEqualToString:@""])
            {
                [self setSecretRoom];
            }
            if (![self isBlankString:successData[@"room_top"]]) {
                room_top_upload_cover =successData[@"room_top_upload_cover"];
                room_top =successData[@"room_top"];
            } else {
                room_top_upload_cover =successData[@"upload_cover"];
                room_top =zhuboModel.haoma;
            }
            
            if (![self isBlankString:successData[@"room_bottom"]]) {
                room_bottom_upload_cover =successData[@"room_bottom_upload_cover"];
                room_bottom =successData[@"room_bottom"];
            } else {
                room_bottom_upload_cover =successData[@"upload_cover"];
                room_bottom =zhuboModel.haoma;
            }
        
        // 是否开播，没开播禁言
        isAllShutup = ![self isBlankString:successData[@"endtime"]];
        
        self.backScrollView.delegate=self;
        self.backScrollView.contentSize=CGSizeMake(0, SCREEN_HEIGHT*3);
        
        self.PlayerViewTop.constant=SCREEN_HEIGHT;
        self.PlayerViewBottom.constant=SCREEN_HEIGHT;
        self.backScrollView.contentOffset=CGPointMake(0, SCREEN_HEIGHT);
        
//            room_top_upload_cover=successData[@"room_top_upload_cover"];
//            room_bottom_upload_cover=successData[@"room_bottom_upload_cover"];
            
//        self.backImgView3 = nil;
        if (backimg) {
            self.backImgView3.image = backimg;
        } else {
            [self.backImgView3 sd_setImageWithURL:[self placeImg:zhuboModel.live_banner]];
        }
        
            
//        self.backImgView3.backgroundColor = [UIColor yellowColor];
//        self.backImgView3.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            self.backImgView3.hidden = YES;
            if (backImgView0==nil) {
                backImgView0=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                backImgView0=[self processBlurBackground:backImgView0];
                
                [backImgView0 sd_setImageWithURL:[self placeImg:room_top_upload_cover]];
                [self.backScrollView addSubview:backImgView0];
            }
            else{
                [backImgView0 sd_setImageWithURL:[self placeImg:room_top_upload_cover]];
            }
            if (backImgView2==nil) {
                backImgView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2, SCREEN_WIDTH, SCREEN_HEIGHT)];
                backImgView2=[self processBlurBackground:backImgView2];
                [backImgView2 sd_setImageWithURL:[self placeImg:room_bottom_upload_cover]];
                [self.backScrollView addSubview:backImgView2];
            }
            else{
                [backImgView2 sd_setImageWithURL:[self placeImg:room_bottom_upload_cover]];
            }
                
        if (self.gamePush==YES) {
            self.backScrollView.contentSize=CGSizeMake(0, SCREEN_HEIGHT);
            self.backScrollView.contentOffset=CGPointMake(0, SCREEN_HEIGHT);
            backImgView0.image=[UIImage imageNamed:@""];
            backImgView2.image=[UIImage imageNamed:@""];
            backImgView.image=[UIImage imageNamed:@"icon_user_begin_live"];
            self.backScrollView.scrollEnabled=NO;
        }
        if ([[showinfo objectForKey:@"blocklevel"] intValue]==1) {
            
            [[MessageHelper messageHelper] showWarnMessage:self title:nil sub:@"您已经被踢出房间"];
            //1031
            [self performSelector:@selector(exitUserLive) withObject:self afterDelay:0.8];
            return;
        }
        else if ([[showinfo objectForKey:@"blocklevel"] intValue]>1) {
            
            [[MessageHelper messageHelper] showWarnMessage:self title:nil sub:@"您已经被禁言"];
            isBlockChat=YES;
        }
        //endtime equal
        if (![[successData objectForKey:@"endtime"] isEqualToString:@""]) {
            if (self.Record==YES)
            {
            }
            else if (self.gamePush==YES)
            {
            }
            else if (self.chatPush==YES)
            {
            }
            else
            {
                [self endLive];
            }
        }
        //0929
        if (self.Record==YES)//回放
        {   //隐藏部分按钮
            self.upBtn.hidden=YES;
            self.moreBtn.hidden=YES;
            self.reviewBtn.hidden=YES;
            self.shouHuBtn.hidden=YES;
            //    调整视频播放时间的位置
            self.videoRecordView.hidden=NO;
            self.timeLab.text = @"00:00:00/00:00:00";
            // 回放添加滑动条
            //左右轨的图片
            UIImage *LeftImg= [UIImage imageNamed:@"sliderone"];
            UIImage *RightImg = [UIImage imageNamed:@"slidertwo"];
            //滑块图片
            UIImage *thumbImage = [UIImage imageNamed:@"slidercircle"];
            _sliderView.layer.cornerRadius=5*ScreenBiLi;
            _sliderView.layer.masksToBounds=YES;
            _sliderView.minimumValue=0;
            [_sliderView setMinimumTrackImage:LeftImg forState:UIControlStateNormal];
            [_sliderView setMaximumTrackImage:RightImg forState:UIControlStateNormal];
            // 注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
            [_sliderView setThumbImage:thumbImage forState:UIControlStateHighlighted];
            [_sliderView setThumbImage:thumbImage forState:UIControlStateNormal];
            //111
            self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimeLabel)];
            [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self initTCShow:self.viewUrl];
        }
        else if (self.gamePush==YES)//8.17 游戏房进入
        {
            _loadingView.hidden=YES;
            [self loadChat];
        }
        else if (self.chatPush==YES)//2018.3.6 游戏房进入
        {
            _loadingView.hidden=YES;
            [self loadChat];
        }
        else//看直播
        {
            //1表示的是收费房间
            if ([successData[@"isPayMode"] isEqualToString:@"1"])
            {
                if ([self.appDelegate.userModel.user.guizhu intValue]>4&&[PayRoom intValue]>=1) {
                    [self initTCShow:[showinfo objectForKey:@"download_video_add"]];
                    [self loadTiePian:showinfo[@"img_list"]];
                }
                else{
                   NSString *room_price=[NSString stringWithFormat:@"该直播间每分钟%ld%@！", [successData[@"room_price"] integerValue],[self moneyname]];
                   [self shoufeiShowAlertWith:room_price];
                }
            }
            else if ([successData[@"isPayMode"] isEqualToString:@"2"])
            {
                if ([self.appDelegate.userModel.user.guizhu intValue]>4&&[PayRoom intValue]>=1) {
                    [self initTCShow:[showinfo objectForKey:@"download_video_add"]];
                    [self loadTiePian:showinfo[@"img_list"]];
                }
                else{
                  NSString *room_price=[NSString stringWithFormat:@"该直播间每分钟%ld%@！", [successData[@"room_price"] integerValue],[self moneyname]];
                  [self shoufeiShowAlertWith:room_price];
                }
            }
            else
            {
                if (userPwd==nil||[userPwd isEqualToString:@""]) { //密码为空时正常看直播
                    if (!isEndLive) {
                        [self initTCShow:[showinfo objectForKey:@"download_video_add"]];
                        [self loadTiePian:showinfo[@"img_list"]];
                    }
                    
                }
            }
        }
        if([[showinfo objectForKey:@"isfav"] intValue]==1)
        {
//            self.attentionBtn.hidden = YES;
            self.attentionBtn.selected = YES;
            self.nickNameTrailing.constant=39;
        }
        else
        {
            if (self.gamePush==YES)
            {
//                self.attentionBtn.hidden = YES;
                self.attentionBtn.selected = YES;
                self.nickNameTrailing.constant=39;
                return;
            }
            if (self.chatPush==YES) {//2018.3.6
                return;
            }
            else
            {
                self.attentionBtn.hidden = NO;
                self.attentionBtn.selected = NO;
                self.nickNameTrailing.constant=39;
            }
            [self.attentionBtn setBackgroundColor:colorHead];
            HeartBeatSecond=180;
            //倒计时10s提醒关注
            _attentionTimer = [NSTimer pltScheduledTimerWithTimeInterval:1.0 target:self selector:@selector(awokeAttentionLive) userInfo:nil];
         }
        if ([successData[@"endtime"] integerValue] > 0) {
            if (stopBgImg) {
                stopLab.text=@"主播已下播";
            } else {
                stopBgImg=[[UIImageView alloc] initWithFrame:self.view.frame];
                stopBgImg.image=[UIImage imageNamed:@"stopBgImage"];
                stopLab =[[UILabel alloc] init];
                stopLab.bounds=CGRectMake(0, 0, SCREEN_WIDTH, 30);
                stopLab.center=CGPointMake(stopBgImg.size.width/2, stopBgImg.size.height/2-40);
                stopLab.text=@"主播已下播";
                stopLab.textAlignment=NSTextAlignmentCenter;
                stopLab.textColor=[UIColor whiteColor];
                stopLab.font=[UIFont systemFontOfSize:24.0f];
                [stopBgImg addSubview:stopLab];
                [self.liveShowView insertSubview:stopBgImg atIndex:2];
            }
        }
        
      }];
  }];
}
//2.28 添加
- (void)sliderVauleChange:(UISlider*)slider
{
    _sliderView.value= slider.value;
}
//将时间转换成00格式
- (NSString *)formatPlayerTime:(NSTimeInterval)duration
{
    int secend = duration;
    return [NSString stringWithFormat:@"%02d",secend];
}

- (void)updateTimeLabel
{
}

//将时间转换成00:00:00格式
- (NSString *)formatPlayTime:(NSTimeInterval)duration
{
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

//暂停和播放按钮
- (IBAction)stopOrPlayAction:(UIButton *)btn
{
    btn.selected=!btn.selected;
}
- (void)shoufeiShowAlertWith:(NSString *)massage
{
    //弹框
    __weak typeof(self)weakself =self;
    UIAlertController *beginShouFei =[UIAlertController alertControllerWithTitle:@"收费提示" message:massage preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:beginShouFei animated:YES completion:nil];
    UIAlertAction *cancle =[UIAlertAction actionWithTitle:@"不差钱" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself initTCShow:[showinfo objectForKey:@"download_video_add"]];
        [weakself loadTiePian:showinfo[@"img_list"]];
    }];
    UIAlertAction *sure =[UIAlertAction actionWithTitle:@"我不看了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself exitUserLive];
    }];
    [beginShouFei addAction:cancle];
    [beginShouFei addAction:sure];
}

#pragma mark - 倒计时10s提醒关注
- (void)awokeAttentionLive
{
    if (HeartBeatSecond==1)
    {  //关注view
        if (_attentionTimer!=nil)
        {
            [_attentionTimer invalidate];
             _attentionTimer = nil;
        }
        self.guanzhuView=[[GuanZhuHostView alloc] initWithFrame:CGRectMake(15*ScreenBiLi, SCREEN_HEIGHT, SCREEN_WIDTH-30*ScreenBiLi, 164*ScreenBiLi) andHeadImage:[[ToolHelper toolHelper] realAvatarUrl:beginLiveModel.anchor.id andUpdate:beginLiveModel.anchor.update_avatar_time] andNickname:beginLiveModel.anchor.nickname];
        self.guanzhuView.delegate=self;
        [self.liveShowView addSubview:self.guanzhuView];
        [self.liveShowView bringSubviewToFront:self.guanzhuView];
        // ------View出现动画
        [UIView animateWithDuration:0.3 animations:^{
            self.guanzhuView.frame=CGRectMake(15*ScreenBiLi, SCREEN_HEIGHT-164*ScreenBiLi-(iphoneX?31*ScreenBiLi:15*ScreenBiLi), SCREEN_WIDTH-30*ScreenBiLi, 164*ScreenBiLi);
        }];
        _attentionTimer2 = [NSTimer pltScheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideAttentionLive) userInfo:nil];
        return;
    }
    HeartBeatSecond--;
}
- (void)hideAttentionLive
{
    if (_attentionTimer2!=nil)
    {
        [_attentionTimer2 invalidate];
        _attentionTimer2 = nil;
    }
    if (_attentionTimer!=nil)
    {
        [_attentionTimer invalidate];
        _attentionTimer = nil;
    }
    //关注view
    if (self.guanzhuView!=nil) {
        [self.guanzhuView hide];
    }
}

#pragma mark - 观众头像点击的代理方法
-(void)onViewerAvatarTapped:(UserInfoModel *)info{
    //2017.6.9
    giftUserModel = userInfoModel =info;
    self.totalheight.constant=300;
    [self hideYinXiangBtn];
    isScret=@"show";
    //弹出观众管理View并展示数据
    [self showManageView:info.id orNumber:nil];
}
- (void)hideYinXiangBtn
{
    self.yinxiangBtn1.hidden=YES;
    self.yinxiangBtn2.hidden=YES;
    self.yinxiangBtn3.hidden=YES;
    self.addyinxiangBtn.hidden=YES;
}
#pragma maek - 主播头像按钮点击事件
- (IBAction)hostAvatarAction:(UIButton *)sender
{
    giftUserModel = userInfoModel = beginLiveModel.anchor;
    if (self.gamePush==YES)
    {
        [self hideYinXiangBtn];
        self.totalheight.constant=300;
    }
    else if (self.Record==YES)
    {
        self.totalheight.constant=364;
        self.addyinxiangBtn.hidden=NO;
    }
    else
    {
        self.totalheight.constant=364;
        self.addyinxiangBtn.hidden=NO;
    }
    isScret=@"show";
      //弹出观众管理View并展示数据
    [self showManageView:beginLiveModel.anchor.id orNumber:nil];
    
    [totalPeopleView dismissView];
}

- (void)touchUserAvatar:(NSString *)userid {
    [self showManageView:userid orNumber:nil];
}
#pragma mark - 银票按钮点击事件
- (IBAction)ticketAction:(UIButton *)sender
{
//    [self.rankList showView];
//    return;
    //2018.3.8修改
    LiveContributionViewController * devoteVC = [[LiveContributionViewController alloc] init];
    devoteVC.navigationItem.title = [NSString stringWithFormat:@"贡献榜"];
//    devoteVC.userInfoModel = beginLiveModel.anchor;
    devoteVC.userId = beginLiveModel.anchor.id;
    //2018.4.4修改
//    devoteVC.ticketStr=[NSString stringWithFormat:@"%d",self.lastTicket];
    [self.navigationController pushViewController:devoteVC animated:YES];
}

-(void)sendGiftF:(int)giftid andLianSongNum:(int)giftliansongnum
{
    [super sendGiftF:giftid andLianSongNum:giftliansongnum];
    //在目前的系统中，礼物只能送给主播，所以在这个地方强制收礼对象为主播
    //Todo:更好的做法是在以前设置giftUserModel的地方做好判断，是否允许送给用户，另外送礼流程也要相应修改，获得更准确的收礼对象
//    giftUserModel=beginLiveModel.anchor;
    if (!giftUserModel) {
        return;
    }
    int giftnum=[sendGiftNum intValue];
//    self.attach += giftliansongnum;
    //连送点击次数*每次连送数量
//    giftliansongnum*=giftnum;
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    // set call parameters
    NSString *method = @"sendGift";
    [args setObject:[NSNumber numberWithInt:self.attach] forKey:@"attach"];
    [args setObject:[NSNumber numberWithInt:giftid] forKey:@"giftid"];
    [args setObject:[NSNumber numberWithInt:giftliansongnum] forKey:@"giftnum"];
    [args setObject:[NSMutableString stringWithFormat:@"nowords"] forKey:@"giftwords"];
    if (giftUserModel.id!=nil) {
        [args setObject:giftUserModel.id forKey:@"touserid"];
    }
    //设置收礼人id
    if (showerNickname!=nil) { //5.21
        [args setObject:[NSMutableString stringWithString:showerNickname] forKey:@"tousername"];
    }
    NSString *nickname=self.appDelegate.userModel.user.nickname;
    NSString *userid=self.appDelegate.userModel.user.id;
    if (![self isBlankString:showinfo[@"showid"]]) {//1.2 添加判断
        [args setObject:showinfo[@"showid"] forKey:@"showid"];
    }
    //fromuserid 为自己
    if (userid!=nil) {
        [args setObject:userid forKey:@"fromuserid"];
    }
    if (nickname!=nil) { //1.17
        [args setObject:nickname forKey:@"fromusername"];
    }
    [args setObject:[NSNumber numberWithInt:0] forKey:@"sofaid"];
    [socket invoke:method withArgs:args];
}
#pragma mark - 关注按钮点击事件
- (IBAction)attentionBtnAction:(UIButton *)sender
{
    if (!self.attentionBtn.selected) {
        NSMutableDictionary *args=[NSMutableDictionary dictionary];
        NSString *method = @"clientAction";
        [args setObject:[NSMutableString stringWithString:@"add_fav"] forKey:@"action"];
        [socket invoke:method withArgs:args];
        //    self.attentionBtn.hidden = YES;
        self.attentionBtn.selected = YES;
        self.nickNameTrailing.constant=39;
        //8.23 隐藏底部弹出的关注view
        [self hideAttentionLive];
        
    } else {
        
        if (!openShouHuView) {
            openShouHuView = [[NSBundle mainBundle] loadNibNamed:@"OpenShouHuView" owner:self options:nil].lastObject;
            openShouHuView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
//            totalPeopleView.delegate = self;
            [openShouHuView initArr];
            if (SCREEN_HEIGHT >= 812) {
                openShouHuView.bottomLayout.constant = (486-openShouHuView.bgImg.height);
            } else {
                openShouHuView.bottomLayout.constant = -34;
            }
            [self.liveShowView addSubview:openShouHuView];
            __weak typeof(self) weakSelf = self;
            openShouHuView.buyBtnClick = ^(NSDictionary * _Nonnull params) {
                [weakSelf buyGuard:params];
            };
        }
        
        [self requestPrice];
        
        //    [totalPeopleView dismissView];
        
//        if (!self.manageView.hidden) {
//            [self hideManageView];
//        }
        
        
        
        [openShouHuView showView];
        
        
        
//        shouhuVC.title=@"开通守护";
//        shouhuVC.hidesBottomBarWhenPushed=YES;
//        shouhuVC.beginModel=self.beginLiveModel;
//        [self.navigationController pushViewController:shouhuVC animated:YES];
    }
    
}

- (void)buyGuard:(NSDictionary *)params {
    NSString *url =[NSString stringWithFormat:@"%@ajax/buy_guard.php?guard_userid=%@&type=1&platform=ios&token=%@",DATAAPI,self.beginLiveModel.anchor.id,self.appDelegate.userModel.token];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:url andController:self andView:self.view andParams:[params mutableCopy] andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] integerValue]==200)
        {    //弹开通守护成功的窗口
//            [self dismissShouHuView:nil];
            [openShouHuView dismissShouHuView:openShouHuView.buyBtn];
            [[HudHelper hudHepler]showShortTips:self.view tips:successData[@"api_msg"]];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"buyGuardSuccess" object:nil];
            [self updataGuard];
        }
        else if ([successData[@"api_code"] integerValue]==500)
        {
//            [[MessageHelper messageHelper]showWarnMessage:self title:@"" sub:successData[@"api_msg"]];
            [[HudHelper hudHepler]showShortTips:self.view tips:successData[@"api_msg"]];
            //跳转充值页面
            //            [self rechargeBalance];
            
            [self rechargeBalance];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeBalance" object:nil];
        }
    }];
}

- (void)requestPrice
{
//    [[RootHttpHelper httpHelper] achieveCommonPostURL:[NSString stringWithFormat:@"vip/guard?roomnumber=%@",self.beginLiveModel.anchor.haoma] andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
    if (!shouhuArr) {
        shouhuArr = [NSMutableArray array];
    }
    NSString *requestUrl=[NSString stringWithFormat:@"%@v3/vip/guard?roomnumber=%@",DATAAPI,self.beginLiveModel.anchor.haoma];//
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:requestUrl andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        [shouhuArr removeAllObjects];
    
        if ([successData[@"api_code"] integerValue]==200)
        {
            NSMutableArray *arr=[successData objectForKey:@"data"];
            for (NSDictionary *dic in arr) {
                shouHuModel *shouhu=[[shouHuModel alloc] initWithDictionary:dic error:nil];
                [shouhuArr addObject:shouhu];
            }
            openShouHuView.shouHuArr = shouhuArr;
//            [self freshData];
        }
    }];
}

- (void)totalPeopleViewBuyShouHu {
//    [super totalPeopleViewBuyShouHu];
    
    if (!openShouHuView) {
        openShouHuView = [[NSBundle mainBundle] loadNibNamed:@"OpenShouHuView" owner:self options:nil].lastObject;
        openShouHuView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        //            totalPeopleView.delegate = self;
        [openShouHuView initArr];
        if (SCREEN_HEIGHT >= 812) {
            openShouHuView.bottomLayout.constant = (486-openShouHuView.bgImg.height);
        } else {
            openShouHuView.bottomLayout.constant = -34;
        }
        [self.liveShowView addSubview:openShouHuView];
        __weak typeof(self) weakSelf = self;
        openShouHuView.buyBtnClick = ^(NSDictionary * _Nonnull params) {
            [weakSelf buyGuard:params];
        };
    }
    
    [self requestPrice];
    
    [openShouHuView showView];
}

- (void)totalPeopleViewBuyGuiZu {
//    [super totalPeopleViewBuyGuiZu];
    
    NobleViewController *guizuVC=[[NobleViewController alloc] init];
    guizuVC.hidesBottomBarWhenPushed=YES;
    guizuVC.beginModel=self.beginLiveModel;
    [self.navigationController pushViewController:guizuVC animated:YES];
}

#pragma mark - 分享按钮点击事件
- (IBAction)shareAction:(UIButton *)sender
{
    if([WXApi isWXAppInstalled]||[WXApi isWXAppSupportApi])
            {
                self.shareView.hidden = NO;
                self.shareView.transform = CGAffineTransformMakeTranslation(0, 0);
                [self.shareView bringToFront];
                self.shareToWx.hidden=NO;
                self.shareToWxFriend.hidden=NO;
            }
}
#pragma mark - 取消分享
- (IBAction)cancelShareBtnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.shareView.hidden = YES;
        self.shareView.transform = CGAffineTransformMakeTranslation(0, 195);
    }];
}

#pragma mark - 分享按钮点击事件
- (IBAction)shareBtnClick:(UIButton *)sender
{
    self.appDelegate.isshareGetCode=YES;
    //8.11修改分享标题和描述语 //room_share_name 后台返回的描述
    NSUserDefaults *userdefault =[NSUserDefaults standardUserDefaults];
    //分享的地址
    NSString *shareAdd=[userdefault objectForKey:@"room_share_address"];
    NSString *tempUrl = [userdefault objectForKey:@"share_jump_url"];
    if (tempUrl && ![tempUrl isEqualToString:@""]) {
        shareAdd = tempUrl;
    } else {
        shareAdd = [NSString stringWithFormat:@"%@/live/%@",shareAdd,beginLiveModel.anchor.haoma];
    }
    //8.28 分享的标题
    NSString *room_sharename=beginLiveModel.anchor.room_share_name;
    if ([self isBlankString:room_sharename])
    {
        room_sharename=[NSString stringWithFormat:@"%@正在直播卖萌，还不进来围观",beginLiveModel.anchor.nickname];
    }
    else
    {
        room_sharename=[room_sharename stringByReplacingOccurrencesOfString:@"[nickname]" withString:[NSString stringWithFormat:@"%@",beginLiveModel.anchor.nickname]];
        room_sharename=[room_sharename stringByReplacingOccurrencesOfString:@"[title]" withString:[NSString stringWithFormat:@"%@",showTitle]];
    }
    
    //分享简介
    NSString *room_sharedes=beginLiveModel.anchor.room_share_des;
    if ([self isBlankString:room_sharedes])
    {
        room_sharedes=[NSString stringWithFormat:@"%@正在直播卖萌，还不进来围观",beginLiveModel.anchor.nickname];
    }
    else
    {
        room_sharedes=[room_sharedes stringByReplacingOccurrencesOfString:@"[nickname]" withString:[NSString stringWithFormat:@"%@",beginLiveModel.anchor.nickname]];
        room_sharedes=[room_sharedes stringByReplacingOccurrencesOfString:@"[title]" withString:[NSString stringWithFormat:@"%@",showTitle]];
    }
    switch (sender.tag)
    {
        case 60001:
            //NSLog(@"++++++++++++++++分享到QQ");
            if (self.appDelegate.hongbaoID!=nil) {//18.5.31修改
                NSString * room_title=[NSString stringWithFormat:@"%@",DownLoadName];
                [[QQHelper qqHelper] shareLinkToQQ:[NSString stringWithFormat:@"%@", ShareURL] atIndex:2 andTitle:room_title andInfo:nil andImage:super.headView.image];
            }else{
                [[QQHelper qqHelper] shareLinkToQQ:shareAdd atIndex:2 andTitle:room_sharename andInfo:room_sharedes andImage:super.headView.image];
            }
            
            break;
        case 60002:
            //NSLog(@"++++++++++++++++分享到微信");
            if (self.appDelegate.hongbaoID!=nil) {//18.5.31修改
                NSString * room_title=[NSString stringWithFormat:@"%@",DownLoadName];
                [[WXHelper wxHelper] shareLinkToWx:[NSString stringWithFormat:@"%@", ShareURL] atIndex:0 andTitle:room_title andInfo:nil andImage:super.headView.image];
            }else{
                [[WXHelper wxHelper] shareLinkToWx:shareAdd atIndex:0 andTitle:room_sharedes andInfo:nil andImage:super.headView.image];
            }
            break;
        case 60003:
            //NSLog(@"++++++++++++++++分享到微博");
            //[[WeiboHelper weiboHelper] shareLinkToWeibo:[NSString stringWithFormat:@"%@/live/%@",shareAdd,beginLiveModel.anchor.haoma] atIndex:0 andTitle:room_sharename andInfo:room_sharedes andImage:super.headView.image];
            break;
        case 60004:
            //NSLog(@"++++++++++++++++分享到微信朋友圈");
        {
            if (self.appDelegate.hongbaoID!=nil) {//18.5.31修改
                NSString * room_title=[NSString stringWithFormat:@"%@",DownLoadName];
                [[WXHelper wxHelper] shareLinkToWx:[NSString stringWithFormat:@"%@", ShareURL] atIndex:1 andTitle:room_title andInfo:nil andImage:super.headView.image];
            }else{
               [[WXHelper wxHelper] shareLinkToWx:shareAdd atIndex:1 andTitle:room_sharedes andInfo:nil andImage:super.headView.image];
            }
        }
            break;
        case 60005:
        {
            if (self.appDelegate.hongbaoID!=nil) {//18.5.31修改
                NSString * room_title=[NSString stringWithFormat:@"%@",DownLoadName];
                [[QQHelper qqHelper] shareLinkToQQ:[NSString stringWithFormat:@"%@", ShareURL] atIndex:3 andTitle:room_title andInfo:nil andImage:super.headView.image];
            }else{
                [[QQHelper qqHelper] shareLinkToQQ:shareAdd atIndex:3 andTitle:room_sharename andInfo:room_sharedes andImage:super.headView.image];
            }
        }
            break;
        default:
            break;
    }
    self.appDelegate.roomNumber=roomnumber;
    self.appDelegate.showID=showinfo[@"showid"];
    [self cancelShareBtnClick:nil];
}

#pragma mark - 回退按钮点击事件
- (IBAction)exitBtnAction:(UIButton *)sender
{
    if (self.chatPush==YES) {
        [self closeLianMai];
        
            if (self.delegate&&[self.delegate respondsToSelector:@selector(viewerController: withNickname:withheadimg:withUserid:)]) {
                [self.delegate viewerController:self withNickname:self.beginLiveModel.anchor.nickname withheadimg:self.beginLiveModel.anchor.avatar withUserid:[NSString stringWithFormat:@"%@",self.beginLiveModel.anchor.id]];
            [self downThePhone];
        };
        return;
    }
    // 真正的退出房间
    [self exitUserLive];
}

#pragma mark - 退出直播
- (void)exitUserLive
{
    if (self.Record==YES)
    {
        [self.link invalidate];
         self.link=nil;
    }
    [self closeCurrentVC];//2017.12.18
    if (self.gamePush==YES)
    {
        for (UIViewController *temp in self.navigationController.viewControllers)
        {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    else
    {
        [self dismiss];
    }
}

//2017.12.18 修改
- (void)closeCurrentVC
{
    [self hideAttentionLive];
    
    [self.avatarAnimation stop];
    [self.avatarAnimation removeFromSuperview];
    self.avatarAnimation = nil;
    
    [self overMultiPK:NO];
    
    //6.5
    if (gameWebView) {
        [gameWebView removeFromSuperview];
        [gameWebView.configuration.userContentController removeScriptMessageHandlerForName:@"jsCallNativeClose"];//移除按钮的唤起事件
        [gameWebView.configuration.userContentController removeScriptMessageHandlerForName:@"jsCallNative"];//移除按钮的唤起事件
        
        gameWebView = nil;
    }
    if (self.finishBtn) {
        [self.finishBtn removeFromSuperview];
         self.finishBtn=nil;
    }
    if (self.moreView) {
        [self.moreView removeFromSuperview];
        self.moreView=nil;
    }
    if (self.gameMoreView) {
        [self.gameMoreView removeFromSuperview];
        self.gameMoreView=nil;
    }
    if(self.backgroundMusic){
        [self.backgroundMusic stop];
         self.backgroundMusic=nil;
    }
    if (_delayTimer)
    {
        [_delayTimer invalidate];
         _delayTimer = nil;
    }
    if (self.gameTimer) {
        [self.gameTimer invalidate];
        self.gameTimer = nil;
    }
    if (self.pkTimer)
    {
        [self.pkTimer invalidate];
         self.pkTimer = nil;
    }
    if (self.delayEndTimer)
    {
        [self.delayEndTimer invalidate];
         self.delayEndTimer = nil;
    }
    if (delGiftTimer) {
        [delGiftTimer invalidate];
         delGiftTimer=nil;
    }
    if (hideTimer) {
        [hideTimer invalidate];
         hideTimer =nil;
    }
    if (socket) {
        [super closeConnect];
    }
    if (backImgView) {
        [self removebackimg];
    }
    [self endCurrentPlayer];//移除当前视频
    
    [self lianmaiEndLive];
    
    if (self.kit.pusher) {
        [self lianmaiEndPusher];
    }
    
    [self.pkPlayer stopPlay];
    [self.pkPlayer setRenderView:nil];
    self.pkPlayer = nil;
    if (self.playerPKView) {
        [self.playerPKView removeFromSuperview];
        self.playerPKView = nil;
    }
    
    if (self.kit) {
        //只离开一次频道，可以用这个方法，如果更换频道无法这样使用。
        if (joined==YES)
        {
            self.kit.wantStop=YES;
            [self.kit leaveChannel];
             joined=NO;
        }
        if (self.kit.txKit.trtcCloud) {
            [TRTCCloud destroySharedIntance];
            self.kit.txKit.trtcCloud = nil;
        }
//        [self.kit.preview removeFromSuperview];
        self.kit=nil;
        if (self.lianMaiBtn) {
            [self.lianMaiBtn removeFromSuperview];
        }
        
        
    }
}

-(void)bye:(int)userid{
    [super bye:userid];
    if ([showerUserid intValue]==userid) {//是主播退出
        isAllShutup = YES;
        
        if (stopBgImg.superview) {
            stopLab.text=@"主播已下播";
        } else {
            stopBgImg=[[UIImageView alloc] initWithFrame:self.view.frame];
            stopBgImg.image=[UIImage imageNamed:@"stopBgImage"];
            stopLab =[[UILabel alloc] init];
            stopLab.bounds=CGRectMake(0, 0, SCREEN_WIDTH, 30);
            stopLab.center=CGPointMake(stopBgImg.size.width/2, stopBgImg.size.height/2-40);
            stopLab.text=@"主播已下播";
            stopLab.textAlignment=NSTextAlignmentCenter;
            stopLab.textColor=[UIColor whiteColor];
            stopLab.font=[UIFont systemFontOfSize:24.0f];
            [stopBgImg addSubview:stopLab];
            [self.liveShowView insertSubview:stopBgImg atIndex:2];
        }
        
        
        [self.view endEditing:YES];
        if (self.chatPush==YES) { //3.8
            if (self.delegate&&[self.delegate respondsToSelector:@selector(viewerController: withNickname:withheadimg:withUserid:)]) {
                [self.delegate viewerController:self withNickname:self.beginLiveModel.anchor.nickname withheadimg:self.beginLiveModel.anchor.avatar withUserid:[NSString stringWithFormat:@"%d",userid]];
            }
            [self downThePhone];
            return;
        }
        [self endLive];
    }
}

#pragma mark - 直播结束直播跳页面
- (void)endLive
{
    return;
    /// wkwebview 调用js方法
    if (isGaming)// 当前是游戏页面 才会显示js的页面
    {
        [gameWebView evaluateJavaScript:@"jsNotifyTs()" completionHandler:nil];
        [self.view bringSubviewToFront:gameWebView];
    }
}
//实现聊天区域的代理方法
- (void)msgViewDidScroll:(UIScrollView *)scrollView
{
    self.backScrollView.scrollEnabled=NO;
}
- (void)msgViewEndScroll:(UIScrollView *)scrollView
{
    if (self.gamePush==YES || isLianMai) {
        return;
    }
    self.backScrollView.scrollEnabled=YES;
}
#pragma mark - 监听键盘出现
- (void)handleKeyboardWillShow:(NSNotification *)paramNotification
{
    self.backScrollView.scrollEnabled=NO;
    NSDictionary* info = [paramNotification userInfo];
    //kbSize即为键盘尺寸 (有width, height)
    [self.LayerView bringSubviewToFront:self.toolBar];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;         //得到鍵盤的高度
    isComm = NO;
    //输入框位置动画加载
    if([tempText isEqual:self.chatText]){
        //输入框位置动画加载
        self.sengGiftView.hidden = YES;
        [self begainMoveUpAnimation:kbSize andView:self.toolBar];
    }
    if ([tempText isEqual:self.sendGiftTextView]) {
        self.sengGiftView.hidden = NO;
        isShowSendGiftView = YES;
        [self.view bringSubviewToFront:self.sengGiftView];
        [self begainMoveUpAnimation:kbSize andView:self.sengGiftView];
    }
    [UIView animateWithDuration:0.5 animations:^{
        //        self.chatViewBottom.constant=kbSize.height;
        self.ChatManageView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height);
    }];
}
- (IBAction)chatAction:(UIButton *)sender
{
    self.backScrollView.scrollEnabled=NO;
    [super chatAction:sender];
}
- (void)handleKeyboardDidShow:(NSNotification *)paramNotification
{
    self.backScrollView.contentOffset=CGPointMake(0, SCREEN_HEIGHT);
}
#pragma mark - 监听键盘隐藏
- (void)handleKeyboardWillHide:(NSNotification *)paramNotification
{
    if (self.gamePush==NO) {
        if (!isLianMai) {
                    self.backScrollView.scrollEnabled=YES;
                }
    }
    NSDictionary* info = [paramNotification userInfo];
    //kbSize即为键盘尺寸 (有width, height)
    [self.LayerView bringSubviewToFront:self.toolBar];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;      //得到鍵盤的高度
    isComm = YES;
    //输入框位置动画加载
    if([tempText isEqual:self.chatText]){
        //输入框位置动画加载
        [self begainMoveUpAnimation:kbSize andView:self.toolBar];
        [self bottomSwip:nil];
    }
    if ([tempText isEqual:self.sendGiftTextView]) {
        self.sengGiftView.hidden = YES;
        [self begainMoveUpAnimation:kbSize andView:self.sengGiftView];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        //        self.chatViewBottom.constant=kbSize.height;
        self.ChatManageView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    
    if (SCREEN_HEIGHT>=812) {  //2018.9.6 适配iphonex的游戏高度页面
        self.btnBottom.constant=20;
    } else {
        self.btnBottom.constant=0;
    }
}
- (void)downTheBtn
{
    if(/*self.chatViewBottom.constant!=0&&*/pushToRedBag==NO)
    {
        [self bottomSwip:nil];
        self.chatBtn.hidden = NO;
        self.msgView.userInteractionEnabled=YES;
        if (self.gamePush==YES) { //游戏过来的不执行向下的手势
            return;
        }
        self.reviewBtn.hidden = NO;
        self.shareBtn.hidden=NO;
        self.moreBtn.hidden=NO;
//        self.upBtn.hidden=NO;
        super.chatText.text = @"";
    }
}
#pragma mark - 设置toolBar的位置
- (void)begainMoveUpAnimation:(CGSize)keyboardSize andView:(UIView *)view
{
    if(isComm)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            //移动位置(到初始位置)
            view.transform = CGAffineTransformMakeTranslation(0, 84);
            if (userPwd==nil||[userPwd isEqualToString:@""])//密码房时不显示
            {
                self.toolBar.hidden=YES;
            }
            if (isShowSendGiftView) {
                isShowSendGiftView = NO;
                [self downTheBtn];
            } else {
                [self downTheBtn];
            }
            isComm = YES;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            //移动位置(到键盘上方)
            view.transform = CGAffineTransformMakeTranslation(0, -keyboardSize.height);
            if (userPwd==nil||[userPwd isEqualToString:@""])//密码房时不显示
            {
                self.toolBar.hidden=NO;
                [self.liveShowView bringSubviewToFront:self.toolBar];
            }
            if(/*self.chatViewBottom.constant==0&&*/pushToRedBag==NO)
            {
//               self.chatViewBottom.constant=self.toolBar.frame.size.height+keyboardSize.height;
                if (self.chatPush==NO) {
                    self.msgView.userInteractionEnabled=NO;
                }
                self.chatBtn.hidden = YES;
                self.reviewBtn.hidden = YES;
                self.shareBtn.hidden=YES;
                self.moreBtn.hidden=YES;
                self.upBtn.hidden=YES;
            }
            isComm = NO;
        }];
    }
}

#pragma mark - 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //移除玩法的view
    [self touchesBeganClick];
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    int x = point.x; int y = point.y-143;
    //从点击位置判断要显示的用户是哪一个
    NSString *infoRoomnumber=@"";
    if (x>=SCREEN_WIDTH/2) {
        infoRoomnumber=rightNumber;
    }
    else{
        infoRoomnumber=leftNumber;
    }
    BOOL inArea=NO;//点击区域

    if ([self.playerPKView.subviews containsObject:[touch view]]) {
        [self touchOtherRoomBtnAction];
    }
}



- (void)touchOtherRoomBtnAction {
    NSString *infoRoomnumber = leftNumber;
    if ([roomnumber isEqualToString:leftNumber]) {
        infoRoomnumber = rightNumber;
    }
    if ((isPKing /*|| isLianMai*/) && self.liveShowLeft.constant==0) {//pk时点击屏幕弹出个人信息
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否立即前往对面主播房间" preferredStyle:(UIAlertControllerStyleAlert)];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goOtherRoom:infoRoomnumber];
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}


- (void)goOtherRoom:(NSString *)roomNum
{
    roomnumber=roomNum;//对面房间
    [self endCurrentPlayer];
    [self get_room_infoStatus];
}

#pragma mark - 展示管理列表
- (void)showMansgeList
{
    //获取管理列表
    [[RootHttpHelper httpHelper] achieveCommonPostURL:[NSString stringWithFormat:@"%@%@%@",liveBanKickForepart,beginLiveModel.id,liveBanKickHeel] andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        if(code == 200)
        {
            NSError *err = nil;
            liveBansKicksModel = [[LiveBansKicksModel alloc] initWithDictionary:successData error:&err];
            isBanCommounicate = NO;
            for (int i = 0; i < liveBansKicksModel.bans.count; i++) {
                LiveBansModel *banModel = (LiveBansModel *)liveBansKicksModel.bans[i];
                if ([banModel.im_uid isEqualToString:self.appDelegate.userModel.user.im_uid]) {
                    isBanCommounicate = YES;
                    break;
                }
            }
        }
    }];
}
#pragma mark - 弹幕按钮点击事件
- (IBAction)bulletBtnAction:(UIButton *)sender
{
    [super bulletBtnAction:sender];
}
- (void)cancelInteactWithHost{
    [super cancelInteactWithHost];
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要断开与主播的连麦么？" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSMutableDictionary * params=[NSMutableDictionary dictionary];
        [params setObject:@"lianmai_end" forKey:@"action"];
        [socket invoke:@"micOpt" withArgs:params];
//        if (self.kit) {
//            //[self.kit2 stopPreview];
//            if (joined==YES) {
//                self.kit.wantStop=YES;
//                [self.kit leaveChannel];
//                joined=NO;
//            }
//            [self.kit.preview removeFromSuperview];
////            self.kit2=nil;
//        }
        self.lianMaiBtn.hidden=YES;
        [self lianmaiEndPusher];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - @ta的按钮点击事件
//11.29添加@ta的功能
- (IBAction)aitePeopleAction:(UIButton *)sender
{
    if ([userInfoModel.id isEqualToString:self.appDelegate.userModel.user.id])
    {
        [[MessageHelper messageHelper]showWarnMessage:self title:@"" sub:@"不用对自己操作了,去@别的小伙伴吧"];
        return;
    }
    //隐藏manageview页面
    [self hideManageView];
    //弹出键盘
    [self chatAction:nil];
    if (userInfoModel.nickname!=nil) { //18.5.15
        super.chatText.text=[NSString stringWithFormat:@"@%@ %@",userInfoModel.nickname,super.chatText.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendBtnAction:nil];
    return YES;
}

#pragma mark - 发送按钮点击事件
- (IBAction)sendBtnAction:(UIButton *)sender
{
//    if (isAllShutup) {
//        [[MessageHelper messageHelper] showMessage:self title:nil sub:@"主播未开播，暂时无法发言"];
//        return;
//    }
    //发送之前编码
    NSString * chatString =[ReplaceEmoji escape:super.chatText.text];
    if([chatString isEqualToString:@""])
    {
        [self.view makeToast:@"请说点什么吧" duration:1.5 position:ToastDefaultPosition];
    }
    else
    {
        if(isBullet)
        {
            NSMutableDictionary *args=[NSMutableDictionary dictionary];
            // set call parameters
            NSString *method = @"sendGift";
            [args setObject:[NSNumber numberWithInt:1] forKey:@"giftnum"];
            [args setObject:chatString forKey:@"giftwords"];
            [args setObject:showerUserid forKey:@"touserid"];
            [args setObject:self.beginLiveModel.anchor.nickname forKey:@"tousername"];
            [args setObject:self.appDelegate.userModel.user.nickname forKey:@"fromusername"];//发送飞屏的人
            [args setObject:[NSNumber numberWithInt:0] forKey:@"sofaid"];
            if (isDanMu==YES)
            {
                [args setObject:[NSNumber numberWithInt:3] forKey:@"giftid"];//飞屏
                [args setObject:@"0" forKey:@"showid"];
            }
            if (isLaBa==YES)
            {
                [args setObject:[NSNumber numberWithInt:65] forKey:@"giftid"];//全服
            }
            if (isRenYiMen==YES)
            {
                [args setObject:[NSNumber numberWithInt:90] forKey:@"giftid"];//传送门
            }
            [socket invoke:method withArgs:args];
        }
        else
        {
            [self sendMsgToRoom:chatString andToNickname:@"ALL" toUserid:0];
        }
        //退出键盘，并清空输入框内数据
        [self cleanUpData];
        //2017.12.7
        [[SailorPopMenuViewSingleton shareManager] menuHide];
    }
}

#pragma mark - 喇叭按钮点击事件
- (IBAction)labaBtnAction:(UIButton *)sender
{
    //发送之前编码
    NSString * chatString =[ReplaceEmoji escape:super.chatText.text];
    if([chatString isEqualToString:@""])
    {
        [self.view makeToast:@"请说点什么吧" duration:1.5 position:ToastDefaultPosition];
    }
    else
    {
        if(isBullet)
        {
            NSMutableDictionary *args=[NSMutableDictionary dictionary];
            // set call parameters
            NSString *method = @"sendGift";
            NSString *nickname=self.beginLiveModel.anchor.nickname;
            [args setObject:[NSNumber numberWithInt:65] forKey:@"giftid"];//全服
            [args setObject:[NSNumber numberWithInt:1] forKey:@"giftnum"];
            [args setObject:chatString forKey:@"giftwords"];
            [args setObject:showerUserid forKey:@"touserid"];
            //1104
            [args setObject:nickname forKey:@"tousername"];
            [args setObject:self.appDelegate.userModel.user.nickname forKey:@"fromusername"];//发送弹幕的人
            [args setObject:[NSNumber numberWithInt:0] forKey:@"sofaid"];
            [socket invoke:method withArgs:args];
            //退出键盘，并清空输入框内数据
            [self cleanUpData];
        }
        else
        {
            [[HudHelper hudHepler]showShortTips:self.view tips:@"发送喇叭需选中左侧弹幕按钮"];
        }
    }
}

#pragma mack - 获取用户数据
- (void)showManageView:(NSString *)userid orNumber:(NSString *)roomnumber
{
    if ([isScret isEqualToString:@"hide"]) { //神秘人不显示个人信息弹框
        return;
    }
    //1.10修改
    [self cleanUpData];
    //1105
    [self.view bringSubviewToFront:self.manageView];
    [UIView animateWithDuration:0.5 animations:^{
        self.manageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.manageView.hidden = NO;
    }];
    if (yinxiangArr==nil) {
        yinxiangArr =[NSMutableArray array];
    }
    __weak GameAudienceViewController *weakSelf = self;
    NSString *queryUrl=@"";
    if (userid!=nil) {
        queryUrl=[NSString stringWithFormat:@"users/detail/%@",userid];
    }
    else if (roomnumber!=nil) {
        queryUrl=[NSString stringWithFormat:@"users/detail/%@?type=roomnumber",roomnumber];
    }
    [[RootHttpHelper httpHelper] achieveCommonPostURL:queryUrl andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        if (successData==nil) {
            return;
        }
        [yinxiangArr removeAllObjects];
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        if(code == 200)
        {
            NSError *err;
            giftUserModel = userInfoModel = [[UserInfoModel alloc]initWithDictionary:successData error:&err];
            NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:userInfoModel.yinxiang];
            for (YinXiangModel *yinxiang in arr) {
                if (yinxiang.name) {
                    [yinxiangArr addObject:yinxiang.name];
                }
            }
            //弹出观众管理View并展示数据
            [weakSelf showManageViewInMain];      
        }
    }];
}

#pragma mark - 弹出观众管理View并展示数据
- (void)getMansgeList
{
    isLiveGuard = NO;
    //获取管理员列表
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:[NSString stringWithFormat:@"%@%@/%@%@%@",DATAAPI,APIVersion,liveGuardForepart,beginLiveModel.anchor.haoma,liveGuardHeel] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        if(code == 200)
        {
            [guardLists removeAllObjects];
            for (NSMutableDictionary * model in [successData objectForKey:@"data"])
            {
                NSError *err = nil;
                liveGuardListModel = [[LiveGuardListModel alloc] initWithDictionary:model error:&err];
                if ([liveGuardListModel.guard.id isEqualToString:self.appDelegate.userModel.user.id]){
                    isLiveGuard = YES;
                }
                [guardLists addObject:liveGuardListModel];
            }
        }
    }];
}

- (void)showManageViewInMain
{
                [self showTheGuiZu:self.vipImg With:userInfoModel.guizhu];//11.6贵族

    //自己是管理员
    if (isLiveGuard==YES)
    {
        //点击的是主播
        if ([userInfoModel.id isEqualToString:showerUserid]) {
//            self.mansgeLab.hidden=NO;
//            self.mansgeLab.text=@"举报";
            
            if (yinxiangArr.count==0)
            {
                self.yinxiangWidth1.constant = self.yinxiangWidth2.constant = self.yinxiangWidth3.constant = 0;
                self.yinxiangBtn1.hidden=YES;
                self.yinxiangBtn2.hidden=YES;
                self.yinxiangBtn3.hidden=YES;
                
            }
            else
            {
                if (yinxiangArr.count==1) {
                    self.yinxiangWidth2.constant = self.yinxiangWidth3.constant = 0;
                    [self.yinxiangBtn1 setTitle:yinxiangArr[0] forState:0];
                    self.yinxiangBtn1.hidden=NO;
                    
                }
                if (yinxiangArr.count==2) {
                    self.yinxiangWidth3.constant = 0;
                    [self.yinxiangBtn1 setTitle:yinxiangArr[0] forState:0];
                    self.yinxiangBtn1.hidden=NO;
                    [self.yinxiangBtn2 setTitle:yinxiangArr[1] forState:0];
                    self.yinxiangBtn2.hidden=NO;
                    
                }
                if (yinxiangArr.count==3) {
                    [self.yinxiangBtn1 setTitle:yinxiangArr[0] forState:0];
                    self.yinxiangBtn1.hidden=NO;
                    [self.yinxiangBtn2 setTitle:yinxiangArr[1] forState:0];
                    self.yinxiangBtn2.hidden=NO;
                    [self.yinxiangBtn3 setTitle:yinxiangArr[2] forState:0];
                    self.yinxiangBtn3.hidden=NO;
                }
            }
            
        }
        else
        {
            self.totalheight.constant=300;
            self.yinxiangBtn1.hidden=YES;
            self.yinxiangBtn2.hidden=YES;
            self.yinxiangBtn3.hidden=YES;
            self.addyinxiangBtn.hidden=YES;
            //点击自己的头像 左上角不显示
            if ([userInfoModel.id isEqualToString:self.appDelegate.userModel.user.id]) {
                self.mansgeLab.hidden=YES;
                                        [self showTheGuiZu:self.vipImg With:self.appDelegate.userModel.user.guizhu];//11.6贵族

            }
            else //点击别的观众的头像 因为是管理员 所以有禁言和踢出权限
            {
//                self.mansgeLab.hidden=NO;
//                self.mansgeLab.text=@"管理";
                self.homeReportBtn.selected = YES;
            }
        }
    }
    else  //不是管理员
    {
        //点击的是主播
        if ([userInfoModel.id isEqualToString:showerUserid]) {
//            self.mansgeLab.hidden=NO;
//            self.mansgeLab.text=@"举报";
            
            if (yinxiangArr.count==0)
            {
                self.yinxiangBtn1.hidden=YES;
                self.yinxiangBtn2.hidden=YES;
                self.yinxiangBtn3.hidden=YES;
                self.yinxiangWidth1.constant = self.yinxiangWidth2.constant = self.yinxiangWidth3.constant = 0;
            }
            else
            {
                if (yinxiangArr.count==1) {
                    [self.yinxiangBtn1 setTitle:yinxiangArr[0] forState:0];
                    self.yinxiangBtn1.hidden=NO;
                    self.yinxiangWidth2.constant = self.yinxiangWidth3.constant = 0;
                }
                if (yinxiangArr.count==2) {
                    [self.yinxiangBtn1 setTitle:yinxiangArr[0] forState:0];
                    self.yinxiangBtn1.hidden=NO;
                    [self.yinxiangBtn2 setTitle:yinxiangArr[1] forState:0];
                    self.yinxiangBtn2.hidden=NO;
                    self.yinxiangWidth3.constant = 0;
                }
                if (yinxiangArr.count==3) {
                    [self.yinxiangBtn1 setTitle:yinxiangArr[0] forState:0];
                    self.yinxiangBtn1.hidden=NO;
                    [self.yinxiangBtn2 setTitle:yinxiangArr[1] forState:0];
                    self.yinxiangBtn2.hidden=NO;
                    [self.yinxiangBtn3 setTitle:yinxiangArr[2] forState:0];
                    self.yinxiangBtn3.hidden=NO;
                }
            }
        }
        else
        {
            self.totalheight.constant=300;
            self.yinxiangBtn1.hidden=YES;
            self.yinxiangBtn2.hidden=YES;
            self.yinxiangBtn3.hidden=YES;
            self.addyinxiangBtn.hidden=YES;
            //点击自己的头像 左上角不显示
            if ([userInfoModel.id isEqualToString:self.appDelegate.userModel.user.id]) {
                self.mansgeLab.hidden=YES;
                //自己是不是vip
                                        [self showTheGuiZu:self.vipImg With:self.appDelegate.userModel.user.guizhu];//11.6贵族

            }
            else //点击别的观众的头像 因为是管理员 所以有禁言和踢出权限
            {
//                self.mansgeLab.hidden=NO;
//                self.mansgeLab.text=@"举报";
                self.homeReportBtn.selected = NO;
            }
        }
    }
    [self.manageHeadImg sd_setImageWithURL:[self placeCorpsImg:[[ToolHelper toolHelper] realAvatarUrl:userInfoModel.id andUpdate:userInfoModel.update_avatar_time]] placeholderImage:[self placeDefaultImg]];
    self.manageHeadImg.contentMode=UIViewContentModeScaleAspectFill;
    self.manageHeadImg.clipsToBounds = YES;
    self.manageNickName.text = userInfoModel.nickname;
    
    if (userInfoModel.avatar_frame) {
        if (![userInfoModel.avatar_frame isEqualToString:@""]) {
            NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [directoryPaths objectAtIndex:0];
            NSString *filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",userInfoModel.avatar_frame]];
            if (!self.cardAvatarAnimation) {
                CGFloat width = (self.manageHeadImg.width * 42) / 30;
                self.cardAvatarAnimation = [LOTAnimationView animationWithFilePath:filePath];
                self.cardAvatarAnimation.loopAnimation = YES;
                [self.cardAvatarAnimationView addSubview:self.cardAvatarAnimation];
                [self.cardAvatarAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.cardAvatarAnimationView);
                    make.width.height.equalTo(@(width));
                }];
                [self.cardAvatarAnimation playWithCompletion:^(BOOL animationFinished) {
                }];
            }
        } else {
            if (self.cardAvatarAnimation) {
                [self.cardAvatarAnimation stop];
                [self.cardAvatarAnimation removeFromSuperview];
                self.cardAvatarAnimation = nil;
            }
        }
    } else {
        if (self.cardAvatarAnimation) {
            [self.cardAvatarAnimation stop];
            [self.cardAvatarAnimation removeFromSuperview];
            self.cardAvatarAnimation = nil;
        }
    }
    
    //3.7 当银票数量大于1万时 显示x万
    NSString *numbers =userInfoModel.total_ticket;
    if ([numbers intValue]>10000)
    {
        NSString *ticket=[NSString stringWithFormat:@"%.2f万",[numbers floatValue]/10000];
        self.ticketNum.text=ticket;
        if ([numbers intValue]>100000000)
        {
            NSString *ticket=[NSString stringWithFormat:@"%.2f亿",[numbers floatValue]/100000000];
            self.ticketNum.text=ticket;
        }
    }
    else
    {
        self.ticketNum.text =numbers;
    }
    if([userInfoModel.total_send_gift isEqualToString:@"0"]){
        
        self.mansgeBalance.text = @"0";
    }else{
        //3.7 当银票数量大于1万时 显示x万
        NSString *numbers =userInfoModel.total_send_gift;
        if ([numbers intValue]>10000)
        {
            NSString *ticket=[NSString stringWithFormat:@"%.2f万",[numbers floatValue]/10000];
            self.mansgeBalance.text=ticket;
            if ([numbers intValue]>100000000)
            {
                NSString *ticket=[NSString stringWithFormat:@"%.2f亿",[numbers floatValue]/100000000];
                self.mansgeBalance.text=ticket;
            }
        }
        else
        {
            self.mansgeBalance.text =numbers;
        }
    }
    if([self isBlankString:userInfoModel.hometown_city]){
        
        self.manageHome.text = @"地区：火星";
    }else{
        self.manageHome.text = [NSString stringWithFormat:@"地区：%@",userInfoModel.hometown_city];
    }
    if([userInfoModel.gender isEqualToString:@"0"]){
        
        [self.manageSex setImage:[UIImage imageNamed:@"icon_live_sex"]];
    }else{
        [self.manageSex setImage:[UIImage imageNamed:@"icon_live_sex_boy"]];
    }
    if ([userInfoModel.summary isEqualToString:@""]) {
        self.summary.text = @"[暂无个性签名]";
    } else {
        self.summary.text = userInfoModel.summary;
    }
    NSString *usernumber_name=[[NSUserDefaults standardUserDefaults]objectForKey:@"usernumber_name"];
    if (![self isBlankString:usernumber_name]) {
        if([userInfoModel.haoma isEqualToString:@"0"]){
            self.manageNum.text = [NSString stringWithFormat:@"直播号:%@",userInfoModel.unique_id];
        }else{
            self.manageNum.text = [NSString stringWithFormat:@"%@:%@",usernumber_name,userInfoModel.haoma];
        }
    } else if ([usernumber_name isEqualToString:@""] && ![usernumber_name isKindOfClass:[NSNull class]]) {
        self.manageNum.text = [NSString stringWithFormat:@"ID:%@",userInfoModel.haoma];
    }
    if(![self isBlankString:userInfoModel.fans_num]){
        
        self.fansNum.text = [NSString stringWithFormat:@"%@",userInfoModel.fans_num];
    }else{
        self.fansNum.text = @"0";
    }
    if(![self isBlankString:userInfoModel.follow_num]){
        
        self.followNum.text = [NSString stringWithFormat:@"%@",userInfoModel.follow_num];
    }else{
        self.followNum.text = @"0";
    }
    if([userInfoModel.is_follow isEqualToString:@"0"]){
        //        [self.isFollowBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.isFollowBtn.selected = NO;
    }else{
        //        [self.isFollowBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.isFollowBtn.selected = YES;
    }
    //2018.10.31显示等级
    [self showThelevel:userInfoModel.rank_id and:self.manageNack and:self.nackNum isZhuBo:NO];
    if ([userInfoModel.person_verify isEqualToString:@"3"]) {
        [self showThelevel:userInfoModel.anchor_rank_id and:self.manageNack_anchor and:self.nackNum isZhuBo:YES];
        self.manageNack_anchor.hidden = NO;
    } else {
        self.manageNack_anchor.hidden = YES;
    }
    self.dupiao.text=[self jiFenNum];
}

#pragma mark - 按钮点击事件
- (IBAction)reportBtnAction:(UIButton *)sender
{
    if ([userInfoModel.id isEqualToString:self.appDelegate.userModel.user.id]) {
        //点击的是自己 按钮事件不执行
        return;
    }
    if (!isLiveGuard) {
        UIAlertController * interactAlertView = [UIAlertController alertControllerWithTitle:@"" message:@"确定举报该用户吗？" preferredStyle:UIAlertControllerStyleAlert];
        [interactAlertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

        }]];
        [interactAlertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

            //调用举报接口
            [[RootHttpHelper httpHelper] achieveCommonPostURL:[NSString stringWithFormat:@"%@%@",post_report_person,userInfoModel.id] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {

                NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
                if(code == 200)
                {
                    [[MessageHelper messageHelper] showSuccessMessage:self title:nil sub:@"举报成功"];
                }
            }];
            
        }]];
        
        [self presentViewController:interactAlertView animated:YES completion:nil];
    }else if (isLiveGuard) {
        // 管理观众
        UIAlertController * mansgeAlertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [mansgeAlertView addAction:[UIAlertAction actionWithTitle:@"禁言/解禁" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            // 贵族
            if (![self isBlankString:userInfoModel.guizhu]) {
                int i = [userInfoModel.guizhu intValue];
                if (i > 4 && i < 7) {
                    self.vipImg.hidden = NO;
                    self.vipImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_gui%d",i]];
                    [[MessageHelper messageHelper] showWarnMessage :self title:@"很遗憾" sub:@"对方是贵族,只有主播才可以禁言ta哦"];
                } else {
                    self.vipImg.hidden = YES;
                    [super switchchatBtnClicked:[userInfoModel.id intValue]];
                }
            } else {
                self.vipImg.hidden = YES;
                [super switchchatBtnClicked:[userInfoModel.id intValue]];
            }
            
        }]];
        [mansgeAlertView addAction:[UIAlertAction actionWithTitle:@"踢人" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            // 贵族
            if (![self isBlankString:userInfoModel.guizhu]) {
                int i = [userInfoModel.guizhu intValue];
                if (i > 4 && i < 7) {
                    self.vipImg.hidden = NO;
                    self.vipImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_gui%d",i]];
                    [[MessageHelper messageHelper] showWarnMessage :self title:@"很遗憾" sub:@"对方是贵族,只有主播才可以踢ta哦"];
                } else {
                    self.vipImg.hidden = YES;
                    [self kickoutBtnClicked:[userInfoModel.id intValue]];
                }
            } else {
                self.vipImg.hidden = YES;
                [self kickoutBtnClicked:[userInfoModel.id intValue]];
            }
        }]];
        [mansgeAlertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        }]];
        // 管理观众弹出提示框
        [self presentViewController:mansgeAlertView animated:YES completion:nil];
    }
}

#pragma mark - 展示管理员列表
- (void)showGuardList
{     //获取管理员列表
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:[NSString stringWithFormat:@"%@%@/%@%@%@",DATAAPI,APIVersion,liveGuardForepart,beginLiveModel.id,liveGuardHeel] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        if(code == 200)
        {
            [guardLists removeAllObjects];
            for (NSMutableDictionary * model in [successData objectForKey:@"data"])
            {
                NSError *err = nil;
                liveGuardListModel = [[LiveGuardListModel alloc] initWithDictionary:model error:&err];
                [guardLists addObject:liveGuardListModel];
            }
            //获取管理员列表
            LiveGuardianViewController * guardVC = [[LiveGuardianViewController alloc] init];
            guardVC.rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            guardVC.guardLists = guardLists;
            guardVC.beginLiveModel = beginLiveModel;
            [self.navigationController pushViewController:guardVC animated:YES];
//            [self presentViewController:guardVC animated:YES completion:^{}];
        }
    }];
}

#pragma mark - 关闭按钮点击事件
- (IBAction)closeBtnAction:(UIButton *)sender
{
    //9.3 这里把送礼对象的model设置为了nil
    giftUserModel = userInfoModel = nil;
    /// 2.17
    [self hideManageView];
}

#pragma mark - 关注按钮点击事件
- (IBAction)followBtnAction:(UIButton *)sender
{
    if([userInfoModel.is_follow isEqualToString:@"0"]){
        [[RootHttpHelper httpHelper] achieveCommonPostURL:[NSString stringWithFormat:@"%@%@",s_liveFollow,userInfoModel.id]  andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {

            NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
            if(code == 200)
            {
                userInfoModel.is_follow = @"1";
//                [self.isFollowBtn setTitle:@"已关注" forState:UIControlStateNormal];
                self.isFollowBtn.selected = YES;
            }
        }];
    }
    else
    {
        [[RootHttpHelper httpHelper] achieveCommonPostURL:[NSString stringWithFormat:@"%@%@",s_liveUnfollow,userInfoModel.id] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
            NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
            if(code == 200)
            {
                userInfoModel.is_follow = @"0";
//                [self.isFollowBtn setTitle:@"关注" forState:UIControlStateNormal];
                self.isFollowBtn.selected = NO;
            }
        }];
    }
}
#pragma mark - 个人主页点击事件
- (IBAction)homePageAction:(UIButton *)sender
{
    

}
#pragma mark - 展示红包界面
- (void)showRedPackView
{
    [super showRedPackView];
    [UIView animateWithDuration:0.5 animations:^{
//        self.redPackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.redPackView.hidden = NO;
        ///5.23置于当前view的最前端
        [self.LayerView bringSubviewToFront:self.redPackView];
    }];
}
//关闭按钮
- (IBAction)chatViewClose:(id)sender {
    self.toolBar.hidden = NO;
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.ChatViewInLive.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 316);
    } completion:^(BOOL finished) {
//        self.ChatViewInLive.hidden=YES;
        if (self.gamePush==YES || isLianMai) {
            return;
        }
        if (self.gamePush==NO) {
            self.backScrollView.scrollEnabled=YES;
        }
    }];
}

//私信弹出的视图的返回按钮点击事件
- (IBAction)chatBackClick:(id)sender {
    self.chatBack.hidden = YES;
    self.friendBtn.hidden = NO;
    self.messageBtn.hidden = NO;
    self.friendTitle.text = @"";
    self.friendTitle.hidden = YES;
    if ([self.friendBtn.titleLabel.font isEqual:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]]) {
        self.friendLine.hidden = NO;
    } else {
        self.messageLine.hidden = NO;
    }
 
}
//私信弹出的视图的好友按钮点击事件
- (IBAction)friendBtnClick:(id)sender {
    self.friendBtn.selected = YES;
    self.messageBtn.selected = NO;
    self.friendBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.friendLine.hidden = NO;
    self.messageLine.hidden = YES;
    [self.ChatViewInChatView addSubview:self.friendListTableView];
    [super getFriendList];
}
//私信弹出的视图的消息按钮点击事件
- (IBAction)messageBtnClick:(id)sender {
    self.messageBtn.selected = YES;
    self.friendBtn.selected = NO;
    self.friendBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.friendLine.hidden = YES;
    self.messageLine.hidden = NO;
    [self.friendListTableView removeFromSuperview];
}

#pragma mark - 释放界面
- (void)dealloc
{
    NSLog(@"YYGameViewerUserLiveController dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"buyGuardSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"rechargeBalance" object:nil];
    
}

#pragma mark - 收到fms回调
//收到fms回调
-(void)resultReceived:(NSString *)method andParams:(NSDictionary *)args {
    [super resultReceived:method andParams:args];
    if ([method isEqualToString:@"pk_start"])
    { // 从回放进来之后收到pk_start的时候会显示pk条和时间  这里处理一下 移除掉
        if (self.Record==YES)
        {
            [self removeAllView];
        }
    }
    /*
     if ([method isEqualToString:@"pk_start_pc"]) //观看pc端的连麦
     {
     if (fullscreenBtn) {
        fullscreenBtn.hidden=YES;
     }
     //NSString *pkid=[args SafeObject:@"pkid"];
     NSString *faqiren=[args SafeObject:@"faqiren"];
     NSString *faqiren_nickname=[args SafeObject:@"faqiren_nickname"];
     NSString *jieshouren=[args SafeObject:@"jieshouren"];
     NSString *jieshouren_nickname=[args SafeObject:@"jieshouren_nickname"];
     NSString *faqiren_video=[args SafeObject:@"faqiren_video"];
     NSString *jieshouren_video=[args SafeObject:@"jieshouren_video"];
     NSString *time=[args SafeObject:@"time"];
     //收到pc端连麦之后 显示pk条和倒计时 显示两个pk主播的视频
     if ([faqiren isEqualToString:roomnumber]) {
     [self createPKViewWithFaQi:faqiren_nickname AndJieShou:jieshouren_nickname andTime:time withNumber:1 andPcOrNot:YES];
     }
     else
     {
     [self createPKViewWithFaQi:jieshouren_nickname AndJieShou:faqiren_nickname andTime:time withNumber:0 andPcOrNot:YES];
     }
     //判断pk发起人是不是当前房间的主播 然后根据发起人对视频进行平移
     if ([faqiren isEqualToString:roomnumber])//发起人是当前房间的主播
     {
     if(self.player!=nil){
     [self removebackimg];
     [self.player stop]; //先重置播放器 然后seturl重新播放
     [self.player.view removeFromSuperview];
     self.player=nil;
     pc_live=YES;
     [self createBackImg];
     [self createPlayerViewWithUrl:faqiren_video];
     [self createPC_PlayerWithUrl:jieshouren_video];
     }
     }
     if ([jieshouren isEqualToString:roomnumber])//接收人是当前房间的主播
     {
     if(self.player!=nil){
     [self removebackimg];
     [self.player stop]; //先重置播放器 然后seturl重新播放
     [self.player.view removeFromSuperview];
     self.player=nil;
     pc_live=YES;
     [self createBackImg];
     [self createPlayerViewWithUrl:jieshouren_video];
     [self createPC_PlayerWithUrl:faqiren_video];
     }
     }
     }
     // 过程中所有人收到pk值变化
     else if ([method isEqualToString:@"pk_value_pc"])
     {
     float faqiren_value=[[args SafeObject:@"faqiren_value"] floatValue];
     float jieshouren_value=[[args SafeObject:@"jieshouren_value"] floatValue];
     [self.pkview setPKValueBlue:faqiren_value andRed:jieshouren_value];
     }
     //所有人收到pk结束
     else if ([method isEqualToString:@"pk_end_pc"])
     {
     if (fullscreenBtn) {
     fullscreenBtn.hidden=NO;
     }
     //NSString * faqiren=[args SafeObject:@"faqiren"];
     //NSString * jieshouren=[args SafeObject:@"jieshouren"];
     NSString *win_usernumber=[args SafeObject:@"win_usernumber"];
     [self pk_endwith:win_usernumber];
     //收到pc端PK结束 移除pk条 移除后加的播放器 恢复原来的播放器
     [self removeAllView];
     if (self.player!=nil) {
     [self removebackimg];
     [self.player stop];
     [self.player.view removeFromSuperview];
     self.player=nil;
     pc_live=NO;
     [self createBackImg];
     [self createPlayerViewWithUrl:[showinfo objectForKey:@"download_video_add"]];
     }
     if (self.pc_player!=nil) {
     [self.pc_player stop];
     [self.pc_player.view removeFromSuperview];
     self.pc_player=nil;
     }
     }
     */
    //所有人收到pk结束
    else if ([method isEqualToString:@"pk_end"])
    {

    }
    //12.22  新增收费房间 收到开始收费的广播
    if([method isEqualToString:@"beginPayMode"]){
        if ([self.appDelegate.userModel.user.guizhu intValue]>4&&[PayRoom intValue]>=1) {//公爵以上不作处理
        }
        else{
        NSString *money=[args SafeObject:@"money"];
        //弹框
        UIAlertController *beginShouFeiAlert =[UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"一分钟后开始每分钟%ld%@收费!",[money integerValue],[self moneyname]] preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:beginShouFeiAlert animated:YES completion:nil];
        UIAlertAction *cancle =[UIAlertAction actionWithTitle:@"不差钱" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sure =[UIAlertAction actionWithTitle:@"我不看了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self exitUserLive];
        }];
        [beginShouFeiAlert addAction:cancle];
        [beginShouFeiAlert addAction:sure];
     }
  }
    //7.13 新增收费房间 收到停止收费的广播
    else if([method isEqualToString:@"endPayMode"]){
        //弹框
        UIAlertController*endShouFeiAlert =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"此房间已经停止收费了!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure =[UIAlertAction actionWithTitle:@"太棒了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self exitUserLive];
        }];
        [endShouFeiAlert addAction:sure];
    }
//    if ([method isEqualToString:@"infoAlert"]) {
//        NSString *alertInfo=[args SafeObject:@"msg"];
//        if ([alertInfo isEqualToString:@""]) {
//            return;
//        }
//        __weak typeof(self) weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf exitUserLive];
//        });
        //  2s后离开房间
//        [self performSelector:@selector(exitUserLive) withObject:self afterDelay:1.0f];
//    }
    //9.27 观众端收到welocme出来之前离开的页面
    if ([method isEqualToString:@"welcome"]) {
        NSDictionary *userinfo = [[self dictionaryWithJsonString:[args SafeObject:@"data"]] objectForKey:@"userinfo"];
        if ([userinfo[@"userid"] isEqualToString:self.appDelegate.userModel.user.id]) {
            if ([userinfo[@"guard"] integerValue] == 1) {
                self.attentionBtn.hidden = YES;
                self.nickNameTrailing.constant=6;
            }
        }
        NSString *who=[args SafeObject:@"nickname"];
        if ([who isEqualToString:@""]) {
            return;
        }
        NSString *car=[args SafeObject:@"data"];
        //1.11 添加
        if (![car respondsToSelector:@selector(dataUsingEncoding:)]) {
            return;
        }
        NSError *error;
        NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:[car dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if ([[[obj objectForKey:@"userinfo"] objectForKey:@"userid"] isEqualToString:showerUserid]){//等于主播的话 也就是说主播退出之后重新进来了
            isAllShutup = NO;
            if (stopBgImg)
            {
                [stopBgImg removeFromSuperview];
            }
        }
    }
     if ([method isEqualToString:@"userInfoUpdate"]){
        NSString *doAction=[args SafeObject:@"action"];
        if ([doAction isEqualToString:@""]) {
            return;
        }
        /// 3.29 主播暂时离开收到fms的回调显示离开页面
        else if ([doAction isEqualToString:@"video_stop"])
        {
//            if (isLianMaiMore) {
//                self.fangzhuView.hidden = YES;
//            }
            stopBgImg=[[UIImageView alloc] initWithFrame:self.view.frame];
            stopBgImg.image=[UIImage imageNamed:@"stopBgImage"];
            stopLab =[[UILabel alloc] init];
            stopLab.bounds=CGRectMake(0, 0, SCREEN_WIDTH, 30);
            stopLab.center=CGPointMake(stopBgImg.size.width/2, stopBgImg.size.height/2-40);
            stopLab.text=@"主播暂时离开,稍后回来";
            stopLab.textAlignment=NSTextAlignmentCenter;
            stopLab.textColor=[UIColor whiteColor];
            stopLab.font=[UIFont systemFontOfSize:24.0f];
            [stopBgImg addSubview:stopLab];
            [self.liveShowView insertSubview:stopBgImg atIndex:2];
        }
        else if ([doAction isEqualToString:@"video_start"])
        {
            if (stopBgImg)
            {
                [stopBgImg removeFromSuperview];
            }
        }
        NSString *userid=[args SafeObject:@"data"];
        if ([doAction isEqualToString:@"setadminadd"]) {
            if ([userid isEqualToString:self.appDelegate.userModel.user.id]) {
                isLiveGuard=YES;
            }
        }
        else if ([doAction isEqualToString:@"setadmindel"]) {
            if ([userid isEqualToString:self.appDelegate.userModel.user.id]) {
                isLiveGuard=NO;
            }
        }
        else if([doAction isEqualToString:@"lianmai_success"]){//连麦成功
            //连麦默认开美颜
            self.selfInV2=YES;
            self.backScrollView.scrollEnabled = NO;
            self.lianMaiBtn.hidden=NO;

            if (self.chatPush==YES) {
                if (_delayTimer!=nil)//接通视频之后需要移除延时倒计时timer
                {
                    [_delayTimer invalidate];
                     _delayTimer = nil;
                }
                if(self.backgroundMusic){ //3.13 添加
                    [self.backgroundMusic stop];
                     self.backgroundMusic=nil;
                }
                self.lianMaiBtn.hidden=YES;
            }
            [self initMic2];
            
            self.kit.isPK = NO;
            self.kit.txKit.isPK = NO;

            
            
            
            joined=YES;
            isLianMai=YES;//2018.8.27 同意连麦之后做一个标记
        }
        else if ([doAction isEqualToString:@"lianmai_kick"]) {
            if([[args SafeObject:@"data"] isEqualToString:@""]){
                if (self.kit!=nil){
                    if (joined==YES)
                    {
                        self.kit.wantStop=YES;
                        [self.kit leaveChannel];
                        joined=NO;
                    }
                    
                     self.kit=nil;
                }
                if (self.chatPush==YES) {//连麦结束断开房间
                    return;
                }
                
                self.kit.txKit.twoVideo = 0;
                self.kit.txKit.threeVideo = 0;
                self.zhuboPKView.hidden = YES;
                self.pkAvatarView_1.hostView = nil;
                
                self.fangzhuView.hidden = YES;
                
                //2017.11.13
                self.lianMaiBtn.hidden=YES;
                isLianMai=NO;//2018.8.27 连麦结束标记去掉

                //18.4.10修改
                return;
            }
        }
        else if([doAction isEqualToString:@"lianmai_user"]){//2麦有人上麦

            NSArray *dataArr = [[args SafeObject:@"data"] componentsSeparatedByString:@",|"];
            if ([[args SafeObject:@"data"] isEqualToString:@""]) {
                dataArr = @[];
            }
            if(dataArr.count == 0){
                [self lianmaiEndLive];
                [self lianmaiEndPusher];
                self.pkBgTopImg.hidden = YES;
                self.pkBgBottomImg.hidden = YES;
                self.pkLeftView.hidden = YES;
                self.pkSofaBGImg.hidden = YES;
                self.pkRightView.hidden = YES;
                self.playerView.frame=self.view.frame;
                
                self.backScrollView.scrollEnabled = YES;
                isLianMai=NO;
                self.lianMaiBtn.hidden=YES;
                
                return;
            }
//                self.kit2.wantStop=NO;
//            isLianMai=YES;
            self.selfInV2 = NO;
            NSMutableArray *info = [NSMutableArray array];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:dataArr[0] forKey:@"userid"];
            [dic setValue:dataArr[1] forKey:@"flv"];
            [info addObject:dic];
            if ([dic[@"userid"] isEqualToString:self.appDelegate.userModel.user.haoma]) {
                self.selfInV2 = YES;
            }
            
            __weak typeof(self) weakself = self;
            [self getTRCTuserSig:self.appDelegate.userModel.user.haoma withBlock:^{
                [weakself uploadLianMaiUserInfoView:info withUid:[NSString stringWithFormat:@"%@",user]];
            }];
        }
        else if([doAction isEqualToString:@"lianmai_message"]){//连麦申请
            if (self.chatPush==YES) {//用户直接同意连麦
                NSMutableDictionary * params=[NSMutableDictionary dictionary];
                [params setObject:@"lianmai_info" forKey:@"action"];
                [params setObject:self.appDelegate.userModel.user.haoma forKey:@"usernumber"];
                [params setObject:@"agree" forKey:@"position"];
                [socket invoke:@"micOpt" withArgs:params];
                if (videoback!=nil) {
                    [videoback removeFromSuperview];
                    self.liveShowView.hidden=YES;
                    self.account.hidden=YES;
                }
                return;
            }
            UIAlertController * interactAlertView = [UIAlertController alertControllerWithTitle:@"" message:@"主播要求与你连麦，是否同意？" preferredStyle:UIAlertControllerStyleAlert];
            [interactAlertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSMutableDictionary * params=[NSMutableDictionary dictionary];
                [params setObject:@"lianmai_info" forKey:@"action"];
                [params setObject:self.appDelegate.userModel.user.haoma forKey:@"usernumber"];
                [params setObject:@"dissent" forKey:@"position"];
                [socket invoke:@"micOpt" withArgs:params];
              
            }]];
            [interactAlertView addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                
                NSMutableDictionary * params=[NSMutableDictionary dictionary];
                [params setObject:@"lianmai_info" forKey:@"action"];
                [params setObject:self.appDelegate.userModel.user.haoma forKey:@"usernumber"];
                [params setObject:@"agree" forKey:@"position"];
                [socket invoke:@"micOpt" withArgs:params];
                
                [self delayStartV2];
            }]];
            [self presentViewController:interactAlertView animated:YES completion:nil];
        }
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (void)addMaskView:(CGFloat)y
{
    self.maskView =[[PKMaskView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (void)lianmaiEnd {
    self.pkBgTopImg.hidden = YES;
    self.pkBgBottomImg.hidden = YES;
    self.pkLeftView.hidden = YES;
    self.pkSofaBGImg.hidden = YES;
    self.pkRightView.hidden = YES;
    
    if(self.playerView) {
        @try {
//            [self.appDelegate.player.view removeObserver:self forKeyPath:@"frame1"];
            self.playerView.frame = [UIScreen mainScreen].bounds;
        } @catch (NSException *exception) {
            NSLog(@"%s exception:%@", __func__, exception);
        }
    }
    if (self.maskView) {
        [self.maskView removeFromSuperview];
        self.maskView=nil;
    }
}

//3.6
- (void)closeLianMai
{   //断开
    NSMutableDictionary * params=[NSMutableDictionary dictionary];
    [params setObject:@"lianmai_end" forKey:@"action"];
    [socket invoke:@"micOpt" withArgs:params];
    [self lianmaiEnd];
}
//公聊
-(void)sendMsgToRoom:(NSString *) msg andToNickname:(NSString *)nickname toUserid:(NSString *)toUserid{
    if (isBlockChat) {
        [[MessageHelper messageHelper] showWarnMessage:self title:nil sub:@"您已经被禁言"];
         return;
    }
    NSString *to=@"ALL";
    NSMutableDictionary *args=[NSMutableDictionary dictionary];
    NSString *method = @"sendMessage";
    [args setObject:[NSMutableString stringWithString:to] forKey:@"to"];
    [args setObject:[NSMutableString stringWithString:msg] forKey:@"msg"];
    [socket invoke:method withArgs:args];
}

- (void)quitRoom
{
     [self closeCurrentVC];
     [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)UAA{
    [super UAA];
    [self quitRoom];
    //9.28 用gcd替换之前的performSelector方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.appDelegate popupErrorMsg:@"相同的账号进入房间,您已被踢出,请检查您的账号密码是否泄漏"];
    });
}

-(void)END{
    [super END];
    [self quitRoom];
    //9.28 用gcd替换之前的performSelector方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.appDelegate popupErrorTitle:@"当前直播间已经被管理员关闭"];
    });
}

#pragma mark - 2麦直播界面
-(void)initMic2
{
    if (self.kit) {
        return;
    }
    if (self.kit== nil){
        // 创建带有默认参数的 kit，不会打断其他后台的音乐播放
        self.kit = [[TXLiveStreamerKit alloc] initWithDefaultCfg];
    }
    self.kit.isAudience = YES; // 是否是观众、如果是观众连麦后不进行推流
    self.kit.wantStop=NO;
    // ---------------------------

    if (self.chatPush==YES) {
        self.kit.chatPush=self.chatPush;
    }
    
    TRTCVideoEncParam *encoder = [[TRTCVideoEncParam alloc] init];
    // 分辨率
    encoder.videoResolution = TRTCVideoResolution_1280_720;
    // 横屏还是竖屏
    encoder.resMode = TRTCVideoResolutionModePortrait;
    // 码率
    encoder.videoBitrate = 1500;
    encoder.minVideoBitrate = 1500;
    // 采集帧率
    encoder.videoFps = 20;
    [self.kit.txKit.trtcCloud setVideoEncoderParam:encoder];
    
    TRTCNetworkQosParam *qosParams = [[TRTCNetworkQosParam alloc] init];
    qosParams.preference = TRTCVideoQosPreferenceClear;
    [self.kit.txKit.trtcCloud setNetworkQosParam:qosParams];
    
    TRTCRenderParams *params = [[TRTCRenderParams alloc] init];
    params.mirrorType = TRTCVideoMirrorTypeEnable;
    [self.kit.txKit.trtcCloud setLocalRenderParams:params];
    [self.kit.txKit.trtcCloud setVideoEncoderMirror:YES];
    
    [self setTXLiveStreamerKitCfg];
    //仅在开始推流前设置有效 视频输出格式 (默认:kCVPixelFormatType_32BGRA)
//    self.kit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
    //仅在开始推流前设置有效  采集格式
//    self.kit.capturePixelFormat   = kCVPixelFormatType_32BGRA;
    // 注册通知：
    //[self registerObserver];
//    self.kit2.preview.frame = self.view.frame;
    //启动预览
//    [self.kit2 startPreview:self.liveShowView];
    //** 推流设置成镜像模式,默认为NO */
//    self.kit2.streamerMirrored=YES;
    self.kit.isAudience = YES;
}


- (void)setTXLiveStreamerKitCfg
{
    //设置rtc参数
    

    
//    [self.avatar_0 initWithUid:self.appDelegate.userModel.user.haoma];
//    self.avatar_0.hostView.frame = self.appDelegate.micRect;
//    [self.kit.txKit addLocalView:self.avatar_0];
    
    
    
//    self.kit2.selfInFront = NO;//小窗口显示自己还是对方
//    if (self.chatPush==YES) {//1v1视频大小
//        self.kit2.selfInFront = YES;////1v1视频小窗口显示自己的窗口 大窗口显示对方
//        self.kit2.winRect = CGRectMake(0.7, 0.7, 0.3, 0);//设置小窗口大小
//        [self createHideVideoView];
//    }
//    else
//    {
//        self.kit2.winRect = CGRectMake(0.5, 0.25, 0.5, 0);//设置小窗口大小
//    }
//    self.kit2.rtcLayer = 4;//设置小窗口图层，因为主版本占用了1~3，建议设置为4
    __weak GameAudienceViewController *weak_self = self;
//    self.kit.txKit.joinChannelBlock = ^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
//        // 成功加入通道 后进行推流只推自己的视频流
//        joined = YES;
//        [weak_self.kit.txKit setLiveTranscoding];
//    };
//    self.kit2.localVideoStateChange = ^{
//        [weak_self initLocalVideo];
//    };
//    self.kit2.onCallStart =^(int status){
//        if(status == 200)
//        {
//            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
//            {
//                [[HudHelper hudHepler]showShortTips:weak_self.view tips:@"连线成功"];
//                [weak_self.liveShowView sendSubviewToBack:weak_self.appDelegate.player.view];
//            }
//
//        }
//    };//连麦接通后回调
    
    self.kit.uploadLianMaiInfo = ^(NSMutableArray *info, NSUInteger uid) {
        // 根据 TRTC 当前用户更新连麦视图（不包含自己）
//        [weak_self uploadLianMaiUserInfoView:info withUid:[NSString stringWithFormat:@"%ld",uid]];
    };
    self.kit.onCallStop = ^(int status){
        if(status == 200)
        {
            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
            {
//                [weak_self leaveTheKitView];
//                [weak_self playerCreatePlayer];
            }
        }
    };//连麦停止回调
    self.kit.txKit.joinChannelBlock = ^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
        {
            [weak_self delayStartV2];
        }
    };
    self.kit.txKit.leaveChannelBlock = ^(NSInteger stat) {
//        [weak_self.kit.txKit.trtcCloud stopLocalPreview];
    };
    
    
    self.kit.onChannelJoin = ^(int status){
        if(status == 200)
        {
            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
            {
                [weak_self delayStartV2];
            }
        }
    };//加入通道回调
}

- (void)leaveTheKitView
{    //2麦下播
     NSMutableDictionary * params=[NSMutableDictionary dictionary];
     [params setObject:@"lianmai_end" forKey:@"action"];
     [socket invoke:@"micOpt" withArgs:params];
    [self lianmaiEnd];
}
-(void)delayStartV2{
    //2麦开播
    NSMutableDictionary * params=[NSMutableDictionary dictionary];
    [params setObject:@"lianmai_ann" forKey:@"action"];
    [socket invoke:@"micOpt" withArgs:params];
}


//全服红包点击跳转直播间
- (void)fullHongBaoClick:(UITapGestureRecognizer *)sender
{
    if(![hongBaoModel.roomnumber isEqualToString:@""] && hongBaoModel.roomnumber!=nil){
        if (roomnumber!=self.appDelegate.userModel.user.haoma) {
            //不是主播就跳转到红包房间
            [self exitUserLive];
            //7.20 跳转房间时传房间号
            [self.appDelegate accrssLiveRoom:hongBaoModel.roomnumber];
        }
    }
}
//主播印象
- (IBAction)yinxiangbtnAction:(UIButton *)sender
{
    YinXiangViewController *yinxiangVC=[[YinXiangViewController alloc] init];
    yinxiangVC.navigationItem.title=@"主播印象";
    yinxiangVC.roomNumber=roomnumber;
    yinxiangVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:yinxiangVC animated:YES];
}
- (IBAction)moreAction:(UIButton *)sender
{
    if (self.moreView!=nil) {
        if (self.moreView.hidden==YES) {
            self.moreView.hidden=NO;
        }
        return;
    }
    NSArray *imageArr=[NSArray array];
    NSArray *titleArr=[NSArray array];

    
    imageArr=@[isHideAnimation?@"giftAnimationOn":@"giftAnimationOff",isWinningMusicOFF?@"icon_live_winning_off":@"icon_live_winning_on",@"icon_live_recommend",@"icon_live_chat_record",isHideFlyPing?@"icon_live_piaoping_on":@"icon_live_piaoping_off"];
    titleArr=@[@"礼物特效",@"中奖音效",@"帝皇推荐",@"聊天记录",isHideFlyPing?@"房间飘屏开":@"房间飘屏关"];
    
    
    self.moreView=[[TheMoreView alloc] initWith];
    self.moreView.delegate=self;
    [self.moreView initWithMoreArray:imageArr andTitle:titleArr];
    [self.moreView showInView:self.view];
    [self.view bringSubviewToFront:self.moreView];
}

//7.19
- (void)ButtonClickAction:(UIButton *)btn
{
    [super ButtonClickAction:btn];
    switch (btn.tag) {
//        case 0://隐藏视频
//        {
//            if (isVideoOn)
//            {
//                videoBackImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//                videoBackImg.image=[UIImage imageNamed:@"stopBgImage"];
//                [self.liveShowView insertSubview:videoBackImg atIndex:2];
//                //关闭声音
//                isVideoOn=NO;
//                //9.28 修改 隐藏视频的时候重置播放器  该方法可以停止播放，但是不会销毁播放器
//                if(self.appDelegate.player){
//                    [self.appDelegate.player reset:NO];
//                }
//                [self.moreView setImg:@"shipin_on" andTitle:@"显示视频" byTag:0];
//            }
//            else
//            {   //打开声音
//                isVideoOn=YES;
//                //移除画面并播放视频
//                if (videoBackImg) {
//                   [videoBackImg removeFromSuperview];
//                }
//                //9.28 如果player不存在，退出
//                if(nil == self.appDelegate.player){
//                    //提示用户退出房间重新进入
//                    UIAlertController *control =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已经和房间断开连接,请退出重新进入" preferredStyle:UIAlertControllerStyleAlert];
//                    [self presentViewController:control animated:YES completion:nil];
//                    UIAlertAction *sure =[UIAlertAction actionWithTitle:@"退出房间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [self exitBtnAction:nil];
//                    }];
//                    [control addAction:sure];
//                    return;
//                }
//                if(self.appDelegate.player)//player存在使用seturl重新播放
//                {
//                    [self.appDelegate.player setUrl:[NSURL URLWithString:[showinfo objectForKey:@"download_video_add"]]];
//                    [self.appDelegate.player prepareToPlay];
//                }
//                [self.moreView setImg:@"shipin_off" andTitle:@"隐藏视频" byTag:0];
//            }
//        }
//            break;
        case 0://礼物效果
        {
            [self animationPlayAndEndBtnAction:btn];
        }
            break;
        case 1://中奖声效
        {
            [self winningMusicBtnAction:btn];
        }
            break;
//        case 1://砸蛋
//        {
//            [self showGameZaDan];
//        }
//            break;
        case 2://帝皇推荐
        {
            [self guizuRecommend];
        }
            break;
        case 3://玩游戏
        {
            [self showChatRecord];
        }
            break;
        case 4://开关飘屏
        {
            [self piaopingBtnAction:btn];
        }
            break;
        default:
            break;
    }
}

- (void)winningMusicBtnAction:(UIButton *)btn
{
    if (isWinningMusicOFF){
        isWinningMusicOFF = NO;
        self.appDelegate.isWinningMusicOFF = NO;
        [[MessageHelper messageHelper]showSuccessMessage:self title:@"" sub:@"中奖音效已开启"];
        [self.moreView setImg:@"icon_live_winning_on" andTitle:@"中奖音效" byTag:btn.tag];
    }
    else{
        isWinningMusicOFF = YES;
        self.appDelegate.isWinningMusicOFF = YES;
        [[MessageHelper messageHelper]showWarnMessage:self title:@"" sub:@"中奖音效已关闭"];
        [self.moreView setImg:@"icon_live_winning_off" andTitle:@"中奖音效" byTag:btn.tag];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isWinningMusicOFF forKey:@"isWinningMusicOFF"];
    [defaults synchronize];
}


- (void)piaopingBtnAction:(UIButton *)btn
{
    if (isHideFlyPing){
        isHideFlyPing = NO;
        [[MessageHelper messageHelper]showSuccessMessage:self title:@"" sub:@"房间飘屏已开启"];
        [self.moreView setImg:@"icon_live_piaoping_off" andTitle:@"房间飘屏关" byTag:btn.tag];
    }
    else{
        isHideFlyPing = YES;
        [self.appDelegate.winningSFMArray removeAllObjects];
        [[MessageHelper messageHelper]showWarnMessage:self title:@"" sub:@"房间飘屏已关闭"];
        [self.moreView setImg:@"icon_live_piaoping_on" andTitle:@"房间飘屏开" byTag:btn.tag];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isHideFlyPing forKey:@"isHideFlyPing"];
    [defaults synchronize];
}

- (void)showChatRecord {
    if (self.moreView) {
        self.moreView.hidden=YES;
    }
    self.chatRecordView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.chatRecordView.transform = CGAffineTransformIdentity;
    }];
}

- (void)guizuRecommend {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[AppDelegate appDelegate].userModel.token forKey:@"token"];
    [params setValue:roomnumber forKey:@"roomnumber"];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:[NSString stringWithFormat:@"%@%@/%@",DATAAPI,@"v4",@"guizhu/recommend"] andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue] == 200) {
            [[MessageHelper messageHelper] showSuccessMessage:self title:nil sub:successData[@"api_msg"]];
        } else {
            [[MessageHelper messageHelper] showWarnMessage:self title:nil sub:successData[@"api_msg"]];
        }
    }];
}

- (void)animationPlayAndEndBtnAction:(UIButton *)btn
{
    if (!isHideAnimation){
        bigAnimationView.aniPlaying=YES;
        bigAnimationView.isSwitchSoundOn=YES;
        isHideAnimation = YES;
        [[MessageHelper messageHelper]showSuccessMessage:self title:@"" sub:@"豪华礼物特效已开启"];
        [self.moreView setImg:@"giftAnimationOn" andTitle:@"礼物特效" byTag:btn.tag];
    }
    else{
        bigAnimationView.aniPlaying=NO;
        bigAnimationView.isSwitchSoundOn=NO;
        isHideAnimation = NO;
        [[MessageHelper messageHelper]showWarnMessage:self title:@"" sub:@"豪华礼物特效已关闭"];
        [self.moreView setImg:@"giftAnimationOff" andTitle:@"礼物特效" byTag:btn.tag];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isHideAnimation forKey:@"isHideAnimation"];
    [defaults synchronize];
//    btn.selected=!btn.selected;
}
- (void)musicBtnAction:(UIButton *)btn
{
    [super musicBtnAction:btn];
    //8.28
    if (bigAnimationView.isSwitchSoundOn)
    {
        //关闭声音
        bigAnimationView.isSwitchSoundOn=NO;
        [[MessageHelper messageHelper]showWarnMessage:self title:@"" sub:@"豪华礼物音乐已关闭"];
        [self.moreView setImg:@"music_off" andTitle:@"开礼物音乐" byTag:btn.tag];
    }
    else
    {
        //打开声音
        bigAnimationView.isSwitchSoundOn=YES;
        [[MessageHelper messageHelper]showSuccessMessage:self title:@"" sub:@"豪华礼物音乐已打开"];
        [self.moreView setImg:@"music_on" andTitle:@"关礼物音乐" byTag:btn.tag];
    }
}
#pragma mark 这里是聊天服务器连接失败的delegate
//rtmp 连接失败
-(void)connectFailedEvent:(int)code description:(NSString *)description{
    
    [super connectFailedEvent:code description:description];
    [self retryConnectRtmpSever];
}
- (void)retryConnectRtmpSever
{
    //2018.1.23 自动重连
    if (reConnecTime>64) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnecTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.txPlayer!=nil) {
            [self removebackimg];
            [self.txPlayer stopPlay];
            [self.txPlayer setObserver:nil];
            [self.playerView removeFromSuperview];
            self.playerView = nil;
            self.txPlayer = nil;
            [self initTCShow:[showinfo objectForKey:@"download_video_add"]];
        } //18.6.29 修改 网络断开的时候把视频和聊天服务器一块重连
    });
    //   重连时间2的指数级增长
    if (reConnecTime == 0) {
        reConnecTime =5;
    }else{
        reConnecTime *=2;
    }
}
- (void)alertView
{
    return;
    UIAlertController *control =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已经和聊天服务器断开连接,将无法聊天送礼" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:control animated:YES completion:nil];
     UIAlertAction *sure =[UIAlertAction actionWithTitle:@"退出房间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exitBtnAction:nil];
    }];
    UIAlertAction *reconnect =[UIAlertAction actionWithTitle:@"重连" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_txPlayer!=nil) {
            [self removebackimg];
            [self.txPlayer stopPlay];
            [self.txPlayer setObserver:nil];
            [self.playerView removeFromSuperview];
            self.playerView = nil;
            self.txPlayer = nil;
            [self createBackImg];
            [self initTCShow:[showinfo objectForKey:@"download_video_add"]];
        } //18.6.29 修改 网络断开的时候把视频和聊天服务器一块重连
    }];
    [control addAction:sure];
    [control addAction:reconnect];
}
//9.3 rtmp 断开提示
-(void)disconnectedEvent {
    [super disconnectedEvent];
    [self retryConnectRtmpSever];
}
- (void)createHideVideoView
{
    if (self.hideVideoView!=nil) {
        [self.hideVideoView removeFromSuperview];
         self.hideVideoView=nil;
    }
    self.hideVideoView=[[UIView alloc] init];
    self.hideVideoView.frame=CGRectMake(SCREEN_WIDTH-80*ScreenBiLi, SCREEN_HEIGHT-SCREEN_HEIGHT/3-80*ScreenBiLi, 80*ScreenBiLi, 80*ScreenBiLi);
    self.hideVideoView.backgroundColor=[UIColor clearColor];
    self.hideVideoView.userInteractionEnabled=YES;
    [self.backScrollView addSubview:self.hideVideoView];
    [self.backScrollView bringSubviewToFront:self.hideVideoView];
    self.hideVideoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.hideVideoBtn.frame=CGRectMake((self.hideVideoView.frame.size.width-60*ScreenBiLi)/2, 0*ScreenBiLi, 60*ScreenBiLi, 60*ScreenBiLi);
    [self.hideVideoBtn setImage:[UIImage imageNamed:@"shipin_on"] forState:UIControlStateNormal];
    [self.hideVideoBtn addTarget:self action:@selector(hideCurrentVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.hideVideoView addSubview:self.hideVideoBtn];
    [self.hideVideoView bringSubviewToFront:self.hideVideoBtn];
    
    self.hideVideoTitle=[[UILabel alloc] init];
    self.hideVideoTitle.frame=CGRectMake(0, self.hideVideoBtn.frame.size.height, self.hideVideoView.frame.size.width, 20*ScreenBiLi);
    self.hideVideoTitle.text=@"关闭摄像头";
    self.hideVideoTitle.textColor=[UIColor whiteColor];
    self.hideVideoTitle.font=[UIFont systemFontOfSize:12.0f];
    self.hideVideoTitle.textAlignment=NSTextAlignmentCenter;
    [self.hideVideoView addSubview:self.hideVideoTitle];
}
//隐藏1v1视频
- (void)hideCurrentVideo:(UIButton *)btn
{
    btn.selected=!btn.selected;
    if (btn.selected) {
        [self.hideVideoBtn setImage:[UIImage imageNamed:@"shipin_off"] forState:0];
        self.hideVideoTitle.text=@"开启摄像头";
        self.kit.winRect = CGRectMake(0, 0, 0.01, 0.01);
        NSMutableDictionary * params=[NSMutableDictionary dictionary];
        [params setObject:@"onetoone_switch_video" forKey:@"action"];
        [params setObject:@"off" forKey:@"status"];
        [socket invoke:@"onetoone_switch_video" withArgs:params];
    }
    else
    {
        [self.hideVideoBtn setImage:[UIImage imageNamed:@"shipin_on"] forState:0];
        self.hideVideoTitle.text=@"关闭摄像头";
        self.kit.winRect = CGRectMake(0.7, 0.7, 0.3, 0);
        NSMutableDictionary * params=[NSMutableDictionary dictionary];
        [params setObject:@"onetoone_switch_video" forKey:@"action"];
        [params setObject:@"on" forKey:@"status"];
        [socket invoke:@"onetoone_switch_video" withArgs:params];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 方式1.匹配keypath
//    if ([keyPath isEqualToString:@"frame"]) {
//        //NSLog(@"preview = %f", self.kit.preview.frame.origin.y);
//        if(self.kit2.preview.frame.origin.y==0){
//            self.kit2.preview.frame=CGRectMake(0, -((SCREEN_HEIGHT-SCREEN_WIDTH*8/9)/2-(self.zhenzhuCountView.frame.size.height+self.zhenzhuCountView.frame.origin.y+7*ScreenBiLi + 25 +7)), SCREEN_WIDTH, SCREEN_HEIGHT);
//        }
//    }
//    if ([keyPath isEqualToString:@"frame1"]) {
//        if (self.appDelegate.player.view.y==0) {
//            self.appDelegate.player.view.frame = CGRectMake(0, -((SCREEN_HEIGHT-SCREEN_WIDTH*8/9)/2-(self.zhenzhuCountView.frame.size.height+self.zhenzhuCountView.frame.origin.y+7*ScreenBiLi + 25 +7)), SCREEN_WIDTH, SCREEN_HEIGHT);
//        }
//    }
}

- (void)againloadPlayer {
}

- (void)lianmaiStartPusher:(RoomAvatarView *)view {
    if (!self.kit.pusher) {
        // 连麦后创建推送
        [self.kit initTXLivePusherisRTC:YES with:view.hostView];
        [self.kit.pusher setObserver:self];
    }
    [self.kit startPusher];
    [view initWithUid:self.appDelegate.userModel.user.haoma];
    view.hostView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [self.kit.pusher setRenderView:view.hostView]; // 设置预览view
    // 开始推流
    
    __weak typeof(self) weakself = self;
    [self getTRCTuserSig:self.appDelegate.userModel.user.haoma withBlock:^{
        
        if (weakself.selfInV2 && !weakself.isPusher) {
            weakself.isPusher = YES;
            [weakself.kit.pusher startPush:[NSString stringWithFormat:@"trtc://cloud.tencent.com/push/56853_%@?sdkappid=%@&userId=%@&usersig=%@",weakself.appDelegate.userModel.user.haoma,TRTCSDKAppID,weakself.appDelegate.userModel.user.haoma,TXTRCTUserSig]];
            
            
//            [weakself.txPlayer stopPlay];
//            [weakself.txPlayer setRenderView:weakself.playerView];
            [weakself.txPlayer startLivePlay:[NSString stringWithFormat:@"trtc://cloud.tencent.com/play/56853_%@?sdkappid=%@&userId=%@&usersig=%@&appscene=live",weakself.beginLiveModel.anchor.haoma,TRTCSDKAppID,weakself.appDelegate.userModel.user.haoma,TXTRCTUserSig]];

            
        }
    }];

    
//    [self.kit.pusher startPush:self.appDelegate.userModel.user.push_video_add];
    self.backScrollView.scrollEnabled = NO;
    
    
}



// 连麦结束后关闭推流，摄像头采集、麦克风采集
- (void)lianmaiEndPusher {
    isLianMai = NO;
    joined = NO;
    self.isPusher = NO;
    [self.kit stopPusher];
    self.backScrollView.scrollEnabled = YES;
    
    [self.txPlayer startLivePlay:[showinfo objectForKey:@"download_video_add"]];
    
}

- (void)touchesBeganClick {
    if (self.guanzhuView) {
        [self hideAttentionLive];
    }
    [self downTheBtn];
    [self showTheLove];//点亮爱心
    
    [self closeBtnAction:nil];
    [self chatViewClose:nil];
    if (self.moreView) {
        self.moreView.hidden=YES;
    }
}
@end

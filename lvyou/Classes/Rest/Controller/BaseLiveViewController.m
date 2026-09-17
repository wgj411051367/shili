//
//  LiveViewController.m
//  beibei
//
//  Created by 金颖 on 16/9/11.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseLiveViewController.h"
#import "PublicChatView.h"
#import "TotalPeopleTableViewCell.h"

@implementation BaseLiveViewController
@synthesize msgView,watchCollention,friendBtn,chatBack,messageBtn,friendTitle,bottom_url_height,bottom_url,game_url;

#pragma mark - 准备加载页面
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
   
}

#pragma mark - 已开始加载页面，可以在这一步向view中添加一个过渡动画
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
   
}

#pragma mark - 加载页面失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
   
}
/// 4.17
- (void)loadGameView:(NSString *)type andHeight:(CGFloat)height andGameUrl:(NSString *)url
{
    NSLog(@"gameurl====%@",url);

    if (gameWebView)
    {
        [gameWebView removeFromSuperview];
        [gameWebView.configuration.userContentController removeScriptMessageHandlerForName:@"jsCallNativeClose"];//移除按钮的唤起事件
        [gameWebView.configuration.userContentController removeScriptMessageHandlerForName:@"jsCallNative"];//移除按钮的唤起事件
        
        gameWebView = nil;
        [self bottomSwip:nil];//3.22切换游戏
    }
    bottomAreaHeight=[NSNumber numberWithFloat:height];
    /// 加载底部的游戏页面
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    // 3.13修改
    [configuration.userContentController addScriptMessageHandler:self name:@"jsCallNativeClose"];
    [configuration.userContentController addScriptMessageHandler:self name:@"jsCallNative"];
    gameWebView = [[CustomWKWebView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height) configuration:configuration];
    if ([type isEqualToString:@"bottom"])
    {
        gameType=type;
        gameWebView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
        gameWebView.bottomHeight=0;
//        self.upBtn.hidden=NO;
        //8.14游戏页面跳转进来不显示upbtn按钮
        if (self.gamePush==YES)
        {
            self.upBtn.hidden=YES;
        }
    }
    else if ([type isEqualToString:@"fullscreen"])
    {
        gameType=type;
        gameWebView.frame=CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        // 创建btn
        UIButton *moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame=CGRectMake(20, SCREEN_HEIGHT-40, 31, 31);
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"icon_user_live_more_top"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [gameWebView addSubview:moreBtn];
        gameWebView.bottomHeight=0;
        if(![userInfoModel.id isEqualToString:showerUserid])//观众
        {
             [self showFullGame];
        }
    }
    else if ([type isEqualToString:@"fullscreen_overlay"])
    {
        gameType=type;
        gameWebView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        gameWebView.bottomHeight=[NSNumber numberWithDouble:height];//只有overlay游戏不等于0
//        self.upBtn.hidden=NO;
        //8.14游戏页面跳转进来不显示upbtn按钮
        if (self.gamePush==YES)
        {
            self.upBtn.hidden=YES;
        }
    }
    giftAndGameSelected = YES;
     gameWebView.backgroundColor=[UIColor clearColor];
    /// opaque 不透明的
    [gameWebView setOpaque:NO];
     gameWebView.userInteractionEnabled=YES;
     gameWebView.allowsBackForwardNavigationGestures = YES;
    [gameWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
     gameWebView.navigationDelegate=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self againloadPlayer];
    });
    
    self.leftSwipGestureRecognizer.enabled = NO;
    self.rightSwipGestureRecognizer.enabled = NO;
    
    if (@available(ios 11.0,*)) //2018.9.6 wkwebview适配iphoneX
    {
        gameWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}



//2017.6.22 白屏
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0));
{
    if (webView==gameWebView)
    {
        [gameWebView reload];
    }
}

//在web页监听js
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //此处的url是web页中获取到的 需要对它进行判断
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    /// 包含
    if ([url containsString:@"loadComplete"])
    {
        if (!isSetPkTime) {
            //7.17
            [gameWebView evaluateJavaScript:[NSString stringWithFormat:@"setTime(%0.f)",pkdaojishi] completionHandler:nil];
            isSetPkTime = YES;
        }
        
        if ([gameType isEqualToString:@"fullscreen"])
        {
            [self showFullGame];
            /// 引导图片
            [self.liveShowView addSubview:backimages];
            [self countTimer];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    //3.23 更新余额
    else if ([url containsString:@"jscallnative_refresh_balance"])
    {
        NSArray *tmpArr=[url componentsSeparatedByString:@"-"];
        NSString *balanceStr=tmpArr[[tmpArr count]-1];
        [self updateSelfBalance:[NSString stringWithFormat:@"%d",[balanceStr intValue]] andSendid:SharedAppDelegate.userModel.user.id];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([url containsString:@"jscallnative_pay"])
    {
        [self rechargeBtnAction];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([url containsString:@"jscallnative_openurl_"])
    {
        //7.24 游戏路单
        NSArray *tmpArr=[url componentsSeparatedByString:@"jscallnative_openurl_"];
        NSString *webUrl=tmpArr[[tmpArr count]-1];
        [self pushGameWebview:webUrl];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
- (void)pushGameWebview:(NSString *)url
{
}
- (NSTimer *)countTimer
{
    if (!hideTimer) {
        /// 2.9
        hideTimer = [NSTimer pltScheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hide) userInfo:nil];
    }
    return hideTimer;
}

- (void)hide
{
    [backimages removeFromSuperview];
    backimages=nil;
}
- (void)hideBtn
{
    self.msgView.hidden=YES;
    self.chatBtn.hidden = YES;
    self.reviewBtn.hidden = YES;
    self.shareBtn.hidden=YES;
    self.moreBtn.hidden=YES;
    self.upBtn.hidden=YES;
    self.guiZuViewInLive.hidden=YES;
    self.shouHuBtn.hidden=YES;
    self.headBackImage.hidden=YES;
    self.zhenzhuCountView.hidden = YES;
    self.ticket.hidden = YES;
    self.watchCollention.hidden=YES;
    self.account.hidden=NO;
}
- (void)showBtn
{
    self.headBackImage.hidden=NO;
    self.watchCollention.hidden=NO;
    self.msgView.hidden=NO;
    self.chatBtn.hidden = NO;
    if (self.gamePush==YES)
    {//游戏列表跳转过来的
        return;
    }
//    self.guiZuViewInLive.hidden=NO;
    self.upBtn.hidden=NO;
    self.zhenzhuCountView.hidden = NO;
    self.account.hidden=NO;
    self.ticket.hidden = NO;
    self.reviewBtn.hidden = NO;
    self.moreBtn.hidden=NO;
    if([WXApi isWXAppInstalled]||[WXApi isWXAppSupportApi])
            {
                self.shareBtn.hidden=NO;
                self.shareToWx.hidden=NO;
                self.shareToWxFriend.hidden=NO;
            }
}
#pragma mark - 显示所有控件
- (void)leftSwip:(UIGestureRecognizer *)gestureRecognizer
{

    if (self.chatPush==YES) {
        return;
    }
    isClearPing = NO;
    if(gestureRecognizer!=nil){
        CGPoint pt=[gestureRecognizer locationInView:self.view];
        CGRect rect=self.watchCollention.frame;
        if(pt.y<=rect.size.height+28){//28是写死的距离顶部的高度
            return;
        }
    }
    if([gameType isEqualToString:@"fullscreen"]){
        [self showFullGame];
        return;
    }
    if(self.liveShowLeft.constant!=0)//显示状态
    {
        [UIView animateWithDuration:0.2f animations:^{
            self.liveShowLeft.constant=0;
            if (_flyBackView) {
                self.flyBackView.frame=CGRectMake(15, self.zhenzhuCountView.frame.size.height+self.zhenzhuCountView.frame.origin.y+7, SCREEN_WIDTH-30, 25);
            }
            [self.view layoutIfNeeded];
        }];
    }
//    switch (LiveBannerType) {
//        case NSDataLiveBannerTypeON:
//            if (self.chatPush==NO&&self.gamePush==NO){
//             [self flyViewAnimation];//10.25飞屏公告
//            }
//            break;
//        default:
//            break;
//    }
}

-(void)showFullGame{
    [UIView animateWithDuration:0.2f animations:^{
        gameWebView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    [self hideBtn];
}
-(void)hideFullGame{
    [UIView animateWithDuration:0.2f animations:^{
        gameWebView.frame=CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    [self showBtn];
}
#pragma mark ----清屏
-(void)rightSwip:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.chatPush==YES) {
        return;
    }
    isClearPing = YES;
    NSLog(@"一键清屏");
    if([gameType isEqualToString:@"fullscreen"]){//隐藏游戏
        // 8.31添加判断 因为斗地主游戏右划选牌的时候会触发手势事件
        if (gestureRecognizer!=nil)
        {
            CGPoint pt=[gestureRecognizer locationInView:self.view];
            CGRect rect=self.ChatManageView.frame;
            if(pt.y>=rect.size.height*2){//rect.size.height*2 ==400  //pt.y =438
                
                return;
            }
        }
        [self hideFullGame];
        return;
    }
    if(self.liveShowLeft.constant==0){
        [UIView animateWithDuration:0.2f animations:^{
            self.liveShowLeft.constant=SCREEN_WIDTH;
            if (_flyBackView) {
                self.flyBackView.frame=CGRectMake(15+SCREEN_WIDTH, self.zhenzhuCountView.frame.size.height+self.zhenzhuCountView.frame.origin.y+7, SCREEN_WIDTH-30, 25);
            }
            [self.view layoutIfNeeded];
        }];
    }
}
//上划 显示送礼或游戏
- (void)topSwip:(UIGestureRecognizer *)gestureRecognizer
{
        self.upBtn.selected=NO;
        if(giftAndGameSelected && ![gameType isEqualToString:@"fullscreen"]&& gameType!=nil){//目前显示的是半屏和覆盖游戏
            [UIView animateWithDuration:0.2f animations:^{
                if(![gameType isEqualToString:@"fullscreen"] || gameWebView.frame.origin.x!=0){
                        gameWebView.frame=CGRectMake(0, SCREEN_HEIGHT-gameWebView.frame.size.height, gameWebView.frame.size.width, gameWebView.frame.size.height);
                }
                [self.view layoutIfNeeded];
            }];
        }
}
//下划 隐藏送礼或游戏
- (void)bottomSwip:(UIGestureRecognizer *)gestureRecognizer
{
//    if(self.chatViewBottom.constant!=0){
        [UIView animateWithDuration:0.2f animations:^{
             self.chatViewBottom.constant=0;
//                balanceUpdate=NO;//1.12 礼物页面出现的时候
//             }
             if(gameWebView && ![gameType isEqualToString:@"fullscreen"]){
                gameWebView.frame=CGRectMake(0, SCREEN_HEIGHT, gameWebView.frame.size.width, gameWebView.frame.size.height);
             }
             if (SCREEN_HEIGHT>=812.0)//2018.9.6 适配iphonex的游戏高度页面
             {
                self.btnBottom.constant=20;
             }
             self.upBtn.selected=YES;
             [self.view layoutIfNeeded];
            giftAndGameSelected = NO;
            gameType = nil;
        }];
//    }
}

/// 按钮点击事件响应
- (void)moreClick
{
    
}
//点击隐藏键盘
- (void)singleTap
{   /// 移除引导页
    if (isExist) {
        [backimages removeFromSuperview];
        isExist=NO;
    }
}
- (IBAction)exitBtnAction:(UIButton *)sender
{
    
}
#pragma mark - 退出直播
- (void)exitUserLive
{

}
#pragma mark - 设置手势
- (void)createGestureRecognizer
{
    /// 2.7 设置手势
    self.leftSwipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwip:)];
    self.leftSwipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.leftSwipGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:self.leftSwipGestureRecognizer];
    
    self.rightSwipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwip:)];
    self.rightSwipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    self.rightSwipGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:self.rightSwipGestureRecognizer];
    
}
// 手势的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"WKContentView")] || [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"WKScrollView")]) {
        return YES;
    }
    return NO;
}
#pragma mark - View从superView中移除时
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 显示导航条
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 隐藏导航条
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if(gameWebView){
        //7.17
        [gameWebView evaluateJavaScript:@"refreshBalanceFromNative()" completionHandler:nil];
        //7.18 回来之后刷新一下游戏的webview
        [gameWebView reload];
    }
    isExist=YES;
    if (backimages==nil){
        backimages =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backimages.image=[UIImage imageNamed:@"guidePage"];
    }
    //1.12 更新自己的币 5.16修改
    if (balanceUpdate==YES)
    {
        [self updateBalance];
    }
    if (self.chatPush==NO&&self.gamePush==NO) {
                [self flyViewAnimation];//10.25飞屏公告
            }
}
- (void)updateBalance
{
    [[RootHttpHelper httpHelper] basicGETURL2:[NSString stringWithFormat:@"%@%@/%@",DATAAPI,APIVersion,users_info] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        NSError *err = nil;
        if ([successData[@"api_code"] integerValue]==200)
        {
            UserInfoModel* userInfoModel = [[UserInfoModel alloc] initWithDictionary:successData error:&err];
            SharedAppDelegate.userModel.user.balance=userInfoModel.balance;
            [self updateSelfBalance:userInfoModel.balance andSendid:self.appDelegate.userModel.user.id];
        }
    }];
}

#pragma mark 加载游戏
-(void)loadGame{
 
    NSLog(@"height====%@",self.bottom_url_height);
    if (![self isBlankString:self.bottom_url])//9.6 修改
    {
        [self loadGameView:@"bottom" andHeight:SCREEN_WIDTH*[self.bottom_url_height floatValue] andGameUrl:self.bottom_url];
        [self topSwip:nil];
        giftAndGameSelected=NO;
    }
}

//- (void)startAnimation
//{
//    [UIView beginAnimations:@"Notice" context:NULL];
//    [UIView setAnimationDuration:30.0f];
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    [UIView setAnimationRepeatAutoreverses:NO];
//    [UIView setAnimationRepeatCount:0];
//    CGRect frame = self.noticLab.frame;
//    frame.origin.x = -frame.size.width;
//    self.noticLab.frame = frame;
//    [UIView commitAnimations];
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 私信入口下线：隐藏直播房内的「好友 / 私信」入口按钮（聊天代码保留，用户点不到）
    self.friendBtn.hidden = YES;
    self.messageBtn.hidden = YES;

    int wBili = 1280.0/720 * SCREEN_WIDTH;
    int hBili = 720.0/1280 * SCREEN_HEIGHT;
    float h = (hBili == SCREEN_WIDTH)?SCREEN_HEIGHT:wBili;
    float y = (hBili == SCREEN_WIDTH)?0:(SCREEN_HEIGHT-h)/2;
    self.pk3ViewHeight.constant = h/2;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.appDelegate.isWinningMusicOFF = isWinningMusicOFF = [[defaults objectForKey:@"isWinningMusicOFF"] boolValue];
    
    //2018.4.20 禁止手机休眠
    if (!self.appDelegate.winningSFMArray) {
        self.appDelegate.winningSFMArray = [NSMutableArray array];
    }
    [self.appDelegate.winningSFMArray removeAllObjects];
    
    if (!self.appDelegate.winningSFMArray2) {
        self.appDelegate.winningSFMArray2 = [NSMutableArray array];
    }
    [self.appDelegate.winningSFMArray2 removeAllObjects];
    
    if (!self.appDelegate.otherSFMArray) {
        self.appDelegate.otherSFMArray = [NSMutableArray array];
    }
    [self.appDelegate.otherSFMArray removeAllObjects];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    sendUserId = @"";
    sendUserName = @"";
    self.isHiddenCar = YES;
    isClearPing = NO;
    self.liveTopHeight.constant = iphoneX?44:25;
    self.pkBgTopImgHeight.constant = iphoneX?-143:-124;
    self.messageTopHeight.constant = 40;
    
//    noice = [[NSUserDefaults standardUserDefaults]objectForKey:@"notice"];
//
//    if (![self isBlankString:noice]) {
//        self.noticView.hidden = NO;
//    }
    
//    [self flyViewAnimation];
    
    if (!roadpointsArr) {
        roadpointsArr = [NSMutableArray array];
    }
    _liveShowView.tag=9999;
    isBottomUp=YES;   //默认是向下的箭头
    isVideoOn=YES;//默认是有视频的
    pushToRedBag=NO;//默认不跳转红包页面
    balanceUpdate=NO;//开始不更新
    //7.20
    second = 30;//倒计时
    //键盘标示符
    isComm = NO;
    //评论框起始位置
    self.chatText.tintColor = colorHead;
    self.toolBar.transform = CGAffineTransformMakeTranslation(0, 84);
    self.sengGiftView.transform = CGAffineTransformMakeTranslation(0, 44);
    self.sendGiftTextView.delegate = self;
    [self.sendBtn setBackgroundColor:colorHead];
    //隐藏分享View
    self.shareView.hidden = YES;
    self.shareView.transform = CGAffineTransformMakeTranslation(0, 195);
    //弹幕标示符
    isBullet = NO;
    isDianZan = NO;
    //默认没有选择礼物
    giftSign = NSDataLiveGiftSignTypeNone;
    //观众数组
    if(viewers ==nil)
    {
        viewers = [NSMutableArray array];
    }
    if(topUser == nil) {
        topUser = [NSMutableArray array];
    }
    if (peopleuseridArr==nil) {
        peopleuseridArr= [NSMutableArray array];
    }
    sendGiftNum = @"1";
    LianSongNum = @"1";
    self.attach=0;
    heartSize = 36;
    //普通聊天弹幕Model
    grounderFPModel = [[GrounderModel alloc] init];
    //   喇叭聊天弹幕
    grounderChatModel = [[GrounderModel alloc] init];
    // 隐藏观众管理View
    self.manageView.transform = CGAffineTransformMakeTranslation(0, 260);
    self.manageView.hidden = YES;
    // 红包View
    
    self.redPackView.transform = CGAffineTransformMakeScale(0.35, 0.35);
    self.redPackView.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.redPackViewRight.constant = 16;
    });
    msgArr=[NSMutableArray array];
    removeTimer=[NSTimer pltScheduledTimerWithTimeInterval:1.1 target:self selector:@selector(insertMessage) userInfo:nil];
    //送礼按钮是否被选中
    giftAndGameSelected=NO;
    //创建手势
    [self createGestureRecognizer];
    
    //设置弹出框
    if(theTitles == nil)
    {
        theTitles = [NSMutableArray array];
    }
    [theTitles addObject:@"聊天"];
    [theTitles addObject:@"退出"];

    if(chatArr == nil)
    {
        chatArr = [NSMutableArray array];
    }
    [chatArr addObject:@"公聊"];
    [chatArr addObject:@"弹幕"];
    [chatArr addObject:@"喇叭"];
    [chatArr addObject:@"传送门"];
    //全服红包的数组
    hongBaoArray =[[NSMutableArray alloc] initWithCapacity:0];
    
    __weak BaseLiveViewController *weakSelf = self;
    self.msgView.delegate=self;
    self.msgView.block= ^(YYTCShowLiveMsg *msg){
        [weakSelf showInfoFromChat:msg];
    };
    isUserListLoading=NO;
    showtime=1.0;

    
    //            self.guiZuViewInLive.hidden=NO;//有贵族
    [self giftNumberList];

    // Do any additional setup after loading the view.
    giftViews=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getmsg:) name:@"GETMSG" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playSFMAnimation) name:@"playSFMAnimation" object:nil];
    self.chatText.placeholder = @"说点什么吧";
    
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"说点什么吧" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:11.0f]}];
    self.chatText.attributedPlaceholder = placeholderString;
    ///3.30 改变placeholder字体大小
//    [self.chatText setValue:[UIFont boldSystemFontOfSize:11.0f] forKeyPath:@"_placeholderLabel.font"];
    self.chatText.returnKeyType=UIReturnKeySend;
    self.chatText.delegate=self;
    
    self.friendListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH, 278+30+200) style:UITableViewStyleGrouped];
    self.friendListTableView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.friendListTableView.delegate = self;
    self.friendListTableView.dataSource = self;
    self.friendListTableView.separatorStyle = UITableViewScrollPositionNone;
    [self setupRefresh];
    //3.7
    if (SCREEN_HEIGHT>=812.0)
    {
        self.btnBottom.constant=20;
    }
    else
    {
        self.btnBottom.constant=0;
    }
    [self createCloseLianMai];
    self.shareBtn.hidden=NO;
    
    if (!taskView) {
        taskView = [[NSBundle mainBundle] loadNibNamed:@"TaskLiveView" owner:self options:nil].firstObject;
        taskView.frame = CGRectMake(0, 26, 100, 106-26);
        taskView.backgroundColor = [UIColor clearColor];
        [self.taskBGView addSubview:taskView];
    }
    
    // 聊天记录
    if (!self.chatRecordView) {
        self.chatRecordView = [[NSBundle mainBundle] loadNibNamed:@"ChatRecordView" owner:nil options:nil].firstObject;
        self.chatRecordView.closeBtnClick = ^{
            [weakSelf dissmissChatRecordView];
        };
        self.chatRecordView.chatRecordMessageView.block= ^(YYTCShowLiveMsg *msg){
            [weakSelf showInfoFromChat:msg];
        };
        [self.liveShowView addSubview:self.chatRecordView];
        self.chatRecordView.frame = CGRectMake(0, 129+NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-129-NavigationBar_HEIGHT);
        self.chatRecordView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT-129-NavigationBar_HEIGHT);
        self.chatRecordView.hidden = 0;
    }
    
    liansongBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [liansongBtn setFrame:CGRectMake(SCREEN_WIDTH-86*ScreenBiLi, SCREEN_HEIGHT-106*ScreenBiLi, 86*ScreenBiLi, 86*ScreenBiLi)];
    liansongBtn.layer.cornerRadius=43*ScreenBiLi;
    liansongBtn.layer.masksToBounds=YES;
    [liansongBtn setBackgroundColor:[UIColor colorWithHex:0x5393FE]];
//    [liansongBtn setBackgroundImage:[UIImage imageNamed:@"icon_live_liansong"] forState:UIControlStateNormal];
    [self.liveShowView addSubview:liansongBtn];
    [liansongBtn addTarget:self action:@selector(sendBtnClicked1) forControlEvents:UIControlEventTouchUpInside];
    [liansongBtn setTitle:@"30连送" forState:UIControlStateNormal];
    [liansongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    liansongBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    liansongBtn.hidden = YES;
    
    [liansongBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)]];
    
    [self setViewBackColor];
    
    
    CGFloat x = -10;
    NSLog(@"%@",NSStringFromCGRect(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)));
    
//    if (IS_IPHONE_7P) {
//        x = 8;
//    } else if (IS_IPHONE_6) {
//        x = 10;
//    }
    
    CGFloat bigWidth = (SCREEN_WIDTH-(x*2))/4*3;
    CGFloat bigHeight = bigWidth*2;
    
    CGFloat smallWidth = (SCREEN_WIDTH-(x*2))/4;
    CGFloat smallHeight = bigHeight/4.0;
    
    
//    if (IS_IPHONE_7P || IS_IPHONE_6) {
//        y = fabs(((SCREEN_HEIGHT - bigHeight)/2) - (38+self.btnBottom.constant));
//    }
    CGFloat _y = (SCREEN_HEIGHT - bigHeight)/2+48;
    
    self.appDelegate.micRect = CGRectMake(0, 0, smallWidth, smallHeight);
    
    CGRect frame_0 = CGRectMake(bigWidth+x, _y, smallWidth, smallHeight);
    CGRect frame_1 = CGRectMake(bigWidth+x, frame_0.origin.y+smallHeight, smallWidth, smallHeight);
    CGRect frame_2 = CGRectMake(bigWidth+x, frame_1.origin.y+smallHeight, smallWidth, smallHeight);
    CGRect frame_3 = CGRectMake(bigWidth+x, frame_2.origin.y+smallHeight, smallWidth, smallHeight);
    CGRect frame_4 = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    NSLog(@"remoteLayoutlocalRect:%@",NSStringFromCGRect(frame_4));
    NSLog(@"remoteLayout1:%@",NSStringFromCGRect(frame_1));
    NSLog(@"remoteLayoutview:%@",NSStringFromCGRect(self.fangzhuView.frame));
    //self.fangzhuViewHeight.constant = SCREEN_HEIGHT;
    
    self.avatar_0 = [[RoomAvatarView alloc] initWithFrame:frame_0];
    
    self.avatar_0.hidden = YES;
    
    [self.fangzhuView addSubview:self.avatar_0];
    
    normalAvatarArr = @[self.avatar_0];
    
    _avatarFrameArr = @[[NSValue valueWithCGRect:frame_0]];
    
    if (!_avatarOnMicArr) {
        _avatarOnMicArr = [NSMutableArray array];
    }
    
}


- (void)setViewBackColor
{
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.startPoint = CGPointMake(0, 0); //渐变色起始位置
    self.gradientLayer.endPoint = CGPointMake(0, 0.2); //渐变色终止位置
    self.gradientLayer.colors = @[(__bridge id)[UIColor.clearColor colorWithAlphaComponent:0].CGColor, (__bridge id)
     [UIColor.clearColor colorWithAlphaComponent:1.0].CGColor];
    self.gradientLayer.locations = @[@(0), @(1.0)]; // 对应colors的alpha值
    self.gradientLayer.rasterizationScale = UIScreen.mainScreen.scale;
    
    ///  添加蒙层效果的图层
    
    self.ChatManageView.backgroundColor = UIColor.clearColor;
    
    self.ChatManageView.layer.mask = self.gradientLayer;
    NSLog(@"%@",NSStringFromCGRect(self.ChatManageView.frame));
//    self.ChatManageView.frame = CGRectMake(0, self.pkLeftView.y+self.pkLeftView.height-10, SCREEN_WIDTH, SCREEN_HEIGHT-(self.pkLeftView.y+self.pkLeftView.height));
    NSLog(@"%@",NSStringFromCGRect(self.ChatManageView.frame));
    self.gradientLayer.frame = self.ChatManageView.bounds;
    
}

- (void)dissmissChatRecordView {
    [UIView animateWithDuration:0.3 animations:^{
        self.chatRecordView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT-129-NavigationBar_HEIGHT);
    } completion:^(BOOL finished) {
        self.chatRecordView.hidden = YES;
    }];
}

- (void)createCloseLianMai
{
    self.lianMaiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.lianMaiBtn.frame=CGRectMake(0*ScreenBiLi, 143, 60*ScreenBiLi, 30*ScreenBiLi);
    self.lianMaiBtn.backgroundColor=RGBACOLOR(0, 0, 0, 0.7);
    [self.lianMaiBtn setTitle:@"断 开" forState:0];
    [self.lianMaiBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.lianMaiBtn addTarget:self action:@selector(cancelInteactWithHost) forControlEvents:UIControlEventTouchUpInside];
    self.lianMaiBtn.hidden=YES;
    [self.liveShowView addSubview:self.lianMaiBtn];
    [self.liveShowView bringSubviewToFront:self.lianMaiBtn];
}
- (void)cancelInteactWithHost
{
}
#pragma mark - 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.chatText) {
        [self.chatText resignFirstResponder];
        self.chatText.text = @"";
    }
    if (self.shareView) {
        [UIView animateWithDuration:0.2 animations:^{
            self.shareView.hidden = YES;
            self.shareView.transform = CGAffineTransformMakeTranslation(0, 195);
        }];
    }
    if (self.gameMoreView!=nil) {
        self.gameMoreView.hidden=YES;
    }
    //    移除更多按钮创建的view
    if (self.moreView!=nil) {
        self.moreView.hidden=YES;
    }
    // 贵族view
    if (self.guizuView) {
        [self.guizuView removeFromSuperview];
    }
    
    if (totalPeopleView) {
        [totalPeopleView dismissView];
    }
    
}
#pragma mark - 右下角按钮点击事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tempText=textField;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if ([textField isEqual:self.sendGiftTextView]) {
        NSLog(@"%@",textField.text);
    }
}

//点击聊天区域显示用户详情
-(void)showInfoFromChat:(YYTCShowLiveMsg *)msg{
    if (msg.ishide) {
        isScret=@"hide";
    }
    else{
        isScret=@"show";
    }
    if (msg.jump_url) {
        if (![msg.jump_url isEqualToString:@""]) {
            NSString *url = msg.jump_url;
            if ([url containsString:@"HBF"]) {
                // 全服红包跳房间
                NSArray *tempArr =[url componentsSeparatedByString:@",|"];
                
                if (roomnumber!=self.appDelegate.userModel.user.haoma) {
                    //不是主播就跳转到红包房间
                    [self exitUserLive];
                    //7.20 跳转房间时传房间号
                    [self.appDelegate accrssLiveRoom:tempArr[1]];
                }
            }
            if ([url isEqualToString:@"recharge"]) {
                // 跳充值
                [self rechargeBtnAction];
            }
            return;
        }
    }
    userInfoModel=[[UserInfoModel alloc] init];
    userInfoModel.id =msg.customElemModel.s_uid;
    if (userInfoModel.id==nil)
    {
        return;
    }
    else
    {
        if (![userInfoModel.id isEqualToString:showerUserid]) {//点击的是观众
            self.totalheight.constant=300;
            self.yinxiangBtn1.hidden=YES;
            self.yinxiangBtn2.hidden=YES;
            self.yinxiangBtn3.hidden=YES;
            self.addyinxiangBtn.hidden=YES;
        }
        else {//点击的是主播
            self.totalheight.constant=364;
            self.addyinxiangBtn.hidden=NO;
        }
        [self showManageView:userInfoModel.id orNumber:nil];
    }
}

 //聊天地址
-(void)doConnect:(id)_delegate andUrl:(NSString *)url {
    socket = [[SLLiveSocket alloc] init:url andParams:nil];
    socket.delegate = _delegate;
}

-(void)closeConnect{
    [socket disconnect];
    socket.delegate=nil;
    socket=nil;
    NSLog(@"聊天服务器断开了......");
}

//禁言
-(void)switchchatBtnClicked:(int)kickoutUserid
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:[NSMutableString stringWithFormat:@"%d",kickoutUserid] forKey:@"userid"];
    [socket invoke:@"switchChat" withArgs:args];
}
//设置管理员
-(void)setAdminBtnClicked:(int)kickoutUserid
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:[NSMutableString stringWithFormat:@"setadmin"] forKey:@"action"];
    [args setObject:[NSMutableString stringWithFormat:@"%d",kickoutUserid] forKey:@"currentOptUid"];
    [socket invoke:@"setadmin" withArgs:args];
}
//踢人
-(void)kickoutBtnClicked:(int)kickoutUserid
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:[NSMutableString stringWithFormat:@"%d",kickoutUserid] forKey:@"userid"];
    [socket invoke:@"kickOut" withArgs:args];
    
}
//添加ping
- (void)addPingAction
{
    NSMutableDictionary * params=[NSMutableDictionary dictionary];
    [params setObject:@"ping" forKey:@"action2"];
    [socket invoke:@"ping" withArgs:params];
}
//2018.3.2 将时间转换成00:00格式
- (NSString *)formatPlayTimer:(NSTimeInterval)duration
{
    int minute = 0,secend = duration;
    minute = (secend % 3600)/60;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
}
//pk的倒计时功能
- (void)pktimerreduce
{
    if (pkdaojishi==0) {
        //连麦结束 pk条3s之后移除
        [self removeAllTimer];
        [self finishPKAction];
        return;
    }
    pkdaojishi--;
//    if ((pkdaojishiTotal - pkdaojishi) >= 60 ) {
//        self.finishBtn.hidden = YES;
//    }
    pktimerlab.text=[NSString stringWithFormat:@"%@", [self formatPlayTimer:pkdaojishi]];
    [self userLoseConnect];//2018.8.15
}
- (void)userLoseConnect
{
    __weak typeof(self)weakself =self;
    self.kit.onOffLine = ^(int status) {
        weakself.pkOffLine=YES;
        //[weakself finishPKAction];
        [weakself PKOverAction];
    };
    self.kit.onUserJoin  = ^(int status) {
         weakself.pkOffLine=NO;
    };
    self.kit.onCallStop = ^(int status){

        [weakself PKOverAction];
    };
}
//主动断开pk 或 pk时间到发pk_finish
- (void)finishPKAction
{
    NSMutableDictionary * params=[NSMutableDictionary dictionary];
    [params setObject:@"pk_finish" forKey:@"action2"];
    [socket invoke:@"pk_finish" withArgs:params];
}
//惩罚时间到发pk_over
- (void)PKOverAction
{
    if (isLianMai) {
        NSMutableDictionary * params=[NSMutableDictionary dictionary];
        [params setObject:@"lianmai_end" forKey:@"action"];
        [socket invoke:@"micOpt" withArgs:params];
        
        self.kit.txKit.twoVideo = 0;
        self.kit.txKit.threeVideo = 0;
        [self.kit removePushStream];
        self.fangzhuView.hidden = YES;
        self.kit.txKit.clientRole = TRTCRoleAnchor;
        [self.kit leaveChannel];

        joined=NO;
        
    } else {
        self.pkLeftView.hidden = YES;
        self.pkSofaBGImg.hidden = YES;
        self.pkRightView.hidden = YES;
        [self removeDelayTime];//移除pk条界面
        isFaQiRen = NO;
        isSetPkTime = NO;
        self.pkProphetBtn.hidden = YES;
        self.pkBgTopImg.hidden = YES;
        self.pkBgBottomImg.hidden = YES;
        [self removePkUserView];// 移除PK对方用户名字
        self.zhuboPKView.hidden = YES;
//        self.pkUserCount = 0;
        if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
            self.kit.txKit.twoVideo = 0;
            self.kit.txKit.threeVideo = 0;

            self.hostAnchorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            // 结束旁路推流，以防止产生额外的费用
//            [self.kit removePushStream];
        } else {
            [self.playerView setFrame:self.view.bounds];
        }
        self.kit.isPK = NO;
        self.kit.txKit.isPK = NO;
    }
    NSMutableDictionary * params=[NSMutableDictionary dictionary];
    [params setObject:@"pk_over" forKey:@"action2"];
    [socket invoke:@"pk_over" withArgs:params];
}
//创建倒计时
- (void)createDaoJiShiWithTime:(NSString *)time
{
    if (pkbackimg) {
        [pkbackimg removeFromSuperview];
         pkbackimg=nil;
    }
    pkbackimg=[[UIImageView alloc] init];
    pkbackimg.hidden = YES;
            pkbackimg.frame=CGRectMake((SCREEN_WIDTH-81*ScreenBiLi)/2, self.pkview.frame.origin.y-56*ScreenBiLi-5*ScreenBiLi, 81*ScreenBiLi, 56*ScreenBiLi);
    pkbackimg.image=[UIImage imageNamed:@"pktimer"];
    pkdaojishi=[time intValue];
    pktimerlab=[[UILabel alloc] initWithFrame:CGRectMake(0, pkbackimg.frame.size.height/4.6, pkbackimg.frame.size.width, pkbackimg.frame.size.height)];
    pktimerlab.textColor=[UIColor whiteColor];
    pktimerlab.font=[UIFont systemFontOfSize:13.0f weight:UIFontWeightMedium];
    pktimerlab.textAlignment=NSTextAlignmentCenter;
    [pkbackimg addSubview:pktimerlab];
//    [self.liveShowView addSubview:pkbackimg];
//    [self.liveShowView bringSubviewToFront:pkbackimg];
    [self.liveShowView insertSubview:pkbackimg atIndex:4];
//    [self.pkBgBottomImg bringSubviewToFront:pkbackimg];
//    [pkbackimg sendSubviewToBack:self.ChatManageView];
    
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0, -332/2);
    pkbackimg.transform = CGAffineTransformScale(translation,0.5, 0.5);
//    CGAffineTransform translation = CGAffineTransformMakeTranslation(0, -332/2);
//    pktimerlab.transform = CGAffineTransformScale(translation,0.5, 0.5);

    
    pkEndLeftImg = [[UIImageView alloc] init];
    pkEndLeftImg.frame = CGRectMake((SCREEN_WIDTH/2-73*ScreenBiLi)/2, self.pkview.frame.origin.y-73*ScreenBiLi, 73*ScreenBiLi, 73*ScreenBiLi);
//    [self.liveShowView addSubview:pkEndLeftImg];
//    [self.liveShowView bringSubviewToFront:pkEndLeftImg];
//    [self.pkBgBottomImg bringSubviewToFront:pkEndLeftImg];
    [self.liveShowView insertSubview:pkEndLeftImg atIndex:5];
//    [pkEndLeftImg sendSubviewToBack:self.ChatManageView];
    
    
    
    pkEndRightImg = [[UIImageView alloc] init];
    pkEndRightImg.frame = CGRectMake(SCREEN_WIDTH - 73*ScreenBiLi - (SCREEN_WIDTH/2-73*ScreenBiLi)/2, self.pkview.frame.origin.y-73*ScreenBiLi, 73*ScreenBiLi, 73*ScreenBiLi);
//    [self.liveShowView addSubview:pkEndRightImg];
//    [self.liveShowView bringSubviewToFront:pkEndRightImg];
//    [self.pkBgBottomImg bringSubviewToFront:pkEndRightImg];
    [self.liveShowView insertSubview:pkEndRightImg atIndex:6];
//    [pkEndRightImg sendSubviewToBack:self.ChatManageView];
    
//    pkEndLeftImg.frame = CGRectMake((SCREEN_WIDTH/2-150.5*ScreenBiLi)/2, self.pkview.frame.origin.y-85*ScreenBiLi, 150.5*ScreenBiLi, 85*ScreenBiLi);
//    pkEndRightImg.frame = CGRectMake(SCREEN_WIDTH - 150.5*ScreenBiLi - (SCREEN_WIDTH/2-150.5*ScreenBiLi)/2, self.pkview.frame.origin.y-85*ScreenBiLi, 150.5*ScreenBiLi, 85*ScreenBiLi);
    
    [self pkAminationStart];
}

- (void)pkAminationStart {
    self.pkAminationLeftImg.hidden = NO;
    self.pkAmintaionRightImg.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pkAminationLeftImg.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH/2, 0);
        self.pkAmintaionRightImg.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH/2, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.pkAminationLeftImg.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH/2-20*ScreenBiLi, 0);
            self.pkAmintaionRightImg.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH/2+20*ScreenBiLi, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.pkAminationLeftImg.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH/2, 0);
                self.pkAmintaionRightImg.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH/2, 0);
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    pkbackimg.hidden = NO;
                    [UIView animateWithDuration:0.5 animations:^{
                        pkbackimg.transform = CGAffineTransformIdentity;
                        self.pkAminationLeftImg.transform = CGAffineTransformIdentity;
                        self.pkAmintaionRightImg.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        self.pkAminationLeftImg.hidden = YES;
                        self.pkAmintaionRightImg.hidden = YES;
                    }];
                });
                
            }];
        }];
    }];
}


//创建pk条
- (void)createPKViewWithFaQi:(NSString *)faqiren AndJieShou:(NSString *)jieshouren andTime:(NSString *)time withNumber:(int)number andPcOrNot:(BOOL)isPC
{
    //添加PK条  在主播端会开启连麦 添加一个倒计时的提示框
    [self removeAllView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (SharedAppDelegate.player.view) {
//            SharedAppDelegate.player.scalingMode = MPMovieScalingModeAspectFit;//竖屏
////            SharedAppDelegate.player.view.frame=[UIScreen mainScreen].bounds;
//        }
//    });
    if (isPC==YES)
    {
        self.pkview=[[PKView alloc] initWithFrame:CGRectMake(2*ScreenBiLi, SCREEN_HEIGHT/4-20*ScreenBiLi, SCREEN_WIDTH-4*ScreenBiLi, 20*ScreenBiLi) withzhubo:faqiren withguest:jieshouren withNumber:number];
    }
    else
    {
        self.pkview=[[PKView alloc] initWithFrame:CGRectMake(0,self.pkBgBottomImg.y-28*ScreenBiLi, SCREEN_WIDTH, 28*ScreenBiLi) withzhubo:faqiren withguest:jieshouren withNumber:number];//
                if (number == 1) {
                    self.pkSofaBGImg.image = [UIImage imageNamed:@"icon_pk_sofa_blue_bg"];
                    self.pkleftfirstbackimg.image = [UIImage imageNamed:@"firstinlive_blue_3"];
                    self.pkleftsecondbackimg.image = [UIImage imageNamed:@"firstinlive_blue_2"];
                    self.pkleftthirdbackimg.image = [UIImage imageNamed:@"firstinlive_blue_1"];
                    self.pkrightfirstbackimg.image = [UIImage imageNamed:@"firstinlive_red_1"];
                    self.pkrightsecondbackimg.image = [UIImage imageNamed:@"firstinlive_red_2"];
                    self.pkrightthirdbackimg.image = [UIImage imageNamed:@"firstinlive_red_3"];
                } else {
                    self.pkSofaBGImg.image = [UIImage imageNamed:@"icon_pk_sofa_red_bg"];
                    self.pkleftfirstbackimg.image = [UIImage imageNamed:@"firstinlive_red_3"];
                    self.pkleftsecondbackimg.image = [UIImage imageNamed:@"firstinlive_red_2"];
                    self.pkleftthirdbackimg.image = [UIImage imageNamed:@"firstinlive_red_1"];
                    self.pkrightfirstbackimg.image = [UIImage imageNamed:@"firstinlive_blue_1"];
                    self.pkrightsecondbackimg.image = [UIImage imageNamed:@"firstinlive_blue_2"];
                    self.pkrightthirdbackimg.image = [UIImage imageNamed:@"firstinlive_blue_3"];
                }
        //3.13 隐藏守护按钮
        self.shouHuBtn.hidden=YES;
    }
//    [self.liveShowView addSubview:self.pkview];
    [self.liveShowView insertSubview:self.pkview atIndex:6];
//    [self.liveShowView sendSubviewToBack:self.pkview];//pk条放在前边
//    [self.pkBgBottomImg sendSubviewToBack:self.pkview];
    [self createDaoJiShiWithTime:time];
     self.pkTimer = [NSTimer pltScheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pktimerreduce) userInfo:nil];
}
- (void)pk_endwith:(NSString *)win_usernumber
{
    if ([win_usernumber isEqualToString:roomnumber]) {
        if ([roomnumber isEqualToString:SharedAppDelegate.userModel.user.haoma]) {
            [self initFinishBtn];
            self.finishBtn.hidden = NO;
            self.finishBtn.frame=CGRectMake(SCREEN_WIDTH-53*ScreenBiLi, iphoneX?153:134, 48*ScreenBiLi, 24*ScreenBiLi);
        }
        
        //显示赢了
//        [self.pkview showPKResult:@"pkwinner"];
        [pkEndLeftImg setImage:[UIImage imageNamed:@"icon_pk_winner"]];
        [pkEndRightImg setImage:[UIImage imageNamed:@"icon_pk_loser"]];
        
    }
    else if([win_usernumber isEqualToString:@""]){
        if ([roomnumber isEqualToString:SharedAppDelegate.userModel.user.haoma]) {
            [self initFinishBtn];
            self.finishBtn.hidden = NO;
            self.finishBtn.frame=CGRectMake(SCREEN_WIDTH-53*ScreenBiLi, iphoneX?153:134, 48*ScreenBiLi, 24*ScreenBiLi);
        }
        //显示平
//        [self.pkview showPKResult:@"pkequal"];
        [pkEndLeftImg setImage:[UIImage imageNamed:@"icon_pk_equal"]];
        [pkEndRightImg setImage:[UIImage imageNamed:@"icon_pk_equal"]];
    }
    else{
        //显示输
//        [self.pkview showPKResult:@"pkloser"];
        [pkEndLeftImg setImage:[UIImage imageNamed:@"icon_pk_loser"]];
        [pkEndRightImg setImage:[UIImage imageNamed:@"icon_pk_winner"]];
    }
}
//PK结束之后延时2分钟
- (void)createPKEndTimer
{
    [self removeAllTimer];
    if (cf_daojishi>0) {
        pkendtime=cf_daojishi;
    }
    else{
        pkendtime=120;
    }
    pkbackimg.image=[UIImage imageNamed:@"pktimer_cf"];
    self.delayEndTimer = [NSTimer pltScheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pkendwithView) userInfo:nil];
}
- (void)pkendwithView
{
    if (pkendtime==0) {
        [self removeAllTimer];
        [self PKOverAction];//2018.12.21惩罚时间到发pk_over
        [self removeDelayTime];//倒计时到了之后移除pk
//        self.pkProphetBtn.hidden = YES;
        return;
    }
    [self userLoseConnect];//2018.8.15
    pkendtime--;
    pktimerlab.text=[NSString stringWithFormat:@"%@", [self formatPlayTimer:pkendtime]];
    if (pkdaojishi > 0) {
        if ((pkdaojishiTotal - pkdaojishi) >= 60 ) {
            self.finishBtn.hidden = YES;
        }
    }
    
}
- (void)removeDelayTime
{
    if (isPKing==YES)
    {
        isPKing=NO; //2018.8.27 移除当前正在pk的标记
        [self.kit leaveChannel];
        joined=NO;
    }
    [self removeAllView];
}
- (void)removeAllView
{
    [pkEndLeftImg removeFromSuperview];
    pkEndLeftImg = nil;
    
    [pkEndRightImg removeFromSuperview];
    pkEndRightImg = nil;
    if (self.finishBtn) {
        [self.finishBtn removeFromSuperview];
        self.finishBtn=nil;
    }
    if (pkbackimg) {
        [pkbackimg removeFromSuperview];//移除倒计时
        pkbackimg=nil;
    }
    
    if (self.pkview) {
        [self.pkview removeTheView];
    }
    
    if (self.pkUserView) {
        [self.pkUserView removeSubviews];
        [self.pkUserView removeFromSuperview];
        self.pkUserView = nil;
    }
    
    
    
    if (self.playerView) {
        self.playerView.frame=[UIScreen mainScreen].bounds;
    }
    
    if (self.kit) {
//        self.hostAnchorView.frame = [UIScreen mainScreen].bounds;
//        @try {
            if (joined==NO) {
//                [self.kit.preview removeObserver:self forKeyPath:@"frame"];
                self.hostAnchorView.frame = [UIScreen mainScreen].bounds;
            }
//        }
//        @catch (NSException *exception) {
//            
//        }
    }//1.29修改
    
    if (_maskView) {
        [_maskView removeFromSuperview];
        _maskView=nil;
    }
    [self removeAllTimer];
}
//移除pk和惩罚倒计时timer
- (void)removeAllTimer
{
    if (self.pkTimer!=nil) { //pk倒计时
        [self.pkTimer invalidate];
        self.pkTimer=nil;
    }
    if (self.delayEndTimer!=nil) {//惩罚倒计时
        [self.delayEndTimer invalidate];
        self.delayEndTimer=nil;
    }
}
//创建pk之后的断开按钮
- (void)initFinishBtn
{
    if(self.finishBtn)
    {
        [self.finishBtn removeFromSuperview];
         self.finishBtn=nil;
    }
    self.finishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.finishBtn.frame=CGRectMake(SCREEN_WIDTH-50*ScreenBiLi, self.zhuboPKView.y+12*ScreenBiLi, 48*ScreenBiLi, 24*ScreenBiLi);
    [self.finishBtn setImage:[UIImage imageNamed:@"icon_pk_stop"] forState:UIControlStateNormal];
    self.finishBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.finishBtn.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    [self.finishBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.finishBtn.layer.cornerRadius = 12*ScreenBiLi;
    self.finishBtn.layer.masksToBounds = YES;
//    self.finishBtn.backgroundColor=RGBACOLOR(0, 0, 0, 0.4);
    [self.finishBtn addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.liveShowView addSubview:self.finishBtn];
    [self.liveShowView bringSubviewToFront:self.finishBtn];
    
    
}

- (void)finishBtnAction
{
   //[self finishPKAction];
    
    [self PKOverAction];
}

- (void)removePkUserView {
    if (self.pkUserView) {
        [self.pkUserView removeSubviews];
        [self.pkUserView removeFromSuperview];
        self.pkUserView = nil;
    }
}
- (void)initpkUserView:(BOOL)isVoiceBtn andUserRoomnumber:(NSString *)userRoomNumber andName:(NSString *)name andThreeUserRoomnumber:(NSString *)userRoomNumberThree andThreeName:(NSString *)threeName andUseridTwo:(NSString *)useridTwo andUseridThree:(NSString *)useridThree {
    
    NSMutableArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"FollowArray"];
    
    if (self.pkUserView) {
        [self.pkUserView removeSubviews];
        [self.pkUserView removeFromSuperview];
        self.pkUserView = nil;
    }
    self.pkUserView = [[UIView alloc] init];
    self.pkUserView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
    self.pkUserView.layer.cornerRadius = 12*ScreenBiLi;
    self.pkUserView.layer.masksToBounds = YES;
    [self.liveShowView insertSubview:self.pkUserView belowSubview:bigAnimationView];

    [self.pkUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.liveShowView.mas_centerX).offset(5*ScreenBiLi);
        make.top.equalTo(self.pkBgTopImg.mas_bottom).offset(10*ScreenBiLi);
        make.height.equalTo(@(24*ScreenBiLi));
        make.right.lessThanOrEqualTo(@(-53*ScreenBiLi));
    }];
    
    
    self.pkNameLab = [[UILabel alloc] init];
    self.pkNameLab.text = name;
    self.pkNameLab.textColor = [UIColor whiteColor];
    self.pkNameLab.font = [UIFont systemFontOfSize:12];
    [self.pkUserView addSubview:self.pkNameLab];
    [self.pkNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pkUserView).offset(4);
        make.bottom.equalTo(self.pkUserView).offset(-4);
        make.left.equalTo(self.pkUserView).offset(6);
        if (isVoiceBtn) {
            make.right.equalTo(self.pkUserView).offset(-30);
        } else {
            if ([temp containsObject:userRoomNumber]) {
                make.right.equalTo(self.pkUserView).offset(-6);
            } else {
                make.right.equalTo(self.pkUserView).offset(-30);
            }
        }
    }];
    
    self.pkUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pkUserBtn.tag = [useridTwo integerValue];
    [self.pkUserBtn addTarget:self action:@selector(pkUserBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.pkUserView addSubview:self.pkUserBtn];
    [self.pkUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.pkUserView);
        make.right.equalTo(self.pkNameLab);
    }];
    if (isVoiceBtn) {
        currentMuteUserRoom = userRoomNumber;
        UIButton *pkVoiceBtn = [[UIButton alloc] init];
        pkVoiceBtn.tag = [userRoomNumber integerValue];
        [pkVoiceBtn setImage:[UIImage imageNamed:@"muteBtnOn"] forState:UIControlStateNormal];
        [pkVoiceBtn addTarget:self action:@selector(pkVoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.pkUserView addSubview:pkVoiceBtn];
        [pkVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.pkUserView);
            make.centerY.equalTo(self.pkUserView);
        }];
    } else {
        if (![temp containsObject:userRoomNumber]) {
            self.pkFollowBtn = [[UIButton alloc] init];
            self.pkFollowBtn.tag = [useridTwo integerValue];
            [self.pkFollowBtn setImage:[UIImage imageNamed:@"icon_pk_follow"] forState:UIControlStateNormal];
            [self.pkFollowBtn addTarget:self action:@selector(pkFollowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.pkUserView addSubview:self.pkFollowBtn];
            [self.pkFollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.pkUserView).offset(-3);
                make.centerY.equalTo(self.pkUserView);
            }];
        }
    }
}

- (void)pkFollowBtnAction:(UIButton *)sender {
    NSMutableDictionary *params =[NSMutableDictionary dictionaryWithDictionary:@{@"token":self.appDelegate.userModel.token,@"usernumber":[NSString stringWithFormat:@"%ld",sender.tag]}];
    
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:[NSString stringWithFormat:@"%@%@/follow/0",DATAAPI,@"v4"] andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
        if ([[successData objectForKey:@"api_code"] integerValue] == 200) {
            [self setFollowListIsRemove:NO andUserid:[NSString stringWithFormat:@"%ld",sender.tag]];
            self.pkFollowBtn.hidden = YES;
            [self.pkNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.pkUserView).offset(4);
                make.bottom.equalTo(self.pkUserView).offset(-4);
                make.left.equalTo(self.pkUserView).offset(6);
                make.right.equalTo(self.pkUserView).offset(-6);
            }];
        }
    }];
}

- (void)pkVoiceBtnAction:(UIButton *)sender {
    if (sender.selected) {//待更全面的测试
        if (isPKing) {
//            [self.kit.txKit.trtcCloud muteAllRemoteAudio:NO];
            if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
                // 拉流对方主播声音开
                [self.pkPlayer setPlayoutVolume:100];
            }
//            [self.kit.txKit.rtcEngine muteRemoteAudioStream:self.kit.joinid mute:NO];
            [sender setImage:[UIImage imageNamed:@"muteBtnOn"] forState:0];
        }
    }
    else{
        if (isPKing) {
//            [self.kit.txKit.trtcCloud muteAllRemoteAudio:YES];
            if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
                // 拉流对方主播声音开
                [self.pkPlayer setPlayoutVolume:0];
            }
//            [self.kit.txKit.rtcEngine muteRemoteAudioStream:self.kit.joinid mute:YES];
            [sender setImage:[UIImage imageNamed:@"muteBtnOff"] forState:0];
        }
    }
    sender.selected=!sender.selected;
}


- (void)pkUserBtnAction:(UIButton *)sender {
    if (self.manageView.hidden) {
        [self showManageView:[NSString stringWithFormat:@"%ld",sender.tag] orNumber:nil];
    }
}

- (void)addMessage:(YYTCShowLiveMsg*)msg
{
    [msgArr addObject:msg];
}
//插入一条消息
- (void)insertMessage   //2018.8.31修改
{
    if(msgArr.count==0){
        return;
    }
    NSMutableDictionary *needInsertMsgs=[NSMutableDictionary dictionary];
    long msgCount=msgArr.count;
    for (int i=0; i<msgCount; i++) {
        YYTCShowLiveMsg *currentMsg=msgArr[i];
        NSString *keyName=[NSString stringWithFormat:@"%@|%@|%@",currentMsg.customElemModel.r_id,currentMsg.customElemModel.s_uid,currentMsg.customElemModel.t_uid];
        YYTCShowLiveMsg *lastMsg=[needInsertMsgs objectForKey:keyName];
        if(lastMsg!=nil){//有这个条目，只需要修改数值
            NSInteger currentNum=[lastMsg.customElemModel.r_num intValue];
            NSInteger addNum=[currentMsg.customElemModel.r_num intValue];
            lastMsg.customElemModel.r_num=[NSString stringWithFormat:@"%ld",currentNum+addNum];
            [needInsertMsgs setObject:lastMsg forKey:keyName];
        }
        else{
            [needInsertMsgs setObject:currentMsg forKey:keyName];
        }
    }
    for (int i=0; i<msgCount; i++) {
        [msgArr removeObjectAtIndex:0];
    }
    NSEnumerator *enumerator = [needInsertMsgs keyEnumerator];
    for (NSObject *key in enumerator) {
        YYTCShowLiveMsg* msg=[needInsertMsgs objectForKey:key];
        msg.customElemModel.time=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
        [self.msgView insertTCShowMsg:msg andLeft:NO andisMsg:YES];
        if (self.chatRecordView) {
            [self.chatRecordView.chatRecordMessageView insertTCShowMsg:msg andLeft:YES andisMsg:YES];
        }
    }
}
//收到fms回调
-(void)resultReceived:(NSString *)method andParams:(NSDictionary *)args {

    NSError *error;
    if (_pushSmallVideo==NO) {
        if ([method isEqualToString:@"updateTopUser"]) {
            NSArray *arr=[args SafeObject:@"users"];
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            [topUser removeAllObjects];
            for (NSDictionary *info in arr) {
                UserInfoModel * infoModel = [[UserInfoModel alloc] init];
                infoModel.id=[NSString stringWithFormat:@"%@",[info objectForKey:@"userid"]];
                /// 2.14  用户的头像
                infoModel.avatar=[[ToolHelper toolHelper] realAvatarUrl:infoModel.id andUpdate:self.avatarUploadDate];
                infoModel.update_avatar_time=timeSp;
                infoModel.fans_num=@"0";
                infoModel.follow_num=@"0";
                infoModel.is_follow=@"0";
                infoModel.avatar_frame = [info objectForKey:@"avatar_frame"];
                [topUser addObject:infoModel];
            }
            [self reDrawUserList];
//            if (![arr isKindOfClass:[NSArray class]] || [arr isKindOfClass:[NSNull class]] || arr==NULL || arr==nil) {
//                arr = @[];
//            }
//            NSArray *backImgContrl=@[self.firstBgImg,self.secondBgImg,self.threeBgImg];
//            NSArray *avatarImgControl=@[self.firstAvatarImg,self.secondAvatarImg,self.threeAvatarImg,self.fourAvatarImg,self.fiveAvatarImg,self.sixAvatarImg,self.sevenAvatarImg,self.eightAvatarImg,self.nineAvatarImg,self.tenAvatarImg];
////            NSArray *avatarBtnControl=@[self.firstavatarbtn,self.secondavatarbtn,self.thirdavatarbtn,self.forthavatarbtn];
//            int xi=0;
//            self.firstAvatarImg.hidden=self.secondAvatarImg.hidden=self.threeAvatarImg.hidden=self.fourAvatarImg.hidden=self.fiveAvatarImg.hidden=YES;
            self.firstBgImg.hidden=self.secondBgImg.hidden=self.threeBgImg.hidden = YES;
//            for (NSDictionary *diction in arr) {
//                if (xi==9) {
//                    continue;
//                }
//                [peopleuseridArr addObject:diction];
//                NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
////                ((UIButton *)avatarBtnControl[xi]).tag=xi;
////                [((UIButton *)avatarBtnControl[xi])addTarget:self action:@selector(avatarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [avatarImgControl[xi] sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:[NSString stringWithFormat:@"%@",diction[@"userid"]] andUpdate:timeSp]]];
//                ((UIImageView *)avatarImgControl[xi]).hidden=NO;
//                if (xi>=3) {
//                    xi++;
//                    continue;
//                }
//                if ([diction[@"top3"] intValue]==0) {
//                    ((UIImageView *)backImgContrl[xi]).hidden=YES;
//                }
//                else if ([diction[@"top3"] intValue]==3) {
//                    ((UIImageView *)backImgContrl[xi]).image=[UIImage imageNamed:@"icon_live_room_first"];
//                    ((UIImageView *)backImgContrl[xi]).hidden=NO;
//                }
//                else if ([diction[@"top3"] intValue]==2) {
//                    ((UIImageView *)backImgContrl[xi]).image=[UIImage imageNamed:@"icon_live_room_second"];
//                    ((UIImageView *)backImgContrl[xi]).hidden=NO;
//                }
//                else if ([diction[@"top3"] intValue]==1) {
//                    ((UIImageView *)backImgContrl[xi]).image=[UIImage imageNamed:@"icon_live_room_three"];
//                    ((UIImageView *)backImgContrl[xi]).hidden=NO;
//                }
//                xi++;
//            }
        }
    }
    if ([method isEqualToString:@"redPackageUpdate"]) {
        //"{"game_id":"30000","jindu":"1000000","total":null,"action2":"redPackageUpdate"}"
        NSString *gameId = [args SafeObject:@"game_id"];
        NSString *jindu = [args SafeObject:@"get_gift_balance"];
        NSString *total = [args SafeObject:@"need_gift_balance"];
        if ([self.game_id isEqualToString:gameId] || [gameId integerValue] > [self.game_id integerValue]) {
            if ([gameId integerValue] > [self.game_id integerValue]) {
                if (self.gameTimer) {
                    [self.gameTimer invalidate];
                    self.gameTimer = nil;
                }
            }
            NSDictionary *dict = @{@"game_id":gameId,@"get_gift_balance":jindu,@"need_gift_balance":total};
            [self showSmallView:dict];

        }
    }
    if ([method isEqualToString:@"open_next_turn"]) {
        if (self.gameTimer) {
            [self.gameTimer invalidate];
            self.gameTimer = nil;
        }
        if (_redSmallView) {
            [_redSmallView removeFromSuperview];
            _redSmallView = nil;
        }
        if (_redBigView) {
            [_redBigView removeFromSuperview];
            _redBigView = nil;
        }
        gameTimeCount = 0;
        NSString *gameId = [args SafeObject:@"game_id"];
        NSString *jindu = [args SafeObject:@"get_gift_balance"];
        NSString *total = [args SafeObject:@"need_gift_balance"];
        NSDictionary *dict = @{@"game_id":gameId,@"get_gift_balance":jindu,@"need_gift_balance":total};
        if ([gameId integerValue] > [self.game_id integerValue]) {
            if (self.gameTimer) {
                [self.gameTimer invalidate];
                self.gameTimer = nil;
            }
        }
        [self showSmallView:dict];
    }
    if ([method isEqualToString:@"change_room_title"]) {
        
        NSString *pwdstatus = [args SafeObject:@"pwdstatus"];
        if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
            if ([args.allKeys containsObject:@"pwd_set_status"]) {
                
                NSString *pwdsetstatus = [args SafeObject:@"pwd_set_status"];
                if (![pwdsetstatus boolValue]) {
                    [self shouFeiAction:nil];
                    return;
                }
            }
        }
        if ([pwdstatus isEqualToString:@"1"]) {
            self.time.text = [NSString stringWithFormat:@"密码:%@",[args SafeObject:@"pwdnew"]];
            pwd=[NSString stringWithFormat:@"%@",[args SafeObject:@"pwdnew"]];
            if ([[AppDelegate appDelegate].userModel.user.id isEqualToString:showerUserid]) {
                self.time.hidden=NO;
                //显示分享密码的弹框
                [self showShareMimaView];
            }
        } else if ([pwdstatus isEqualToString:@"-1"]){
            //不显示密码label
            self.time.hidden=YES;
        }
    }
    //游戏获奖之后弹出打赏页面
    if ([method isEqualToString:@"gamewintip"])
    {   //  弹框
        giftUserModel=self.beginLiveModel.anchor;
        NSString *giftid=[args SafeObject:@"id"];
        NSString *price=[args SafeObject:@"price"];
        NSString *img=[args SafeObject:@"img"];
        self.dashangView=[[DaShangView alloc] initWithFrame:CGRectMake(45*ScreenBiLi, -375*ScreenBiLi, 225*ScreenBiLi, 310*ScreenBiLi) andImage:img andPrice:price andGiftid:giftid];
        self.dashangView.delegate=self;
        [self.liveShowView addSubview:self.dashangView];
        [self.liveShowView bringSubviewToFront:self.dashangView];
        //春天动画
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.dashangView.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        } completion:nil];
    }
    
    else if ([method isEqualToString:@"reset_pic_banner"]) {
        NSArray *arr = [args SafeObject:@"img_list"];
        if ([arr isKindOfClass:[NSArray class]]) {
            [self loadTiePian:[arr mutableCopy]];
        }
    }
    //2018.1.20  所有人收到pk的开始 观众进入已经开始pk的房间时也会收到
    else if ([method isEqualToString:@"pk_start"])
    {
        joined=YES;
        isPKing=YES; //2018.8.27 添加当前正在pk的标记
        if ([roomnumber isEqualToString:self.appDelegate.userModel.user.haoma]) {
            self.kit.isPK = YES;
            self.kit.txKit.isPK = YES;
        }
        self.kit.txKit.twoVideo = 0;
        self.kit.txKit.threeVideo = 0;
        
//        self.pkUserCount = 2;
        self.kit.pkUserCount = 2;
        
//        [self.kit.pusher stopCamera];
//        [self.kit.pusher stopMicrophone];
//        [self.kit.pusher stopPush];
//        [self.kit.streamerBase stopStream];
//        self.kit.winRect = CGRectMake(iphoneX?0.36:0.33, 0.25, iphoneX?0.28:0.33, 0);//设置小窗口大小
//        self.kit.winRect = CGRectMake(0.33, 0.25, 0.33, 0.33);//设置小窗口大小
        self.kit.winRect = CGRectMake(0.5, 0.25, 0.5, 0);//设置小窗口大小
//        self.pk3ViewHeight.constant = 332;
//        self.pk3ViewHeight.constant = 166*ScreenBiLi;
//        self.pkthreeBtn.hidden = NO;
        self.pkLeftView.hidden = NO;
        self.pkSofaBGImg.hidden = NO;
        self.pkRightView.hidden = NO;
        self.pkProphetBtn.hidden = NO;
        self.pkBgTopImg.hidden = NO;
        self.pkBgBottomImg.hidden = NO;
        [self.pkBgTopImg setImage:[UIImage imageNamed:@"icon_pkBG_top"]];
        [self.pkBgBottomImg setImage:[UIImage imageNamed:@"icon_pkBG_bottom"]];
        
        NSString *faqiren_level_image=[args SafeObject:@"faqiren_level_image"];
        NSString *jieshouren_level_image=[args SafeObject:@"jieshouren_level_image"];
        
        NSString *time=[args SafeObject:@"time"];
        pkdaojishiTotal = [time integerValue];
        NSString *faqiren=[args SafeObject:@"faqiren"];
        NSString *jieshouren=[args SafeObject:@"jieshouren"];
        NSString *faqiren_nickname=[args SafeObject:@"faqiren_nickname"];
        NSString *jieshouren_nickname=[args SafeObject:@"jieshouren_nickname"];
        NSString *faqirenuserid=[args SafeObject:@"faqiren_userid"];
        NSString *jieshourenuserid=[args SafeObject:@"jieshouren_userid"];
        
        NSString *pkother_1 = @"";
        if ([faqiren isEqualToString:roomnumber]) {
            pkother_1 = jieshouren;
//            [self.pkLevelRight sd_setImageWithURL:[self placeImg:jieshouren_level_image]];
//            [self.pkLevelLeft sd_setImageWithURL:[self placeImg:faqiren_level_image]];
//            self.pkLevelLeft.hidden = NO;
//            self.pkLevelRight.hidden = NO;
        } else {
            pkother_1 = faqiren;
//            [self.pkLevelRight sd_setImageWithURL:[self placeImg:faqiren_level_image]];
//            [self.pkLevelLeft sd_setImageWithURL:[self placeImg:jieshouren_level_image]];
//            self.pkLevelLeft.hidden = NO;
//            self.pkLevelRight.hidden = NO;
        }
        self.kit.txKit.twoVideo = [pkother_1 integerValue];
        
        if (!_pkPlayer) {
            self.pkPlayer = [[V2TXLivePlayer alloc] init];
            [self.pkPlayer setCacheParams:1 maxTime:5];
//            [self.pkPlayer setObserver:self];
            [self.pkPlayer setRenderFillMode:V2TXLiveFillModeFill];
        }
        
        if (self.playerPKView) {
            [self.playerPKView removeFromSuperview];
            self.playerPKView = nil;
        }
        self.playerPKView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, self.zhuboPKView.y, SCREEN_WIDTH/2, self.pk3ViewHeight.constant)];
    
        [self.pkPlayer setRenderView:self.playerPKView];
        
        if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
            
            self.hostAnchorView.frame = CGRectMake(0, self.zhuboPKView.y, SCREEN_WIDTH/2, self.pk3ViewHeight.constant);
            
//            [self pusherLiveWithIsRTC:YES];
            
            [self.view insertSubview:self.playerPKView aboveSubview:self.hostAnchorView];
            
            __weak typeof(self) weakself = self;
            [self getTRCTuserSig:self.appDelegate.userModel.user.haoma withBlock:^{
                NSString *url = [NSString stringWithFormat:@"trtc://cloud.tencent.com/play/56853_%@?sdkappid=%@&userId=%@&usersig=%@",pkother_1,TRTCSDKAppID,weakself.appDelegate.userModel.user.haoma,TXTRCTUserSig];
                [weakself.pkPlayer startLivePlay:url];
            }];
            

        } else {
//            [self playerCreatePlayer];
            
            [self.playerView setFrame:CGRectMake(0, self.zhuboPKView.y, SCREEN_WIDTH/2, self.pk3ViewHeight.constant)];
            
            [self.liveShowView insertSubview:self.playerPKView aboveSubview:self.playerView];
            
            UITapGestureRecognizer *tapPkGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOtherRoomBtnAction)];
            tapPkGesture.cancelsTouchesInView = NO;
            [self.playerPKView addGestureRecognizer:tapPkGesture];
            
            NSMutableDictionary *params=[NSMutableDictionary dictionary];
            [params setValue:@"ios" forKey:@"platform"];
            NSString *requestUrl=[NSString stringWithFormat:@"%@iumobile/apis/index.php?languages=zh_cn&action=get_room_info&roomnumber=%@&token=%@",DATAAPI,pkother_1,self.appDelegate.userModel.token];
           [[RootHttpHelper httpHelper] achieveCommonPostURL2:requestUrl andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
               NSMutableDictionary *showinfo=[NSMutableDictionary dictionaryWithDictionary:successData];
               [self.pkPlayer startLivePlay:[showinfo objectForKey:@"download_video_add"]];
           }];
            
        }
        
        NSArray *avatarImgControl=@[self.pkrightfirstavatarimg,self.pkrightsecondavatarimg,self.pkrightthirdavatarimg,self.pkleftfirstavatarimg,self.pkleftsecondavatarimg,self.pkleftthirdavatarimg];
        for (UIImageView *img in avatarImgControl) {
            img.image = [UIImage imageNamed:@"icon_pk_sofa_no"];
        }
        pkStart=YES;
        NSString *cf_time=[args SafeObject:@"cf_second"];
        if (cf_time!=nil) {
            cf_daojishi=[cf_time intValue];
        }
        if ([faqiren isKindOfClass:[NSNull class]]) {
            return;
        }
        
        if ([faqiren isEqualToString:roomnumber]) { //发起人是当前房间的主播
            [self createPKViewWithFaQi:[NSString stringWithFormat:@"%@",faqiren_nickname] AndJieShou:[NSString stringWithFormat:@"%@",jieshouren_nickname] andTime:time withNumber:1 andPcOrNot:NO];
            leftNumber=faqiren;
            rightNumber=jieshouren;
            leftName = faqiren_nickname;
            rightName = jieshouren_nickname;
        }
        else if ([jieshouren isEqualToString:roomnumber])
        {
            //4.3修改
            [self createPKViewWithFaQi:[NSString stringWithFormat:@"%@",jieshouren_nickname] AndJieShou:[NSString stringWithFormat:@"%@",faqiren_nickname] andTime:time withNumber:0 andPcOrNot:NO];
            leftNumber=jieshouren;
            rightNumber=faqiren;
            leftName = jieshouren_nickname;
            rightName = faqiren_nickname;
        }
        else{  //2018.8.27 修改发起人和接收人都不是当前房间
            return;
        }
        //观众端
        
        joined=YES;
        isPKing=YES; //2018.8.27 添加当前正在pk的标记
        //4.2 只有PK的人才能看到断按钮
                if ([self.appDelegate.userModel.user.haoma isEqualToString:faqiren]) {
                    [self initFinishBtn];
                    [self initpkUserView:YES andUserRoomnumber:jieshouren andName:jieshouren_nickname andThreeUserRoomnumber:@"" andThreeName:@"" andUseridTwo:jieshourenuserid andUseridThree:@""];
                }
                else if ([self.appDelegate.userModel.user.haoma isEqualToString:jieshouren])
                {
                    [self initFinishBtn];
                    [self initpkUserView:YES andUserRoomnumber:faqiren andName:faqiren_nickname andThreeUserRoomnumber:@"" andThreeName:@"" andUseridTwo:faqirenuserid andUseridThree:@""];
                }
                else if ([roomnumber isEqualToString:jieshouren]) {
                    [self initpkUserView:NO andUserRoomnumber:faqiren andName:faqiren_nickname andThreeUserRoomnumber:@"" andThreeName:@"" andUseridTwo:faqirenuserid andUseridThree:@""];
                }
                else  if ([roomnumber isEqualToString:faqiren]) {
                    [self initpkUserView:NO andUserRoomnumber:jieshouren andName:jieshouren_nickname andThreeUserRoomnumber:@"" andThreeName:@"" andUseridTwo:jieshourenuserid andUseridThree:@""];
                }
        
        self.ChatManageView.frame = CGRectMake(0, self.pkLeftView.y+self.pkLeftView.height-10, SCREEN_WIDTH, SCREEN_HEIGHT-(self.pkLeftView.y+self.pkLeftView.height));
        self.gradientLayer.frame = self.ChatManageView.bounds;
        
    }
    // 过程中所有人收到pk值变化
    else if ([method isEqualToString:@"pk_value"])
    {
        float faqiren_value=[[args SafeObject:@"faqiren_value"] floatValue];
        float jieshouren_value=[[args SafeObject:@"jieshouren_value"] floatValue];
        [self.pkview setPKValueBlue:faqiren_value andRed:jieshouren_value];
        
        if ([args.allKeys containsObject:@"faqiren_topuserarr"]) {
            NSArray *arr=[args SafeObject:@"faqiren_topuserarr"];
            if (arr.count > 0) {
                BOOL isPKFaQiRen = NO;
                NSDictionary *dic = [arr SafeObjectAt:0];
                if ([dic[@"userid"] isEqualToString:showerUserid]) {
                    isPKFaQiRen = YES;
                }
                if (self.pkview.num == 1) {
                    NSArray *avatarImgControl=@[self.pkleftthirdavatarimg,self.pkleftsecondavatarimg,self.pkleftfirstavatarimg];
                    int xi=0;
                    for (NSDictionary *diction in arr) {
                        if (xi==3) {
                            break;
                        }
                        [peopleuseridArr addObject:diction];
                        [avatarImgControl[xi] sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:[NSString stringWithFormat:@"%@",diction[@"userid"]] andUpdate:@"11"]]];
                        xi++;
                    }
                } else {
                    NSArray *avatarImgControl=@[self.pkrightfirstavatarimg,self.pkrightsecondavatarimg,self.pkrightthirdavatarimg];
                    int xi=0;
                    for (NSDictionary *diction in arr) {
                        if (xi==3) {
                            break;
                        }
                        [peopleuseridArr addObject:diction];
                        [avatarImgControl[xi] sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:[NSString stringWithFormat:@"%@",diction[@"userid"]] andUpdate:@"11"]]];
                        xi++;
                    }
                }
            }
        }
        
        if ([args.allKeys containsObject:@"jieshouren_topuserarr"]) {
            NSArray *arr1=[args SafeObject:@"jieshouren_topuserarr"];
            if (arr1.count > 0) {
                BOOL isPKFaQiRen = NO;
                NSDictionary *dic = [arr1 SafeObjectAt:0];
                if ([dic[@"userid"] isEqualToString:showerUserid]) {
                    isPKFaQiRen = YES;
                }
                if (self.pkview.num == 1) {
                    NSArray *avatarImgControl=@[self.pkrightfirstavatarimg,self.pkrightsecondavatarimg,self.pkrightthirdavatarimg];
                    int xi=0;
                    for (NSDictionary *diction in arr1) {
                        if (xi==3) {
                            break;
                        }
                        [peopleuseridArr addObject:diction];
                        [avatarImgControl[xi] sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:[NSString stringWithFormat:@"%@",diction[@"userid"]] andUpdate:@"11"]]];
                        xi++;
                    }
                } else {
                    NSArray *avatarImgControl=@[self.pkleftthirdavatarimg,self.pkleftsecondavatarimg,self.pkleftfirstavatarimg];
                    int xi=0;
                    for (NSDictionary *diction in arr1) {
                        if (xi==3) {
                            break;
                        }
                        [peopleuseridArr addObject:diction];
                        [avatarImgControl[xi] sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:[NSString stringWithFormat:@"%@",diction[@"userid"]] andUpdate:@"11"]]];
                        xi++;
                    }
                }
            }
        }
    }
    // pk结束
    else if ([method isEqualToString:@"pk_over"])
    {
        self.pkLeftView.hidden = YES;
        self.pkSofaBGImg.hidden = YES;
        self.pkRightView.hidden = YES;
        [self removeDelayTime];//移除pk条界面
        isFaQiRen = NO;
        isSetPkTime = NO;
        self.pkProphetBtn.hidden = YES;
        self.pkBgTopImg.hidden = YES;
        self.pkBgBottomImg.hidden = YES;
        [self removePkUserView];// 移除PK对方用户名字
        self.zhuboPKView.hidden = YES;
//        self.pkUserCount = 0;
        
        [self.pkPlayer stopPlay];
        [self.pkPlayer setRenderView:nil];
        _pkPlayer = nil;
        if (self.playerPKView) {
            [self.playerPKView removeFromSuperview];
            self.playerPKView = nil;
        }
        if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
            self.hostAnchorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
        } else {
            [self.playerView setFrame:self.view.bounds];
        }
        
        self.kit.isPK = NO;
        self.kit.txKit.isPK = NO;

    }
    //所有人收到pk结束
    else if ([method isEqualToString:@"pk_end"])
    {
        isSetPkTime = NO;
          NSString * faqiren=[args SafeObject:@"faqiren"];
          NSString * jieshouren=[args SafeObject:@"jieshouren"];
//              float faqiren_value=[[args SafeObject:@"faqiren_value"] floatValue];
//              float jieshouren_value=[[args SafeObject:@"jieshouren_value"] floatValue];
        NSString *win_usernumber=[args SafeObject:@"win_usernumber"];//赢的人的usernumber,如果为空表示平
        NSString *time=[args SafeObject:@"time"];
        if (time!=nil) {
            cf_daojishi=[time intValue];
        }
        //pk结束 显示pk条 以及pk的结果 赢、输或者平局 3s之后移除掉 如果有一方断线或结束pk了 主播端会断开连麦
        if (self.pkOffLine==YES) {
            [self pk_endwith:win_usernumber];//掉线时间过长直接把pk结束掉
            winRoomnumber = win_usernumber;
            
             return;
        }
        [self pk_endwith:win_usernumber];
        winRoomnumber = win_usernumber;
        //只有PK的人才能看到断开按钮
//        switch (ShowPKENDType) {
//            case NSDataRequestShowPKENDTypeEnd:
                //4.2 只有PK的人才能看到断开按钮
            if ([SharedAppDelegate.userModel.user.haoma isEqualToString:faqiren]) {
                if ([win_usernumber isEqualToString:@""] || [faqiren isEqualToString:win_usernumber]) {
                    [self initFinishBtn];
                    self.finishBtn.hidden = NO;
                    self.finishBtn.frame=CGRectMake(SCREEN_WIDTH-53*ScreenBiLi, iphoneX?153:134, 48*ScreenBiLi, 24*ScreenBiLi);
                } else {
//                    if(self.finishBtn)
//                    {
//                        self.finishBtn.hidden = YES;
//                        [self.finishBtn removeFromSuperview];
//                        self.finishBtn=nil;
//                    }
                }
                //                    [self initFinishBtn];
            }
            if ([SharedAppDelegate.userModel.user.haoma isEqualToString:jieshouren])
            {
                if ([win_usernumber isEqualToString:@""] || [jieshouren isEqualToString:win_usernumber]) {
                    [self initFinishBtn];
                    self.finishBtn.hidden = NO;
                    self.finishBtn.frame=CGRectMake(SCREEN_WIDTH-53*ScreenBiLi, iphoneX?153:134, 48*ScreenBiLi, 24*ScreenBiLi);
                } else {
//                    if(self.finishBtn)
//                    {
//                        self.finishBtn.hidden = YES;
//                        [self.finishBtn removeFromSuperview];
//                        self.finishBtn=nil;
//                    }
                }
                //                    [self initFinishBtn];
            }
//            break;
//        }
        
        if ([args.allKeys containsObject:@"faqiren_topuserarr"]) {
            NSArray *arr=[args SafeObject:@"faqiren_topuserarr"];
            
            if (arr.count > 0) {
                BOOL isPKFaQiRen = NO;
                NSDictionary *dic = [arr SafeObjectAt:0];
                if ([dic[@"userid"] isEqualToString:showerUserid]) {
                    isPKFaQiRen = YES;
                }
                if (isPKFaQiRen) {
                    //            NSDictionary *dic=[arr SafeObjectAt:0];
                    NSArray *avatarImgControl=@[self.pkleftfirstavatarimg,self.pkleftsecondavatarimg,self.pkleftthirdavatarimg];
                    int xi=0;
                    for (NSDictionary *diction in arr) {
                        if (xi==3) {
                            break;
                        }
                        [peopleuseridArr addObject:diction];
                        [avatarImgControl[xi] sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:[NSString stringWithFormat:@"%@",diction[@"userid"]] andUpdate:@"11"]]];
                        xi++;
                    }
                } else {
                    //            NSDictionary *dic=[arr SafeObjectAt:0];
                    NSArray *avatarImgControl=@[self.pkrightfirstavatarimg,self.pkrightsecondavatarimg,self.pkrightthirdavatarimg];
                    int xi=0;
                    for (NSDictionary *diction in arr) {
                        if (xi==3) {
                            break;
                        }
                        [peopleuseridArr addObject:diction];
                        [avatarImgControl[xi] sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:[NSString stringWithFormat:@"%@",diction[@"userid"]] andUpdate:@"11"]]];
                        xi++;
                    }
                }
            }
        }
        
        if ([args.allKeys containsObject:@"jieshouren_topuserarr"]) {
            NSArray *arr1=[args SafeObject:@"jieshouren_topuserarr"];
            if (arr1.count > 0) {
                BOOL isPKFaQiRen = NO;
                NSDictionary *dic = [arr1 SafeObjectAt:0];
                if ([dic[@"userid"] isEqualToString:showerUserid]) {
                    isPKFaQiRen = YES;
                }
                if (isPKFaQiRen) {
                    //            NSDictionary *dic=[arr SafeObjectAt:0];
                    
                    NSArray *avatarImgControl=@[self.pkleftfirstavatarimg,self.pkleftsecondavatarimg,self.pkleftthirdavatarimg];
                    int xi=0;
                    for (NSDictionary *diction in arr1) {
                        if (xi==3) {
                            break;
                        }
                        [peopleuseridArr addObject:diction];
                        [avatarImgControl[xi] sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:[NSString stringWithFormat:@"%@",diction[@"userid"]] andUpdate:@"11"]]];
                        xi++;
                    }
                } else {
                    //            NSDictionary *dic=[arr SafeObjectAt:0];
                    NSArray *avatarImgControl=@[self.pkrightfirstavatarimg,self.pkrightsecondavatarimg,self.pkrightthirdavatarimg];
                    int xi=0;
                    for (NSDictionary *diction in arr1) {
                        if (xi==3) {
                            break;
                        }
                        [peopleuseridArr addObject:diction];
                        [avatarImgControl[xi] sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:[NSString stringWithFormat:@"%@",diction[@"userid"]] andUpdate:@"11"]]];
                        xi++;
                    }
                }
            }
        }
        //2018.3.12修改
        [self createPKEndTimer];
    }
    else if ([method isEqualToString:@"pk_start_multi"]) {
//        "{"rooms":[{"roomnumber":"88962424","userid":"41461","nickname":"游客_9373","stream":"http:\/\/qqplay.cxlzc.com\/livebb\/56853_88962424.flv","avatar":"http:\/\/img.cxlzc.com\/static_data\/uploaddata\/avatar\/4\/41461.gif?_t=1632884924"},{"roomnumber":"13722957","userid":"41474","nickname":"梅子没熟","stream":"http:\/\/qqplay.cxlzc.com\/livebb\/56853_13722957.flv","avatar":"http:\/\/img.cxlzc.com\/static_data\/uploaddata\/avatar\/4\/41474.gif?_t=1623229840"},{"roomnumber":"27272887","userid":"70332","nickname":"sym","stream":"http:\/\/qqplay.cxlzc.com\/livebb\/56853_27272887.flv","avatar":""},{"roomnumber":"44362804","userid":"41463","nickname":"justsoso","stream":"http:\/\/qqplay.cxlzc.com\/livebb\/56853_44362804.flv","avatar":"https:\/\/thirdwx.qlogo.cn\/mmopen\/vi_32\/dyaiogq83ervqibqqmliabyoibpwpkpirnrjn5gax6zwb0vlzkpxgw9vm0xottfskicdiyw8caxm01xqticeawrf1wa\/132"}],"action2":"pk_start_multi"}"
        [self startMultixpk:args];
    } else if ([method isEqualToString:@"pk_end_multi"]) {
        // 进入惩罚阶段
        if (_pkMultiView) {
            [_pkMultiView startCFTimer];
        }

    }
    else if ([method isEqualToString:@"pk_over_multi"]) {
        [self overMultiPK:NO];
    }
    else if ([method isEqualToString:@"pk_value_multi"]) {
        [self uploadMultiPKValue:args];
    }
    else if ([method isEqualToString:@"pk_status_multi"]) {
        [self pkMultiInfoState:args];
    }
    else if ([method isEqualToString:@"pk_host_to_room"]) {
        if ([args.allKeys containsObject:@"mute_state"]) {
            // 更新静音状态
            [_pkMultiView uploadZhuBoVoiceState:args[@"mute_state"]];
        } else if ([args.allKeys containsObject:@"leave_host"]) {
            [self leavePKHost:args];
        }
    }
    else if ([method isEqualToString:@"welcome"]) {
//        if (![[args SafeObject:@"data"] isKindOfClass:[NSDictionary class]]) {
//            <#statements#>
//        }
//        [self initTotalView:@"&guard=1" type:0];
//        [self initTotalView:@"&guibin=1" type:1];
//        [self initTotalView:@"" type:2];
        NSString *who=[args SafeObject:@"nickname"];
        if ([who isEqualToString:@""]) {
            return;
        }
        //12.19 新增贵宾人数
        NSString *guibin_num=[NSString stringWithFormat:@"%@",[args SafeObject:@"guibin_num"]];
        if (guibin_num!=nil) {
            self.guizuNum.text=guibin_num;
        }
        else
        {
            self.guizuNum.text=@"0";
        }
        NSString *guard_num=[NSString stringWithFormat:@"%@",[args SafeObject:@"guard_num"]];
        if (guard_num!=nil) {
            self.shouhuNum.text = [NSString stringWithFormat:@"粉丝团:%@",guard_num];
        }
        else
        {
            self.shouhuNum.text=@"粉丝团:0";
        }
        
        //7.17 新增图标
        NSString*uimg=[args SafeObject:@"uimg"];
        NSString*uimgh=[args SafeObject:@"uimgh"];
        
        NSString *jsonString=[NSString stringWithFormat:@"%@",[args SafeObject:@"data"]];
        // 1.2 添加判断
        if (![jsonString respondsToSelector:@selector(dataUsingEncoding:)]) {
            return;
        }
        NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];//kNilOptions 1.2 修改
        BOOL isNotSelf=YES,isNotHide=YES;
        if ([[[obj objectForKey:@"userinfo"] objectForKey:@"userid"] isEqualToString:SharedAppDelegate.userModel.user.id])
        {
            if ([obj isKindOfClass:[NSDictionary class]]) { //2018.8.17 添加获取当前用户的币
                currentBalance=[[obj objectForKey:@"userinfo"] objectForKey:@"balance"];
            }
            //            自己进入直播间
            NSLog(@"self welcome");
            
  
            self.lookLiveTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
            //初始化房间观众列表
            [self initRoomUsers];
            isNotSelf=NO;
        }
        //不是隐身
        NSString *carname=[[obj objectForKey:@"car"] objectForKey:@"giftname"];
        NSString *carid=[[obj objectForKey:@"car"] objectForKey:@"giftid"];
        NSDictionary *horseInfo=[SharedAppDelegate.horseDic objectForKey:carid];
        NSString *version=[horseInfo objectForKey:@"uptime"];
        NSString *newpwd=[horseInfo objectForKey:@"newpwd"];//8.14礼物解压新密码
        NSString *filename=[horseInfo objectForKey:@"filename"];//8.17礼物新giftid
        if ([self isBlankString:filename]) {
            filename =@"-100";
        }
        if ([self isBlankString:newpwd]) {
            newpwd =@"0";
        }
        if(![carname isEqualToString:@""] && _isHiddenCar){
            //座驾显示
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:carid,@"giftid",[NSString stringWithFormat:@"%@/static_data/gift/%@.zip?%@",IMAGEAPI,carid,version],@"url",version,@"version",newpwd,@"newpwd",filename,@"filename", nil];
            [self showAni:params];
            
        }
        //只有黑色vip可以隐身
        //if ([[[userDefaults objectForKey:@"profile"] objectForKey:@"viplevel"] intValue]>=3) { //status
        if([[[obj objectForKey:@"car"] objectForKey:@"state"] isEqualToString:@"hide"]){
            isNotHide=NO;
        }
        //}
        int viplevel=[[[obj objectForKey:@"userinfo"] objectForKey:@"viplevel"] intValue];
        if (isNotHide) {
            
            int richlevel=[[[obj objectForKey:@"userinfo"] objectForKey:@"richlevel"] intValue];
            int starlevel=[[[obj objectForKey:@"userinfo"] objectForKey:@"starlevel"] intValue];
            
            CustomElemModel *elemModel = [[CustomElemModel alloc]init];
            elemModel.type  = IM_TYPE_ENTER;
            elemModel.s_uid = [[obj objectForKey:@"userinfo"] objectForKey:@"userid"];
            elemModel.s_nick =[[obj objectForKey:@"userinfo"] objectForKey:@"nickname"];
            /// 4.20    判断当前时间
            elemModel.time =[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
            elemModel.chat_bg_color = [args SafeObject:@"chat_bg_color"];
            //7.17 增加图标
            if (![self isBlankString:uimg]) {
                elemModel.uimg=uimg;
                elemModel.uimgh=uimgh;
            }
            
            if ([[[obj objectForKey:@"userinfo"] objectForKey:@"usernumber"] isEqualToString:roomnumber]) {
                elemModel.s_level=[NSString stringWithFormat:@"%d",starlevel];
                elemModel.ishost=@"1";
            }
            else{
                elemModel.s_level=[NSString stringWithFormat:@"%d",richlevel];
                elemModel.ishost=@"0";
            }
            
            NSString *zuojiaStr=[[obj objectForKey:@"car"] objectForKey:@"giftname"];
            NSString *zuojiaInfo=@"";
            if(![zuojiaStr isEqualToString:@""]){
                zuojiaInfo=[NSString stringWithFormat:@"%@",zuojiaStr];
                elemModel.extra=zuojiaInfo;
            }
            user=[[UserInfoModel alloc] init];
            user.id=[[obj objectForKey:@"userinfo"] objectForKey:@"userid"];
            user.nickname=elemModel.s_nick;
            YYTCShowLiveMsg *msg=[[YYTCShowLiveMsg alloc] initWithCustom:user message:elemModel];
            if ([[[obj objectForKey:@"userinfo"] objectForKey:@"usernumber"] isEqualToString:roomnumber]) {
                msg.ishost=YES;
            }
            else{
                msg.ishost=NO;
            }
            NSString *userlevel=[[NSUserDefaults standardUserDefaults] objectForKey:@"show_info_level"];
            if ([elemModel.s_level intValue]>=[userlevel intValue]) {
                [self.msgView insertTCShowMsg:msg andLeft:NO andisMsg:YES];
            }
        }
        else //3.13 修改隐身进入房间
        {
            int richleveltwo=[[[obj objectForKey:@"userinfo"] objectForKey:@"richlevel"] intValue];
            int starleveltwo=[[[obj objectForKey:@"userinfo"] objectForKey:@"starlevel"] intValue];
            CustomElemModel *elemModel = [[CustomElemModel alloc]init];
            elemModel.type  = IM_TYPE_ENTER;
            /// 4.20    判断当前时间
            elemModel.time =[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
            //7.17 增加图标
            if (![self isBlankString:uimg]) {
                elemModel.uimg=uimg;
                elemModel.uimgh=uimgh;
            }
            if ([[[obj objectForKey:@"userinfo"] objectForKey:@"usernumber"] isEqualToString:roomnumber]) {
                elemModel.s_level=[NSString stringWithFormat:@"%d",starleveltwo];
                elemModel.ishost=@"1";
            }
            else{
                elemModel.s_level=[NSString stringWithFormat:@"%d",richleveltwo];
                elemModel.ishost=@"0";
            }
            NSString *zuojiaStr=[[obj objectForKey:@"car"] objectForKey:@"giftname"];
            NSString *zuojiaInfo=@"";
            if(![zuojiaStr isEqualToString:@""]){
                zuojiaInfo=[NSString stringWithFormat:@"%@",zuojiaStr];
                elemModel.extra=zuojiaInfo;
            }
            user=[[UserInfoModel alloc] init];
            user.id=[[obj objectForKey:@"userinfo"] objectForKey:@"userid"];
            user.nickname=elemModel.s_nick;
            YYTCShowLiveMsg *msg=[[YYTCShowLiveMsg alloc] initWithCustom:user message:elemModel];
            if ([[[obj objectForKey:@"userinfo"] objectForKey:@"usernumber"] isEqualToString:roomnumber]) {
                msg.ishost=YES;
            }
            else{
                msg.ishost=NO;
            }
            msg.ishide=YES;
            NSString *userlevel=[[NSUserDefaults standardUserDefaults] objectForKey:@"show_info_level"];
            if ([elemModel.s_level intValue]<[userlevel intValue]) {
                return;
            }
            [self.msgView insertTCShowMsg:msg andLeft:NO andisMsg:YES];
        }
        if (isNotHide && isNotSelf) {
            //不是隐身，也不是自己，增加在线观众
            onlineNum++;
            NSString *onlineStr;
            if (onlineNum > 1000) {
                onlineStr = [NSString stringWithFormat:@"%dk",onlineNum/1000];
            } else {
                onlineStr = [NSString stringWithFormat:@"%d",onlineNum];
            }
            [_count setText:onlineStr];
            UserInfoModel * infoModel = [[UserInfoModel alloc] init];
            NSDictionary *info=[obj objectForKey:@"userinfo"];
            infoModel.id=[info objectForKey:@"userid"];
           
            infoModel.avatar=[[ToolHelper toolHelper] realAvatarUrl:infoModel.id andUpdate:[info objectForKey:@"update_avatar_time"]];
            infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
            infoModel.nickname=[info objectForKey:@"nickname"];
            infoModel.total_ticket=[info objectForKey:@"totalpoint"];
            infoModel.total_send_gift=[info objectForKey:@"totalcost"];
            infoModel.hometown_city=[info objectForKey:@"city"];
            infoModel.gender=[info objectForKey:@"gender"];
            infoModel.haoma=[info objectForKey:@"usernumber"];
            infoModel.fans_num=@"0";
            infoModel.follow_num=@"0";
            infoModel.rank_id=[info objectForKey:@"richlevel"];
            infoModel.is_follow=@"0";
            infoModel.avatar_frame = [info objectForKey:@"avatar_frame"];
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval now=[dat timeIntervalSince1970] / 1000;
            infoModel.vip_util=[NSString stringWithFormat:@"%f",viplevel*(now+10.0)];
//            [self addPeople:infoModel];
            [self initRoomUsers];
        }
        NSString *currentOnline=[args SafeObject:@"totalpeople"];
        onlineNum=[currentOnline intValue];
        
        NSString *onlineStr;
        if (onlineNum > 1000) {
            onlineStr = [NSString stringWithFormat:@"%0.1fk",onlineNum/1000.0];
        } else {
            onlineStr = [NSString stringWithFormat:@"%d",onlineNum];
        }
        [_count setText:onlineStr];
    }
    else if([method isEqualToString:@"kickbackResult"]){
        NSString *cmd=[args SafeObject:@"r"];
        if ([cmd isEqualToString:@""]) {
            return;
        }
        //NSString *msg=@"";
        NSArray *arr=[cmd componentsSeparatedByString:@",|"];
        NSString *command=[[arr objectAtIndex:0] substringToIndex:3];
        NSString * isscret=[args SafeObject:@"state"];//10.11 神秘人隐身
        NSString *from=[arr objectAtIndex:2];
        if([command isEqualToString:@"SKK"]){
            //12.25  显示xx点亮了爱心
            CustomElemModel *elemModel = [[CustomElemModel alloc]init];
            elemModel.type  = IM_TYPE_STAR;
            elemModel.s_nick =from;
            //            判断当前时间
            elemModel.time =[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
            //用户等级
            elemModel.s_level=arr[[arr count]-1];
            user=[[UserInfoModel alloc] init];
            user.nickname=elemModel.s_nick;
            YYTCShowLiveMsg *msg=[[YYTCShowLiveMsg alloc] initWithCustom:user message:elemModel];
            [self showTheCartoon];
            if ([isscret isEqualToString:@"hide"])//10.11 神秘人
            {
                elemModel.s_nick =@"神秘人";
                msg.ishide=YES;
            }
            else{
                elemModel.s_nick =from;
                msg.ishide=NO;
            }
            //免费礼物（点赞）
            if (clicked==NO)
            {
                if(clicked==YES)
                {
                    return;
                }
                [self.msgView insertTCShowMsg:msg andLeft:NO andisMsg:YES];
                clicked=YES;
                //6秒之后把此布尔值置为最初值
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    clicked=NO;
                });
            }
        }
    }
    else if ([method isEqualToString:@"infoAlert"]) {
        NSString *alertInfo=[args SafeObject:@"msg"];
        if ([self isBlankString:alertInfo]) {
            return;
        }
        if ([alertInfo isKindOfClass:[NSString class]]) { //8.6添加判断
            if ([alertInfo containsString:@"对不起"]) {
                [self showAdmin_kickoutAlertViewWithMsg:alertInfo];
            }
            else
            {
                [[MessageHelper messageHelper] showWarnMessage :self title:nil sub:alertInfo];
                if ([alertInfo containsString:@"PK组局失败"]) {
                    [self pkMultiFail];
                }
                if ([alertInfo containsString:@"拒绝了你的pk邀请"]) {
                    [self mutilPkFail];
                }
            }
        }
    }
    else if([method isEqualToString:@"switchChat"]){
        if (isBlockChat) {
            isBlockChat=NO;
            [[MessageHelper messageHelper] showSuccessMessage :self.navigationController title:nil sub:@"您已经被解除禁言"];
        }
        else{
            isBlockChat=YES;
            
            [[MessageHelper messageHelper] showWarnMessage :self title:nil sub:@"您已经被禁言"];
        }
    }
    else if([method isEqualToString:@"kickOut"]){
        NSString *code=[args SafeObject:@"code"];
        NSString *msg=[args SafeObject:@"msg"];
        if ([code isEqualToString:@""]) {
            return;
        }
        if ([code isEqualToString:@"no_guizu"])
        {
            [self showNoGuiZuAlertViewWithMsg:msg];
        }
        if ([code isEqualToString:@"admin_kickout"])
        {
            [self showAdmin_kickoutAlertViewWithMsg:msg];
        }
        if ([code isEqualToString:@"sfm_kou_user_money_fail"])
        {
            [self showAdmin_kickoutAlertViewWithMsg:msg];
        }
        if ([code isEqualToString:@"sfm_user_no_money"])
        {
            [self showAdmin_kickoutAlertViewWithMsg:msg];
        }
        if ([code isEqualToString:@"onetoone_ing"]) {
            [self showAdmin_kickoutAlertViewWithMsg:msg];
        }
        else
        { //3.8 提示消息
            [[MessageHelper messageHelper] showWarnMessage :self title:nil sub:msg];
        }
    }
    //7.17 添加ping
    else if([method isEqualToString:@"ping"]){
        
        [self addPingAction];
    }
    else if ([method isEqualToString:@"userInfoUpdate"]) {
        NSString *doAction=[args SafeObject:@"action"];
        if ([doAction isEqualToString:@""]) {
            return;
        }
        if ([doAction isEqualToString:@"userUserids"]) {//更新在线人数
            NSArray *tmpArr=[[args SafeObject:@"data"] componentsSeparatedByString:@":"];
            onlineNum=[[tmpArr objectAtIndex:0] intValue];
            
        
            NSString *onlineStr;
            if (onlineNum > 1000) {
                onlineStr = [NSString stringWithFormat:@"%dk",onlineNum/1000];
            } else {
                onlineStr = [NSString stringWithFormat:@"%d",onlineNum];
            }
            
            [_count setText:onlineStr];
            NSArray *idArr=[[tmpArr objectAtIndex:1] componentsSeparatedByString:@","];
            [viewers removeAllObjects];
            for (NSString *toponlineid in idArr){
                UserInfoModel * infoModel = [[UserInfoModel alloc] init];
                infoModel.id=toponlineid;
                ///6.14
                NSNumber *currentTime=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
                
                infoModel.avatar=[[ToolHelper toolHelper] realAvatarUrl:infoModel.id andUpdate:[currentTime stringValue]];
                [viewers addObject:infoModel];
            }
//            [self reDrawUserList];
        }
        else if ([doAction isEqualToString:@"HBF"]) {//红包
            NSArray *tempArr =[[args SafeObject:@"data"]  componentsSeparatedByString:@",|"];
            NSString *jsonStr=[[args SafeObject:@"data"]  substringFromIndex:[tempArr[0] length]+2];
            leftSecond =[tempArr[0] intValue];
            //1.11 添加
            if (![jsonStr respondsToSelector:@selector(dataUsingEncoding:)]) {
                return;
            }
            NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSArray *tmpArr=[[obj objectForKey:@"ann"] componentsSeparatedByString:@",|"];
            //更新自己的钱数
            [self updateSelfBalance:[NSString stringWithFormat:@"%@",[obj objectForKey:@"balance"]] andSendid:tmpArr[2]];
            
            if([[obj objectForKey:@"isbroadcast"] isEqualToString:@"1"]){
                CustomElemModel *redPackElemModel2=[[CustomElemModel alloc] init];
                redPackElemModel2.s_uid=tmpArr[1];//当前红包id
                ///6.14
                NSNumber *currentTime=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
                redPackElemModel2.s_avatar=[[ToolHelper toolHelper] realAvatarUrl:tmpArr[2] andUpdate:[currentTime stringValue]];
                redPackElemModel2.s_nick=tmpArr[0];
                redPackElemModel2.t_nick=[obj objectForKey:@"roomname"];
                redPackElemModel2.message=tmpArr[3];
                if ([[obj objectForKey:@"roomnumber"]isEqualToString:roomnumber])
                {
                    [self showGlobalHB:redPackElemModel2.s_uid andLeftTime:leftSecond];
                }
                else
                {
                    
                    hongBaoRoomnumber=[obj objectForKey:@"roomnumber"];
                    hongBaoModel.roomnumber=[obj objectForKey:@"roomnumber"];
                    hongBaoModel.shower_userid=[obj objectForKey:@"roomuserid"];
                    hongBaoModel.name = [args SafeObject:@"name"];
                    hongBaoModel.userid=[args SafeObject:@"userid"];
                    hongBaoModel.type = @"300";
                    hongBaoModel.bg=[NSString stringWithFormat:@"%@/img/lvv2/sfmbg/%@",IMAGEAPI,[args SafeObject:@"bg"]];
                    hongBaoModel.fontColors=[args SafeObject:@"colors"];
                    hongBaoModel.color=[args SafeObject:@"color"];
                    hongBaoModel.pos=[args SafeObject:@"pos"];
                    hongBaoModel.staytime=[args SafeObject:@"staytime"];
                    hongBaoModel.pr=[args SafeObject:@"pr"];
                    hongBaoModel.pl=[args SafeObject:@"pl"];
                    hongBaoModel.fontSize=[args SafeObject:@"size"];
                    hongBaoModel.avatar_size=[args SafeObject:@"asize"];
                    hongBaoModel.avatar_x=[args SafeObject:@"aleft"];
                    hongBaoModel.avatar_y=[args SafeObject:@"atop"];
                    hongBaoModel.sizetop=[args SafeObject:@"sizetop"];
                    hongBaoModel.scale9_top=[args SafeObject:@"9t"];
                    hongBaoModel.scale9_bottom=[args SafeObject:@"9b"];
                    hongBaoModel.scale9_left=[args SafeObject:@"9l"];
                    hongBaoModel.scale9_right=[args SafeObject:@"9r"];
                    hongBaoModel.imgscale = [args SafeObject:@"imgscale"];
                    hongBaoModel.version = [args SafeObject:@"version"];
                    if ([[args SafeObject:@"content"] isKindOfClass:[NSArray class]]) {
                        NSMutableArray *temp = [NSMutableArray array];
                        for (NSDictionary *dict in [args SafeObject:@"content"]) {
                            SFMContentModel *model = [[SFMContentModel alloc] initWithDictionary:dict error:nil];
                            [temp addObject:model];
                        }
                        hongBaoModel.content = [temp mutableCopy];
                    }
                    
                    hongBaoModel.content_left = [args SafeObject:@"content_left"];
                    hongBaoModel.content_right = [args SafeObject:@"content_right"];
                    hongBaoModel.screen_height=[NSNumber numberWithFloat:self.ChatManageView.frame.origin.y];
                    hongBaoModel.screen_top = [NSNumber numberWithFloat:self.taskBGView.y + self.taskBGView.height];
                    ///6.14
                    NSNumber *currentTime=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
                    if([[ToolHelper toolHelper] ReplacingCharActer:redPackElemModel2.s_avatar])
                    {
                        hongBaoModel.headImage = [[ToolHelper toolHelper] realAvatarUrl:redPackElemModel2.s_avatar andUpdate:[currentTime stringValue]];
                    }
                    else
                    {
                        hongBaoModel.headImage = [NSString stringWithFormat:@"%@%@&update=%@",IMAGEAPI,redPackElemModel2.s_avatar,currentTime];
                    }
                    hongBaoModel.title = [NSString stringWithFormat:@"点这里去抢红包,30s之后开抢"];
//                    if (self.chatPush==NO) {
//                        self.flyView=[[PublicChatView alloc] init];
//                        [self.flyView setContent:hongBaoModel];
//                        UITapGestureRecognizer *singleTapges=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullHongBaoClick:)];
//                        [self.flyView addGestureRecognizer:singleTapges];
//                        [self.liveShowView addSubview:self.flyView];
//                    }
//                    [self performSelector:@selector(clearHongBaoInfo) withObject:nil afterDelay:30.0f];
                    
                    YYTCShowLiveMsg *message=[[YYTCShowLiveMsg alloc] initWithMessage:[NSString stringWithFormat:@"%@%@",[obj objectForKey:@"roomname"],@"甩出一个🧧！30秒后抢>"]];
                    message.jump_url = [NSString stringWithFormat:@"HBF,|%@",[obj objectForKey:@"roomnumber"]];
                    message.jump_name = @"甩出一个🧧！30秒后抢>";
    //                message.customElemModel = elemModel;
                    [self.msgView insertTCShowMsg:message andLeft:NO andisMsg:YES];
                    
                }
                
            }
            else{
                redPackElemModel=[[CustomElemModel alloc] init];
                redPackElemModel.s_uid=tmpArr[1];//当前红包id
                ///6.14
                NSNumber *currentTime=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
                redPackElemModel.s_avatar=[[ToolHelper toolHelper] realAvatarUrl:tmpArr[2] andUpdate:[currentTime stringValue]];

                redPackElemModel.s_nick=tmpArr[0];
                redPackElemModel.t_nick=[obj objectForKey:@"roomname"];
                redPackElemModel.message=tmpArr[3];
                //普通红包
                [self showRedPackView];
            }
        }
        else if ([doAction isEqualToString:@"HBQ"]) {//抢到红包
            NSArray *tmpArr=[[args SafeObject:@"data"] componentsSeparatedByString:@",|"];
            
            
            YYTCShowLiveMsg *message=[[YYTCShowLiveMsg alloc] initWithMessage:[NSString stringWithFormat:@"%@抢到了%@%@",[tmpArr objectAtIndex:0],[tmpArr objectAtIndex:1],[self moneyname]]];
            [self.msgView insertTCShowMsg:message andLeft:NO andisMsg:YES];
            if ([tmpArr objectAtIndex:2]!=nil) { //5.31修改 抢到红包之后再去分享才能到账
                if ([[tmpArr objectAtIndex:2] isEqualToString:SharedAppDelegate.userModel.user.id])
                {
                    if (![self isBlankString:[tmpArr objectAtIndex:2]]) {
                        if (![self isBlankString:[tmpArr objectAtIndex:3]]) {
                         SharedAppDelegate.hongbaoID=[tmpArr objectAtIndex:3];
                        }
                        NSInteger tmp=[SharedAppDelegate.userModel.user.balance integerValue]+[tmpArr[1] integerValue];
                        SharedAppDelegate.currentBalance=[NSString stringWithFormat:@"%ld",tmp];
                        SharedAppDelegate.currentUserID=tmpArr[2];
                        
                        [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"share_success_qianghongbao?sid=%@",SharedAppDelegate.hongbaoID] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
                            if ([successData[@"api_code"] intValue]==200)
                            {
                                if (SharedAppDelegate.currentUserID!=nil) {
                                    if ([SharedAppDelegate.userModel.user.id isEqualToString:SharedAppDelegate.currentUserID])
                                    {
                                        if (SharedAppDelegate.currentBalance!=nil) {
                                            SharedAppDelegate.userModel.user.balance=SharedAppDelegate.currentBalance;
                                            [self updateSelfBalance:SharedAppDelegate.currentBalance andSendid:tmpArr[2]];
                                            if (successData[@"api_msg"]!=nil) {
                                                [[HudHelper hudHepler]showShortTips:SharedAppDelegate.window tips:successData[@"api_msg"]];
                                            } else {
                                                [[MessageHelper messageHelper] showSuccessMessage:self title:@"恭喜" sub:[NSString stringWithFormat:@"抢到了%@%@",[tmpArr objectAtIndex:1],[self moneyname]]];
                                            }
                                        }
                                    }
                                }
                            }
                        }];
                    }
                }
            }
//            else
//            {
//                // 显示别人抢了多少红包
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                  [[MessageHelper messageHelper] showSuccessMessage:self title:@"" sub:[NSString stringWithFormat:@"%@\n抢到了%@%@",[tmpArr objectAtIndex:0],[tmpArr objectAtIndex:1],[self moneyname]]];
//                });
//            }
        }
        else if ([doAction isEqualToString:@"UAA"]) {//被相同账户顶替
            [self UAA];
        }
    }
    else if ([method isEqualToString:@"richTxt"]) {
        NSMutableArray *arr = [[args SafeObject:@"content"] mutableCopy];
        if (![arr isKindOfClass:[NSArray class]]) {
            return;
        }
        CustomElemModel *elemModel = [[CustomElemModel alloc] init];
        elemModel.type = IM_TYPE_CHOU_MSG;
        elemModel.content = arr;
        
        YYTCShowLiveMsg *message=[[YYTCShowLiveMsg alloc] initWithCustom:user message:elemModel];
        [self.msgView insertTCShowMsg:message andLeft:NO andisMsg:YES];
    }
    else if ([method isEqualToString:@"getMessage"]) {
        NSString *from=[args SafeObject:@"chatuserinfo"];
        if ([from isEqualToString:@""]) {
            return;
        }
        NSString *msg=[args SafeObject:@"msg"];
        //7.17 新增图标
        NSString*uimg=[args SafeObject:@"uimg"];
        NSString*uimgh=[args SafeObject:@"uimgh"];
        NSString*isscret=[args SafeObject:@"state"];// 神秘人隐身
        //显示消息的时候解码
        msg=[ReplaceEmoji decode:msg];
        NSArray *fromarr=[from componentsSeparatedByString:@"-"];
        NSString *from_starlevel;
        if ([fromarr count]>=5)
        {
            from_starlevel=[fromarr objectAtIndex:2];
        }
        else{
            from_starlevel=@"0";
        }
        CustomElemModel *elemModel = [[CustomElemModel alloc]init];
        elemModel.type  = IM_TYPE_CHAT_MSG;
        elemModel.s_uid = [fromarr objectAtIndex:0];
        elemModel.extra=msg;
        elemModel.s_nick =[fromarr objectAtIndex:1];
        elemModel.s_level=from_starlevel;
        elemModel.guizu = [args SafeObject:@"guizhu"];
        elemModel.chat_bg_color = [args SafeObject:@"chat_bg_color"];
        //7.17 增加图标
        if (![self isBlankString:uimg]) {
            elemModel.uimg=uimg;
            elemModel.uimgh=uimgh;
        }
        user=[[UserInfoModel alloc] init];
        user.nickname=elemModel.s_nick;
        user.id=elemModel.s_uid;
        YYTCShowLiveMsg *message=[[YYTCShowLiveMsg alloc] initWithCustom:user message:elemModel];
        if ([isscret isEqualToString:@"hide"])//10.11 神秘人
        {
            elemModel.s_nick =@"神秘人";
            message.ishide=YES;
        }
        else{
            elemModel.s_nick =[fromarr objectAtIndex:1];
            message.ishide=NO;
        }
        if ([[fromarr objectAtIndex:0] isEqualToString:showerUserid]) {
            message.ishost=YES;
        }
        [self.msgView insertTCShowMsg:message andLeft:NO andisMsg:YES];
        if (self.chatRecordView) {
            [self.chatRecordView.chatRecordMessageView insertTCShowMsg:message andLeft:YES andisMsg:YES];
        }
    }
    else if ([method isEqualToString:@"getPrivateMessage"]) {
        NSString *from=[args SafeObject:@"chatuserinfo"];
        if ([from isEqualToString:@""]) {
            return;
        }
        NSArray *fromarr=[from componentsSeparatedByString:@"-"];
        NSString *from_starlevel;
        if ([fromarr count]>=6) {
            from_starlevel=[fromarr objectAtIndex:5];
        }
        else{
            from_starlevel=@"0";
        }
    }
    //这里不处理bye
    else if([method isEqualToString:@"bye"]){
        NSString *userid=[args SafeObject:@"userid"];
        if ([userid isEqualToString:@""]) {
            return;
        }
       else {//有人离开修改此时的房间人数
           NSString *currentOnline=[args SafeObject:@"totalpeople"];

           NSString *onlineStr;
           if ([currentOnline integerValue] > 1000) {
               onlineStr = [NSString stringWithFormat:@"%dk",[currentOnline intValue]/1000];
           } else {
               onlineStr = [NSString stringWithFormat:@"%d",[currentOnline intValue]];
           }
           
           [_count setText:onlineStr];
           //1.24 新增贵宾人数
           NSString *guibin_num=[NSString stringWithFormat:@"%@",[args SafeObject:@"guibin_num"]];
           if (guibin_num!=nil) {
               self.guizuNum.text=guibin_num;
           }
           else
           {
               self.guizuNum.text=@"0";
           }
           
           NSString *guard_num=[NSString stringWithFormat:@"%@",[args SafeObject:@"guard_num"]];
           if (guard_num!=nil) {
               self.shouhuNum.text = [NSString stringWithFormat:@"粉丝团:%@",guard_num];
           }
           else
           {
               self.shouhuNum.text=@"粉丝团:0";
           }
        }
        [self bye:[userid intValue]];
    }
    else if([method isEqualToString:@"announce"]){
        NSString *cmd=[args SafeObject:@"msg"];
        NSString *isscret=[args SafeObject:@"state"];// 神秘人隐身
        NSArray *arr=[cmd componentsSeparatedByString:@",|"];
        
        NSString *msg=[arr SafeObjectAt:1];
        //2.14  显示消息的时候解码
        msg=[ReplaceEmoji decode:msg];
        NSData *tmpdata=[msg dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",tmpdata);
        if ([msg isEqualToString:@""]) {
            return;
        }
        if (isClearPing) {
            return;
        }
        //喇叭弹幕
        grounderChatModel.userid=arr[3];
        grounderChatModel.type = @"100";
        grounderChatModel.name = [arr objectAtIndex:2];
        grounderChatModel.bg=[NSString stringWithFormat:@"%@/img/lvv2/sfmbg/%@",IMAGEAPI,[args SafeObject:@"bg"]];
        grounderChatModel.fontColors=[args SafeObject:@"colors"];
        grounderChatModel.color=[args SafeObject:@"color"];
        grounderChatModel.pos=[args SafeObject:@"pos"];
        grounderChatModel.staytime=[args SafeObject:@"staytime"];
        grounderChatModel.pr=[args SafeObject:@"pr"];
        grounderChatModel.pl=[args SafeObject:@"pl"];
        grounderChatModel.fontSize=[args SafeObject:@"size"];
        grounderChatModel.avatar_size=[args SafeObject:@"asize"];
        grounderChatModel.avatar_x=[args SafeObject:@"aleft"];
        grounderChatModel.avatar_y=[args SafeObject:@"atop"];
        grounderChatModel.sizetop=[args SafeObject:@"sizetop"];
        grounderChatModel.scale9_top=[args SafeObject:@"9t"];
        grounderChatModel.scale9_bottom=[args SafeObject:@"9b"];
        grounderChatModel.scale9_left=[args SafeObject:@"9l"];
        grounderChatModel.scale9_right=[args SafeObject:@"9r"];
        
        grounderChatModel.version = [args SafeObject:@"version"];
        if ([[args SafeObject:@"content"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in [args SafeObject:@"content"]) {
                SFMContentModel *model = [[SFMContentModel alloc] initWithDictionary:dict error:nil];
                [temp addObject:model];
            }
            grounderChatModel.content = [temp mutableCopy];
        }
        
        grounderChatModel.content_left = [args SafeObject:@"content_left"];
        grounderChatModel.content_right = [args SafeObject:@"content_right"];
        grounderChatModel.screen_height=[NSNumber numberWithFloat:self.ChatManageView.frame.origin.y];
        grounderChatModel.screen_top = [NSNumber numberWithFloat:self.taskBGView.y + self.taskBGView.height];
        //2017.12.7 添加跳转的房间
        grounderChatModel.toroomnumber=[args SafeObject:@"toroomnumber"];
        ///6.14
        NSNumber *currentTime=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
        grounderChatModel.headImage=[[ToolHelper toolHelper] realAvatarUrl:arr[3] andUpdate:[currentTime stringValue]];
        grounderChatModel.title = [NSString stringWithFormat:@"%@",msg];
        grounderChatModel.imgscale=[args SafeObject:@"imgscale"];
        if (self.chatPush==NO) {
            self.flyView=[[PublicChatView alloc] init];
            self.flyView.delegate=self;
            if ([isscret isEqualToString:@"hide"]) {
                self.flyView.isSecret=YES;
            }
            else{
                self.flyView.isSecret=NO;
            }
            [self.flyView setContent:grounderChatModel];
            [self.liveShowView addSubview:self.flyView];
        }
        NSString *fromid=[arr objectAtIndex:3];
        NSString *str =[arr objectAtIndex:0];
        NSString *roomnum =[str substringFromIndex:3];
        //18.7.16修改
        if (arr.count>6) {
            NSString *shower_point=[arr objectAtIndex:6];
//            NSString *liushui_point=[arr objectAtIndex:9];
//            [self updateShowerPoint:liushui_point andSendroom:roomnum];
        }
//        if (arr.count>9) {
//            NSString *liushui_point=[arr objectAtIndex:9];
//            [self updateShowerPoint:liushui_point andSendroom:roomnum];
//        }
//        if (arr.count>10) {
//            if ([roomnum isEqualToString:roomnumber]) {
//                NSString *jifen_point = [arr objectAtIndex:10];
//                [self updateJiFenPoint:jifen_point];
//            }
//        }
        /// 3.29 sender_balance
        if (arr.count>5) {
            NSString *sender_balance=[arr objectAtIndex:5];
            [self updateSelfBalance:sender_balance andSendid:fromid];
        }
    }
    else if([method isEqualToString:@"sendGiftResult"]){
        NSString *cmd=[args SafeObject:@"r"];
        if ([cmd isEqualToString:@""]) {
            return;
        }
        if ([[args SafeObject:@"roadpoints"] isKindOfClass:[NSString class]] && [[args SafeObject:@"roadpoints"] isEqualToString:@""]) {
            roadpointsArr=[@[] mutableCopy];
        } else {
            roadpointsArr=[args SafeObject:@"roadpoints"];
        }
        //7.17 新增图标  ============
        uimgStr=[args SafeObject:@"uimg"];
        uimghStr=[args SafeObject:@"uimgh"];
        NSString*isscret=[args SafeObject:@"state"];// 神秘人隐身
        NSString *msg=@"";
        NSArray *arr=[cmd componentsSeparatedByString:@",|"];
        if (arr.count<=0) {
            return;
        }
        NSString *substr=[arr objectAtIndex:0];
        NSString *command;
        if (substr.length>=3) {
            command=[substr substringToIndex:3];
        } //添加判断容错
        NSString *action_roomnumber=[substr substringFromIndex:3];
        
        if ([arr count]>5) {
            NSString *fromid=[arr objectAtIndex:5];
            NSArray *tmp=[fromid componentsSeparatedByString:@"-"];
            fromid=[tmp objectAtIndex:0];
            
        }
        if([command isEqualToString:@"SFM"]){//飞屏
            if (isClearPing) {// 清屏了
                return;
            }
            if (isHideFlyPing) {
                return;
            }
            if(arr.count>0){
               msg=[arr objectAtIndex:1];
            }
            //2.14  显示消息的时候解码
            msg=[ReplaceEmoji decode:msg];
            
            if ([msg containsString:@"开通了守护"]) {
                [self initTotalView:@"&guard=1" type:0];
            }
            //普通弹幕
            NSString *from=[arr objectAtIndex:4];
            NSString *roomNum=[[arr objectAtIndex:0]substringFromIndex:3];
            NSString *fromid=[arr objectAtIndex:3];
            /// 3.29 余额
            //NSString *balance=[arr objectAtIndex:7];
            //  两行飞屏
            GrounderModel *grounderFPModel1 = [[GrounderModel alloc] init];
            grounderFPModel1.name=from;
            ///6.14
            NSNumber *currentTime=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
            grounderFPModel1.headImage=[[ToolHelper toolHelper] realAvatarUrl:fromid andUpdate:[currentTime stringValue]];
            //7.20 动画背景和持续时间
            grounderFPModel1.bg=[NSString stringWithFormat:@"%@/img/lvv2/sfmbg/%@",IMAGEAPI,[args SafeObject:@"bg"]];
            grounderFPModel1.userid=fromid;
            grounderFPModel1.type = @"200";
            grounderFPModel1.fontColors=[args SafeObject:@"colors"];
            grounderFPModel1.color=[args SafeObject:@"color"];
            grounderFPModel1.pos=[args SafeObject:@"pos"];
            grounderFPModel1.staytime=[args SafeObject:@"staytime"];
            grounderFPModel1.pr=[args SafeObject:@"pr"];
            grounderFPModel1.pl=[args SafeObject:@"pl"];
            grounderFPModel1.fontSize=[args SafeObject:@"size"];
            grounderFPModel1.avatar_size=[args SafeObject:@"asize"];
            grounderFPModel1.avatar_x=[args SafeObject:@"aleft"];
            grounderFPModel1.avatar_y=[args SafeObject:@"atop"];
            grounderFPModel1.sizetop=[args SafeObject:@"sizetop"];
            grounderFPModel1.scale9_top=[args SafeObject:@"9t"];
            grounderFPModel1.scale9_bottom=[args SafeObject:@"9b"];
            grounderFPModel1.scale9_left=[args SafeObject:@"9l"];
            grounderFPModel1.scale9_right=[args SafeObject:@"9r"];
            grounderFPModel1.version = [args SafeObject:@"version"];
            grounderFPModel1.sfm_info = [args SafeObject:@"sfm_info"];
            if ([[args SafeObject:@"content"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *temp = [NSMutableArray array];
                for (NSDictionary *dict in [args SafeObject:@"content"]) {
                    SFMContentModel *model = [[SFMContentModel alloc] initWithDictionary:dict error:nil];
                    [temp addObject:model];
                }
                grounderFPModel1.content = [temp mutableCopy];
            }
            
            grounderFPModel1.content_left = [args SafeObject:@"content_left"];
            grounderFPModel1.content_right = [args SafeObject:@"content_right"];
            grounderFPModel1.screen_height=[NSNumber numberWithFloat:self.ChatManageView.frame.origin.y - self.taskBGView.frame.origin.y - self.taskBGView.height];
            grounderFPModel1.screen_top = [NSNumber numberWithFloat:self.taskBGView.y + self.taskBGView.height];
            //2017.12.7 添加跳转的房间
            grounderFPModel1.toroomnumber=[args SafeObject:@"toroomnumber"];
            grounderFPModel1.imgscale=[args SafeObject:@"imgscale"];
            grounderFPModel1.title = [NSString stringWithFormat:@"%@",msg];
            
            if (self.appDelegate.otherSFMArray.count > 10 && [grounderFPModel1.version intValue] == 2) {
                BOOL back = NO;
                back = arc4random()%10 == 1;
                if (back) {
                    NSLog(@"飞屏丢了");
                    return;
                }
            }
            if ([args.allKeys containsObject:@"giftinfo"]) {
                NSDictionary *giftinfo = [args SafeObject:@"giftinfo"];
                NSString *from_room=[args SafeObject:@"from_room"];
                if (![from_room isEqualToString:roomnumber]) {
                    NSString *giftid = giftinfo[@"giftid"];
                    NSString *giftflash = giftinfo[@"giftflash"];
                    NSString *filename = giftinfo[@"filename"];
                    NSString *newpwd = giftinfo[@"newpwd"];
                    NSString *version = giftinfo[@"version"];
                    if ([giftflash containsString:@"swf"]||[giftflash containsString:@"svga"]||[giftflash containsString:@"mp4"]){
                        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:giftid,@"giftid",[NSString stringWithFormat:@"%@/static_data/gift/%@",IMAGEAPI,[NSString stringWithFormat:@"%@.zip?%@",giftid,version]],@"url",version,@"version",newpwd,@"newpwd",filename,@"filename", nil];
                        [self showAni:params];
                    }
                }
            }
            
//            if ([grounderFPModel1.version intValue] == 3) {
//                BOOL isBool = arc4random()%2;
//                if (isBool) {
//                    grounderFPModel1.version = @"4";
//                    grounderFPModel1.pos = [NSString stringWithFormat:@"%ld",[grounderFPModel1.pos integerValue]+20];
//                }
//            }
//
            
            if ([grounderFPModel1.version intValue] == 3) {
                BOOL isFirst = NO;
                if (!self.flyawardView) {
                    self.flyawardView = [[PublicChatView alloc] init];
                    self.flyawardView.delegate=self;
                    [self.flyawardView setContent:grounderFPModel1];
                    [self belowSubView:self.ChatManageView withView:self.flyawardView];
                    isFirst = YES;
                }
                if ([AppDelegate appDelegate].winningSFMArray.count == 0 && isFirst) {
                    isFirst = NO;
                } else {
                    if (self.flyawardView.hidden || !self.flyawardView.superview) {
                        [self.flyawardView setContent:grounderFPModel1];
                        [self belowSubView:self.ChatManageView withView:self.flyawardView];
                        
                        self.flyawardView.hidden = NO;
                    } else {
                        NSLog(@"playSFMAnimation add version = %@",grounderFPModel1.version);
                        [self.appDelegate.winningSFMArray addObject:grounderFPModel1];
                    }
                }
            } else if ([grounderFPModel1.version intValue] == 4) {
                BOOL isFirst = NO;
                if (!self.flyawardView2) {
                    self.flyawardView2 = [[PublicChatView alloc] init];
                    self.flyawardView2.delegate=self;
                    [self.flyawardView2 setContent:grounderFPModel1];
                    [self belowSubView:self.ChatManageView withView:self.flyawardView2];
                    
                    isFirst = YES;
                }
                if ([AppDelegate appDelegate].winningSFMArray2.count == 0 && isFirst) {
                    isFirst = NO;
                } else {
                    if (self.flyawardView2.hidden || !self.flyawardView2.superview) {
                        [self.flyawardView2 setContent:grounderFPModel1];
                        [self belowSubView:self.ChatManageView withView:self.flyawardView2];
                        
                        self.flyawardView2.hidden = NO;
                    } else {
                        NSLog(@"playSFMAnimation add version = %@",grounderFPModel1.version);
                        [self.appDelegate.winningSFMArray2 addObject:grounderFPModel1];
                    }
                }
            } else if ([grounderFPModel1.version intValue] == 5) {
                BOOL isFirst = NO;
                if (!self.flyawardView3) {
                    self.flyawardView3 = [[PublicChatView alloc] init];
                    self.flyawardView3.delegate=self;
                    [self.flyawardView3 setContent:grounderFPModel1];
                    [self belowSubView:self.ChatManageView withView:self.flyawardView3];
                    
                    isFirst = YES;
                }
                if ([AppDelegate appDelegate].winningSFMArray3.count == 0 && isFirst) {
                    isFirst = NO;
                } else {
                    if (self.flyawardView3.hidden || !self.flyawardView3.superview) {
                        [self.flyawardView3 setContent:grounderFPModel1];
                        [self belowSubView:self.ChatManageView withView:self.flyawardView3];
                        
                        self.flyawardView3.hidden = NO;
                    } else {
                        NSLog(@"playSFMAnimation add version = %@",grounderFPModel1.version);
                        [self.appDelegate.winningSFMArray3 addObject:grounderFPModel1];
                    }
                }
            } else {
                
                if (self.chatPush==NO) {
                    
                    NSString *str = @"";
                    if (grounderFPModel1.content.count > 0) {
                        NSArray *content = grounderFPModel1.content;
                        SFMContentModel *contentModel = content.lastObject;
                        str = contentModel.text;
                    }
                    NSString *title = [NSString stringWithFormat:@"%@%@",grounderFPModel1.title,str];
                    if (![self.appDelegate.otherSFMArray containsObject:title]) {
                        [self.appDelegate.otherSFMArray addObject:title];
//                        NSLog(@"飞屏新增：version = 2 %@",title);
                    } else {
//                        NSLog(@"飞屏重复：version = 2 %@",title);
                        return;
                    }
                    
                    self.flyView=[[PublicChatView alloc] init];
                    if ([isscret isEqualToString:@"hide"]) {
                        self.flyView.isSecret=YES;
                    }
                    else{
                        self.flyView.isSecret=NO;
                    }
                    grounderFPModel = grounderFPModel1;
                    [self.flyView setContent:grounderFPModel1];
                    self.flyView.delegate=self;
                    [self.liveShowView addSubview:self.flyView];
                }
            }
            
            if (arr.count>6) {
                NSString *shower_point=[arr objectAtIndex:6];
                
//            }
//            if (arr.count>9) {
//                NSString *liushui_point=[arr objectAtIndex:9];
//                [self updateShowerPoint:liushui_point andSendroom:roomNum];
//            }
//            if (arr.count>10) {
//                if ([roomNum isEqualToString:roomnumber]) {
//                    NSString *jifen_point = [arr objectAtIndex:10];
//                    [self updateJiFenPoint:jifen_point];
//                }
            }
            if (arr.count>5) {
             NSString *sender_balance=[arr objectAtIndex:5];
             [self updateSelfBalance:sender_balance andSendid:fromid];
            }
        }
        else if([command isEqualToString:@"SAN"]){//公告
            if (arr.count>1) {
               msg=[arr objectAtIndex:1];
            }
        }
        else if([command isEqualToString:@"SYS"]){//公告
            if (arr.count>1) { //6.19 修改
                msg=[arr objectAtIndex:1];
                //18.7.10修改
                if (arr.count>2){
                    if ([arr[2] isEqualToString:@"1"]) {
                        UIAlertController *AlertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                        [AlertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        }]];
                        [self presentViewController:AlertView animated:YES completion:nil];
                        return;
                    }
                }
                
                YYTCShowLiveMsg *message=[[YYTCShowLiveMsg alloc] initWithMessage:msg];
                message.jump_url = [args SafeObject:@"jump_url"];
                message.jump_name = [args SafeObject:@"btn_name"];
//                message.customElemModel = elemModel;
                [self.msgView insertTCShowMsg:message andLeft:NO andisMsg:YES];
            }
        }
        else if([command isEqualToString:@"SKK"]){//红包
            
        }
        else if([command isEqualToString:@"END"]){
            
            [self END];//被管理员关闭
        }
        else if([command isEqualToString:@"FLY"]){
            if (arr.count>0) {
                msg=[arr objectAtIndex:1];
            }
        }
        else if([command isEqualToString:@"MOV"]){
            
        }
        else if([command isEqualToString:@"SGG"]){//送礼
            if (isClearPing) { // 清屏了
                return;
            }
            if (arr.count<=0) {
                return;
            }
            getgift_sid++;
            NSString *num=[arr objectAtIndex:2];
            NSString *fromid=[arr objectAtIndex:5];
            NSArray *tmp=[fromid componentsSeparatedByString:@"-"];
            fromid=[tmp objectAtIndex:0];
            
            if (tmp.count<2) { //18.7.31 添加
                return;
            }
            NSString *from_richlevel=[tmp objectAtIndex:1];
            if ([fromid isEqualToString:self.appDelegate.userModel.user.id]) {
                if ([from_richlevel intValue] > [self.appDelegate.userModel.user.rank_id intValue]) {
                    // 送礼消息中带上的送礼等级大于之前接口获取到的送礼等级时刷新礼物界面，解除🔒的状态
                    self.appDelegate.userModel.user.rank_id = from_richlevel;
                }
            }
            NSString *from_usernumber=[tmp objectAtIndex:5];
            NSString *from=[arr objectAtIndex:6];
            NSString *award=[arr objectAtIndex:7];
            NSArray *award_tmp=[award componentsSeparatedByString:@"|"];
            NSString *award_mulit=award_tmp[0];
            NSString *toid=[arr objectAtIndex:3];
            tmp=[toid componentsSeparatedByString:@"-"];
            toid=[tmp objectAtIndex:0];
            NSString *to=[arr objectAtIndex:4];
            NSString *giftid=[arr objectAtIndex:8];
            NSString *giftflash=[arr objectAtIndex:9];
            NSString *giftcate=[arr objectAtIndex:10];
            NSString *sender_balance=[arr objectAtIndex:13];
            NSString *shower_point=[arr objectAtIndex:14];
            NSString *liushui_point;
            NSString *jifen_point;
            
            if ([wishGiftidArr containsObject:giftid]) {
                // 礼物id = 心愿单礼物id 那么就更下心愿单数量
                [self getTaskInfo];
            }
            
            if ([game_xj_giftid intValue] == [giftid intValue] && [self.appDelegate.userModel.user.id isEqualToString:fromid]) {
                // 星际礼物 要告知h5 刷新
                if (gameWebView) {
                    [gameWebView evaluateJavaScript:@"getBalance()" completionHandler:^(id _Nullable, NSError * _Nullable error) {
                                            
                    }];
                }
            }
            
            if (arr.count > 25) {
                liushui_point=[arr objectAtIndex:25];
            }
            if (arr.count > 26) {
                jifen_point=[arr objectAtIndex:26];
            }
            //NSString *getter_balance=[arr objectAtIndex:15];
            //2017.12.12 最终的余额
            NSString *getter_balance=@"";
            if ([arr count]>16) {
            getter_balance=[arr objectAtIndex:16];
            }
            //是送给主播的话，才更新主播的point
            if([showerUserid isEqualToString:toid]){
                [self updateShowerPoint:shower_point];
//                if (liushui_point) {
//                    [self updateShowerPoint:liushui_point];
//                }
                [self updateJiFenPoint:jifen_point];
            }
            [self updateSelfBalance:getter_balance andSendid:toid];
            [self updateSelfBalance:sender_balance andSendid:fromid];
            
            // 12.22 新增收费房间扣费判断
            if ([giftid isEqualToString:@"8001"]){
                return;
            }
            if ([giftid isEqualToString:@"570"]){ //1v1
                return;
            }
            if ([SharedAppDelegate.userModel.user.id isEqualToString:fromid]){
                self.isSendGift = YES;
                [self reduceBagListWithID:giftid andNum:[num intValue]];
            }
            //1031  显示xx给xx送礼
            CustomElemModel *elemModel = [[CustomElemModel alloc]init];
            elemModel.type  = IM_TYPE_GIFT;
            elemModel.s_uid = fromid;
            elemModel.s_nick =from;
            elemModel.t_uid = toid;
            elemModel.t_nick = to;
            elemModel.r_num = num;
            elemModel.r_id = giftid;
            elemModel.chat_bg_color = [args SafeObject:@"chat_bg_color"];
            //7.4 增加图标
            if (![self isBlankString:uimgStr]) {
                elemModel.uimg=uimgStr;
                elemModel.uimgh=uimghStr;
            }
            //判断当前时间
            elemModel.time =[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
            //用户等级
            elemModel.s_level=from_richlevel;
            user=[[UserInfoModel alloc] init];
            user.nickname=elemModel.s_nick;
            user.id=elemModel.s_uid;
            YYTCShowLiveMsg *msg=[[YYTCShowLiveMsg alloc] initWithCustom:user message:elemModel];
            //显示主播图标
            if ([from_usernumber isEqualToString:roomnumber]) {
                msg.ishost=YES;
            }
            if ([isscret isEqualToString:@"hide"])//10.11 神秘人
            {
                elemModel.s_nick =@"神秘人";
                msg.ishide=YES;
            }
            else{
                elemModel.s_nick =from;
                msg.ishide=NO;
            }
//            [self.msgView insertTCShowMsg:msg];
            
            
            
            if([giftid isEqualToString:@"4"]){//刷新沙发
                
            }
            if(![action_roomnumber isEqualToString:[NSString stringWithFormat:@"%@",roomnumber]]){
                return;
            }
            GiftModel *getGiftModel = [[GiftModel alloc]initWithDictionary:[SharedAppDelegate.giftDic objectForKey:giftid] error:nil];
            BOOL isNewTuYa = NO;
            if ([giftcate isEqualToString:@"114"]) {
                if (roadpointsArr.count > 0 && [roadpointsArr[0] isKindOfClass:[NSDictionary class]]) {
                    isNewTuYa = YES;
                    for (NSDictionary *dict in roadpointsArr) {
                        GiftModel *giftModel = [[GiftModel alloc]initWithDictionary:[SharedAppDelegate.giftDic objectForKey:dict[@"giftid"]] error:nil];
                        
                        //1031  显示xx给xx送礼
                        CustomElemModel *elemModel = [[CustomElemModel alloc]init];
                        elemModel.type  = IM_TYPE_GIFT;
                        elemModel.s_uid = fromid;
                        elemModel.s_nick =from;
                        elemModel.t_uid = toid;
                        elemModel.t_nick = to;
                        elemModel.r_num = [dict SafeObject:@"giftnum"];
                        elemModel.r_id = giftModel.id;
                        elemModel.chat_bg_color = [args SafeObject:@"chat_bg_color"];
                        //7.4 增加图标
                        if (![self isBlankString:uimgStr]) {
                            elemModel.uimg=uimgStr;
                            elemModel.uimgh=uimghStr;
                        }
                        //判断当前时间
                        elemModel.time =[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
                        //用户等级
                        elemModel.s_level=from_richlevel;
                        user=[[UserInfoModel alloc] init];
                        user.nickname=elemModel.s_nick;
                        user.id=elemModel.s_uid;
                        YYTCShowLiveMsg *msg=[[YYTCShowLiveMsg alloc] initWithCustom:user message:elemModel];
                        //显示主播图标
                        if ([from_usernumber isEqualToString:roomnumber]) {
                            msg.ishost=YES;
                        }
                        if ([isscret isEqualToString:@"hide"])//10.11 神秘人
                        {
                            elemModel.s_nick =@"神秘人";
                            msg.ishide=YES;
                        }
                        else{
                            elemModel.s_nick =from;
                            msg.ishide=NO;
                        }
                        if ([args.allKeys containsObject:@"need_show"]) {
                            NSString *need_show=[args SafeObject:@"need_show"];
                            // 是否展示送礼消息  2表示幸运礼物
                            if (!([need_show intValue] == 2)) {
                                [self addMessage:msg]; // 2018.8.30  替换之前送礼的消息
                            }
                        } else {
                            [self addMessage:msg]; // 2018.8.30  替换之前送礼的消息
                        }
                        
                        
                        //播放礼物动画
                        GSPChatMessage *chatMessage = [[GSPChatMessage alloc] init];
                        chatMessage.text = [NSString stringWithFormat:@"%@个【%@】",@"1",giftModel.name];
                        chatMessage.senderChatID = fromid;
                        chatMessage.senderName = from;
                        SendGiftModel *sendGiftModel = [[SendGiftModel alloc] init];
                        sendGiftModel.isHaoHuaGift=YES;
                        NSNumber *currentTime=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
                        sendGiftModel.giftImage = [NSString stringWithFormat:@"%@%@",IMAGEAPI,giftModel.icon];
                        if ([isscret isEqualToString:@"hide"])//10.13 神秘人送礼
                        {
                            sendGiftModel.name =@"神秘人";
                            sendGiftModel.headImage = @"";
                            
                        }
                        else{
                            sendGiftModel.name = from;
                            sendGiftModel.headImage = [[ToolHelper toolHelper] realAvatarUrl:fromid andUpdate:[currentTime stringValue]];
                        }
                        sendGiftModel.toname = to;
                        sendGiftModel.giftName = giftModel.name;
                        sendGiftModel.giftCount = 1;
                        sendGiftModel.award_mulit=award_mulit;
                        sendGiftModel.giftId=giftModel.id;
                        sendGiftModel.attach=[[dict SafeObject:@"attach"] intValue];
                         [self playBackCartoonModel:sendGiftModel andMessage:chatMessage anHide:isscret];
                    }
                    [bigAnimationView customDrawWithRoadpoints:roadpointsArr];
                    
                    
                    
                } else {
                    [bigAnimationView customDrawWithImage:[NSString stringWithFormat:@"%@%@",IMAGEAPI,getGiftModel.icon] andRoadpoints:roadpointsArr];
                }
                
            }
            
            if (!isNewTuYa) {
                if ([args.allKeys containsObject:@"need_show"]) {
                    NSString *need_show=[args SafeObject:@"need_show"];
                    // 是否展示送礼消息  2表示幸运礼物
                    if (!([need_show intValue] == 2)) {
                        [self addMessage:msg]; // 2018.8.30  替换之前送礼的消息
                    }
                } else {
                    [self addMessage:msg]; // 2018.8.30  替换之前送礼的消息
                }
                
                if (![giftflash isKindOfClass:[NSString class]]) { //6.25 添加
                    return;
                }
    //            if (giftflash.length<=3) {
    //                return;
    //            }
                BOOL isHaoHuaGift = NO;
                if ([giftflash containsString:@"swf"]||[giftflash containsString:@"svga"]||[giftflash containsString:@"mp4"]){
                    isHaoHuaGift=YES;
                }
                NSString *version=getGiftModel.uptime;
                NSString *newpwd=getGiftModel.newpwd;//8.14礼物解压新密码
                NSString *filename=getGiftModel.filename;//8.17礼物新id
                if ([self isBlankString:filename]) {
                    filename =@"-100";
                }
                if ([self isBlankString:newpwd]) {
                    newpwd =@"0";
                }
                if([version isKindOfClass:[NSNull class]] || [version isEqualToString:@""]){
                    version=@"1";
                }
                if([giftflash isEqualToString:@"tietiao"]){
                    
                }else{
                    //播放礼物动画
                    GSPChatMessage *chatMessage = [[GSPChatMessage alloc] init];
                    chatMessage.text = [NSString stringWithFormat:@"%@个【%@】",@"1",getGiftModel.name];
                    chatMessage.senderChatID = fromid;
                    chatMessage.senderName = from;
                    SendGiftModel *sendGiftModel = [[SendGiftModel alloc] init];
                    sendGiftModel.isHaoHuaGift=isHaoHuaGift;
                    NSNumber *currentTime=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
                    sendGiftModel.giftImage = [NSString stringWithFormat:@"%@%@",IMAGEAPI,getGiftModel.icon];
                    if ([isscret isEqualToString:@"hide"])//10.13 神秘人送礼
                    {
                        sendGiftModel.name =@"神秘人";
                        sendGiftModel.headImage = @"";
                        
                    }
                    else{
                        sendGiftModel.name = from;
                        sendGiftModel.headImage = [[ToolHelper toolHelper] realAvatarUrl:fromid andUpdate:[currentTime stringValue]];
                    }
                    sendGiftModel.toname = to;
                    sendGiftModel.giftName = getGiftModel.name;
                    sendGiftModel.giftCount = [num integerValue]*[num integerValue];
                    sendGiftModel.award_mulit=award_mulit;
                    sendGiftModel.giftId=giftid;
                    sendGiftModel.giftVersion=version;
                    sendGiftModel.newpwd=newpwd;//2018.8.17
                    sendGiftModel.filename=filename;//2018.8.17
                    sendGiftModel.attach=[[args SafeObject:@"attach"] intValue];
                     [self playBackCartoonModel:sendGiftModel andMessage:chatMessage anHide:isscret];
                }
                if (isHaoHuaGift) {
                    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:giftid,@"giftid",[NSString stringWithFormat:@"%@/static_data/gift/%@",IMAGEAPI,[NSString stringWithFormat:@"%@.zip?%@",giftid,version]],@"url",version,@"version",newpwd,@"newpwd",filename,@"filename", nil];
                    [self showAni:params];
                }
            }
        }
    }
    else if([method isEqualToString:@"sendGiftFail"]){
        NSString *jsonString=[args SafeObject:@"msg"];
        if ([jsonString isEqualToString:@""]) {
            return;
        }
          //1.16修改
        if ([jsonString isEqualToString:@"1"]) {
           [[HudHelper hudHepler]showShortTips:self.view tips:@"可能是余额不足，请充值后再试"];
        }
        else
        {
           [[HudHelper hudHepler]showShortTips:self.view tips:jsonString];
        }
    }
    else if([method isEqualToString:@"sendKickbackFail"]){
        [[MessageHelper messageHelper] showWarnMessage:self title:@"无法点亮" sub:@"在线时间越长得到点亮机会越多哦"];
    }
}


- (void)addMaskView:(CGFloat)y
{
    _maskView =[[PKMaskView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT)];
}


- (void)showNoGuiZuAlertViewWithMsg:(NSString *)massag
{
    //提示
    UIAlertController *guiZuAlertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:massag preferredStyle:UIAlertControllerStyleAlert];
    [guiZuAlertView addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self exitBtnAction:nil];
    }]];
    [guiZuAlertView addAction:[UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exitBtnAction:nil];
        NobleViewController *guizuVC=[[NobleViewController alloc] init];
        guizuVC.hidesBottomBarWhenPushed=YES;
        guizuVC.tabPush=NO;
        guizuVC.beginModel=self.beginLiveModel;
        [self.navigationController pushViewController:guizuVC animated:YES];
    }]];
    [self presentViewController:guiZuAlertView animated:YES completion:nil];
}

- (void)showAdmin_kickoutAlertViewWithMsg:(NSString *)msg
{
    [[MessageHelper messageHelper] showWarnMessage :self title:nil sub:msg];
    [self performSelector:@selector(exitBtnAction:) withObject:self afterDelay:1.0];
}
- (void)showShouFeiFailAlertViewWithMsg:(NSString *)msg
{
    UIAlertController *shouFeiAlertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [shouFeiAlertView addAction:[UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self exitBtnAction:nil];
    }]];
    
    [shouFeiAlertView addAction:[UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self rechargeBtnAction];
    }]];
    [self presentViewController:shouFeiAlertView animated:YES completion:nil];
}

//3.23 修改
#pragma mark 送礼和收礼修改自己的币
-(void)updateSelfBalance:(NSString *)value andGetBalance:(NSString *)balance andSendid:(NSString *)sendid{
    //如果是自己就更新balance
    if ([SharedAppDelegate.userModel.user.id isEqualToString:sendid])
    {
//        if ([value intValue]>10000)
//        {
//            NSString *ticket=[NSString stringWithFormat:@"%@万",[self notRounding:[value doubleValue]/10000.f afterPoint:2]];
//            if ([value intValue]>100000000)
//            {
//                NSString *ticket=[NSString stringWithFormat:@"%@亿",[self notRounding:[value doubleValue]/100000000.f afterPoint:2]];
//            }
//        }
//        else
//        {
//        }
        self.moneyLab.text = [NSString stringWithFormat:@"剩余%@：%@",[self moneyname],value];
        SharedAppDelegate.userModel.user.balance=value;
    }
    else
    {
        int endBalance=[balance intValue];
        NSString*selfBalance=SharedAppDelegate.userModel.user.balance;
        NSString * jinbi=[NSString stringWithFormat:@"%d",endBalance+[selfBalance intValue]];
//        if ([jinbi intValue]>10000)
//        {
//            NSString *ticket=[NSString stringWithFormat:@"%@万",[self notRounding:[jinbi doubleValue]/10000.f afterPoint:2]];
//            if ([jinbi intValue]>100000000)
//            {
//                NSString *ticket=[NSString stringWithFormat:@"%@亿",[self notRounding:[jinbi doubleValue]/100000000.f afterPoint:2]];
//
//            }
//        }
//        else
//        {
//        }
        self.moneyLab.text = [NSString stringWithFormat:@"剩余%@：%@",[self moneyname],value];
        SharedAppDelegate.userModel.user.balance=jinbi;
    }
}
#pragma mark 修改自己的币
-(void)updateSelfBalance:(NSString *)value andSendid:(NSString *)sendid{
    //如果是自己就更新balance
    if ([SharedAppDelegate.userModel.user.id isEqualToString:sendid])
    {
//        if ([value intValue]>10000)
//        {
//            NSString *ticket=[NSString stringWithFormat:@"%@万",[self notRounding:[value doubleValue]/10000.f afterPoint:2]];
//            if ([value intValue]>100000000)
//            {
//                NSString *ticket=[NSString stringWithFormat:@"%@亿",[self notRounding:[value doubleValue]/100000000.f afterPoint:2]];
//
//            }
//        }
//        else
//        {
//        }
        self.moneyLab.text = [NSString stringWithFormat:@"剩余%@：%@",[self moneyname],value];
        SharedAppDelegate.userModel.user.balance=value;
    }
}




#pragma mark 修改主播的ticket
-(void)updateShowerPoint:(NSString *)value{
    //11.22 添加判断来进行页面上银票的展示
    //3.7 当银票数量大于1万时 显示x万
    [self showThePiao:self.ticket With:value];//票数
    // 送礼之后的银票数赋值给lastTicket 为了最后的计算
    self.lastTicket =[value intValue];
    //如果是自己就更新balance
//    if ([SharedAppDelegate.userModel.user.id isEqualToString:showerUserid]) {
//        SharedAppDelegate.userModel.user.ticket=value;
//    }
}

-(void)updateShowerPoint:(NSString *)value andSendroom:(NSString *)room{
    //如果是自己所在房间就更新balance
    if ([room isEqualToString:roomnumber]) {
        [self showThePiao:self.ticket With:value];//票数
        // 发送弹幕之后的银票数赋值给lastTicket 为了最后的计算
        self.lastTicket =[value intValue];
    }
}

- (void)updateJiFenPoint:(NSString *)value {
    if ([self.appDelegate.userModel.user.id isEqualToString:showerUserid]) {
        if ([value intValue]>10000)
        {
            NSString *ticket=[NSString stringWithFormat:@"当前%@:%@W",[self jiFenNum],[self notRounding:[value doubleValue]/10000 afterPoint:2]];
        }else {
        }
        SharedAppDelegate.userModel.user.ticket=value;
    }
}

-(void)sendKickback{

    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    NSString *method = @"sendKickback";
    [args setObject:[NSNumber numberWithInt:[showerUserid intValue]] forKey:@"touserid"];
    [socket invoke:method withArgs:args];
}
// 「微信支付直接送礼」路径已彻底移除（App Store 3.1.1 / 5.6：绕 IAP 的第三方充值送礼）。
// 原 charge/wx/ios 接口调用 + PayReq 微信 SDK 支付整段删除，无调用点。送礼主流程走 socket 扣余额。
-(void)sendGift:(int)giftid andgiftNum:(int)giftnum andGiftPrice:(NSString *)giftprice
{
}

-(void)sendGiftF:(int)giftid andLianSongNum:(int)giftliansongnum andUserid:(NSString *)userid{
    UserInfoModel *m=[[UserInfoModel alloc] init];
    m.id=userid;
    giftUserModel=m;
    [self sendGiftF:giftid andLianSongNum:giftliansongnum];
}
//送礼
-(void)sendGiftF:(int)giftid andLianSongNum:(int)giftliansongnum
{
    
}
//rtmp 连接成功
-(void)connectedEvent {
    NSLog(@"rtmp server connected");
    NSString *nickname=SharedAppDelegate.userModel.user.nickname;
    NSString *token=SharedAppDelegate.userModel.token;
    NSString *usernumber=SharedAppDelegate.userModel.user.haoma;
    NSString *userid=SharedAppDelegate.userModel.user.id;
    if(nickname==nil || [nickname isEqualToString:@""]){
        nickname=@"iPhone游客";;
        token=@"";
        usernumber=0;
        userid=@"0";
    }
    //    开播之前昵称要转义 解决昵称中带空格不能开播的问题
    nickname=[nickname stringByReplacingOccurrencesOfString:@" " withString:@"\20"];
    NSMutableDictionary *param=[[NSMutableDictionary alloc] initWithCapacity:0];
    [param setValue:roomnumber forKey:@"roomnumber"];
    [param setValue:nickname forKey:@"nickname"];
    [param setValue:token forKey:@"token"];
    [param setValue:usernumber forKey:@"usernumber"];
    [param setValue:userid forKey:@"userid"];
    [param setValue:@"" forKey:@"botinfo"];
    [param setValue:@"" forKey:@"chatuserinfo"];
    [param setValue:@"1" forKey:@"version"];//5.31 添加
    if (self.chatPush==YES) {
        [param setValue:@"1" forKey:@"onetoone"];
    }
    else
    {
        [param setValue:@"0" forKey:@"onetoone"];
    }
    if (isInto) {
        // 检查下当前红包状态
        [self checkRedPackInfo];
    } else if (![roomnumber isEqualToString:self.appDelegate.userModel.user.haoma]) {
        [self checkRedPackInfo];
    }
    isInto = YES;
    
    [socket invoke:@"into" withArgs:param];
}
//rtmp 连接失败
-(void)connectFailedEvent:(int)code description:(NSString *)descriptio
{

}
//rtmp 断开
-(void)disconnectedEvent {
    
}
-(void)showAni:(NSDictionary *)dic{
    if(bigAnimationView){
        // 礼物特效层级调整
//        [bigAnimationView bringToFront];
        [bigAnimationView playgame:dic];
    }
}
///3.27 关闭送豪华礼物的声音
- (void)musicBtnAction:(UIButton *)btn
{
    [self.view makeToast:@"" duration:1 position:@""];
}
-(void)startCocos2d{
    //2018.4.4
    if(bigAnimationView!=nil){
        return;
    }
    bigAnimationView=[[SLGiftAnimationView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [bigAnimationView initAniView];
    bigAnimationView.isQueue=YES;
    bigAnimationView.aniPlaying=YES;//9.5 添加
    //8.28 修改
    bigAnimationView.isSwitchSoundOn=YES;
    if (self.pushSmallVideo==YES) { //2018.7.27 修改
        [self.view addSubview:bigAnimationView];
    }
    else{
        if ([self.appDelegate.userModel.user.haoma isEqualToString:self.beginLiveModel.anchor.haoma]) {
            if ([self.liveShowView.subviews containsObject:self.ChatManageView]) {
                NSInteger index = [self.liveShowView.subviews indexOfObject:self.ChatManageView];
                [self.liveShowView insertSubview:bigAnimationView atIndex:index];
            } else {
                [self.liveShowView insertSubview:bigAnimationView belowSubview:self.ChatManageView];
            }
        } else {
            if ([self.LayerView.subviews containsObject:self.ChatManageView]) {
                NSInteger index = [self.LayerView.subviews indexOfObject:self.ChatManageView];
                [self.LayerView insertSubview:bigAnimationView atIndex:index];
            } else {
                [self.LayerView insertSubview:bigAnimationView belowSubview:self.ChatManageView];
            }
            
            
            
//            [self.LayerView insertSubview:bigAnimationView belowSubview:self.ChatManageView];
        }
//        [self.liveShowView addSubview:bigAnimationView];
        
    }
//    [self.liveShowView bringSubviewToFront:bigAnimationView];
}
-(void)stopCocos2d{
    //4.12删除送礼的动画弹框  //2018.7.27 修改
    if (pos0) {
        pos0.showtime=0;
        [pos0 removeFromSuperview];
        pos0=nil;
    }
    if (pos1) {
        pos1.showtime=0;
        [pos1 removeFromSuperview];
        pos1=nil;
    }
    if (pos2) {
        pos2.showtime=0;
        [pos2 removeFromSuperview];
        pos2=nil;
    }
//    if (pos3) {
//        pos3.showtime=0;
//        [pos3 removeFromSuperview];
//        pos3=nil;
//    }
    if(bigAnimationView==nil){
        return;
    }
    // 8.30移除之前停掉动画
    [bigAnimationView stop];
    [bigAnimationView removeFromSuperview];
     bigAnimationView=nil;
}
//2018.1.19
#pragma mark - 初始化房间观众列表
- (void)initRoomUsers
{
    watchCollention.userInteractionEnabled=YES;
    watchCollention.scrollEnabled=YES;
    watchCollention.delegate=self;
    pageNum = 1;
    //获取直播间内成员列表
    __weak BaseLiveViewController *weakSelf = self;
    [[RootHttpHelper httpHelper] basicGETURL2:[NSString stringWithFormat:@"%@/iumobile/apis/index.php?action=getuserlist&roomnumber=%@&pagesize=10&page=%d",DATAAPI,roomnumber,pageNum] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        //NSLog(@"+++++++++++++请求到的数据: %@",successData);
        NSInteger code = [[successData objectForKey:@"code"] integerValue];
        if(code == 200)
        {
            [viewers removeAllObjects];
            for (NSDictionary *info in [successData objectForKey:@"user"]){
                UserInfoModel * infoModel = [[UserInfoModel alloc] init];
                infoModel.id=[info objectForKey:@"userid"];
                /// 2.14  用户的头像
                infoModel.avatar=[[ToolHelper toolHelper] realAvatarUrl:infoModel.id andUpdate:[info objectForKey:@"update_avatar_time"]];
                infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
                infoModel.nickname=[info objectForKey:@"nickname"];
                infoModel.total_ticket=[info objectForKey:@"totalpoint"];
                infoModel.total_send_gift=[info objectForKey:@"totalcost"];
                infoModel.hometown_city=[info objectForKey:@"city"];
                infoModel.gender=[info objectForKey:@"gender"];
                infoModel.haoma=[info objectForKey:@"usernumber"];
                infoModel.fans_num=@"0";
                infoModel.follow_num=@"0";
                infoModel.rank_id=[info objectForKey:@"richlevel"];
                infoModel.is_follow=@"0";
                infoModel.guizhu=[info objectForKey:@"guizhu"];
                infoModel.avatar_frame = [info objectForKey:@"avatar_frame"];
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval now=[dat timeIntervalSince1970] / 1000;
                infoModel.vip_util=[NSString stringWithFormat:@"%f",[[info objectForKey:@"viplevel"] intValue]*(now+10.0)];
                [viewers addObject:infoModel];
            }
//            [weakSelf reDrawUserList];
             onlineNum=[[successData objectForKey:@"num"] intValue];
            NSString *onlineStr;
            if (onlineNum > 1000) {
                onlineStr = [NSString stringWithFormat:@"%0.1fk",onlineNum/1000.0];
            } else {
                onlineStr = [NSString stringWithFormat:@"%d",onlineNum];
            }
            [_count setText:onlineStr];
        }
    }];
}

///2018.1.19  初始化贵族列表
#pragma mark - 初始化贵族列表
- (void)initGuiZuList
{
    //获取直播间内成员列表
    [[RootHttpHelper httpHelper] basicGETURL2:[NSString stringWithFormat:@"%@/iumobile/apis/index.php?action=getuserlist&guibin=1&roomnumber=%@&pagesize=100&page=1",DATAAPI,roomnumber] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        //NSLog(@"+++++++++++++请求到的数据: %@",successData);
        NSInteger code = [[successData objectForKey:@"code"] integerValue];
        [guizuArr removeAllObjects];
        if(code == 200)
        {
            for (NSDictionary *info in [successData objectForKey:@"user"]){
                NobleModel * infoModel = [[NobleModel alloc] init];
                infoModel.userid=[info objectForKey:@"userid"];
                infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
                infoModel.nickname=[info objectForKey:@"nickname"];
                infoModel.anum=[info objectForKey:@"anum"];
                infoModel.clantype=[info objectForKey:@"clantype"];
                infoModel.guizhu=[info objectForKey:@"guizhu"];
                infoModel.medalname=[info objectForKey:@"medalname"];
                infoModel.medalvalid=[info objectForKey:@"medalvalid"];
                infoModel.richlevel=[info objectForKey:@"richlevel"];
                infoModel.tietiao=[info objectForKey:@"tietiao"];
                infoModel.totalcost=[info objectForKey:@"totalcost"];
                infoModel.usernumber=[info objectForKey:@"usernumber"];
                infoModel.usertype=[info objectForKey:@"usertype"];
                infoModel.viplevel=[info objectForKey:@"viplevel"];
                [guizuArr addObject:infoModel];
            }
            if (self.guizuView) {
                [self.guizuView removeFromSuperview];
            }
            self.guizuView=[[BuyGuiZu alloc] initWithFrame:CGRectMake(31.5*ScreenBiLi, -375*ScreenBiLi, 312*ScreenBiLi, 397*ScreenBiLi) andGuiZuNum:self.guizuNum.text andRenQi:onlineNum andRoomnumber:roomnumber andArr:guizuArr];
            self.guizuView.delegate=self;
            [self.liveShowView addSubview:self.guizuView];
            [self.liveShowView bringSubviewToFront:self.guizuView];
            //春天动画
            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                self.guizuView.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            } completion:nil];
        }
    }];
}
//有新的观众进入
-(BOOL)addPeople:(UserInfoModel *)info{
    if(info==nil){
        return NO;
    }
    BOOL isExistOr=NO;
    for(UserInfoModel * i in viewers){
        if ([i.id isEqualToString:info.id]) {
            isExistOr=YES;
        }
    }
    if (!isExistOr) {
        [viewers addObject:info];
        //贵族
            {
                // 2018.1.19
                if ([userInfoModel.guizhu integerValue]<=0){
                    //vip已过期,设置排序值为等级
                    info.orderlevel=info.rank_id;
                    NewUserListItem *item=[[NewUserListItem alloc] initWithFrame:CGRectMake(nextUserItemX,0, 30, 30) andInfo:info andController:self];
                    [watchCollention addSubview:item];
                    nextUserItemX+=30+6;
                    [watchCollention setContentSize:CGSizeMake(nextUserItemX, 30)];
                }
                else{
                    //vip未过期，设置排序值为vip100+等级
                    info.orderlevel=[NSString stringWithFormat:@"%d",100+[info.rank_id intValue]];
                    //降序排列
                    [viewers sortUsingComparator:^NSComparisonResult(__strong id user1,__strong id user2){
                        return [((UserInfoModel *)user1).orderlevel intValue] < [((UserInfoModel *)user2).orderlevel intValue];
                    }];
//                    [self reDrawUserList];
                }
            }
        return YES;
    }
    return NO;
}
//2018.1.19请求用户列表
- (void)requestUserList
{
    if(nextUserItemX<watchCollention.frame.size.width){//最后一个头像小于滚动条宽度
        return;
    }
    if(isUserListLoading){
        return;
    }
    //正在加载数据
    isUserListLoading=YES;
    pageNum+=1;
    [[RootHttpHelper httpHelper] basicGETURL2:[NSString stringWithFormat:@"%@/iumobile/apis/index.php?action=getuserlist&roomnumber=%@&pagesize=10&page=%d",DATAAPI,roomnumber,pageNum] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        //NSLog(@"+++++++++++++请求到的数据: %@",successData);
        NSInteger code = [[successData objectForKey:@"code"] integerValue];
        isUserListLoading=NO;
        //是否有新数据
        BOOL haveNew=NO;
        if(code == 200)
        {
            for (NSDictionary *info in [successData objectForKey:@"user"]){
                haveNew=YES;
                UserInfoModel * infoModel = [[UserInfoModel alloc] init];
                infoModel.id=[info objectForKey:@"userid"];
                /// 2.14
                infoModel.avatar=[[ToolHelper toolHelper] realAvatarUrl:infoModel.id andUpdate:[info objectForKey:@"update_avatar_time"]];
                infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
                infoModel.nickname=[info objectForKey:@"nickname"];
                infoModel.total_ticket=[info objectForKey:@"totalpoint"];
                infoModel.total_send_gift=[info objectForKey:@"totalcost"];
                infoModel.hometown_city=[info objectForKey:@"city"];
                infoModel.gender=[info objectForKey:@"gender"];
                infoModel.haoma=[info objectForKey:@"usernumber"];
                infoModel.fans_num=@"0";
                infoModel.follow_num=@"0";
                infoModel.rank_id=[info objectForKey:@"richlevel"];
                infoModel.is_follow=@"0";
//                [viewers addObject:infoModel];
                
                //请求完之后加item
                NewUserListItem *item=[[NewUserListItem alloc] initWithFrame:CGRectMake(nextUserItemX,0, 30, 30) andInfo:infoModel andController:self];
                [watchCollention addSubview:item];
                nextUserItemX+=30+6;
            }
            if (haveNew) {
                [watchCollention setContentSize:CGSizeMake(nextUserItemX, 30)];
                CGPoint newPoint=[watchCollention contentOffset];
                //                改变contentOffSet
                newPoint.x+=19;
                [watchCollention setContentOffset:newPoint];
            }
        }
    }];
    
}
//安安静静的拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //安安静静的拖动，没有动画的情况下也要判断，有动画的情况交给DidEndDecelerating判断
    if (decelerate==NO && [scrollView isEqual:self.watchCollention]) {
        if([scrollView contentOffset].x>=([scrollView contentSize].width-scrollView.frame.size.width-10)){
            //加载下一页用户列表
            [self requestUserList];
        }
    }
}

//快速滑动完成时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.watchCollention]) {
        if([scrollView contentOffset].x>=([scrollView contentSize].width-scrollView.frame.size.width-10)){
            //加载下一页用户列表
            [self requestUserList];
            
        }
    }
}
//删除观众
-(void)delPeople:(int) deluserid{
    for (UserInfoModel *info in viewers){
        if ([info.id intValue]==deluserid)
        {
            [viewers removeObject:info];
//            [self reDrawUserList];
            break;
        }
    }
}
//重画人员列表
//todo:超过一定数量就不要画了
-(void)reDrawUserList{
    
    for (NewUserListItem *subview in watchCollention.subviews)
    {
        if ([subview isKindOfClass:[NewUserListItem class]]) {
            [subview removeAnimationView];
            [subview removeFromSuperview];
        } else {
            [subview removeFromSuperview];
        }
    }
    nextUserItemX=6;
    for (UserInfoModel *info in topUser){
        if (info) {
            NewUserListItem *item=[[NewUserListItem alloc] initWithFrame:CGRectMake(nextUserItemX,15, 30, 30) andInfo:info andController:self];
            [watchCollention addSubview:item];
            nextUserItemX+=30+6;
        }
    }
    [watchCollention setContentSize:CGSizeMake(nextUserItemX, 30)];
}

//有人离开直播间
-(void)bye:(int)userid{
    [self delPeople:userid];
}
//显示爱心
- (void)showTheCartoon
{
    HeartFlyView* heart = [[HeartFlyView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(SCREEN_WIDTH -  50, SCREEN_HEIGHT - 40);
    heart.center = fountainSource;
    [heart animateInView:self.view];
}
#pragma mack - 播放送礼物动画
- (void)playBackCartoonModel:(SendGiftModel *)sendGiftModel andMessage:(GSPChatMessage *)chatMessage anHide:(NSString *)hided
{
    //位置0正在播放这个人的这个礼物
    if (pos0&&[pos0.giftmodel.name isEqualToString:sendGiftModel.name] && [pos0.giftmodel.giftName isEqualToString:sendGiftModel.giftName] && [pos0.giftmodel.toname isEqualToString:sendGiftModel.toname]) {
        [pos0 shakeNumberLabelWithNum:sendGiftModel.attach andMulit:sendGiftModel.award_mulit];
        //pos0.showtime+=1;
        //本来是多送一个多显示1秒，现在改成延时4秒结束
         pos0.showtime=2.0;
    }
    //位置1正在播放这个人的这个礼物
    else if(pos1&&[pos1.giftmodel.name isEqualToString:sendGiftModel.name] && [pos1.giftmodel.giftName isEqualToString:sendGiftModel.giftName] && [pos1.giftmodel.toname isEqualToString:sendGiftModel.toname]) {
        [pos1 shakeNumberLabelWithNum:sendGiftModel.attach andMulit:sendGiftModel.award_mulit];
        //pos1.showtime+=1;
        //本来是多送一个多显示1秒，现在改成延时4秒结束
        pos1.showtime=2.0;
    }
    else if(pos2&&[pos2.giftmodel.name isEqualToString:sendGiftModel.name] && [pos2.giftmodel.giftName isEqualToString:sendGiftModel.giftName] && [pos2.giftmodel.toname isEqualToString:sendGiftModel.toname]) {
        [pos2 shakeNumberLabelWithNum:sendGiftModel.attach andMulit:sendGiftModel.award_mulit];
        //pos1.showtime+=1;
        //本来是多送一个多显示1秒，现在改成延时4秒结束
        pos2.showtime=2.0;
    }
//    else if(pos3&&[pos3.giftmodel.name isEqualToString:sendGiftModel.name] && [pos3.giftmodel.giftName isEqualToString:sendGiftModel.giftName] && [pos3.giftmodel.toname isEqualToString:sendGiftModel.toname]) {
//        [pos3 shakeNumberLabelWithNum:sendGiftModel.attach andMulit:sendGiftModel.award_mulit];
//        //pos1.showtime+=1;
//        //本来是多送一个多显示1秒，现在改成延时4秒结束
//        pos3.showtime=2.0;
//    }
    //都没在播放
    else{
        BOOL inQueue=NO;
        //判断是否在列队中
        for (PresentView *p in giftViews) {
            if ([p.giftmodel.name isEqualToString:sendGiftModel.name] && [p.giftmodel.giftName isEqualToString:sendGiftModel.giftName]) {
                inQueue=YES;
                //在列队中，更新数值
                [p shakeNumberLabelWithNum:sendGiftModel.attach andMulit:sendGiftModel.award_mulit];
            }
        }
        //不在列队中,创建
        if(!inQueue){
            pv=[[PresentView alloc] init];
            pv.showtime=showtime;
            pv.giftmodel=sendGiftModel;
            if ([hided isEqualToString:@"hide"])//10.13 神秘人送礼
            {
                pv.isHide=YES;
            }
            else{
                pv.isHide=NO;
            }
            [pv shakeNumberLabelWithNum:sendGiftModel.attach andMulit:sendGiftModel.award_mulit];
            [giftViews addObject:pv];
        }
    }
    [self redrawGift];
}
//重画礼物
-(void)redrawGift{
    CGRect rect=[UIScreen mainScreen].bounds;
    if (giftViews.count>0) {
        if(pos0==nil){
            pos0=[giftViews objectAtIndex:0];
            pos0.tag=showtime;
            if (self.pushSmallVideo==YES) {
                [pos0 setFrame:CGRectMake(-rect.size.width / 2, 100+20, rect.size.width / 2, 40)]; //y==240
                [self.view addSubview:pos0];
                
            }
            else
            {
                [pos0 setFrame:CGRectMake(-rect.size.width / 2, _zhenzhuCountView.frame.origin.y+_zhenzhuCountView.frame.size.height+90, rect.size.width / 2, 40)]; //y==240
                [self.liveShowView addSubview:pos0];
            }
            [pos0 animateWithCompleteBlock:^(BOOL finished, NSInteger finishCount) {}];
            [giftViews removeObjectAtIndex:0];
            //pos0=bg0;
            [pos0 addAwardLayerFromVar];
            if (delGiftTimer) {
                [delGiftTimer invalidate];
                delGiftTimer=nil;
            }
             delGiftTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delGiftInView) userInfo:nil repeats:YES];//5.29 修改
        }
        else if(pos1==nil){
            pos1=[giftViews objectAtIndex:0];
            pos1.tag=showtime;
            if (self.pushSmallVideo==YES) {
                [pos1 setFrame:CGRectMake(-rect.size.width / 2, 180+20, rect.size.width / 2, 40)];  //2.14  y==300
                [self.view addSubview:pos1];
            }
            else
             {
                [pos1 setFrame:CGRectMake(-rect.size.width / 2, _zhenzhuCountView.frame.origin.y+_zhenzhuCountView.frame.size.height+160, rect.size.width / 2, 40)];  //2.14  y==300
                [self.liveShowView addSubview:pos1];
             }
             [pos1 animateWithCompleteBlock:^(BOOL finished, NSInteger finishCount) {}];
             [giftViews removeObjectAtIndex:0];
            //pos1=bg1;
             [pos1 addAwardLayerFromVar];
            if (delGiftTimer) {
                [delGiftTimer invalidate];
                 delGiftTimer=nil;
            }
             delGiftTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delGiftInView) userInfo:nil repeats:YES];//5.29 修改
        }
        else if(pos2==nil){
            pos2=[giftViews objectAtIndex:0];
            pos2.tag=showtime;
            if (self.pushSmallVideo==YES) {
                [pos2 setFrame:CGRectMake(-rect.size.width / 2, 260+20, rect.size.width / 2, 40)];  //2.14  y==300
                [self.view addSubview:pos2];
            }
            else
             {
                [pos2 setFrame:CGRectMake(-rect.size.width / 2, _zhenzhuCountView.frame.origin.y+_zhenzhuCountView.frame.size.height+230, rect.size.width / 2, 40)];  //2.14  y==300
                [self.liveShowView addSubview:pos2];
             }
             [pos2 animateWithCompleteBlock:^(BOOL finished, NSInteger finishCount) {}];
             [giftViews removeObjectAtIndex:0];
            //pos1=bg1;
             [pos2 addAwardLayerFromVar];
            if (delGiftTimer) {
                [delGiftTimer invalidate];
                 delGiftTimer=nil;
            }
             delGiftTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delGiftInView) userInfo:nil repeats:YES];//5.29 修改
        }
//        else if(pos3==nil){
//            pos3=[giftViews objectAtIndex:0];
//            pos3.tag=showtime;
//            if (self.pushSmallVideo==YES) {
//                [pos3 setFrame:CGRectMake(-rect.size.width / 2, 340+20, rect.size.width / 2, 40)];  //2.14  y==300
//                [self.view addSubview:pos3];
//            }
//            else
//             {
//                [pos3 setFrame:CGRectMake(-rect.size.width / 2, _zhenzhuCountView.frame.origin.y+_zhenzhuCountView.frame.size.height+300+20, rect.size.width / 2, 40)];  //2.14  y==300
//                [self.liveShowView addSubview:pos3];
//             }
//             [pos3 animateWithCompleteBlock:^(BOOL finished, NSInteger finishCount) {}];
//             [giftViews removeObjectAtIndex:0];
//            //pos1=bg1;
//             [pos3 addAwardLayerFromVar];
//            if (delGiftTimer) {
//                [delGiftTimer invalidate];
//                 delGiftTimer=nil;
//            }
//             delGiftTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delGiftInView) userInfo:nil repeats:YES];//5.29 修改
//        }
        if (gameWebView) {
            [self.view bringSubviewToFront:gameWebView];
        }
    }
}
#pragma mark 礼物提示控制
-(void)delGiftInView
{
    if (pos0!=nil) {
        if (pos0.showtime==0) {
            [pos0 removeFromSuperview];
             pos0=nil;
             [self redrawGift];
        }
        else{
            pos0.showtime=pos0.showtime-1.0;
        }
    }
    if (pos1!=nil) {
        if (pos1.showtime==0) {
            [pos1 removeFromSuperview];
            pos1=nil;
            [self redrawGift];
        }
        else{
            pos1.showtime=pos1.showtime-1.0;
        }
    }
    if (pos2!=nil) {
        if (pos2.showtime==0) {
            [pos2 removeFromSuperview];
            pos2=nil;
            [self redrawGift];
        }
        else{
            pos2.showtime=pos2.showtime-1.0;
        }
    }
//    if (pos3!=nil) {
//        if (pos3.showtime==0) {
//            [pos3 removeFromSuperview];
//            pos3=nil;
//            [self redrawGift];
//        }
//        else{
//            pos3.showtime=pos3.showtime-1.0;
//        }
//    }
}
#pragma mark - TableView的代理方法
#pragma mark - 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendListArray.count;
}
#pragma mark - 初始化Cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TotalPeopleTableViewCell * rCell = [TotalPeopleTableViewCell cellWithTableView:tableView];
    if (indexPath.row<self.friendListArray.count) {
        [self configNicetyFriendsCell:rCell atIndexPath:indexPath];
    }
    return rCell;
}

#pragma mark - 设置Cell内容
- (void)configNicetyFriendsCell:(TotalPeopleTableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    UserInfoModel *personModel= self.friendListArray[indexPath.row];
//    cell.appendBtn.hidden=YES;
//    [cell configNicetyFriendsAtIndexPath:indexPath withArray:self.friendListArray];
    
    cell.vipImg.hidden = YES;
    
    [self showThelevel:personModel.rank_id and:cell.levelImg and:cell.levelNum isZhuBo:NO];
    cell.nickName.text = personModel.nickname;
    [cell.avatarImg sd_setImageWithURL:[[[BaseViewController alloc] init] placeCorpsImg:[[ToolHelper toolHelper] realAvatarUrl:personModel.id andUpdate:personModel.update_avatar_time]]];
    NSString *usernumber_name=[[NSUserDefaults standardUserDefaults]objectForKey:@"usernumber_name"];
    if (![[[BaseViewController alloc] init] isBlankString:usernumber_name]) {
        if([personModel.haoma isEqualToString:@"0"]){
            cell.userId.text = [NSString stringWithFormat:@"直播号 %@",personModel.haoma];
        }else{
            cell.userId.text = [NSString stringWithFormat:@"%@ %@",usernumber_name,personModel.haoma];
        }
    } else if ([usernumber_name isEqualToString:@""] && ![usernumber_name isKindOfClass:[NSNull class]]) {
        cell.userId.text = [NSString stringWithFormat:@"ID %@",personModel.haoma];
    }
    
    //2018.10.31显示等级
    [self showThelevel:personModel.rank_id and:cell.levelImg and:cell.levelNum isZhuBo:NO];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
#pragma mark - 聊天按钮点击事件
- (IBAction)chatAction:(UIButton *)sender
{
//    if(self.chatViewBottom.constant!=0){
        [self bottomSwip:nil];
//    }
    [_chatText becomeFirstResponder];
}
#pragma mark - 请求礼物连发数据
- (void)giftNumberList
{
    
    if(sendGifttitles == nil)
    {
        sendGifttitles = [NSMutableArray array];
    }
    [sendGifttitles addObject:@"1"];
    [sendGifttitles addObject:@"11"];
    [sendGifttitles addObject:@"88"];
    [sendGifttitles addObject:@"288"];
    [sendGifttitles addObject:@"888"];
    [sendGifttitles addObject:@"1314"];
    [sendGifttitles addObject:@"2888"];
    [sendGifttitles addObject:@"其他数量"];
}
//充值
-(void)rechargeBtnAction{
}
//连发按钮
-(void)sendGiftBtn:(UIButton *)btn
{
    if (btn.tag==1)
    {
      [self initSendGiftPopMenuView:btn];
    }
}
- (void)resetGiftNum
{
    sendGiftNum=@"1";
}

- (void)resetGiftNum1:(NSString *)num
{
    sendGiftNum=num;
}

- (void)startLiansong:(int)giftid andLiansongnum:(int)giftliansongnum andUserid:(NSString *)userid {
    liansongGiftid = giftid;
    liansongGiftnum = giftliansongnum;
    liansongUserid = userid;
    [self sendGiftF:liansongGiftid andLianSongNum:liansongGiftnum andUserid:liansongUserid];
    liansongBtn.hidden = NO;
    self.moneyView.hidden = NO;
    
    [liansongBtn setTitle:@"30连送" forState:UIControlStateNormal];
    if (hideLiansongTimer) {
        [hideLiansongTimer invalidate];
        hideLiansongTimer = nil;
    }
    leftT=30;
    hideLiansongTimer=[NSTimer pltScheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideLiansong) userInfo:nil];
}

- (void)sendBtnClicked1 {
    leftT=30;
//    [self addAttachNum:liansongGiftnum];
}

-(void)hideLiansong {
    if (leftT==0) {
        if (hideLiansongTimer!=nil) {
            [hideLiansongTimer invalidate];
            hideLiansongTimer=nil;
        }
        liansongBtn.hidden=YES;
        self.moneyView.hidden = YES;
        return;
    }
    leftT--;
    [liansongBtn setTitle:[NSString stringWithFormat:@"%d连送",leftT] forState:UIControlStateNormal];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        longTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(moveMethod) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:longTimer forMode:NSRunLoopCommonModes];
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {
        [longTimer invalidate];
        longTimer = nil;
    }
}

-(void)hideLiansong1 {
    if (hideLiansongTimer!=nil) {
        [hideLiansongTimer invalidate];
        hideLiansongTimer=nil;
    }
    liansongBtn.hidden=YES;
    self.moneyView.hidden = YES;
}


- (void)moveMethod {
    [self sendBtnClicked1];
//    NSLog(@"移动距离：%d",count++);
}

//送礼页面
-(void)showGiftListInView{
    sendGiftNum=@"1";
}


-(void)showGiftListInView:(NSInteger)index{
    if ([AppDelegate appDelegate].giftCateArray.count<=0) {
        return;
    }
    if (index == 0) {
        self.giftCateid = index;
        [self requestBagData];
        return;
    }
    self.giftCateid = index;
    GiftCateModel *selectCate=[[AppDelegate appDelegate].giftCateArray objectAtIndex:index-1];
    self.giftCateid_se = [selectCate.giftcateid integerValue];
    [self getGiftListByCateid:[selectCate.giftcateid integerValue]];
    sendGiftArr = [selectCate.send_num componentsSeparatedByString:@","];
}
/**********请求背包接口****************///10.11
- (void)requestBagData
{
    
    
    if (!giftLists) {
        giftLists = [[NSMutableArray alloc]init];
    }
    if (!numLists) {
        numLists = [[NSMutableArray alloc]init];
    }
    //获取背包礼物
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:[NSString stringWithFormat:@"%@%@/user/backpack/list",DATAAPI,APIVersion] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        if(code == 200)
        {
            [giftLists removeAllObjects];
            [numLists removeAllObjects];
            for (NSMutableDictionary *dic in successData[@"data"])
            {
                NSMutableDictionary *itemDic=dic[@"item"];
                NSString *giftnum=dic[@"item_num"];
                giftModel = [[GiftModel alloc]initWithDictionary:itemDic error:nil];
                [giftLists addObject:giftModel];
                [numLists addObject:giftnum];
            }
        }
    }];
}

//获取本地礼物列表
- (void)getGiftListByCateid:(NSInteger)cateid
{
    giftLists = [[NSMutableArray alloc]init];
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:RequestGiftListKey];
    if (data==nil) { //3.22如果礼物列表没有获取到 继续加载
        [[RootHttpHelper httpHelper] requestGiftList];
    }
    else
    {
        NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableArray *giftList = [[NSMutableArray alloc]initWithArray:array];
        //[giftLists removeAllObjects];
        for (NSDictionary *dic in giftList)
        {
            if([[dic objectForKey:@"giftcateid"] integerValue]==cateid){
                giftModel = [[GiftModel alloc]initWithDictionary:dic error:nil];
                if ([giftModel.is_show boolValue]) {
                    [giftLists addObject:giftModel];
                }
            }
        }
    }
}
//获取本地礼物列表
- (void)getGiftList
{
    giftLists = [[NSMutableArray alloc]init];
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:RequestGiftListKey];
    if (data==nil) { //3.22如果礼物列表没有获取到 继续加载
        [[RootHttpHelper httpHelper] requestGiftList];
    }
    else
    {
        NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableArray *giftList = [[NSMutableArray alloc]initWithArray:array];
        for (NSDictionary *dic in giftList)
        {
            giftModel = [[GiftModel alloc]initWithDictionary:dic error:nil];
            if ([giftModel.is_show boolValue]) {
                [giftLists addObject:giftModel];
            }
            
        }
    }
}
- (IBAction)upAndDown:(UIButton *)btn
{
    if (isBottomUp==NO) {
        isBottomUp=YES;
        [self topSwip:nil];
    }
    else{
        isBottomUp=NO;
        [self bottomSwip:nil];
   }
}
#pragma mark - 选择礼物连发数量
- (void)initSendGiftPopMenuView:(UIButton *)btn
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    [tempArr addObjectsFromArray:sendGiftArr];
    if (tempArr.count == 0) {
        [tempArr addObject:@"1"];
        [tempArr addObject:@"19"];
        [tempArr addObject:@"59"];
        [tempArr addObject:@"99"];
        [tempArr addObject:@"520"];
        [tempArr addObject:@"1314"];
    
//        [tempArr addObject:@"其他数量"];
    }
    
    NSArray *countArr = @[@"59",@"79",@"99",@"159",@"259"];
    NSArray *countArr1 = @[@"1",@"19",@"59",@"99",@"520",@"1314",@"其他数量"];
    
    if (self.giftCateid_se == 7) {
        sendGifttitles = [countArr mutableCopy];
    } else {
        sendGifttitles = [countArr1 mutableCopy];
    }

    for (int i = 0; i < sendGifttitles.count; i++)
    {
        SailorPopMenuViewModel *model = [[SailorPopMenuViewModel alloc] init];
        model.title = sendGifttitles[i];
        [arr addObject:model];
    }
    //弹出框的宽度
    CGFloat menuViewWidth = 90;
    //弹出框的右下中角起点坐标
    CGPoint startPoint = CGPointMake(SCREEN_WIDTH/2-30*ScreenBiLi, SCREEN_HEIGHT - 60*ScreenBiLi);
    
    [[SailorPopMenuViewSingleton shareManager] creatPopMenuWithFrame:startPoint popMenuWidth:menuViewWidth popMenuItems:arr action:^(NSInteger index) {
//        sendGiftNum = sendGifttitles[index];
        NSInteger temp = index;

        if ([sendGifttitles[index] isEqualToString:@"其他数量"]) {
            self.sendGiftTextView.text = @"";
            tempText = self.sendGiftTextView;
            [self.sendGiftTextView becomeFirstResponder];
                    
        }  else {
            LianSongNum = sendGifttitles[index];
            [btn setTitle:[NSString stringWithFormat:@"%@",LianSongNum] forState:UIControlStateNormal];
        }
        
    }];
}

- (void)hideSendGiftView {
    [self.sendGiftTextView resignFirstResponder];
}

- (IBAction)sendGiftCustomSureAction:(id)sender {
    
    
    if (self.sendGiftTextView.text.length > 5) {
        self.sendGiftTextView.text = @"99999";
    }
    if (![self.sendGiftTextView.text isEqualToString:@""]) {
        LianSongNum = self.sendGiftTextView.text;
    }
    [self.sendGiftTextView resignFirstResponder];
}

#pragma mark - 赋值页面主播信息
- (void)assignmentLiveUserInfo
{
    //文本阴影颜色
//    self.account.shadowColor = colorLetterGray3;
//    self.time.shadowColor = colorLetterGray3;
    //阴影大小
//    self.account.shadowOffset = CGSizeMake(1.0, 1.0);
//    self.time.shadowOffset = CGSizeMake(1.0, 1.0);
                [self showTheGuiZu:self.vipView With:self.beginLiveModel.anchor.guizhu];//11.6贵族

    //    用户头像
    [self.headView sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:self.beginLiveModel.anchor.id andUpdate:self.beginLiveModel.anchor.update_avatar_time]] placeholderImage:[self placeDefaultImg]];//4.17修改头像
    
    if (self.beginLiveModel.anchor.avatar_frame) {
        if (![self.beginLiveModel.anchor.avatar_frame isEqualToString:@""]) {
            NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [directoryPaths objectAtIndex:0];
            NSString *filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",self.beginLiveModel.anchor.avatar_frame]];
            if (!self.avatarAnimation) {
                CGFloat width = (self.headView.width * 42) / 30;
                self.avatarAnimation = [LOTAnimationView animationWithFilePath:filePath];
                self.avatarAnimation.loopAnimation = YES;
                [self.avatarAnimationView addSubview:self.avatarAnimation];
                [self.avatarAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.avatarAnimationView);
                    make.width.height.equalTo(@(width));
                }];
                [self.avatarAnimation playWithCompletion:^(BOOL animationFinished) {
                }];
            }
        } else {
            [self.avatarAnimation stop];
            [self.avatarAnimation removeFromSuperview];
            self.avatarAnimation = nil;
            
        }
    } else {
        [self.avatarAnimation stop];
        [self.avatarAnimation removeFromSuperview];
        self.avatarAnimation = nil;
        
    }
    
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    self.headView.clipsToBounds = YES;
    self.nickname.text = self.beginLiveModel.anchor.nickname;
    self.account.text = [NSString stringWithFormat:@"%@",self.beginLiveModel.anchor.haoma];
    //self.time.text = [[ToolHelper toolHelper] nonceTime:TimeStyle];
    [self showThePiao:self.ticket With:self.beginLiveModel.anchor.total_ticket];//票数
//    [self showThePiao:self.ticket With:self.beginLiveModel.anchor.liushui];//票数
    //添加一个变量来计算起初的银票数  为了直播结束的时候可以算出获得多少银票
    self.lastTicket=[self.beginLiveModel.anchor.total_ticket intValue];
    intoPoint=[self.beginLiveModel.anchor.total_ticket intValue];
//    self.lastTicket=[self.beginLiveModel.anchor.liushui intValue];
//    intoPoint=[self.beginLiveModel.anchor.liushui intValue];
}

//11.21
#pragma mark - 展示全服红包界面
-(void)showGlobalHB:(NSString *)hbid andLeftTime:(int)time{
    //    设置全服红包底部背景大小和红包大小差不多 这样可以防止点击其他空白区域的时候出发tap的点击事件
    nbPackView * hongbaoView=[[nbPackView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-8-92-15*hongBaoArray.count, self.pkRightView.y-40-96, 92, 96) withSecond:time] ;
    hongbaoView.backgroundColor =[UIColor clearColor];
//    hongbaoView.layer.masksToBounds=YES;
//    hongbaoView.layer.cornerRadius=50;
    
    //    红包id
    hongbaoView.hbid=hbid;
    hongbaoView.userInteractionEnabled=YES;
    UITapGestureRecognizer *hongBaoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(theHongBaoClick:)];
    hongBaoTap.numberOfTapsRequired = 1;
    hongBaoTap.numberOfTouchesRequired = 1;
    [hongbaoView addGestureRecognizer:hongBaoTap];
    
    UITapGestureRecognizer *hongBaoTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(theHongBaoClick1:)];
    hongBaoTap1.numberOfTapsRequired = 1;
    hongBaoTap1.numberOfTouchesRequired = 1;
    [hongbaoView.closeBtn addGestureRecognizer:hongBaoTap1];
    
    if (hongBaoArray.count==0) {
        //        如果一开始没有红包 添加到当前视图
        [self.liveShowView addSubview:hongbaoView];
    }
    else{
        //        如果有红包 把之后显示的红包添加到前一个红包后边
        [self.liveShowView insertSubview:hongbaoView belowSubview:[hongBaoArray objectAtIndex:hongBaoArray.count-1]];
    }
    [hongBaoArray addObject:hongbaoView];
}

//全服红包的手势点击事件
- (void)theHongBaoClick:(UITapGestureRecognizer *)tap
{
    nbPackView *hongbaoView=(nbPackView *)tap.view;
    if(hongbaoView.timer!=nil){//定时器未结束 直接返回
        return;
    }
    //    抢全服红包
    [self HBQAction:hongbaoView.hbid];
    [hongbaoView removeFromSuperview];
    [hongBaoArray removeObject:hongbaoView];
    //红包移除后调整红包的位置
    int i=0;
    for (nbPackView *hongbaoView in hongBaoArray) {
        hongbaoView.frame=CGRectMake(SCREEN_WIDTH-8-92-15*i, self.pkRightView.y-40-96, 92 , 96);
        i++;
    }
}
//全服红包的手势点击事件
- (void)theHongBaoClick1:(UITapGestureRecognizer *)tap
{
    nbPackView *hongbaoView=(nbPackView *)tap.view.superview;
    [hongbaoView removeFromSuperview];
    [hongBaoArray removeObject:hongbaoView];
    //红包移除后调整红包的位置
    int i=0;
    for (nbPackView *hongbaoView in hongBaoArray) {
        hongbaoView.frame=CGRectMake(SCREEN_WIDTH-8-92-15*i, self.pkRightView.y-40-96, 92 , 96);
        i++;
    }
}

- (void)dealloc{
    NSLog(@"BaseLiveViewController Dealloc");
    [self removeAllView];
    //2018.4.20 允许手机休眠
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    ///移除添加的手势
    if (self.leftSwipGestureRecognizer) {
        [self.view removeGestureRecognizer:self.leftSwipGestureRecognizer];
    }
    if (self.rightSwipGestureRecognizer) {
        [self.view removeGestureRecognizer:self.rightSwipGestureRecognizer];
    }
    if (removeTimer!=nil) {
        [removeTimer invalidate];
        removeTimer=nil;
    }
    if (msgArr) {
        [msgArr removeAllObjects];
    }
    //5.23
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GETMSG" object:nil];
}
//有新的私信消息
- (void)getmsg:(NSNotification *)obj{
    if (self.ChatViewInLive.frame.origin.y!=(SCREEN_HEIGHT-500)) {
        ///3.28当前页面在游戏界面的时候 有新的消息到来时不会显示小红点
        /// 4.24 有私信到来时改变按钮图标
        [self.reviewBtn setImage:[UIImage imageNamed:@"icon_user_live_newMessage"] forState:UIControlStateNormal];
    }
}

#pragma mark - 展示红包界面
- (void)showRedPackView
{
    _redPackDetaile.hidden = YES;
    //赋值展示
    if([[ToolHelper toolHelper] ReplacingCharActer:redPackElemModel.s_avatar])
    {
        [_redPackAvatar sd_setImageWithURL:[self placeCorpsImg:redPackElemModel.s_avatar] placeholderImage:[self placeDefaultImg]];
    }
    else
    {
        [_redPackAvatar sd_setImageWithURL:[self placeImg:redPackElemModel.s_avatar] placeholderImage:[self placeDefaultImg]];
    }
    _redPackAvatar.contentMode=UIViewContentModeScaleAspectFill;
    _redPackAvatar.clipsToBounds = YES;
    _redPackName.text = [NSString stringWithFormat:@"%@的红包",redPackElemModel.s_nick];
    _redPackDesc.text = redPackElemModel.message;
    _redPackShell.hidden=YES;
    [UIView animateWithDuration:0.5 animations:^{
//        _redPackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        _redPackView.hidden = NO;
        ///5.23置于当前view的最前端
        [self.liveShowView bringSubviewToFront:_redPackView];
    }];
}
//抢红包
- (void)HBQAction:(NSString *)hbid
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    // set call parameters
    NSString *method = @"hongbao";
    [args setObject:@"qiang" forKey:@"action"];
    //1.25 添加判断
    if (hbid!=nil) {
        [args setObject:hbid forKey:@"par1"];
    }
    [args setObject:@"share" forKey:@"par2"];
    [args setObject:@"" forKey:@"par3"];
    [args setObject:@"" forKey:@"par4"];
    [socket invoke:method withArgs:args];
}
#pragma mark - 抢红包点击事件
//抢普通红包
- (IBAction)redPackAction:(UIButton *)sender
{
    _redPackView.hidden = YES;
    [self HBQAction:redPackElemModel.s_uid];
}

#pragma mark - 退出红包界面
- (IBAction)exitRedPackAction:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
//        _redPackView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        _redPackView.hidden = YES;
    }];
}
#pragma mark 点击用户列表头像的时候调用
-(void)onViewerAvatarTapped:(UserInfoModel *)info{
    
}
#pragma mark - 私信按钮点击
- (IBAction)privateAction:(UIButton *)sender
{
    ///3.28
//    [[MessageHelper messageHelper]showWarnMessage:self title:@"悄悄地告诉你哦" sub:@"直播间内互相关注成为好友之后才可以发送私信"];
    [self.reviewBtn setImage:[UIImage imageNamed:@"icon_user_live_chat"] forState:UIControlStateNormal];
    self.toolBar.hidden = YES;
    self.ChatViewInLive.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 500);
    self.ChatViewInLive.hidden=NO;
    [self.liveShowView addSubview:self.ChatViewInLive];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.ChatViewInLive.frame = CGRectMake(0, SCREEN_HEIGHT - 500, SCREEN_WIDTH, 500);
    } completion:^(BOOL finished) {
        
    }];
    self.backScrollView.scrollEnabled = NO;
    [self showDefaultTab];
    /// 2.17 hide the manageview
    if (self.manageView)
    {
        [self hideManageView];
    }
}
-(void) showDefaultTab{}

- (void)getFriendList
{
    if (!_friendListArray) {
        _friendListArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"num":@"5"}];
    [[RootHttpHelper httpHelper] achieveCommonGetURL:@"friends" andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        if(code == 200)
        {
            [_friendListArray removeAllObjects];
            NSArray *tempArray = (NSArray *)[successData objectForKey:@"data"];
            for (int i = 0; i < tempArray.count; i++) {
                NSError *err;
                UserInfoModel *friendInfoModel = [[UserInfoModel alloc]initWithDictionary:[tempArray[i] objectForKey:@"target"] error:&err];
                [_friendListArray addObject:friendInfoModel];
                if (i == tempArray.count - 1 ) {
                    friendPage += 1;
                    friendStart = [NSString stringWithFormat:@"%@",friendInfoModel.id];
                }
            }
            [_friendListTableView reloadData];
            [_friendListTableView.mj_header endRefreshing];
            if (tempArray.count < 5) {
                
                [_friendListTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [_friendListTableView.mj_footer endRefreshing];
            }
        }
    }];
}

#pragma mark-自定义刷新方法
- (void)setupRefresh
{
    __weak BaseLiveViewController *weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求数据
        [weakSelf getFriendList];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _friendListTableView.mj_header = header;
    _friendListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉加载执行方法
        [weakSelf getMoreFriendList];
    }];
    //设置文字
    [header setTitle:headerPullToRefreshText forState:MJRefreshStateIdle];
    [header setTitle:headerReleaseToRefreshText forState:MJRefreshStatePulling];
    [header setTitle:headerRefreshingText forState:MJRefreshStateRefreshing];
}

- (void)getMoreFriendList
{

}
/// 4.24 显示系统消息
- (void)showSystemDetail
{

}
//显示聊天页面
-(void)showChatDetail:(UserInfoModel *)userinfo{

}
-(void)UAA{
    //在子类中各自控制
}

-(void)END{
    //在子类中各自控制
}
-(void)reduceBagListWithID:(NSString *)giftid andNum:(int)num{
    if (!bagLists) {
        return;
    }
    for (BagListModel* m in bagLists) {
        if([[m.item objectForKey:@"id"] isEqualToString:giftid]){
            m.item_num=[NSString stringWithFormat:@"%d",[m.item_num intValue]-num];
            if ([m.item_num isEqualToString:@"0"]) {
                [bagLists removeObject:m];
            }
            break;
        }
    }
    
}
//清除红包信息
-(void)clearHongBaoInfo{
    
    if (hongBaoModel.roomnumber==hongBaoRoomnumber) {
        hongBaoModel.roomnumber=@"";
    }
    
}
//全服红包的点击事件
- (void)fullHongBaoClick:(UITapGestureRecognizer *)sender
{
    
}
- (void)showManageView:(NSString *)userid orNumber:(NSString *)roomnumber{
    
}
//飞屏点击事件
-(void)flyMsgClicked:(long)userid{
    //公告弹幕跳转
    if(![self isBlankString:grounderFPModel.toroomnumber]){
        if (roomnumber!=SharedAppDelegate.userModel.user.haoma) {
            //不是主播就跳转到房间
            [self exitUserLive];
            //7.20 跳转房间时传房间号
            [SharedAppDelegate accrssLiveRoom:grounderFPModel.toroomnumber];
        }
    }
    // 全屏喇叭跳转
    if (![self isBlankString:grounderChatModel.toroomnumber])
    {
        if (roomnumber!=SharedAppDelegate.userModel.user.haoma) {
            //不是主播就跳转到房间
            [self exitUserLive];
            //7.20 跳转房间时传房间号
            [SharedAppDelegate accrssLiveRoom:grounderChatModel.toroomnumber];
        }
    }
}

/// 2.17 隐藏manageview
- (void)hideManageView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.manageView.transform = CGAffineTransformMakeTranslation(0, 260);
//        self.manageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        self.manageView.hidden = YES;
    } completion:^(BOOL finished) {
        [self.cardAvatarAnimation stop];
        [self.cardAvatarAnimation removeFromSuperview];
        self.cardAvatarAnimation = nil;
    }];
}

///6.16 守护按钮点击事件
- (IBAction)shouHuBtnAction:(UIButton *)sender
{
    
    if (!totalPeopleView) {
        totalPeopleView = [[NSBundle mainBundle] loadNibNamed:@"TotalPeopleView" owner:self options:nil].firstObject;
        totalPeopleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        totalPeopleView.hidden = YES;
        [totalPeopleView initView];
        totalPeopleView.delegate = self;
        totalPeopleView.roomnumber = roomnumber;
        [totalPeopleView setupRefresh];
        [self.liveShowView addSubview:totalPeopleView];
//        totalPeopleView.guizuBtn.hidden = YES;
//        totalPeopleView.guizuLab.hidden = YES;
//        totalPeopleView.guanzhongBtn.hidden = YES;
//        totalPeopleView.guanzhongLab.hidden = YES;
        if ([[AppDelegate appDelegate].userModel.user.haoma isEqualToString:roomnumber]) {
            totalPeopleView.isHost = YES;
        }
    }
    
    if (!self.manageView.hidden) {
        [self hideManageView];
    }
    
    self.backScrollView.scrollEnabled = NO;
    
    [totalPeopleView showView:sender];
    
    
    
    
//    [self initTotalView:@"&guard=1" type:0];
//    [self initTotalView:@"&guibin=1" type:1];
//    [self initTotalView:@"" type:2];
}


- (void)initTotalView:(NSString *)url type:(NSInteger)type{
    
    ///6.20 请求守护列表
    if (shouHuArr==nil) {
        shouHuArr=[NSMutableArray array];
    }
    
     //获取直播间内成员列表
     [[RootHttpHelper httpHelper] basicGETURL2:[NSString stringWithFormat:@"%@/iumobile/apis/index.php?action=getuserlist%@&roomnumber=%@&pagesize=50&page=1",DATAAPI,url,roomnumber] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
         //NSLog(@"+++++++++++++请求到的数据: %@",successData);
         
         NSInteger code = [[successData objectForKey:@"code"] integerValue];
         if(code == 200)
         {
             [shouHuArr removeAllObjects];
             NSArray *temp = [successData objectForKey:@"user"];
             self.shouhuNum.text = [NSString stringWithFormat:@"粉丝团:%lu",(unsigned long)temp.count];
         }
     }];
}

//12.19 贵族的按钮点击事件
- (IBAction)showTheGuiZuView:(UIButton *)sender
{
    ///6.20 请求守护列表
    if (guizuArr==nil) {
        guizuArr=[NSMutableArray array];
    }
    [self initGuiZuList];
}
- (void)kaiTongGuiBinBtn
{
    if (self.guizuView) {
        [self.guizuView removeFromSuperview];
    }
    NobleViewController *guizuVC=[[NobleViewController alloc] init];
    guizuVC.hidesBottomBarWhenPushed=YES;
    guizuVC.beginModel=self.beginLiveModel;
    [self.navigationController pushViewController:guizuVC animated:YES];
}
//18.11.25修改
- (void)requestGameWithRoomNumber:(NSString *)roomnumber
{
    if(gameArr == nil)
    {
        gameArr = [NSMutableArray array];
    }
    if (gameNameArr==nil)
    {
        gameNameArr=[NSMutableArray array];
    }
    if (gameIDArr==nil)
    {
        gameIDArr=[NSMutableArray array];
    }
    if (gameISFull==nil)
    {
        gameISFull=[NSMutableArray array];
    }
    if (gameHeight==nil)
    {
        gameHeight=[NSMutableArray array];
    }
    if (gameCover==nil) {
        gameCover=[NSMutableArray array];
    }
    if (urlArr==nil) {
        urlArr=[NSMutableArray array];
    }
    //开播选择游戏
    [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"game?roomnumber2=%@",roomnumber] andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        
        if ([[successData objectForKey:@"api_code"] intValue]==200)
        {
            NSArray *tempArr=successData[@"data"];
            for (int i=0; i<tempArr.count; i++)
            {
                gameModel =[[LiveGameModel alloc] initWithDictionary:tempArr[i] error:nil];
                [gameArr addObject:gameModel];
                //添加游戏名称 id 高度
                [gameNameArr addObject:gameModel.name];
                [gameIDArr addObject:gameModel.gameid];
                [gameISFull addObject:gameModel.full];
                [gameHeight addObject:gameModel.height];
                [gameCover addObject:gameModel.icon];
                [urlArr addObject:gameModel.url];
            }
        }
    }];
}
- (IBAction)pkProphetGameBtnAction:(id)sender {
    self.bottom_url = [NSString stringWithFormat:@"%@game/pkyuyanjia/index.php?roomnumber=%@&token=%@&from=ios&refresh_balance=1",DATAAPI,roomnumber,SharedAppDelegate.userModel.token];
    self.game_url=@"";
    
    self.bottom_url_height=[NSString stringWithFormat:@"%0.3f",1.176];
    if (self.gameMoreView!=nil){
        self.gameMoreView.hidden=YES;
    }
    //9.8 修改
    if (!gameWebView)
    {
        [self loadGame];
    } else {
        //全屏游戏和无游戏，不更改图标
        
            
        giftAndGameSelected=NO;

        if(self.chatViewBottom.constant!=0){
            [self bottomSwip:nil];
        }
        else{
            [self topSwip:nil];
        }
        
    }
}


- (void)selectGameBtnAction:(UIButton *)btn
{
    self.gameid=gameIDArr[btn.tag];
    selectedGameIsFull=gameISFull[btn.tag];
    if ([selectedGameIsFull isEqualToString:@"0"])
    {
        self.bottom_url=[NSString stringWithFormat:@"%@%@/goto_game_page?gameid=%@&token=%@&usernumber=%@&userid=%@&roomnumber=%@&platform=ios",DATAAPI,APIVersion,self.gameid,SharedAppDelegate.userModel.token,SharedAppDelegate.userModel.user.haoma,SharedAppDelegate.userModel.user.id,roomnumber];//urlArr[btn.tag]; 9.4号修改
        self.game_url=@"";
    }
    else
    {
        self.bottom_url=@"";
        self.game_url=[NSString stringWithFormat:@"%@%@/goto_game_page?gameid=%@&token=%@&usernumber=%@&userid=%@&roomnumber=%@&platform=ios",DATAAPI,APIVersion,self.gameid,SharedAppDelegate.userModel.token,SharedAppDelegate.userModel.user.haoma,SharedAppDelegate.userModel.user.id,roomnumber];//urlArr[btn.tag];
    }
    self.bottom_url_height=gameHeight[btn.tag];
    if (self.gameMoreView!=nil){
        self.gameMoreView.hidden=YES;
    }
    //9.8 修改
    [self loadGame];
}
- (void)playGameAction:(UIButton *)btn
{
    if (self.moreView!=nil) {
        if (self.moreView.hidden==NO) {
            self.moreView.hidden=YES;
        }
    }
    if (self.gameMoreView!=nil) {
        if (self.gameMoreView.hidden==YES) {
            self.gameMoreView.hidden=NO;
        }
        return;
    }
    self.gameMoreView=[[TheMoreView alloc] initWith];
    self.gameMoreView.isLiveGame=YES;
    self.gameMoreView.delegate=self;
    [self.gameMoreView initWithMoreArray:gameCover andTitle:gameNameArr];
    [self.gameMoreView showInView:self.liveShowView];
}
//按钮点击事件
- (void)ButtonClickAction:(UIButton *)btn
{
}
#pragma mark - 退出键盘，并清空输入框内数据
- (void)cleanUpData
{
    if (self.chatText) {
        [self.chatText resignFirstResponder];
        self.chatText.text = @"";
    }
}

//12.5
#pragma mark - 弹幕按钮点击事件
- (IBAction)bulletBtnAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 900;
    
//    [self.bulletBtn setTitleColor:[UIColor colorWithHex:0x535353] forState:UIControlStateNormal];
//    [self.bulletBtn setBackgroundColor:[UIColor colorWithHex:0xF2F2F2]];
//    [self.bulletBtn_1 setTitleColor:[UIColor colorWithHex:0x535353] forState:UIControlStateNormal];
//    [self.bulletBtn_1 setBackgroundColor:[UIColor colorWithHex:0xF2F2F2]];
//    [self.bulletBtn_2 setTitleColor:[UIColor colorWithHex:0x535353] forState:UIControlStateNormal];
//    [self.bulletBtn_2 setBackgroundColor:[UIColor colorWithHex:0xF2F2F2]];
//    [self.bulletBtn_3 setTitleColor:[UIColor colorWithHex:0x535353] forState:UIControlStateNormal];
//    [self.bulletBtn_3 setBackgroundColor:[UIColor colorWithHex:0xF2F2F2]];
    
    [self.bulletBtn setImage:[UIImage imageNamed:@"icon_bullet_chat_un"] forState:UIControlStateNormal];
    [self.bulletBtn_1 setImage:[UIImage imageNamed:@"icon_bullet_danmu_un"] forState:UIControlStateNormal];
    [self.bulletBtn_2 setImage:[UIImage imageNamed:@"icon_bullet_laba_un"] forState:UIControlStateNormal];
    [self.bulletBtn_3 setImage:[UIImage imageNamed:@"icon_bullet_renyimen_un"] forState:UIControlStateNormal];
    switch (index)
    {
        case 0://公聊
            [self.bulletBtn setImage:[UIImage imageNamed:@"icon_bullet_chat_se"] forState:UIControlStateNormal];
            self.chatText.placeholder = @"和大家说点什么吧";
            isBullet=NO;
            break;
        case 1://弹幕
        {
            [self.bulletBtn_1 setImage:[UIImage imageNamed:@"icon_bullet_danmu_se"] forState:UIControlStateNormal];
            NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
            NSString *flyPrice=[userDefault objectForKey:@"flymsg_price"];
            NSString *money_name=[userDefault objectForKey:@"money_name"];
            if (![self isBlankString:money_name])
            {
                self.chatText.placeholder = [NSString stringWithFormat:@"弹幕%@%@",flyPrice,money_name];
            }
            else
            {
                self.chatText.placeholder = [NSString stringWithFormat:@"弹幕2%@",[self moneyname]];
            }
            isBullet = YES;
            isDanMu=YES;
            isLaBa=NO;
            isRenYiMen=NO;
        }
            break;
        case 2://喇叭
        {
            [self.bulletBtn_2 setImage:[UIImage imageNamed:@"icon_bullet_laba_se"] forState:UIControlStateNormal];
            
            NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
            NSString *quanFuPrice=[userDefault objectForKey:@"announce_price"];
            NSString *money_name=[userDefault objectForKey:@"money_name"];
            if (![self isBlankString:money_name])
            {
                self.chatText.placeholder = [NSString stringWithFormat:@"喇叭%@%@",quanFuPrice,money_name];
            }
            else
            {
                self.chatText.placeholder = [NSString stringWithFormat:@"喇叭50%@",[self moneyname]];
            }
            isBullet = YES;
            isLaBa=YES;
            isDanMu=NO;
            isRenYiMen=NO;
        }
            break;
        case 3://传送门
            [self.bulletBtn_3 setImage:[UIImage imageNamed:@"icon_bullet_renyimen_se"] forState:UIControlStateNormal];
            [self.bulletBtn_3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.bulletBtn_3 setBackgroundColor:colorHead];
//            [self.bulletBtn setTitle:chatArr[3] forState:0];
            self.chatText.placeholder =[NSString stringWithFormat:@"可点击飞屏穿梭到别人房间(需开通贵族)"];
            isBullet=YES;
            isRenYiMen=YES;
            isLaBa=NO;
            isDanMu=NO;
            break;
        default:
            break;
    }
}

//**贴片广告*//
- (void)loadTiePian:(NSMutableArray *)tempArr
{
    
    if (!_bannerTiePianArr) {
        _bannerTiePianArr=[NSMutableArray array];
    } else {
        for (SDCycleScrollView *view in _bannerTiePianArr) {
            if ([view isKindOfClass:[SDCycleScrollView class]]) {
                [view removeFromSuperview];
            }
        }
        [_bannerTiePianArr removeAllObjects];
    }
    self.bannerInLiveDic=[NSMutableDictionary dictionary];
    
    //9.6 贴片广告数组
    for (int i=0;i<tempArr.count;i++)
    {
        TiePianBanner *model=[[TiePianBanner alloc] initWithDictionary:tempArr[i] error:nil];
        if ([self.bannerInLiveDic objectForKey:[NSString stringWithFormat:@"posx%@_%@",model.x,model.y]]==nil) {
            NSMutableArray *tmp=[NSMutableArray array];
            [tmp addObject:model];
            [self.bannerInLiveDic setObject:tmp forKey:[NSString stringWithFormat:@"posx%@_%@",model.x,model.y]];
        }
        else{
            NSMutableArray *tmp=[self.bannerInLiveDic objectForKey:[NSString stringWithFormat:@"posx%@_%@",model.x,model.y]];
            [tmp addObject:model];
            [self.bannerInLiveDic setObject:tmp forKey:[NSString stringWithFormat:@"posx%@_%@",model.x,model.y]];
        }
    }
    int tagi=0;
    int wishTag = 0;
    for (NSString *xkey in self.bannerInLiveDic) {
        NSMutableArray *adArr=self.bannerInLiveDic[xkey];
        NSMutableArray *imgArr=[NSMutableArray array];  //2018.8.27 添加多个贴片广告的功能
        NSMutableArray *widthArr=[NSMutableArray array];
        NSMutableArray *heightArr=[NSMutableArray array];
        CGFloat x = 0.0;
        CGFloat y = 0.0;
        CGFloat width;
        CGFloat height;
        NSString *labStr;
        NSString *labColor;
        CGFloat labFont = 0.0;
        CGFloat labX = 0;
        CGFloat labY = 0;
        CGFloat labH = 0;
        CGFloat labW = 0;
        BOOL isWish = NO; // 是否存在心愿单
        for (int i=0;i<adArr.count;i++)
        {
            TiePianBanner *tiepian=adArr[i];
            x=[tiepian.x floatValue]*SCREEN_WIDTH;
            width=[tiepian.img_w_scale floatValue]*SCREEN_WIDTH;
            if (x+width > SCREEN_WIDTH) {
                x = SCREEN_WIDTH-width;
            }
            y=[tiepian.y floatValue]*(SCREEN_WIDTH*16/9)+self.zhenzhuCountView.frame.origin.y+self.zhenzhuCountView.height+10;
            
            if ([tiepian.app_open isEqualToString:@"daily_wish"]) {
                [imgArr addObject:tiepian.img_bg];
                wishTag = i;
                tiepian.in_txt = [NSString stringWithFormat:@"%@/%@",tiepian.getnum,tiepian.max_num];
                isWish = YES;
            } else {
                [imgArr addObject:tiepian.img];
            }
            
            height=width/[tiepian.uimgh floatValue];
//            [imgArr addObject:tiepian.img];
            [widthArr addObject:[NSString stringWithFormat:@"%f",width]];
            [heightArr addObject:[NSString stringWithFormat:@"%f",height]];
            if (!tiepian.in_h || !tiepian.in_w || !tiepian.in_x || !tiepian.in_y || !tiepian.in_t_size || !tiepian.or_w) {
                continue;
            }
            labX = width/[tiepian.or_w floatValue]*[tiepian.in_x floatValue];
            labY = width/[tiepian.or_w floatValue]*[tiepian.in_y floatValue];
            labW = width/[tiepian.or_w floatValue]*[tiepian.in_w floatValue];
            labH = width/[tiepian.or_w floatValue]*[tiepian.in_h floatValue];
            labStr = tiepian.in_txt;
            labColor = tiepian.in_t_color;
            labFont = width/[tiepian.or_w floatValue]*[tiepian.in_t_size floatValue];
        }
        NSComparator cmptr = ^(id obj1, id obj2){
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray *widthArray=[widthArr sortedArrayUsingComparator:cmptr];
        NSArray *heightArray=[heightArr sortedArrayUsingComparator:cmptr];
        width=[[NSString stringWithFormat:@"%@",widthArray.lastObject] floatValue];
        height=[[NSString stringWithFormat:@"%@",heightArray.lastObject] floatValue];
        if (x>=SCREEN_WIDTH) {
            x=SCREEN_WIDTH-width;
        }
        else if (x<=0)
        {
            x=0;
        }
        if (y>=SCREEN_HEIGHT) {
            y=SCREEN_HEIGHT-height;
        }
        else if (y<=0)
        {
            y=0;
        }
        if (isWish) {
            if (!_liveWishScrollView || !_liveWishScrollView.superview) {
                if (![self.appDelegate.userModel.user.haoma isEqualToString:self.beginLiveModel.anchor.haoma]) {
                    [self.LayerView insertSubview:self.liveWishScrollView belowSubview:bigAnimationView];
                } else {
                    [self.liveShowView insertSubview:self.liveWishScrollView belowSubview:bigAnimationView];
                }

//                [self.liveShowView addSubview:self.liveWishScrollView];
//                [self.liveShowView sendSubviewToBack:self.liveWishScrollView];
            }
            self.liveWishScrollView.frame = CGRectMake(x, y, width, height);
            if (!wishGiftArr) {
                wishGiftArr = [NSMutableArray array];
            } else {
                [wishGiftArr removeAllObjects];
            }
            if (!wishGiftidArr) {
                wishGiftidArr = [NSMutableArray array];
            } else {
                [wishGiftidArr removeAllObjects];
            }
            for (TiePianBanner *model in adArr) {
                [wishGiftidArr addObject:model.giftid];
            }
            [wishGiftArr addObjectsFromArray:adArr];
            self.liveWishScrollView.dataSource = adArr;
            [self.liveWishScrollView initView];
            isWish = NO;
            tagi++;
            continue;
        }
        self.tiePianBannerScrol = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(x, y, width, height) imageNamesGroup:imgArr];
        self.tiePianBannerScrol.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        self.tiePianBannerScrol.backgroundColor = [UIColor clearColor];
        self.tiePianBannerScrol.autoScroll = NO;
        if (imgArr.count>=2){
            self.tiePianBannerScrol.autoScroll = YES;
            self.tiePianBannerScrol.pageControlDotSize = CGSizeMake(8, -8);
            self.tiePianBannerScrol.currentPageDotColor = colorHead;
            self.tiePianBannerScrol.pageDotColor = [UIColor whiteColor];
            self.tiePianBannerScrol.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
            self.tiePianBannerScrol.pageControlAliment = SDCycleScrollViewPageContolAlimentCenterBottom;
            self.tiePianBannerScrol.showPageControl=YES;
        }
        self.tiePianBannerScrol.delegate=self;
        self.tiePianBannerScrol.autoScrollTimeInterval =4;
        self.tiePianBannerScrol.hidesForSinglePage = YES;
        self.tiePianBannerScrol.tag=1008+tagi;
        tagi++;
        [self addTiePianView];
        if (![labStr isEqualToString:@""]) {
            if (labH != 0) {
                UILabel *label = [[UILabel alloc] init];
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignmentLeft;
                label.minimumScaleFactor = labFont/2.5;
                label.text = labStr;
                if (!labColor || [labColor isEqualToString:@""]) {
                    label.textColor = [UIColor blackColor];
                } else {
                    label.textColor = [UIColor colorWithHexString:labColor];
                }
                
                label.font = [UIFont systemFontOfSize:labFont];
    //            float height = [self widthForString:labStr fontSize:labFont andWidth:labW];
    //            label.frame = CGRectMake(labX, labY, labW, height);
                [self.tiePianBannerScrol addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tiePianBannerScrol).offset(labY);
                    make.left.equalTo(self.tiePianBannerScrol).offset(labX);
                    make.width.equalTo(@(labW));
                }];
            }
            
        }
        
        [self.bannerTiePianArr addObject:self.tiePianBannerScrol];
    }
}

- (LiveWishScrollView *)liveWishScrollView {
    if (!_liveWishScrollView) {
        _liveWishScrollView = [[NSBundle mainBundle] loadNibNamed:@"LiveWishScrollView" owner:self options:nil].firstObject;
    }
    return _liveWishScrollView;
}


#pragma mark - 轮播图片的点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //从tag值找key
    long tagi=cycleScrollView.tag-1008;
    long cyclei=0;
    NSString *rightkey;
    for (NSString *xkey in self.bannerInLiveDic) {
        if(cyclei==tagi){
            rightkey=xkey;
            break;
        }
        cyclei++;
    }
    NSMutableArray *arr=[self.bannerInLiveDic objectForKey:rightkey];
    if (arr.count>0) { //9.17 添加跳转不同的浏览器
        TiePianBanner *tiepian=arr[index];
        if ([tiepian.app_open isEqualToString:@"webview"]) {
            if (![tiepian.address isEqualToString:@""]) {
                [self pushToBannerWebWithLoadUrl:tiepian.address withTitle:nil andShareUrl:tiepian.img];
            }
        }
        else if ([tiepian.app_open isEqualToString:@"ranklist"]) {
        }
        else
        {
            [self pushToBrowserWithString:tiepian.address];
        }
    }
}

- (void)teipianGameUrl:(TiePianBanner *)tiepian {
    [wkWebView removeFromSuperview];
    wkWebView = nil;
    if (!wkWebView) {
        NSString *urlstr;
        if ([tiepian.address containsString:@"?"]) {
            urlstr =[NSString stringWithFormat:@"%@token=%@&from=ios&refresh_balance=1&userid=%@&roomnumber=%@",tiepian.address,[AppDelegate appDelegate].userModel.token,[AppDelegate appDelegate].userModel.user.id,roomnumber];
        }
        else{
            urlstr =[NSString stringWithFormat:@"%@?token=%@&from=ios&refresh_balance=1&userid=%@&roomnumber=%@",tiepian.address,[AppDelegate appDelegate].userModel.token,[AppDelegate appDelegate].userModel.user.id,roomnumber];
        }
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        // 3.13修改
        [configuration.userContentController addScriptMessageHandler:self name:@"jsCallNativeClose"];
        wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, -StatusBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT+StatusBar_HEIGHT) configuration:configuration];
        [wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]]];
        wkWebView.UIDelegate = self;
        wkWebView.navigationDelegate = self;
        
        wkWebView.scrollView.backgroundColor = [UIColor redColor];
        wkWebView.backgroundColor = [UIColor clearColor];
        wkWebView.opaque = NO;
        //            wkWebView.navigationDelegate = self;
        //            wkWebView.UIDelegate = self;
        [self.liveShowView addSubview:wkWebView];
    } else {
        wkWebView.hidden = NO;
    }
    
    isWebView = YES;
}

- (void)pushToWebViewWith:(TiePianBanner *)tiepian
{
}

- (void)pushToBrowserWithString:(NSString *)url
{
    if ([url containsString:@"?"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@&platform=ios",url,SharedAppDelegate.userModel.token]]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@&platform=ios",url,SharedAppDelegate.userModel.token]]];
    }
}

//直播间的滚屏公告
- (void)flyViewAnimation
{
    //滚屏公告
    NSString *msg=[[NSUserDefaults standardUserDefaults]objectForKey:@"notice"];
    if (![self isBlankString:msg]) {
        [self initNoticeView:msg];
    }
}
- (void)initNoticeView:(NSString *)msg
{
    if (self.flyBackView) {
        [self.flyBackView removeFromSuperview];
        self.flyBackView=nil;
    }
    self.flyBackView =[[UIView alloc] init];
    if (msg!=nil) {
        self.flyBackView.frame=CGRectMake(15, self.zhenzhuCountView.frame.size.height+self.zhenzhuCountView.frame.origin.y+7, SCREEN_WIDTH-30, 25);
        self.flyBackView.layer.cornerRadius=6;
        self.flyBackView.layer.masksToBounds=YES;
        self.flyBackView.backgroundColor=[UIColor colorWithHex:0x39475E alpha:0.44];
        self.flyBackLab =[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 6, 25, 12)];
        self.flyBackLab.text=[NSString stringWithFormat:@"%@",msg];
        self.flyBackLab.textAlignment=NSTextAlignmentLeft;
        self.flyBackLab.textColor=[UIColor whiteColor];
        self.flyBackLab.userInteractionEnabled=YES;
        self.flyBackLab.font=[UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium];
        [self.flyBackLab sizeToFit];
        [self.flyBackView addSubview:self.flyBackLab];
        [self.liveShowView addSubview:self.flyBackView];
        [self startAnimation];
    }
}
- (void)startAnimation
{
    [UIView beginAnimations:@"Notice" context:NULL];
    [UIView setAnimationDuration:30.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:10000000];
    CGRect frame = self.flyBackLab.frame;
    frame.origin.x = -frame.size.width;
    self.flyBackLab.frame = frame;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    // 方式1.匹配keypath
//    if ([keyPath isEqualToString:@"frame"]) {
//        //NSLog(@"preview = %f", self.kit.preview.frame.origin.y);
//        if(self.kit.preview.frame.origin.y==0){
//            self.kit.preview.frame=CGRectMake(0, -((SCREEN_HEIGHT-SCREEN_WIDTH*8/9)/2-(self.zhenzhuCountView.frame.size.height+self.zhenzhuCountView.frame.origin.y+7*ScreenBiLi + 25 +7)), SCREEN_WIDTH, SCREEN_HEIGHT);
//        }
//        if ([keyPath isEqualToString:@"frame1"]) {
//            if (SharedAppDelegate.player.view.y==0) {
//                SharedAppDelegate.player.view.frame = CGRectMake(0, -((SCREEN_HEIGHT-SCREEN_WIDTH*8/9)/2-(self.zhenzhuCountView.frame.size.height+self.zhenzhuCountView.frame.origin.y+7*ScreenBiLi + 25 +7)), SCREEN_WIDTH, SCREEN_HEIGHT);
//            }
//        }
//    }
}

- (void)resetlianSongGiftNum
{
    LianSongNum=@"1";
}

- (void)resetlianSongGiftNum1:(NSString *)num
{
    LianSongNum=num;
}

-(NSString *)getlianSongGiftNum{
    return LianSongNum;
}

- (void)setlianSongGiftNum:(NSString *)num {
    LianSongNum = num;
}
- (void)resetAttach
{
    self.attach=0;
}

- (void)addAttachNum:(int)num {
    self.attach += num;
}

- (void)totalPeopleViewBuyShouHu {

}

- (void)totalPeopleViewBuyGuiZu {

}



- (void)rechargeBalance
{
}

- (IBAction)taskBtnAction:(UIButton *)sender {
    if (sender.selected) {
//        self.taskBGView.
        [self.taskBtn setImage:[UIImage imageNamed:@"icon_live_down"]];
        [UIView animateWithDuration:0.5 animations:^{
            self.taskBGViewHeight.constant = 21;
        }];
    } else {
        [self.taskBtn setImage:[UIImage imageNamed:@"icon_live_up"]];
        [UIView animateWithDuration:0.5 animations:^{
            self.taskBGViewHeight.constant = 108;
        }];
    }
    sender.selected = !sender.selected;
    [self getTaskInfo];
}

// 获取每日任务接口
- (void)getTaskInfo {
    if (!_taskListArray) {
        _taskListArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!roomnumber) {
        return;
    }
    [params setObject:roomnumber forKey:@"roomnumber"];
    if (showerUserid) {
        [params setObject:showerUserid forKey:@"touserid"];
    }
    
    [[RootHttpHelper httpHelper] achieveCommonGetURL:@"task/daily" andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        if(code == 200)
        {
            [self.taskListArray removeAllObjects];
            for (NSDictionary *dict in successData[@"task_list"]) {
                TaskLiveModel *model = [[TaskLiveModel alloc] initWithDictionary:dict error:nil];
                [self.taskListArray addObject:model];
                
                for (TiePianBanner *tiepian in wishGiftArr) {
                    if ([model.giftid isEqualToString:tiepian.giftid]) {
                        tiepian.getnum = model.num;
                        tiepian.max_num = model.max;
                    }
                }
            }
            
            self.liveWishScrollView.dataSource = wishGiftArr;
            [self.liveWishScrollView.collection reloadData];
        }
    }];
}
- (void)initMaskView {
    if (!maskView) {
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        maskView.backgroundColor = [UIColor clearColor];
        maskView.hidden = YES;
        [self.liveShowView addSubview:maskView];
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-400*ScreenBiLi);
        [button addTarget:self action:@selector(dissmissWishView) forControlEvents:UIControlEventTouchUpInside];
        [maskView addSubview:button];
    } else {
        maskView.hidden = YES;
    }
}

- (void)showWishView {
    if (!wishView) {
        [self initMaskView];
        wishView = [[WKWebView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 420*ScreenBiLi)];
        [wishView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@iumobile/h5/templates/wish_today.html?token=%@&from=ios&refresh_balance=1&roomnumber=%@",DATAAPI,[AppDelegate appDelegate].userModel.token,roomnumber]]]];
//        wishView.UIDelegate = self;
//        wishView.navigationDelegate = self;
        wishView.scrollView.scrollEnabled = NO;
//        wishView.scrollView.backgroundColor = [UIColor redColor];
        wishView.backgroundColor = [UIColor clearColor];
        wishView.opaque = NO;
        //            wkWebView.navigationDelegate = self;
        //            wkWebView.UIDelegate = self;
        [self.liveShowView addSubview:wishView];
    } else {
        [wishView reload];
    }
    [self.liveShowView bringSubviewToFront:maskView];
    [self.liveShowView bringSubviewToFront:wishView];
    _moreView.hidden = YES;
    maskView.alpha = 0;
    maskView.hidden = NO;
    wishView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        maskView.alpha = 1;
        wishView.frame = CGRectMake(0, SCREEN_HEIGHT-420*ScreenBiLi, SCREEN_WIDTH, 420*ScreenBiLi);
    }];
}
- (void)dissmissWishView {
    [UIView animateWithDuration:0.2 animations:^{
        maskView.alpha = 0;
        wishView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 420*ScreenBiLi);
    } completion:^(BOOL finished) {
        maskView.hidden = YES;
        wishView.hidden = YES;
    }];
}

//此处是js调用oc的方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"jsCallNativeClose");
    // 3.13修改
    if ([message.name isEqualToString:@"jsCallNativeClose"]) {
//        NSString *url=message.body;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            wkWebView.hidden = YES;
        isWebView = NO;
        if (gameWebView)
        {
            [gameWebView removeFromSuperview];
            [gameWebView.configuration.userContentController removeScriptMessageHandlerForName:@"jsCallNativeClose"];//移除按钮的唤起事件
            [gameWebView.configuration.userContentController removeScriptMessageHandlerForName:@"jsCallNative"];//移除按钮的唤起事件
            
            gameWebView = nil;
            [self bottomSwip:nil];//3.22切换游戏
            giftAndGameSelected=YES;
            gameType = nil;
            self.attach = 0;
        }
//        });
    } else if ([message.name isEqualToString:@"jsCallNative"]) {
        NSDictionary *dict;
        if ([message.body isKindOfClass:[NSString class]]) {
            dict = [NSDictionary dictionaryWithJsonString:message.body];
        } else {
            dict = message.body;
        }
        if (dict[@"action"]) {
            if ([dict[@"action"] isEqualToString:@"xj_buy"]) {
                NSDictionary *data = dict[@"data"];
                game_xj_giftid = data[@"giftid"];
                giftUserModel = [[UserInfoModel alloc] init];
                giftUserModel.id = showerUserid;
                [self addAttachNum:[data[@"num"] intValue]];
                [self sendGiftF:[game_xj_giftid intValue] andLianSongNum:[data[@"num"] intValue]];
            }
        }
        
    }
}

// 在JS端调用alert函数时(警告弹窗)，会触发此代理方法。
// 通过completionHandler()回调JS
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    //    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        completionHandler();
    //    }])];
    //    [self presentViewController:alertController animated:YES completion:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message?:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
    [alert showAlertViewWithActionBlock:^(UIAlertView *newAlertView, NSInteger buttonIndex) {
        completionHandler();
    }];
    
}
// JS端调用confirm函数时(确认、取消式弹窗)，会触发此方法
// completionHandler(true)返回结果
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    //    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //        completionHandler(NO);
    //    }])];
    //    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        completionHandler(YES);
    //    }])];
    //    [self presentViewController:alertController animated:YES completion:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message?:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    [alert showAlertViewWithActionBlock:^(UIAlertView *newAlertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            completionHandler(NO);
        } else {
            completionHandler(YES);
        }
    }];
    
}
/// JS调用prompt函数(输入框)时回调，completionHandler回调结果
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    //        textField.text = defaultText;
    //    }];
    //    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        completionHandler(alertController.textFields[0].text?:@"");
    //    }])];
    //    [self presentViewController:alertController animated:YES completion:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:prompt message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"完成", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert showAlertViewWithActionBlock:^(UIAlertView *newAlertView, NSInteger buttonIndex) {
        UITextField *textField = [newAlertView textFieldAtIndex:0];
        completionHandler(textField.text?:@"");
    }];
}

- (void)showGameZaDan {
    
    if (self.moreView!=nil) {
        if (self.moreView.hidden==NO) {
            self.moreView.hidden=YES;
        }
    }
    
    NSString *urlstr=[NSString stringWithFormat:@"%@game/zadan/?token=%@&from=ios&refresh_balance=1&userid=%@&roomnumber=%@",DATAAPI,[AppDelegate appDelegate].userModel.token,[AppDelegate appDelegate].userModel.user.id,roomnumber];
    
    [self loadGameView:@"bottom" andHeight:SCREEN_WIDTH*1.17 andGameUrl:urlstr];
    [self topSwip:nil];
}

- (void)showShareMimaView {
    
}
- (void)totalPeopleViewDismiss {
    if (self.gamePush==YES || isLianMai) {
        return;
    }
    self.backScrollView.scrollEnabled = YES;
}


// 赠送
- (IBAction)sengGiftToUser:(id)sender {
    if ([self.appDelegate.userModel.user.id isEqualToString:userInfoModel.id]) {
        [[HudHelper hudHepler] showTips:self.view tips:@"不能给自己送礼"];
        return;
    }
    isShowChoose = NO;
    sendUserId = userInfoModel.id;
    sendUserName = userInfoModel.nickname;
    /// 2.17 隐藏manageview
    [self hideManageView];
    if (self.liveShowLeft.constant!=0) {
        [self rightSwip:nil];
    }

}

//给观众送礼礼物按钮点击事件
- (IBAction)giftUserAction:(UIButton *)sender{
    
}


- (void)playSFMAnimation {
    if (self.appDelegate.winningSFMArray.count > 0) {
        self.flyawardView.hidden = NO;
        GrounderModel *model = self.appDelegate.winningSFMArray[0];
        NSLog(@"playSFMAnimation version = %@",model.version);
        [self.flyawardView setContent:model];
        [self belowSubView:self.ChatManageView withView:self.flyawardView];
        
        [[AppDelegate appDelegate].winningSFMArray removeObjectAtIndex:0];
    }
}

- (void)playSFMAnimation2 {
    if (self.appDelegate.winningSFMArray2.count > 0) {
        self.flyawardView2.hidden = NO;
        GrounderModel *model = self.appDelegate.winningSFMArray2[0];
        NSLog(@"playSFMAnimation version = %@",model.version);
        [self.flyawardView2 setContent:model];
        [self belowSubView:self.ChatManageView withView:self.flyawardView2];
        
        [[AppDelegate appDelegate].winningSFMArray2 removeObjectAtIndex:0];
    }
}

- (void)playSFMAnimation3 {
    if (self.appDelegate.winningSFMArray3.count > 0) {
        self.flyawardView3.hidden = NO;
        GrounderModel *model = self.appDelegate.winningSFMArray3[0];
        NSLog(@"playSFMAnimation version = %@",model.version);
        [self.flyawardView3 setContent:model];
        [self belowSubView:self.ChatManageView withView:self.flyawardView3];
        
        [[AppDelegate appDelegate].winningSFMArray3 removeObjectAtIndex:0];
    }
}


- (void)uploadChooseGiftMoney:(NSInteger)money {
    self.giftMoney = money;
}


- (void)belowSubView:(UIView *)belowView withView:(UIView *)view {
    if ([self.appDelegate.userModel.user.haoma isEqualToString:self.beginLiveModel.anchor.haoma]) {
        if ([self.liveShowView.subviews containsObject:belowView]) {
            NSInteger index = [self.liveShowView.subviews indexOfObject:belowView];
            [self.liveShowView insertSubview:view atIndex:index];
        } else {
            [self.liveShowView insertSubview:view belowSubview:belowView];
        }
    } else {
        if ([self.LayerView.subviews containsObject:belowView]) {
            NSInteger index = [self.LayerView.subviews indexOfObject:belowView];
            [self.LayerView insertSubview:view atIndex:index];
        } else {
            [self.LayerView insertSubview:view belowSubview:belowView];
        }
        
        
        
//            [self.LayerView insertSubview:bigAnimationView belowSubview:self.ChatManageView];
    }
}


- (void)uploadLianMaiUserInfoView:(NSMutableArray *)info withUid:(NSString *)uid {
    NSLog(@"有人%@",info);
    if (info.count == 0) {
        // 都走了，一般主播断开也会走到这边来
        for (RoomAvatarView *view in normalAvatarArr) {
            //移除视图，目的是为了下次连麦时不会出现上一次断开时最后一帧都画面
            [view destroyPlayer];
            view.hostView = nil;
            view.hidden = YES;
        }
        return;
    }
    if ([uid isEqualToString:roomnumber]) {
        // 主播突然离开了 TRTC 房间，其他人需要断开连接
        
    }
    
    [_lianMaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar_0.mas_bottom).offset(4);
        make.centerX.equalTo(self.avatar_0);
        make.height.equalTo(@(30*ScreenBiLi));
        make.width.equalTo(@(60*ScreenBiLi));
    }];
    
    if (self.selfInV2) {
        self.lianMaiBtn.hidden = NO;
    }
    self.fangzhuView.hidden = NO;
    self.fangzhuView.backgroundColor = [UIColor clearColor];
    self.avatarOnMicArr = [info mutableCopy];
    if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {

        int i=0;
        for (RoomAvatarView *view in normalAvatarArr) {
            if (i > 3) {
                return;
            }
            if (i > info.count-1) {
                [view destroyPlayer];
                view.hostView = nil;
                view.hidden = YES;
                i++;
                continue;
            }
            [view initLivePlayer];
            view.pkInfo.hidden = YES;
            view.hostView.frame = self.appDelegate.micRect;
            view.hidden = NO;
            
            __weak typeof(self) weakself = self;
            [self getTRCTuserSig:[AppDelegate appDelegate].userModel.user.haoma withBlock:^{
                NSString *url = [NSString stringWithFormat:@"trtc://cloud.tencent.com/play/56853_%@?sdkappid=%@&userId=%@&usersig=%@",info[i][@"userid"],TRTCSDKAppID,[AppDelegate appDelegate].userModel.user.haoma,TXTRCTUserSig];
                [view startLivePlayRTC:url];
            }];
            
            i++;
        }
        
    } else {

        self.avatar_0.hostView.frame = self.appDelegate.micRect;
        self.avatar_0.hidden = NO;
        self.avatar_0.backgroundColor = UIColor.clearColor;

        
        int i=0;

        if (info.count == 0) {
            for (RoomAvatarView *view in normalAvatarArr) {
                [view destroyPlayer];
                view.hostView = nil;
                view.hidden = YES;
            }
            return;
        }
        for (RoomAvatarView *view in normalAvatarArr) {
            if (i >= info.count) {
                if (self.selfInV2 == NO) {
                    [self lianmaiEndPusher];
                }
                
                return;
            }
            
            if ([info[i][@"userid"] isEqualToString:self.appDelegate.userModel.user.haoma]) {
                isLianMai = YES;
                [self lianmaiStartPusher:view];
                
                view.hidden = NO;
                i++;
                continue;
//                [view videoSwitch:YES];
            }
            
            [view initLivePlayer];
            view.pkInfo.hidden = YES;
            view.hostView.frame = self.appDelegate.micRect;
            view.hidden = NO;
            view.uid = info[i];
            
            if (self.selfInV2) {
                NSString *url = [NSString stringWithFormat:@"trtc://cloud.tencent.com/play/56853_%@?sdkappid=%@&userId=%@&usersig=%@",info[i][@"userid"],TRTCSDKAppID,[AppDelegate appDelegate].userModel.user.haoma,TXTRCTUserSig];
                [view startLivePlayRTC:url];
            } else {
                [view startLivePlayRTC:info[i][@"flv"]];
            }
            
            
            
            
            i++;
        }
        
    }
}


- (RedPackSmallView *)redSmallView {
    if (!_redSmallView) {
        _redSmallView = [[NSBundle mainBundle] loadNibNamed:@"RedPackSmallView" owner:self options:nil].lastObject;
        [self.liveShowView addSubview:_redSmallView];
        [_redSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-8));
            make.width.equalTo(@(92));
            make.height.equalTo(@(167));
            make.bottom.equalTo(@(-self.btnBottom.constant - 40 - 5));
//            make.top.equalTo(self.ChatManageView.mas_top);
        }];
        __weak typeof(self) weakself = self;
        _redSmallView.clickMoreRedPcak = ^(BOOL isOpen) {
            if (isOpen) {
                // 开红包
//                weakself.redBigView.redpackID = weakself.game_id;
//                [weakself.redBigView showView:weakself.game_id];
                [weakself isOpenRedPack];
            } else {
                // 规则
                [weakself showRedPackGuiZe];
            }
        };
    }
    return _redSmallView;
}

- (void)isOpenRedPack {
    if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
        self.redBigView.redpackID = self.game_id;
        [self.redBigView showView:self.game_id];
    } else {
        NSString *ts = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        if ([ts integerValue] - [self.lookLiveTime integerValue] >= 300 || self.isSendGift) {
            self.redBigView.redpackID = self.game_id;
            [self.redBigView showView:self.game_id];
        } else {
            [[HudHelper hudHepler] showLongTips:self.view tips:@"您观看直播时长不足5分钟，无法抢红包"];
        }
    }
}

- (RedPackBigView *)redBigView {
    if (!_redBigView) {
        _redBigView = [[NSBundle mainBundle] loadNibNamed:@"RedPackBigView" owner:self options:nil].lastObject;
        _redBigView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_redBigView initView:self.beginLiveModel.anchor];
        [self.view addSubview:_redBigView];
    }
    return _redBigView;
}

- (void)showSmallView:(NSDictionary *)redpackInfo {
//    self.
    
    self.game_id = redpackInfo[@"game_id"];
    self.redSmallView.game_id = redpackInfo[@"game_id"];
    [self.redSmallView uploadProgress:redpackInfo[@"get_gift_balance"] max:redpackInfo[@"need_gift_balance"]];
    
    [self.redSmallView initView];
    
    if ([redpackInfo[@"get_gift_balance"] integerValue] >= [redpackInfo[@"need_gift_balance"] integerValue]) {
        [self startGameTimer];
    }
    
}

- (void)showRedPackGuiZe {
}

- (void)startGameTimer {
    if (self.gameTimer) {
        [self.gameTimer invalidate];
        self.gameTimer = nil;
    }
    if (!self.gameTimer) {
        gameTimeCount = 120;
        __weak typeof(self) weakself = self;
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            gameTimeCount--;
            [self.redSmallView uploadTimeCount:gameTimeCount];
            if (_redBigView) {
                [_redBigView uploadTimeCount:gameTimeCount];
            }
            if (gameTimeCount == 0) {
                [weakself.gameTimer invalidate];
                weakself.gameTimer = nil;
                [weakself nextRunRedPackGame];
            }
        }];
    }
}

- (void)nextRunRedPackGame {
    [_redSmallView removeFromSuperview];
    _redSmallView = nil;
    [_redBigView removeFromSuperview];
    _redBigView = nil;
    if (self.gameid == nil) {
        return;
    }
    if ([roomnumber isEqualToString:self.appDelegate.userModel.user.haoma]) {
        NSMutableDictionary * params=[NSMutableDictionary dictionary];
        [params setObject:@"redpackage_end" forKey:@"action"];
        [params setObject:self.game_id forKey:@"game_id"];
        [socket invoke:@"redpackage_end" withArgs:params];
    } else {
//        // 观众端做下重新获取红包消息
//        [self checkRedPackInfo];
    }
    
}


- (void)checkRedPackInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.appDelegate.userModel.token forKey:@"token"];
    [params setValue:roomnumber forKey:@"roomnumber"];
    [[RootHttpHelper httpHelper] achieveCommonGetURL:@"roomRedpackage/info" andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue] == 200) {
            NSDictionary *dict = successData[@"room_redpackage_info"];
            if (dict.count == 0) {
                if (self.gameTimer && gameTimeCount > 0) {
                    
                } else {
                    [self nextRunRedPackGame];
                }
            } else {
                [self showSmallView:dict];
            }
        }
    }];
}

// 观众切换房间处理
- (void)changeRoom {
    if (self.gameTimer) {
        [self.gameTimer invalidate];
        self.gameTimer = nil;
    }
    gameTimeCount = 0;
    if (_redBigView) {
        [_redBigView removeFromSuperview];
        _redBigView = nil;
    }
    if (_redSmallView) {
        [_redSmallView removeFromSuperview];
        _redSmallView = nil;
    }
}

- (void)getTRCTuserSig:(NSString *)roomId withBlock:(void(^)(void))block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.appDelegate.userModel.token forKey:@"token"];
    [[RootHttpHelper httpHelper] achieveCommonPostURL:@"trtc/getKey" andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
        NSLog(@"trct SuccessData = %@",successData);
        if ([successData[@"api_code"] intValue] == 200) {
            TXTRCTUserSig = successData[@"data"];
            
            block();
        }
    }];
}

- (void)pkMultiFail{}
- (void)mutilPkFail{}


- (void)pusherLiveWithIsRTC:(BOOL)isRTC {
    if (!isRTC) {
        
        if (self.kit.puserMode == V2TXLiveMode_RTC) {
            [self.kit stopPusher];
            [self.kit initTXLivePusherisRTC:NO with:self.hostAnchorView];
            [self.kit.pusher setObserver:self];
            
        }
        [self.kit.pusher startPush:self.appDelegate.userModel.user.push_video_add];
    } else {
        
        __weak typeof(self) weakself = self;
        [self getTRCTuserSig:self.appDelegate.userModel.user.haoma withBlock:^{
            
            if (weakself.kit.puserMode == V2TXLiveMode_RTMP) {
                [weakself.kit stopPusher];
                
                [weakself.kit initTXLivePusherisRTC:YES with:weakself.hostAnchorView];
                [weakself.kit.pusher setObserver:weakself];
                
            }
            
            [weakself.kit.pusher startPush:[NSString stringWithFormat:@"trtc://cloud.tencent.com/push/56853_%@?sdkappid=%@&userId=%@&usersig=%@",weakself.appDelegate.userModel.user.haoma,TRTCSDKAppID,weakself.appDelegate.userModel.user.haoma,TXTRCTUserSig]];
            
        }];
    }
}


- (SLMultiPKStartView *)pkMultiView {
    if (!_pkMultiView) {
        _pkMultiView = [[NSBundle mainBundle] loadNibNamed:@"SLMultiPKStartView" owner:self options:nil].lastObject;
//        _pkMultiView.frame = CGRectMake(0, self.zhuboPKView.y, SCREEN_WIDTH, 570);
        _pkMultiView.roomnumber = roomnumber;
        if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
            [self.liveShowView insertSubview:_pkMultiView belowSubview:self.fangzhuView];
        } else {
            [self.LayerView insertSubview:_pkMultiView belowSubview:self.fangzhuView];
        }
        
        __weak typeof(self) weakself = self;
        _pkMultiView.pkStopClick = ^(BOOL isZhuDong) {
            [weakself overMultiPK:isZhuDong];
        };
        _pkMultiView.pkDisconnectedClick = ^{
            [weakself overMultiPK:YES];
        };
        _pkMultiView.uploadZhuBoFrame = ^(CGRect frame) {
            [weakself uploadFrame:frame];
        };
        
        _pkMultiView.pkFinishClick = ^{
            // 进入惩罚阶段
            [weakself joinCFMultiPK];
        };
        
        _pkMultiView.inviteOtherHostClick = ^{
            [weakself inviteOtherHost];
        };
        _pkMultiView.pkLeaveClick = ^(NSString * _Nonnull roomnumber, NSString * _Nonnull nickname) {
            // 中途离场 参与主播
            [weakself leaveHostActionWithRoomNumber:roomnumber wihtNickname:nickname];
            
        };
        _pkMultiView.gotoOtherRoomClick = ^(NSString * _Nonnull roomnumber, NSString * _Nonnull nickname, BOOL isHost) {
            if (!isHost) {
                [weakself gotoOtherRoom:roomnumber withNickName:nickname];
            }
            [weakself touchesBeganClick];
            
        };
        _pkMultiView.uploadZhuBoVoice = ^(NSMutableArray * _Nonnull rooms) {
            [weakself pushZhuboVoice:rooms];
        };
    }
    return _pkMultiView;
}

- (void)inviteOtherHost {}

- (void)gotoOtherRoom:(NSString *)roomnumber withNickName:(NSString *)nickname{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否立即前往%@主播房间",nickname] preferredStyle:(UIAlertControllerStyleAlert)];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goOtherRoom:roomnumber];
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)joinCFMultiPK {
    
    [self pkMultiStartAction:@"pk_end_multi"];
    
}

- (void)uploadFrame:(CGRect)frame {
    frame.origin.y = frame.origin.y + self.pkMultiView.y;
    if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
        self.hostAnchorView.frame = frame;
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.playerView.frame = frame;
        });
    }
}

- (void)overMultiPK:(BOOL)isInitiative {
    isPKing = NO;
    self.pkMultiBGView.hidden = YES;
    self.pkPeople = 0;
    if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
        self.hostAnchorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } else {
        self.playerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    [_pkMultiView destroy];
    [_pkMultiView removeFromSuperview];
    _pkMultiView = nil;
    
    if (isInitiative) {
        [self pkMultiStartAction:@"pk_over_multi"];
    }
}

- (void)startMultiPKWith:(NSMutableDictionary *)info {
    self.pkPeople = 4;
    isPKing = YES;
    self.pkMultiBGView.hidden = NO;
    [self.view sendSubviewToBack:self.pkMultiBGView];

    CGFloat w = [info[@"viewW"] floatValue] * SCREEN_WIDTH;
    CGFloat h = [info[@"viewH"] floatValue] * (SCREEN_HEIGHT- self.zhuboPKView.y-self.btnBottom.constant-40);
    
    CGFloat x = [info[@"viewX"] floatValue] * SCREEN_WIDTH;
    CGFloat y = [info[@"viewY"] floatValue] * (SCREEN_HEIGHT-self.zhuboPKView.y-self.btnBottom.constant-40) + self.zhuboPKView.y;
    self.pkMultiView.frame = CGRectMake(x, y, w, h);
    
}
//com.tianmazhibo.applive1
//com.shili.applive1
- (void)startMultixpk:(NSDictionary *)dic {
    
    NSArray *rooms = dic[@"rooms"];

//    if ([self.appDelegate.userModel.user.haoma isEqualToString:roomnumber]) {
    pkInfoArr = [rooms mutableCopy];
//    }
    
    NSInteger time = [dic[@"time"] intValue] * 60;
    NSInteger time_cf = [dic[@"cf_time"] intValue] * 60;
    
    [self startMultiPKWith:[dic mutableCopy]];
    
    [self.pkMultiView initView:rooms];
    [self.pkMultiView pullMultiPkRoomnumber:rooms];
    if ([dic.allKeys containsObject:@"starttime"]) {
        NSInteger starttime = [dic[@"starttime"] integerValue];
        // 创建两个NSDate对象
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:starttime];
        NSDate *date2 = [NSDate date];

        // 创建一个NSCalendar对象
        NSCalendar *calendar = [NSCalendar currentCalendar];

        // 指定想要计算的时间单位，这里选择秒
        NSCalendarUnit units = NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:units fromDate:date1 toDate:date2 options:0];

        // 获取时间差（秒）
        NSInteger seconds = [components second];
        NSLog(@"时间差为：%ld秒", (long)seconds);
        
        if (seconds + 3 >= time + time_cf) {
            // pk已结束
            [_pkMultiView destroy];
            [_pkMultiView removeFromSuperview];
            _pkMultiView = nil;
            return;
            
        } else if (seconds >= time) {
            // 惩罚时间
            self.pkMultiView.pkCFCount_now = time_cf - (seconds - time);
            [self.pkMultiView startCFTimer];
        } else if (second < time) {
            // pk时间
            self.pkMultiView.pkCount_now = time - seconds;
            self.pkMultiView.pkCFCount_now = time_cf;
            [self.pkMultiView startPkTimer];
        }
        
    } else {
        self.pkMultiView.pkCount_now = time;
        self.pkMultiView.pkCFCount_now = time_cf;
        [self.pkMultiView startPkTimer];
    }
    
    
    
}

- (void)uploadMultiPKValue:(NSDictionary *)args {
    NSArray *rooms = args[@"data"][@"rooms"];
    if (isPKing) {
        [self.pkMultiView uploadPK_Value:rooms];
    }
}

- (void)pkMultiStartAction:(NSString *)action{}


- (void)pkMultiInfoState:(NSDictionary *)args {
    NSDictionary *successData = args[@"data"];
    NSString *starttime = successData[@"starttime"]; // 4pk开始时间
    NSMutableDictionary *config = [successData[@"config"] mutableCopy];
    [config setValue:starttime forKey:@"starttime"];
    NSArray *pkValue = successData[@"rooms"]; // pk_value
    NSArray *rooms = config[@"rooms"];
    BOOL haveIn = NO;
    
    for (NSDictionary *dic in rooms) {
        if ([dic[@"roomnumber"] isEqualToString:roomnumber]) {
            haveIn = YES;
        }
    }
    if (!haveIn) {
        // 主播没有参与其中
        return;
    }
    
    // 创建4PK画面 并拉取画面
    [self startMultixpk:config];
    
    // 更新pk值
    [self.pkMultiView uploadPK_Value:pkValue];
    
    if (successData[@"mute"]) {
        NSMutableArray *musicArr = successData[@"mute"];
        [self.pkMultiView uploadZhuBoVoiceState:musicArr];
    }
    
    
}

- (void)touchOtherRoomBtnAction{
    NSLog(@"[self.playerPKView addGestureRecognizer:tapPkGesture];");
}

- (void)lianmaiEndPusher{};
- (void)lianmaiEndLive {
    self.fangzhuView.hidden = YES;
    self.lianMaiBtn.hidden = YES;
    for (RoomAvatarView *view in normalAvatarArr) {
        //移除视图，目的是为了下次连麦时不会出现上一次断开时最后一帧都画面
        [view destroyPlayer];
        view.hostView = nil;
        view.hidden = YES;
    }
    if ([roomnumber isEqualToString:self.appDelegate.userModel.user.haoma]) {

    } else {
        [self.kit stopPusher];
    }
}


- (void)touchesBeganClick{}
- (void)pushZhuboVoice{}


- (void)leaveHostActionWithRoomNumber:(NSString *)roomnumber wihtNickname:(NSString *)nickname{}

- (void)uploadHostFrameWithLeaveRoom:(NSString *)roomnumber {
    for (NSDictionary *dic in pkInfoArr.reverseObjectEnumerator) {
        if ([dic[@"roomnumber"] isEqualToString:roomnumber]) {
            [pkInfoArr removeObject:dic];
        }
    }
    
    NSInteger tempCount = pkInfoArr.count;
    for (int i = 0; i < 4-tempCount; i++) {
        // 发起人+参与主播还是小于4就表示少了一个人  需要添加一个空数据
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        [temp setObject:@"" forKey:@"userid"];
        [temp setObject:@"" forKey:@"roomnumber"];
        [temp setObject:@"" forKey:@"nickname"];
        [temp setObject:@"" forKey:@"avatar"];
        [temp setObject:@"" forKey:@"stream"];
        [pkInfoArr addObject:temp];
    }
    
    [self uploadMultiPKWithParams:pkInfoArr];
    
    
    
}

- (void)uploadMultiPKWithParams:(NSMutableArray *)temp {
    
    NSUInteger count = temp.count;
    
    CGFloat containerWidth = 1; // 容器视图的宽度
    CGFloat containerHeight = 1; // 容器视图的高度

    CGFloat widthRatio = 1.0 / 2; // 宽度比例
    CGFloat heightRatio = 1.0 / 2; // 高度比例
    
    if (count % 2 == 0) {
        for (NSUInteger i = 0; i < count; i++) {
            NSMutableDictionary *data = temp[i];

            CGFloat x = i % 2 * containerWidth * widthRatio;
            CGFloat y = i / 2 * containerHeight * heightRatio;
            CGFloat width = containerWidth * widthRatio;
            CGFloat height = containerHeight * heightRatio;

            data[@"x"] = [NSString stringWithFormat:@"%f", x];
            data[@"y"] = [NSString stringWithFormat:@"%f", y];
            data[@"w"] = [NSString stringWithFormat:@"%f", width];
            data[@"h"] = [NSString stringWithFormat:@"%f", height];
        }
    } else if (count == 3) {
        
    }
    
}



- (void)leavePKHost:(NSDictionary *)args {
    NSDictionary *leave_host = [args objectForKey:@"leave_host"];
    NSString *leave_roomnumber = [leave_host objectForKey:@"roomnumber"];
    NSString *leave_nickname = [leave_host objectForKey:@"nickname"];
    
    NSMutableArray *rooms = [NSMutableArray array];
    for (NSDictionary *dic in [args objectForKey:@"rooms"]) {
        if (![dic[@"roomnumber"] isEqualToString:@""]) {
            [rooms addObject:dic[@"roomnumber"]];
        }
    }
    
    if ([leave_roomnumber isEqualToString:roomnumber]) {
        // 当前房间主播退出4PK
        [self overMultiPK:NO];
    } else {
        if ([rooms containsObject:roomnumber]) {
            if (rooms.count == 2) {
                // 最后一个也离开了，表示4pk结束
                [self overMultiPK:YES];
                return;
            }
            // 观众所在参与的主播房间  需要销毁播放器
            [_pkMultiView destroyHostWith:leave_roomnumber];
            
            [self uploadHostFrameWithLeaveRoom:leave_roomnumber];
            if (_pkMultiView) {
                [self.pkMultiView uploadAvatarFrame:pkInfoArr];
            }
        }
        if ([rooms containsObject:self.appDelegate.userModel.user.haoma]) {
            // 参与的各个主播
            [self.view makeToast:[NSString stringWithFormat:@"%@已退出",leave_nickname] duration:1.5 position:ToastDefaultPosition];
            
            
        }
        
        
    }
}
@end

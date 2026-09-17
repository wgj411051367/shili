//
//  LiveViewController.h
//  beibei
//
//  Created by 金颖 on 16/9/11.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomScrollView.h"
#import "NSDictionary+SafeObject.h"
#import "WSClient.h"
#import "SendGiftModel.h"
#import "GSPChatMessage.h"
#import "HeartFlyView.h"
#import "GiftModel.h"
#import "BagListModel.h"
#import "NewUserListItem.h"

#import "PresentView.h"
#import "GameModel.h"
#import "NSArray+SafeObjectAt.h"
#import "YYTCShowLiveMessageView.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import "nbPackView.h"
#import "ReplaceEmoji.h"
#import <WebKit/WebKit.h>
#import "PublicChatView.h"
#import "shili-Swift.h"
#import "TiePianBanner.h"
#import "LiveGameModel.h"
#import "BuyGuiZu.h"
#import "NobleViewController.h"
#import "NobleModel.h"
#import "CustomWKWebView.h"
#import <UIKit/UIKit.h>
#import "TheMoreView.h"
#import "SLGiftAnimationView.h"
#import "DaShangView.h"
#import "TXLiveStreamerKit.h"
#import "TXLiteClient.h"
#import "GiftCateModel.h"
#import "PKView.h"
#import "PKMaskView.h"
#import "UIScrollView+UITouch.h"
#import "TotalPeopleView.h"
#import "OpenShouHuView.h"
#import "shouHuModel.h"
#import "TaskLiveView.h"
#import "TaskLiveModel.h"
#import "ChatRecordView.h"

#import "RoomAvatarView.h"
#import "LiveWishScrollView.h"

#import "RedPackSmallView.h"
#import "RedPackBigView.h"
#import "SLMultiPKStartView.h"

@interface BaseLiveViewController : BaseViewController<SLLiveSocketDelegate,UIScrollViewDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,YYTCShowLiveMessageViewDelegate,TotalPeopleViewDelegate,WKScriptMessageHandler,WKUIDelegate>{
    ///5.23
    SLLiveSocket    *socket;
    //全服红包
    UserInfoModel *user;
    GrounderModel *grounderFPModel;
    GrounderModel *grounderChatModel;
    GrounderModel *hongBaoModel;
    //操作目标
    UserInfoModel * userInfoModel ,*selectedUserInfoModel;

    NSString *showerNickname;
    NSString *showerUserid;
    NSString *roomnumber;
    int getgift_sid;
    NSTimeInterval cf_daojishi;
    //观众数组 6.20守护
    NSMutableArray *viewers,*shouHuArr,*chatArr,*guizuArr,*guanzhongArr,*topUser;
//    NSMutableArray *guizuArr,*guanzhongArr;
    int onlineNum;
    // 2.8
    BOOL isBlockChat,isExist,isBottomUp,clicked,pushToRedBag,balanceUpdate,joined;
    //8.23 送礼失败的提示框
    UIAlertView *alertview;
    //礼物数据
    NSMutableArray *giftLists,*yinxiangArr,*numLists;
    //背包数据
    NSMutableArray *bagLists,*gameLists,*game;
    NSMutableArray *sendGifttitles;
    GiftModel * giftModel;
    //选中的礼物
    GiftModel * chooseGiftModel;
    
    int giftSign;
    
    BagListModel *bagListModel;
    NSString *sendGiftNum,*LianSongNum,*sendGiftMaxNum;
    int intoPoint;//进房间tickets
    int nextUserItemX,second;
    float showtime;
    CustomElemModel *redPackElemModel;
    int friendPage;
    NSString *friendStart;
    PresentView *pos0,*pos1,*pos2,*pos3;
    PresentView *bg0,*bg1;
    PresentView *pv;
    NSTimer *delGiftTimer;//倒计时
    NSMutableArray *giftViews;
    int pageNum;
    BOOL isUserListLoading,giftAndGameSelected,isGaming;
    int leftSecond,heartSize;
    NSString *hongBaoRoomnumber,*gameType;
    
    CGPoint beginPoint;
    //送礼物目标
    UserInfoModel *giftUserModel;
    // 全服红包数组
    NSMutableArray *hongBaoArray,*theTitles;
    
    MBProgressHUD *progress;
    UIImageView *backimages;
    NSTimer *hideTimer;
    /// 4.17
    CustomWKWebView* gameWebView; //这个是底部游戏
    NSMutableArray *registeredNotifications;
    NSNumber *bottomAreaHeight;
    //7.17 新增图标的string
    NSString*uimgStr,*uimghStr,*isScret;//神秘人
    //12.4 分享的标题
    NSString *showTitle;
    //7.19
    //背景图片
    UIImageView *videoBackImg;
    BOOL isVideoOn,isComm,isBullet,isDianZan,isDanMu,isLaBa,isRenYiMen,pkStart,isLianMai,isPKing;
    
    NSTimeInterval reConnecTime;
    //2018.3.2  pk相关
    UIImageView *pkbackimg;
    UILabel *pktimerlab;
    NSTimeInterval pkdaojishi,pkendtime;
    UIImageView *pkEndLeftImg,*pkEndRightImg;
    //3.6 游戏相关
    LiveGameModel *gameModel;
    NSString *selectedGameIsFull;
    NSMutableArray *gameNameArr,*gameIDArr,*gameISFull,*gameHeight,*gameCover,*gameArr,*urlArr;
    UIImageView *cameraback ,*videoback;
    SLGiftAnimationView *bigAnimationView;
    //18.4.8
//    KSYFaceunityFilter * _faceUnityFilter;
    //2018.8.17 获取钱数
    NSString *currentBalance;
    NSMutableArray *msgArr;
    NSTimer *removeTimer;
    NSMutableArray *peopleuseridArr;
    TotalPeopleView *totalPeopleView;
    OpenShouHuView *openShouHuView;
    NSString *noice;
    BOOL isSetPkTime;
    NSString *winRoomnumber;
    
    NSString *leftNumber,*rightNumber;
    NSString *leftName,*rightName;
    NSInteger pkdaojishiTotal;
    NSString *currentMuteUserRoom;
    
    UITextField *tempText;
    BOOL isShowSendGiftView;
    
    TaskLiveView *taskView;
    WKWebView *wishView;
    UIView *maskView;
    BOOL isFaQiRen;
    
    WKWebView *wkWebView;
    BOOL isWebView;
    
    NSMutableArray *roadpointsArr;
    NSString *pwd;
    BOOL isHideFlyPing; // 是否隐藏飞屏
    BOOL isClearPing; // 是否清屏
    BOOL isHideAnimation; // 是否隐藏礼物特效
    BOOL isWinningMusicOFF; // 是否关闭中奖声效
    
    BOOL isShowChoose;
    NSString *sendUserName,*sendUserId;
    
    UIButton *liansongBtn;
    int leftT;
    NSTimer *hideLiansongTimer;
    int liansongGiftid,liansongGiftnum;
    NSString *liansongUserid;
    
    NSTimer *longTimer;
    
    BOOL isAllShutup; // 主播没开播全部禁言
    
    NSArray *sendGiftArr;
    // 用于更新心愿进度
    NSMutableArray *wishGiftidArr;
    NSMutableArray *wishGiftArr;
    
    NSArray *normalAvatarArr;
    BOOL isJingXiang;
    NSInteger gameTimeCount; // 红包倒计时
    
    BOOL isInto;
    NSString *game_xj_giftid;
    
    NSMutableArray *pkInfoArr;
}

@property (nonatomic, assign) BOOL selfInV2;
@property (nonatomic, assign) BOOL isPusher;
@property (nonatomic, copy) NSString *stream;
@property (nonatomic, strong) V2TXLivePlayer *pkPlayer;

@property (nonatomic, assign) NSInteger pkPeople; // pk人数
@property (weak, nonatomic) IBOutlet UIImageView *pkMultiBGView;
@property (nonatomic, strong) SLMultiPKStartView *pkMultiView;

@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) UIView *playerPKView;

@property (nonatomic, strong) UIView *hostAnchorView; // 主播自己的预览View

@property (nonatomic, copy) NSString *lookLiveTime; // 开始看直播时间戳
@property (nonatomic, assign) BOOL isSendGift; // 是否在此房间送过礼

@property (nonatomic, strong) NSTimer *gameTimer; // 红包倒计时
@property (nonatomic, copy) NSString *game_id; // 红包id
@property (nonatomic, strong) RedPackBigView *redBigView;
@property (nonatomic, strong) RedPackSmallView *redSmallView;
@property (nonatomic, copy) NSString *avatarUploadDate; // 头像更新时间

@property (weak, nonatomic) IBOutlet UIView *fangzhuView;
@property (nonatomic, copy) NSArray *avatarFrameArr;
@property (nonatomic, copy) NSMutableArray<RoomAvatarView *> *avatarOnMicArr;
@property (strong, nonatomic) RoomAvatarView *ownerView; // 自己的视频View
@property (strong, nonatomic) RoomAvatarView *avatar_0; //
@property (strong, nonatomic) RoomAvatarView *avatar_1; //
@property (strong, nonatomic) RoomAvatarView *avatar_2; //
@property (strong, nonatomic) RoomAvatarView *avatar_3; //
@property (strong, nonatomic) RoomAvatarView *avatar_4; //

@property (weak, nonatomic) IBOutlet UIImageView *pkLevelLeft;
@property (weak, nonatomic) IBOutlet UIImageView *pkLevelRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pk3ViewHeight;// 3pk的视频高度
@property (weak, nonatomic) IBOutlet UIView *zhuboPKView;
@property (strong, nonatomic) RoomAvatarView *pkAvatarOwnView; // 自己的视频View
@property (strong, nonatomic) RoomAvatarView *pkAvatarView_1; // 对方的视频View_1
@property (strong, nonatomic) RoomAvatarView *pkAvatarView_2; // 对方的视频View_2

@property (nonatomic,strong) LiveWishScrollView *liveWishScrollView;

//@property(nonatomic,assign)int pkUserCount; // pk人数


@property (strong, nonatomic)CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UIImageView *first_pay_view;

// 参数调节
@property(assign)BOOL isHiddenCar;

@property(nonatomic,assign)int attach; // 礼物数量

//9.14 添加贴片广告的数组
@property (strong, nonatomic)NSMutableDictionary *bannerInLiveDic;
@property (strong, nonatomic)SDCycleScrollView *tiePianBannerScrol;
@property (strong, nonatomic)NSMutableArray *bannerTiePianArr;
//2018.8.15添加;
@property(assign)BOOL pkOffLine;
@property (nonatomic)BOOL isPhone;
//3.23添加
@property(assign)BOOL pushSmallVideo;
//2018.3.13 添加播放1v1的背景音乐
@property(nonatomic,strong)AVAudioPlayer *backgroundMusic;
//2017.12.1
@property (nonatomic, strong)TXLiveStreamerKit * kit;
@property (nonatomic, strong)TXLiveStreamerKit * kit3;
@property (nonatomic,strong)PKView *pkview;
@property (nonatomic,strong)PKMaskView *maskView;
@property (nonatomic, strong)NSTimer*pkTimer;
//3.12 惩罚时间
@property (nonatomic, strong)NSTimer*delayEndTimer;
@property (assign) BOOL gamePush;
@property (strong, nonatomic) UIButton *finishBtn;//pk之后断开按钮
@property (strong, nonatomic) UIButton *lianMaiBtn;//主动断开连麦的按钮

@property (strong, nonatomic) UIView *hideVideoView;
@property (strong, nonatomic) UIButton *hideVideoBtn;//隐藏视频按钮
@property (strong, nonatomic) UILabel *hideVideoTitle;//隐藏视频文字
//3.6
@property (assign)BOOL chatPush;
/// 4.19
@property (strong, nonatomic) NSString *game_url;
@property (strong, nonatomic) NSString *bottom_url;
@property (strong, nonatomic) NSString *bottom_url_height;
@property (strong, nonatomic) NSString *gameid;
@property (strong, nonatomic) NSString *isSecretRoom;
//12.21
@property (strong, nonatomic) NSString *isPayMode;
///创建手势
@property(nonatomic,strong)UISwipeGestureRecognizer *leftSwipGestureRecognizer;//左划
@property(nonatomic,strong)UISwipeGestureRecognizer *rightSwipGestureRecognizer;//右划

//12.19 添加贵族的image和label
@property (weak, nonatomic) IBOutlet UILabel *guizuNum;
@property (weak, nonatomic) IBOutlet UIImageView *guizuImg;
@property (weak, nonatomic) IBOutlet UIView *guiZuViewInLive;
// 贵族页面
@property (nonatomic,strong)BuyGuiZu *guizuView;
//电话中心
@property (nonatomic, strong) CTCallCenter * callCenter;
@property(nonatomic,strong)NSMutableArray <UserInfoModel *> *friendListArray;


//好友列表
@property(nonatomic,strong)UITableView *friendListTableView;

@property (strong, nonatomic) BeginLiveModel *beginLiveModel;
//送礼之后的银票数
@property (assign, nonatomic)int lastTicket;

@property (nonatomic,strong)TheMoreView *moreView;
@property (nonatomic,strong)TheMoreView *gameMoreView;
//8.16 打赏页面
@property (nonatomic,strong)DaShangView *dashangView;
//12.4
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *cateidStr;
@property (strong, nonatomic) NSString *touch_height;

//11.6飘屏的view
@property (strong, nonatomic) UIView *flyBackView;
@property (strong, nonatomic) UILabel *flyBackLab;

/// ----------------------6.28 各种按钮和view----------------------------
//直播
@property (weak, nonatomic) IBOutlet UIView *liveShowView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;//背景scrollview
@property (weak, nonatomic) IBOutlet UIView *LayerView;//层
//飞屏
@property (nonatomic,strong)PublicChatView *flyView;
@property (nonatomic,strong)PublicChatView *flyawardView; //中奖飞屏
@property (nonatomic,strong)PublicChatView *flyawardView2; //中奖飞屏
@property (nonatomic,strong)PublicChatView *flyawardView3; //中奖飞屏
//liveShowView的左边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liveShowLeft;
//ChatManageView的底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatViewBottom;

//头像和昵称view
@property (weak, nonatomic) IBOutlet UIView *headBackImage;
//昵称
@property (strong, nonatomic) IBOutlet UILabel *nickname;
//人数
@property (strong, nonatomic) IBOutlet UILabel *count;
//头像
@property (strong, nonatomic) IBOutlet UIImageView *headView;
//vip
@property (strong, nonatomic) IBOutlet UIImageView *vipView;
//观众列表
@property (strong, nonatomic) IBOutlet CustomScrollView *watchCollention;
//值的view
@property (weak, nonatomic) IBOutlet UIView *zhenzhuCountView;
//3.9
@property (strong, nonatomic) IBOutlet UILabel *dupiao;
@property (strong, nonatomic) IBOutlet UILabel *ticket;
@property (strong, nonatomic) IBOutlet UILabel *account;
//时间
@property (strong, nonatomic) IBOutlet UILabel *time;
//当前直播间红包View
@property (strong, nonatomic) IBOutlet UIView *redPackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redPackViewRight;
//红包头像
@property (strong, nonatomic) IBOutlet UIImageView *redPackAvatar;
//发红包的人
@property (strong, nonatomic) IBOutlet UILabel *redPackName;
//红包详情
@property (strong, nonatomic) IBOutlet UILabel *redPackDesc;
//红包钱数
@property (strong, nonatomic) IBOutlet UILabel *redPackShell;
//多少钱袋+多少
@property (strong, nonatomic) IBOutlet UILabel *redPackDetaile;
//观众详情页面View
@property (strong, nonatomic) IBOutlet UIView *manageView;
//管理
@property (strong, nonatomic) IBOutlet UILabel *mansgeLab;
//头像
@property (strong, nonatomic) IBOutlet UIImageView *manageHeadImg;
//vip
@property (strong, nonatomic) IBOutlet UIImageView *vipImg;
//昵称
@property (strong, nonatomic) IBOutlet UILabel *manageNickName;
//性别
@property (strong, nonatomic) IBOutlet UIImageView *manageSex;
//关注按钮
@property (strong,nonatomic)IBOutlet UIButton *attentionBtn;
//等级
@property (strong, nonatomic) IBOutlet UIImageView *manageNack;
//等级
@property (strong, nonatomic) IBOutlet UIImageView *manageNack_anchor;
//多少级
@property (weak, nonatomic) IBOutlet UILabel *nackNum;
//靓号
@property (strong, nonatomic) IBOutlet UILabel *manageNum;
//个性签名
@property (weak, nonatomic) IBOutlet UILabel *summary;
//地区
@property (strong, nonatomic) IBOutlet UILabel *manageHome;
//前端提示
@property (strong, nonatomic) IBOutlet UILabel *balanceOut;
//送出
@property (strong, nonatomic) IBOutlet UILabel *mansgeBalance;
//关注按钮
@property (weak, nonatomic) IBOutlet UIButton *isFollowBtn;
//关注人数
@property (strong, nonatomic) IBOutlet UILabel *followNum;
//粉丝人数
@property (strong, nonatomic) IBOutlet UILabel *fansNum;
//银票数量
@property (strong, nonatomic) IBOutlet UILabel *ticketNum;
//分享View
@property (strong, nonatomic) IBOutlet UIView *shareView;
//微信 朋友圈按钮
@property (strong,nonatomic)IBOutlet UIButton *shareToWx;
@property (strong,nonatomic)IBOutlet UIButton *shareToWxFriend;
@property (weak, nonatomic) IBOutlet UIButton *shareToQuare;
@property (weak, nonatomic) IBOutlet UIButton *shareToQQ;
//ToolBar
@property (strong, nonatomic) IBOutlet UIView *toolBar;
//弹幕按钮
@property (strong, nonatomic) IBOutlet UIButton *bulletBtn;
@property (strong, nonatomic) IBOutlet UIButton *bulletBtn_1;
@property (strong, nonatomic) IBOutlet UIButton *bulletBtn_2;
@property (strong, nonatomic) IBOutlet UIButton *bulletBtn_3;
//喇叭
//@property (strong, nonatomic) IBOutlet UIButton *labaBtn;
//发送按钮
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
//输入框
@property (strong, nonatomic) IBOutlet UITextField *chatText;
//聊天以及按钮的view
@property (weak, nonatomic) IBOutlet UIView *ChatManageView;
//普通聊天
@property (strong, nonatomic) IBOutlet YYTCShowLiveMessageView *msgView;
//退出按钮
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
//聊天
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
//上下箭头
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
//私信
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
//分享
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
//更多
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
//私信页面
@property (strong, nonatomic) IBOutlet UIView *ChatViewInLive;
//私信页面当中的view
@property (weak, nonatomic) IBOutlet UIView *ChatViewInChatView;
//好友按钮
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
@property (weak, nonatomic) IBOutlet UIView *friendLine;
//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *chatBack;
//消息按钮
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIView *messageLine;
//分割线
@property (weak, nonatomic) IBOutlet UILabel *friendTitle;
//6.16
//6.16 添加守护按钮
@property (strong, nonatomic) IBOutlet UIButton *shouHuBtn;
//3.7底部按钮距底部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgheight;
//7.11增加印象按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalheight;
@property (weak, nonatomic) IBOutlet UIButton *yinxiangBtn1;
@property (weak, nonatomic) IBOutlet UIButton *yinxiangBtn2;
@property (weak, nonatomic) IBOutlet UIButton *yinxiangBtn3;
@property (weak, nonatomic) IBOutlet UIButton *addyinxiangBtn;

@property (weak, nonatomic) IBOutlet UIImageView *firstAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *fourAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *fiveAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *sixAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *sevenAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *eightAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *nineAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *tenAvatarImg;

@property (weak, nonatomic) IBOutlet UIImageView *firstBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeBgImg;
@property (weak, nonatomic) IBOutlet UILabel *shouhuNum;
@property (weak, nonatomic) IBOutlet UIButton *pkProphetBtn;

@property (weak, nonatomic) IBOutlet UIImageView *pkBgTopImg;
@property (weak, nonatomic) IBOutlet UIImageView *pkBgBottomImg;


@property (weak, nonatomic) IBOutlet UIImageView *pkAminationLeftImg;
@property (weak, nonatomic) IBOutlet UIImageView *pkAmintaionRightImg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTopHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liveTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pkBgTopImgHeight;


@property (weak, nonatomic) IBOutlet UIButton *homeReportBtn;

@property (weak, nonatomic) IBOutlet UIView *sengGiftView;
@property (weak, nonatomic) IBOutlet UITextField *sendGiftTextView;
@property (nonatomic, assign) NSInteger giftCateid;
@property (nonatomic, assign) NSInteger giftCateid_se;
@property (nonatomic, assign) NSInteger giftMoney; // 礼物数量根据面值大小来做判断

@property (weak, nonatomic) IBOutlet UIView *taskBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taskBGViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *taskBtn;
@property(nonatomic,copy)NSMutableArray *taskListArray;

@property (weak, nonatomic) IBOutlet UIView *pkLeftView;
@property (weak, nonatomic) IBOutlet UIImageView *pkleftfirstavatarimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkleftsecondavatarimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkleftthirdavatarimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkleftfirstbackimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkleftsecondbackimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkleftthirdbackimg;

@property (weak, nonatomic) IBOutlet UIView *pkRightView;
@property (weak, nonatomic) IBOutlet UIImageView *pkrightfirstavatarimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkrightsecondavatarimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkrightthirdavatarimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkrightfirstbackimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkrightsecondbackimg;
@property (weak, nonatomic) IBOutlet UIImageView *pkrightthirdbackimg;

@property (weak, nonatomic) IBOutlet UIImageView *pkSofaBGImg;

@property (nonatomic, strong) UIView *pkUserView;
@property (nonatomic, strong) UIButton *pkUserBtn;
@property (nonatomic, strong) UILabel *pkNameLab;
@property (nonatomic, strong) UIButton *pkFollowBtn;

@property (nonatomic, strong) ChatRecordView *chatRecordView;

@property (weak, nonatomic) IBOutlet UIView *avatarAnimationView;
@property (weak, nonatomic) IBOutlet UIView *cardAvatarAnimationView;
@property (nonatomic, strong) LOTAnimationView *avatarAnimation;
@property (nonatomic, strong) LOTAnimationView *cardAvatarAnimation;


@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

//2022.9.23
@property (nonatomic, strong)NSString *zhuboshowid;



//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pkViewBottomLayout;
/// ----------------------------6.28 各种按钮和view----------------------------------

////////////////////按钮点击事件响应////////////////////////
- (void)showManageView:(NSString *)userid orNumber:(NSString *)roomnumber;
//关注按钮点击事件
- (IBAction)attentionBtnAction:(UIButton *)sender;
//主播头像按钮点击事件
- (IBAction)hostAvatarAction:(UIButton *)sender;
//银票按钮点击事件
- (IBAction)ticketAction:(UIButton *)sender;
//退出直播间按钮点击事件
- (IBAction)exitBtnAction:(UIButton *)sender;
//退出红包界面
- (IBAction)exitRedPackAction:(UIButton *)sender;
//抢红包点击事件
- (IBAction)redPackAction:(UIButton *)sender;
//管理按钮点击事件
- (IBAction)mansgeBtnAction:(UIButton *)sender;
//关闭按钮点击事件
- (IBAction)closeBtnAction:(UIButton *)sender;
//关注按钮点击事件
- (IBAction)followBtnAction:(UIButton *)sender;
//个人主页点击事件
- (IBAction)homePageAction:(UIButton *)sender;
//、、1.5添加@某人的功能
- (IBAction)aitePeopleAction:(UIButton *)sender;

//分享按钮点击事件
- (IBAction)shareBtnClick:(UIButton *)sender;
//取消分享
- (IBAction)cancelShareBtnClick:(UIButton *)sender;
//弹幕开关
- (IBAction)bulletBtnAction:(UIButton *)sender;
//发送按钮
- (IBAction)sendBtnAction:(UIButton *)sender;
//发送喇叭
//- (IBAction)labaBtnAction:(UIButton *)sender;
#pragma mark --直播列表中的聊天界面
//关闭私信
- (IBAction)chatViewClose:(id)sender;
//私信弹出的视图的返回按钮点击事件
- (IBAction)chatBackClick:(id)sender;
//私信好友
- (IBAction)friendBtnClick:(id)sender;
//私信消息
- (IBAction)messageBtnClick:(id)sender;
//聊天按钮点击事件
- (IBAction)chatAction:(UIButton *)sender;
//更多按钮点击事件
- (IBAction)moreAction:(UIButton *)sender;
//连麦断开
- (void)cancelInteactWithHost;
//私信按钮
- (IBAction)privateAction:(UIButton *)sender;
//分享按钮点击事件
- (IBAction)shareAction:(UIButton *)sender;

//玩法按钮点击事件
- (IBAction)playAction:(UIButton *)sender;

//！！！！！！！！！！！！！！！自定义的按钮点击事件！！！！！！！！！！！！！！！！！
//更新余额
-(void)updateSelfBalance:(NSString *)value andSendid:(NSString *)sendid;
//音乐点击事件
- (void)musicBtnAction:(UIButton *)sender;
- (void)topSwip:(UIGestureRecognizer *)gestureRecognizer;
- (void)bottomSwip:(UIGestureRecognizer *)gestureRecognizer;
-(void)leftSwip:(UIGestureRecognizer *)gestureRecognizer;
-(void)rightSwip:(UIGestureRecognizer *)gestureRecognizer;
/// 显示爱心
- (void)showTheCartoon;
//设置禁言
-(void)switchchatBtnClicked:(int)kickoutUserid;
//添加管理员
-(void)setAdminBtnClicked:(int)kickoutUserid;
//踢出直播间
-(void)kickoutBtnClicked:(int)kickoutUserid;
//更多按钮点击
- (void)moreClick;
/// 确认连麦之后隐藏manageview
- (void)hideManageView;
//全服红包的点击事件
- (void)fullHongBaoClick:(NSString *)roomnumber;
//飞屏点击事件
-(void)flyMsgClicked:(long)userid;
//键盘return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
//单击
- (void)singleTap;
//加载游戏
- (void)loadGameView:(NSString *)type andHeight:(CGFloat)height andGameUrl:(NSString *)url;
//充值
-(void)rechargeBtnAction;
//送礼
-(void)sendGiftBtn:(UIButton *)btn;
//加载好友列表
- (void)getFriendList;
//刷新好友列表
- (void)setupRefresh;
/// 4.24
//显示聊天栏详情
-(void)showChatDetail:(UserInfoModel *)userinfo;
//显示系统消息详情
- (void)showSystemDetail;
//守护点击事件
- (IBAction)shouHuBtnAction:(UIButton *)sender;
//12.19开通贵族
- (void)kaiTongGuiBinBtn;
//8.2 websocket连接
- (void)connectedEvent;
-(void)disconnectedEvent;
-(void)connectFailedEvent:(int)code description:(NSString *)description;
-(void)closeConnect;
-(void)doConnect:(id)_delegate andUrl:(NSString *)url;
-(void)sendKickback;
- (void)assignmentLiveUserInfo;
//2017.12.6 花人民币送礼物
-(void)sendGift:(int)giftid andgiftNum:(int)giftnum andGiftPrice:(NSString *)giftprice;
-(void)sendGiftF:(int)giftid andLianSongNum:(int)giftliansongnum;
- (void)playBackCartoonModel:(SendGiftModel *)sendGiftModel andMessage:(GSPChatMessage *)chatMessage;
-(void)startCocos2d;
-(void)stopCocos2d;
-(void)bye:(int)userid;
-(void)UAA;
-(void)END;
-(void)onViewerAvatarTapped:(UserInfoModel *)info;
-(void)showGiftListInView;
-(void)showGiftListInView:(NSInteger)index;
-(void)openVideo2:(NSString *)v2_url;
-(void)closeVideo2;
//输入密码后
-(void)onPwdInput:(NSString *)pwd;
//加载游戏
-(void)loadGame;
//各个按钮点击响应事件
- (void)ButtonClickAction:(UIButton *)btn;
- (void)exitUserLive;

//更新余额
- (void)updateBalance;
- (void)finishBtnAction;

- (void)playGameAction:(UIButton *)btn;//3.6
//2018.3.2
//发起pk
- (void)beginPKActionBlock:(NSString *)time withroomnumber:(NSString *)roomnum;
- (void)suijiActionBlock:(NSString *)time andType:(NSString *)type;
- (void)agreePkActionBlock:(NSString *)time andFaqi:(NSString *)faqipeople andjieshou:(NSString *)jieshoupeople;
- (void)refusePkActionBlock:(NSString *)time andFaqi:(NSString *)faqipeople andjieshou:(NSString *)jieshoupeople;
- (void)removePkTanKuangView;
- (void)removeAllView;
//创建pk条
- (void)createPKViewWithFaQi:(NSString *)faqiren AndJieShou:(NSString *)jieshouren andTime:(NSString *)time withNumber:(int)number andPcOrNot:(BOOL)isPC;
//pk结束
- (void)pk_endwith:(NSString *)win_usernumber;
//3.22
- (void)selectGameBtnAction:(UIButton *)btn;
//2018.8.15 添加
- (void)removeDelayTime;
//2018.9.5
- (void)hideBtn;
- (void)showBtn;
- (void)loadTiePian:(NSMutableArray *)tempArr;
- (void)requestGameWithRoomNumber:(NSString *)roomnumber;//18.11.25 添加
- (void)addTiePianView;
//11.5 重置礼物个数
- (void)resetGiftNum;
- (void)resetGiftNum1:(NSString *)num;;
- (void)resetlianSongGiftNum;
- (void)resetlianSongGiftNum1:(NSString *)num;
- (void)resetAttach;
- (void)showRedPackView;
- (void)cleanUpData;

//获取礼物个数
-(NSString *)getSendGiftNum;
-(NSString *)getlianSongGiftNum;
-(void)setlianSongGiftNum:(NSString *)num;

- (void)initTotalView:(NSString *)url type:(NSInteger)type;

//弹出好友pk页面
- (void)AlertFriendView;
//定向pk
- (void)AlertDingXiangView:(PKLiveType)type;

- (void)homeAction:(UserInfoModel *)model;

- (void)goOtherRoom:(NSString *)roomNum;

- (void)requestBagData;//礼物背包接口
-(void)sendGiftF:(int)giftid andLianSongNum:(int)giftliansongnum andUserid:(NSString *)userid;
// 赠送多人先计算数量
- (void)addAttachNum:(int)num;

- (void)totalPeopleViewBuyShouHu;
- (void)totalPeopleViewBuyGuiZu;
- (void)showWishView;

- (void)showGameZaDan;

-(void)showInfoFromChat:(YYTCShowLiveMsg *)msg;

- (void)showShareMimaView;
- (void)dissmissChatRecordView;

- (void)startLiansong:(int)giftid andLiansongnum:(int)giftliansongnum andUserid:(NSString *)userid;
- (void)hideLiansong;
-(void)hideLiansong1;

- (void)shouFeiAction:(UIButton *)btn;

- (void)playSFMAnimation;
- (void)playSFMAnimation2;
- (void)playSFMAnimation3;

- (void)uploadChooseGiftMoney:(NSInteger)money;
- (void)uploadChooseSendNumArr:(NSArray *)numArr;
- (void)hideSendGiftView;

- (void)belowSubView:(UIView *)belowView withView:(UIView *)view;

- (void)uploadLianMaiUserInfoView:(NSMutableArray *)info withUid:(NSString *)uid;

- (void)againloadPlayer;


- (void)showSmallView:(NSDictionary *)redpackInfo;

- (void)checkRedPackInfo;
// 观众切换房间处理
- (void)changeRoom;

-(void)showGlobalHB:(NSString *)hbid andLeftTime:(int)time;
- (void)getTRCTuserSig:(NSString *)roomId withBlock:(void(^)(void))block;
- (void)pusherLiveWithIsRTC:(BOOL)isRTC;

- (void)pkMultiFail;
- (void)mutilPkFail;
- (void)pkMultiStartAction:(NSString *)action;
- (void)overMultiPK:(BOOL)isInitiative;

- (void)touchOtherRoomBtnAction;
- (void)lianmaiStartPusher:(RoomAvatarView *)view;
- (void)lianmaiEndPusher;
- (void)lianmaiEndLive;

- (void)touchesBeganClick;
- (void)pushZhuboVoice:(NSMutableArray *)rooms;


- (void)inviteOtherHost;
- (void)leaveHostActionWithRoomNumber:(NSString *)roomnumber wihtNickname:(NSString *)nickname;
- (void)uploadHostFrameWithLeaveRoom:(NSString *)roomnumber;
@end

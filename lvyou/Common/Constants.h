// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ////////////////////////////////////////////////////////////////////////
//
//  Constants.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+UIImageExt.h"

#ifdef DEBUG
#define FLOG(fmt,...)    NSLog((@"[%@][%d] " fmt),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,##__VA_ARGS__)
#else
#define FLOG(str, args...) ((void)0)
#endif

#define XG_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#define IOS7_OR_LATER   ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define IOS8_OR_LATER   ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define IOS9_OR_LATER   ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
#define IOS10_OR_LATER   ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#define IOS11_OR_LATER   ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)
#define IOS13_OR_LATER   ([[UIDevice currentDevice].systemVersion doubleValue] >= 13.0)
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 状态栏高度
#define StatusBar_HEIGHT (SCREEN_HEIGHT >= 812.0 ? 44 : 20)
#define NavigationBar_HEIGHT ([UIScreen mainScreen].bounds.size.height >= 812.0 ? 88 : 64)
//TabBar高度
#define TabBar_HEIGHT ([UIScreen mainScreen].bounds.size.height >= 812.0 ? 83 : 49)
// 是否是iPhone X
#define iphoneX [UIScreen mainScreen].bounds.size.height >= 812.0
//segmentControl高度
#define Segment_HEIGHT 35

#define  appThirdLogin  [[HudHelper hudHepler]showTips:self.view tips:@"配置之后才能进行登录"];
#define  appThirdShare  [[HudHelper hudHepler]showTips:self.view tips:@"配置之后才能进行分享"];
//获取版本
#define MyAppBuilder [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:a]
// CommonLibrary中常用的字体
#define kCommonMiddleTextFont      [UIFont systemFontOfSize:14]

//2018.3.13 添加
#define kRefreshWithNewaTimeInterval    20  //主页热门定时刷新的时间

#define SharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//主题色
#define colorHead [UIColor colorWithHex:0xFF5B87]
#define colorMember [UIColor colorWithRed:181.0/255.0 green:133.0/255.0 blue:45.0/255.0 alpha:1.0]
#define colorPlaceholder [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:195.0/255.0 alpha:1.0]
#define colorYellowTint [UIColor colorWithRed:252.0/255.0 green:184.0/255.0 blue:4.0/255.0 alpha:1.0]
#define colorLetterGray3 [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]
#define colorLetterGray4 [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]
#define colorLetterGray5 [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]
#define colorWhite [UIColor colorWithHex:0xFFFFFF]
#define colorNavColor @[[UIColor colorWithHex:0xFFFFFF],[UIColor colorWithHex:0xFFFFFF]]
#define colorBtnColor @[[UIColor colorWithHex:0xFF5B87],[UIColor colorWithHex:0xFF5B87]]

//#define colorBlack [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:1.0]

#define kAppLargeTextFont       [UIFont systemFontOfSize:16]
#define kAppMiddleTextFont      [UIFont systemFontOfSize:14]
#define kAppSmallTextFont       [UIFont systemFontOfSize:12]

// 2.24
#define ScreenBiLi [UIScreen mainScreen].bounds.size.width/375
#define PRODUCTID @"id" //商品ID
#define ADbanner  @"adbanner"
#define PayRoom  @"0" //收费房贵族权限（公爵以上收费房无效，仅限蛟龙）

#define PKTime  @"5"
//请求数据相关
extern NSString *  DATAAPI;
extern NSString *  DATAAPITWO;
extern NSString *  CHAT;
extern NSString *  XMPPDOMAIN;
extern NSString *  IMAGEAPI;
extern NSString *  ShareURL;
extern NSString *  TXTRCTUserSig;

extern NSString * const Authorization;
extern NSString * const Device;
extern NSString * const APIVersion;     //版本
extern NSString * const AppName;        //App名称
extern NSString * const AppVersionName;        //版本号
extern NSString * const AppSchemeName;
extern NSString * const pwdConfig;
extern NSString * const TRTCSDKAppID;//腾讯云 TRTC SDKAppID
extern NSString * const BuglyID;//崩溃日志id
extern NSString * const InstallID;//免邀请码id
extern NSString * const DownLoadName;
//加载图片之前的占位图
extern NSString * const placeHolderImageName;
extern NSString * const placeCoverImage;

//心跳时间
extern NSInteger HeartBeatSecond;
//红包计时器时间
extern NSInteger RedPackSecond;

extern NSString * const OtherSidePush;//对面房间

//默认取值的个数
extern NSString * const GiveNum;

//登录注册类型
typedef NS_ENUM(NSInteger, NSDataRrquestUserOauthType)
{
    NSDataRrquestUserOauthTypeMobile        = 1,
    NSDataRrquestUserOauthTypeWeiBo         = 2,
    NSDataRrquestUserOauthTypeQQ            = 3,
    NSDataRrquestUserOauthTypeWeiXinApp     = 4,
    NSDataRrquestUserOauthTypeWeiXinPublic  = 5,
    NSDataRrquestUserOauthTypeApple         = 6,
};

//自定义消息类型
typedef NS_ENUM(NSInteger, ImCustomMsgModelType)
{
    IM_TYPE_GIFT                = 1,   //礼物//
    IM_TYPE_ENTER               = 6,   //进入房间//
    IM_TYPE_EXIT                = 7,   //退出房间//
    IM_TYPE_PROHIBIT            = 8,   //禁言//
    IM_TYPE_KICKOUT             = 9,   //踢出房间//
    IM_TYPE_FOLLOW              = 11,  //关注主播//
    IM_TYPE_LEVEL_UP            = 12,  //用户升级
    IM_TYPE_STAR                = 14,  //点赞//
    IM_TYPE_UNPROHIBIT          = 15,  //取消禁言//
    IM_TYPE_CHAT_MSG            = 18,  //前端自定义聊天消息
    IM_TYPE_CHOU_MSG            = 19,  //抽奖砸蛋
    //设置场控
    IM_TYPE_LIVE_ADMIN_SET_GUARD  = 10010,
    //取消场控
    IM_TYPE_LIVE_ADMIN_UNSET_GUARD  = 10011,
};

//礼物的标志类型
typedef NS_ENUM(int, NSDataLiveGiftSignType)
{
    NSDataLiveGiftSignTypeNone           = 1,     //未选中礼物
    NSDataLiveGiftSignTypeGift           = 2,     //礼物列表
    NSDataLiveGiftSignTypeBag            = 3,     //背包中的礼物
};
//消息标志类型
typedef NS_ENUM(int, NSDataLiveMessageType)
{
    NSDataLiveMessageTypeFollow           = 1,     //关注
    NSDataLiveMessageTypeComment          = 2,     //评论
    NSDataLiveMessageTypeLike             = 3,     //点赞
};

// 直播间pk类型是 随机还是定向
typedef NS_ENUM(int ,PKLiveType) {
    PKLiveTypeSuiJi,   //随机pk
    PKLiveTypeDingXiang  //定向pk
};

//日期格式
extern NSString * const TimeStyle;
extern NSString * const TimeShortDetaiStyle;
extern NSString * const TimeDetailedStyle;

//加载与刷新
extern NSString * const headerPullToRefreshText;
extern NSString * const headerReleaseToRefreshText;
extern NSString * const headerRefreshingText;

extern NSString * const footerPullToRefreshText;
extern NSString * const footerReleaseToRefreshText;
extern NSString * const footerRefreshingText;

//本地等级数据列表Key
extern NSString * const RankListKey;
//本地礼物数据列表的Key
extern NSString * const RequestGiftListKey;
//本地座驾数据列表的Key
extern NSString * const HorseListKey;
//Weibo
extern NSString * const kwbAppKey;
extern NSString * const kwbScheme;
extern NSString * const kwbSecret;
extern NSString * const kwbRedirectURI;
//Weixin
extern NSString * const kwxAppId;
extern NSString * const kwxScheme;
extern NSString * const kwxSecret;
extern NSString * const kwxLink;
//QQ
extern NSString * const kqqAppId;
extern NSString * const kqqScheme;
extern NSString * const kqqSecret;

//AMap
extern NSString * const kAmapAppkey;

//微信支付
extern NSString * const kIP;
extern NSString * const APP_ID;                 //APPID
extern NSString * const APP_SECRET;    //appsecret
//商户号，填写商户对应参数
extern NSString * const MCH_ID;
//商户API密钥，填写相应参数
extern NSString * const PARTNER_ID;

//弹出框
extern NSInteger const numberOfItemsInRow;

//提示位置
extern NSString * const ToastDefaultPosition;
//顶部位置
extern NSString * const ToastDefaultPositionTop;

/***
 *
 *  相关代理方法
 *
 ***/
//用户修改密码成功
@protocol UserResetDelegate <NSObject>

- (void)userResetSucceed:(NSString *)username andType:(NSInteger)type;

@end

//用户选择星座成功
@protocol ConstellationDelegate <NSObject>

- (void)constellationSucceed:(NSString *)constellation;

@end

//用户选择城市成功
@protocol AddressChooseDelegate <NSObject>

- (void)addressChooseSucceed:(NSDictionary *)city;

@end

//直播话题选择成功
@protocol LiveThemeDelegate <NSObject>

- (void)liveThemeSucceed:(NSString *)themeName andID:(NSString *)themeid;

@end

@interface Constants : NSObject

@end

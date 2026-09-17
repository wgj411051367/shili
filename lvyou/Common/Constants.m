// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
//
//
// ///////////////////////////////////////////////////////////////////////////
//
//  Constants.m
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "Constants.h"
//占位图
NSString * const placeHolderImageName       = @"icon_login_head";
NSString * const placeCoverImage            = @"live";
//正式
NSString *  DATAAPI                         = @"";
NSString *  DATAAPITWO                      = @"";
NSString *  CHAT                            = @"";
NSString *  IMAGEAPI                        = @"";
// 2.3 私信服务器域名
NSString *  XMPPDOMAIN                      = @"";
//提现分享的地址
NSString *  ShareURL                        = @"";
NSString * TXTRCTUserSig              = @"";

NSString * const pwdConfig                  = @"h6wf97h2";// 解密
NSString * const TRTCSDKAppID               = @"1400754835";// 腾讯云 TRTC SDKAppID
NSString * const BuglyID                   = @"e81fb6850e";// 崩溃日志id
NSString * const InstallID                  = @"eCFKOV";// 免邀请码



//AMap
NSString * const kAmapAppkey                = @"a21b558f2f35f4d8c6503705716915cf";

NSString * const Authorization              = @"Authorization";
NSString * const Device                     = @"Device";
NSString * const APIVersion                 = @"v4";// 版本
NSString * const AppName                    = @"实力直播";// App名称
NSString * const AppSchemeName              = @"shili";
NSString * const AppVersionName             = @"V1.0(100)";// app提交版本

NSString * const OtherSidePush=@"来自对面房间的";//对面房间

//Weibo
NSString * const kwbAppKey                  = @"";
NSString * const kwbScheme                  = @"";
NSString * const kwbSecret                  = @"";
NSString * const kwbRedirectURI             = @"http://www.weibo.com";
//Weixin
NSString * const kwxAppId                   = @"wx190d58f44820a985";
NSString * const kwxScheme                  = @"wx190d58f44820a985";
NSString * const kwxSecret                  = @"6aefc1a777bb121f164041af11f09266";
NSString * const kwxLink                    = @"https://ju4.com/shili/";
//微信支付
NSString * const APP_ID                     = @"wx190d58f44820a985";// APPID
NSString * const APP_SECRET                 = @"6aefc1a777bb121f164041af11f09266";// appsecret
NSString * const kIP                        = @"http://211.149.242.216";
//QQ
NSString * const kqqAppId                   = @"";
NSString * const kqqScheme                  = @"tencent";

//商户号，填写商户对应参数
NSString * const MCH_ID                     = @"";
//商户API密钥，填写相应参数
NSString * const PARTNER_ID                 = @"";

//倒计时间
NSInteger HeartBeatSecond                   = 10;
//红包计时器时间
NSInteger RedPackSecond                     = 30;

//默认取值的个数
NSString * const GiveNum                    = @"5";

NSString * const DownLoadName               = @"来直播邂逅美女,签到还能获得大礼包噢";
//日期格式
NSString * const TimeStyle                  = @"YYYY-MM-dd";
NSString * const TimeShortDetaiStyle        = @"YYYY-MM-dd HH:mm";
NSString * const TimeDetailedStyle          = @"YYYY-MM-dd HH:mm:ss";

//本地等级数据列表Key
NSString * const RankListKey                = @"iSailorV1UserRankListKey";
//本地礼物数据列表的Key
NSString * const RequestGiftListKey         = @"iSailorV1LiveRequestGiftListKey";
//本地座驾列表
NSString * const HorseListKey               = @"horseListKey";
//加载与刷新
NSString * const headerPullToRefreshText    = @"下拉刷新";
NSString * const headerReleaseToRefreshText = @"松开马上刷新";
NSString * const headerRefreshingText       = @"正在赶来...";

NSString * const footerPullToRefreshText    = @"上拉加载";
NSString * const footerReleaseToRefreshText = @"松开马上加载";
NSString * const footerRefreshingText       = @"正在赶来...";

//弹出框
NSInteger const numberOfItemsInRow          = 3;
//提示位置
NSString * const ToastDefaultPosition       = @"center";
//顶部位置
NSString * const ToastDefaultPositionTop    = @"top";

@implementation Constants

@end

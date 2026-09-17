// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  AppDelegate.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "BaseModel.h"
#import "UserDBHelper.h"
#import "ToolHelper.h"
#import "Constants.h"
#import "WXApi.h"
#import "HudHelper.h"
#import "QQHelper.h"
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "JInstall.h"
#import "JuSiIMClient.h"
#import "TagsAnchorModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,IJuSiIMClientDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)appDelegate;
//2018.3.7
/**
 * 是否允许转向
 */
// 5.29 当天首次启动
@property(assign)BOOL needCheck;
@property(nonatomic,assign)int CheckTime;
@property(nonatomic,strong)NSString *launchTime;
@property(nonatomic,assign)BOOL allowRotation;
@property (strong, nonatomic) JuSiIMClient *imclient;
@property (strong, nonatomic) NSString *taskID;
@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) PushModel *pushModel;
@property (strong, nonatomic) NSString *liveTitle;
@property (strong, nonatomic) NSString *roomNumber;
@property (strong, nonatomic) NSString *showID;//4.28添加
@property (strong, nonatomic) NSString *hongbaoID;//5.31添加
@property (strong, nonatomic) NSString *currentBalance;//5.31添加
@property (strong, nonatomic) NSString *currentUserID;//5.31添加
@property (strong, nonatomic) BeginLiveModel *beginLiveModel;
@property (strong, nonatomic) NSArray *liveThemeArray;
@property (assign, nonatomic) BOOL isshareGetCode;
@property (assign, nonatomic) BOOL isSignSuccess;//6.4 添加
@property (assign, nonatomic) BOOL issharewithdraw;
@property (assign, nonatomic) BOOL isBandWX;

@property (assign, nonatomic) BOOL isConnet;

@property (nonatomic, copy) NSMutableArray <TagsAnchorModel *>*tagsAnchors;
@property (nonatomic, copy) NSMutableArray *tagsTitles;
@property (nonatomic, copy) TagsAnchorModel *tagsAnchorModel;

@property (nonatomic, strong) UINavigationController *navCtr;

@property (nonatomic, assign) NSInteger isTable;
@property (nonatomic, assign) BOOL isScreen;

//本地等级列表
@property (strong, nonatomic) NSMutableDictionary *zhuboRankDic;
//本地等级列表
@property (strong, nonatomic) NSMutableDictionary *rankDic;
//本地礼物列表
@property (strong, nonatomic) NSMutableDictionary *giftDic;
//2017.12.1 礼物分类
@property (strong, nonatomic) NSMutableArray *giftCateArray;
//本地座驾列表
@property (strong, nonatomic) NSMutableDictionary *horseDic;
/// 2.20 判断是否要认证
@property (strong, nonatomic)NSString *verify;
//当前定位城市
@property (strong, nonatomic) NSString *nonceCityCode;
@property (strong, nonatomic) NSString *nonceLocation;
@property (strong, nonatomic) NSString *nonceLat;
@property (strong, nonatomic) NSString *nonceLng;

@property (strong, nonatomic) NSMutableArray *winningSFMArray;
@property (strong, nonatomic) NSMutableArray *winningSFMArray2;
@property (strong, nonatomic) NSMutableArray *winningSFMArray3;
@property (strong, nonatomic) NSMutableArray *otherSFMArray;
@property (assign, nonatomic) NSInteger isWinningMusicOFF; // 中奖音效开关

@property (assign, nonatomic) BOOL isLogin;

@property (nonatomic, assign) CGRect micRect;

//@property (assign, nonatomic) MAMapPoint myLocation;
//1.24修改strong为copy
@property (nonatomic,copy)void  (^wxGetAccess_token)(NSString *);
@property (nonatomic,copy)void  (^wxGetBand)();
@property (nonatomic,copy)void  (^wxPaySuccess)();
@property (nonatomic,copy)void  (^wxPayCancel)();
@property (nonatomic,copy)void  (^shareGetWitgdraw)();
@property (nonatomic,copy)void  (^wbGetUserInfo)(NSString *access_token,NSString *user_id);
//直播前分享
@property (nonatomic,copy)void (^liveShare)();
//结束直播前分享
@property (nonatomic,copy)void (^endLiveShare)();

- (void)pushToChatViewControllerWith:(UserInfoModel *)user;
//1.16 弹出提示框
- (void)popupErrorMsg:(NSString *)msg;
- (void)popupErrorTitle:(NSString *)title;
- (void)pushToOtherUserPageWith:(NSString *)userId;
//-(void)disconnectFromXMPP;
//8.25 修改
- (void)accrssLiveRoom:(NSString *)userid;
- (NSString *)getCurrentModel;
//2018.11.24添加
- (void)setupStream;
- (void)removeAllDefaultData;
- (NSString *)unionidStr;
- (void)updateMyApnsToken;
// 进入主 App 后（已同意协议+登录）再请求定位，避免启动即弹授权（App Store 5.1.1）
- (void)initializeLocationService;

- (void)showAdolescentModelVC;
@end



// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  AppDelegate.m
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//
#import "AppDelegate.h"
#import "shili-Swift.h"
#import "MBProgressHUD.h"
#import "MessageHelper.h"
#import "GameAudienceViewController.h"
#import <UserNotifications/UserNotifications.h>

#import "AdvertiseView.h"
#import  <sys/utsname.h>
#import "JSKeyChainDataManager.h"
#import <Bugly/Bugly.h>
#import <CoreLocation/CoreLocation.h>

//#import "TXLiveBase.h"
//#import "TXLiteAVSDK.h"
#import "TXLiteAVSDK_Professional/TXLiteAVSDK.h"


#import "PlaceViewController.h"

#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)
#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)

@interface AppDelegate ()<CLLocationManagerDelegate,UNUserNotificationCenterDelegate>
{
    //定位相关
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder * _geocoder;//初始化地理编码器
    
    //IMALoginParam * loginAVParam;
    
    BaseTabBarController * tabBarVC;
    
    BOOL isPush;
    
    BOOL customCertEvaluation;
    
    BOOL isXmppConnected;
    NSInteger reconnectCount;
    BOOL isReconnecting;
    NSInteger pingTimeoutCount;
    
    NSInteger getDATACount;
    
    NSInteger imdisconnectedCount;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    isPush = YES;
    self.isTable = 0;
    [self getCurrentHost];//获取项目中的主api地址
    //2018.3.25 不解码图片：setShouldDecompressImages 在 SDWebImage 5.x 已移除
    //（5.x 改为异步解码 + 更优内存管理，该 4.x 时代的优化已过时，直接移除）
    //    //注册APNS
    [self registerUserNotification];
    //4.12 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
    
    //icon通知个数设置
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    //配置相关工程
//    [self baseSet];
//
//    [self versionUpdate];
//    //7.28广告启动页
//    [self getAdvertisingImage];
    //2018.5.30 添加 当天第一次和第二次登录的时候弹出每日登录提示框 并且可切换账号
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    if([locationString isEqualToString: [[NSUserDefaults standardUserDefaults] objectForKey:@"time"]]){
        //说明是第一次启动
    }
    else
    {
        self.CheckTime=0;
        self.launchTime=locationString;
        [[NSUserDefaults standardUserDefaults] setObject:SharedAppDelegate.userModel.user.id forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setObject:self.launchTime forKey:@"time"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.CheckTime] forKey:@"checktime"];
        [[NSUserDefaults standardUserDefaults] setBool:self.needCheck forKey:@"check"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
     self.needCheck=YES;

    [Bugly startWithAppId:BuglyID];
    
    NSLog(@"%@",[JSKeyChainDataManager readUUID]);
//    [GSKeyChainDataManager deleteUUID];
    if (![JSKeyChainDataManager readUUID]) {
        NSString *deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [JSKeyChainDataManager saveUUID:deviceUUID];
    }
    NSLog(@"%@",[JSKeyChainDataManager readUUID]);
    
    // 定位不在启动时请求（App Store 5.1.1：需在有上下文时再请求）。
    // 改为进入主 App（BaseTabBarController，即用户已同意协议并登录后）时才请求。
    // [self initializeLocationService];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    self.window.rootViewController = [[PlaceViewController alloc] init];
    
    // 显示出来
    [self.window makeKeyAndVisible];

    [self checkDATAAPISuccess:launchOptions];
    
    [TXLiveBase setLicenceURL:@"https://license.vod2.myqcloud.com/license/v2/1259708161_1/v_cube.license" key:@"4dbcfc81526cc1ee432f7a291575c3b1"];
    NSLog(@"SDK Version = %@",[TXLiveBase getSDKVersionStr]);
//    TXL
    return YES;
    
}

- (BOOL)checkReachability {
    return [[ToolHelper toolHelper] connectedToNetwork];
}



- (void)checkDATAAPISuccess:(NSDictionary *)launchOptions {
    if (![self checkReachability]) {
        getDATACount++;
        if (getDATACount%8 == 0) {
            [[HudHelper hudHepler] showShortTips:self.window tips:@"您的网络状态不佳，请检查网络"];
        }
        NSLog(@"域名获取失败");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkDATAAPISuccess:launchOptions];
            
        });
    } else {
        NSLog(@"网络可用：%@", DATAAPI);
        [[RootHttpHelper httpHelper] requestBalanceToBiLi];
        //配置相关工程
        [self baseSet];

        [self versionUpdate];
        //7.28广告启动页
        [self getAdvertisingImage];

        
        //2018.5.30 添加 当天第一次和第二次登录的时候弹出每日登录提示框 并且可切换账号
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSString * locationString=[dateformatter stringFromDate:senddate];
        if([locationString isEqualToString: [[NSUserDefaults standardUserDefaults] objectForKey:@"time"]]){
            //说明是第一次启动
        }
        else
        {
            self.CheckTime=0;
            self.launchTime=locationString;
            [[NSUserDefaults standardUserDefaults] setObject:SharedAppDelegate.userModel.user.id forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults] setObject:self.launchTime forKey:@"time"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.CheckTime] forKey:@"checktime"];
            [[NSUserDefaults standardUserDefaults] setBool:self.needCheck forKey:@"check"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
         self.needCheck=YES;
        ///3.27 添加崩溃查询
        [Bugly startWithAppId:BuglyID];
        
    NSLog(@"%@",[JSKeyChainDataManager readUUID]);
    //    [GSKeyChainDataManager deleteUUID];
        if (![JSKeyChainDataManager readUUID]) {
            NSString *deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
            [JSKeyChainDataManager saveUUID:deviceUUID];
    }
    NSLog(@"%@",[JSKeyChainDataManager readUUID]);
    }
}


- (void)getCurrentHost
{
    NSString *host = @"https://m.cxlzc.com";
    DATAAPI = [host stringByAppendingString:@"/"];
    NSLog(@"API host: %@", DATAAPI);
}


- (void)initializeLocationService {
    if (_locationManager) {   // 已初始化过则只重新开始定位，避免重复请求授权
        [_locationManager startUpdatingLocation];
        return;
    }
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];//开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
    //初始化地理编码器
    _geocoder = [[CLGeocoder alloc] init];
}

#pragma mark - 定位(获取用户当前经纬度)
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
//    CLLocationDegrees latitude = location.coordinate.latitude;
    // 经度
//    CLLocationDegrees longitude = location.coordinate.longitude;
    
    NSLog(@"++++++++++++当前位置 纬度: %f",location.coordinate.latitude);
    NSLog(@"++++++++++++当前位置 经度: %f",location.coordinate.longitude);
    NSLog(@"----我定位到位置了 哈哈哈哈");
    SharedAppDelegate.nonceLat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    SharedAppDelegate.nonceLng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%lf", location.coordinate.longitude]);
//    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", location.coordinate.longitude, location.coordinate.latitude,location.altitude,location.course,location.speed);
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            // 位置名
            NSLog(@"name,%@",placemark.name);
            // 街道
            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            // 子街道
            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            // 市
            NSLog(@"locality,%@",placemark.locality);
            // 区
            NSLog(@"subLocality,%@",placemark.subLocality);
            // 国家
            NSLog(@"country,%@",placemark.country);
            
//            NSLog(@"++++++++++++具体地址: %@,%@%@%@%@%@",address,province,city,district,street,number);
            self.nonceLocation = city;
//            self.nonceCityCode = cityCode;
            
        }else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    [manager stopUpdatingLocation];//不用的时候关闭更新位置服务
}

#pragma mark -  版本更新提示
- (void)versionUpdate
{
    //请求更新的版本
    NSString *version =[NSString stringWithFormat:@"%@iumobile/apis/index.php?action=app_update&platform=ios",DATAAPI];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:MyAppBuilder forKey:@"version"];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:version andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
        if ([successData[@"code"] intValue]==200)
        {
            if ([successData[@"version_must"]isEqualToString:@"1"])
            {
                [[RootHttpHelper httpHelper] achieveCommonPostURL:users_logout andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
                    [[RootHttpHelper httpHelper] setUserToken:@""];
                    SharedAppDelegate.userModel.token = nil;
                    //清除本地用户信息
                    [SharedAppDelegate removeAllDefaultData];
//                    //1.10 退出账号的时候需要断开私信xmpp的连接
//                    [SharedAppDelegate disconnectFromXMPP];
                    //1.18 退出账号的时候删除当前账号发送的message私信的信息   !!!!!!!!!!!!
//                    [[UserDBHelper userDBHelper] deleteMsg:SharedAppDelegate.userModel.user.id];
                    
                    LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
                    UINavigationController * navigationView = [[UINavigationController alloc]initWithRootViewController:loginView];
                    SharedAppDelegate.window.rootViewController = navigationView;
                }];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:successData[@"url"]]];
            }
            else
            {
                UIAlertController *control =[UIAlertController alertControllerWithTitle:@"更新提示" message:@"升级新版本会有更好的体验哦,是否去更新?" preferredStyle:UIAlertControllerStyleAlert];
                [tabBarVC presentViewController:control animated:YES completion:nil];
                UIAlertAction *cancle =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sure =[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:successData[@"url"]]];
                }];
                [control addAction:cancle];
                [control addAction:sure];
            }
        }
    }];
}

- (void)removeAllDefaultData
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"token"];
    [userDefault removeObjectForKey:RankListKey];
    [userDefault removeObjectForKey:RequestGiftListKey];
    [userDefault removeObjectForKey:HorseListKey];
    [userDefault removeObjectForKey:@"RMB_XNB"];
    [userDefault removeObjectForKey:@"money_name"];
    [userDefault removeObjectForKey:@"money_name2"];
    [userDefault removeObjectForKey:@"usernumber_name"];
    [userDefault removeObjectForKey:@"pay_IPHONE_REDUCE"];
    [userDefault removeObjectForKey:@"person_verify"];
    [userDefault removeObjectForKey:@"market"];
    [userDefault removeObjectForKey:@"quanfu_hongbao_price"];
    [userDefault removeObjectForKey:@"flymsg_price"];
    [userDefault removeObjectForKey:@"announce_price"];
    [userDefault removeObjectForKey:@"show_info_level"];
    [userDefault removeObjectForKey:@"phone_number"];
    [userDefault removeObjectForKey:@"room_share_address"];
    [userDefault removeObjectForKey:@"share_jump_url"];
    //9.27 移除小视频相关参数
    [userDefault removeObjectForKey:@"upload_file_type"];
    [userDefault removeObjectForKey:@"upload_file_api_address"];
    [userDefault removeObjectForKey:@"upload_file_aliyun_oss_domain"];
    [userDefault removeObjectForKey:@"upload_file_aliyun_oss_name"];
    [userDefault removeObjectForKey:@"upload_file_aliyun_access_id"];
    [userDefault removeObjectForKey:@"upload_file_aliyun_access_key"];
    [userDefault removeObjectForKey:@"kaibo_title"];
    [userDefault removeObjectForKey:@"cdn_domain"];
    [userDefault removeObjectForKey:@"userlist_domain"];
    [userDefault removeObjectForKey:@"im_domain"];
    [userDefault removeObjectForKey:@"chat_address"];
    [userDefault removeObjectForKey:@"pknumber"];
//    [userDefault removeObjectForKey:@"apnstoken"];//2081.9.4 移除apnstoken
    [userDefault removeObjectForKey:@"notice"];
    [userDefault removeObjectForKey:@"pay_manual"];
    [userDefault removeObjectForKey:@"home_tip"];
    [userDefault removeObjectForKey:@"kefu_wx_1"];
    [userDefault removeObjectForKey:@"kefu_wx_2"];
    [userDefault removeObjectForKey:@"locationCity"];
    [userDefault removeObjectForKey:@"locationType"];
    [userDefault removeObjectForKey:@"yaoqingma"];
    [userDefault synchronize];
    
    self.isLogin = NO;
}
//获取免邀请码的值
- (NSString *)unionidStr
{
    NSString *unionidStr=@"1000";
    NSDictionary *dic=[JInstall getInfo:InstallID];
    if ([dic objectForKey:@"code"]) {
        if ([dic[@"code"] intValue]==200) {
            NSDictionary *data=dic[@"data"];
            if ([data objectForKey:@"u"]) {
                unionidStr=data[@"u"];
            }
        }
    }
    NSLog(@"免邀请码的u===%@",unionidStr);
    return unionidStr;
}

#pragma mark - 配置相关工程
- (void)baseSet
{
//    [self setupStream];
    // 创建window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    // 系统识别码
    UIDevice *device = [[UIDevice alloc] init];
    _UUID = device.identifierForVendor.UUIDString;

    //(私信数据库)
    if ([[UserDBHelper userDBHelper] isTableOK:@"message"])
    {
    }
    else
    {  //创建私信数据库
        [[UserDBHelper userDBHelper] foundUpMessageTable];
    }
    //删除数据库，使用userdefault
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *token=[userDefault objectForKey:@"token"];
    _userModel=[[UserModel alloc] init];
    if (token!=nil) {
        if (![token isEqualToString:@""]) {
            _userModel.token=token;
            [[RootHttpHelper httpHelper] setUserToken:token];
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            [params setValue:MyAppBuilder forKey:@"version_app"];
            [[RootHttpHelper httpHelper] achieveCommonGetURL:users_info andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
                NSError *err = nil;
                UserInfoModel *userInfoModel = [[UserInfoModel alloc] initWithDictionary:successData error:&err];
                ///6.25
                SharedAppDelegate.userModel.user=userInfoModel;
                //3.28
                [userDefault setObject:userInfoModel.market forKey:@"market"];
                [userDefault synchronize];
                
                //1104
                if ([userInfoModel.isblock integerValue]==1)
                {
                [[RootHttpHelper httpHelper] achieveCommonPostURL:users_logout andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
                        
                [[RootHttpHelper httpHelper] setUserToken:@""];
                SharedAppDelegate.userModel.token = nil;
                //清除本地用户信息
                [SharedAppDelegate removeAllDefaultData];
             
                LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
                UINavigationController * navigationView = [[UINavigationController alloc]initWithRootViewController:loginView];
                SharedAppDelegate.window.rootViewController = navigationView;
                    
                    }];
                    return ;
                }
                [self setupStream];
            }];
        }
    }
        if([[ToolHelper toolHelper] isBlankString:_userModel.token])  //无值
        {
                LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
                BaseNavigationController * navigationView = [[BaseNavigationController alloc]initWithRootViewController:loginView];
                self.window.rootViewController = navigationView;
        }
        else
        {
            [self updateMyApnsToken];
            // 创建tabbarController
            tabBarVC = [[BaseTabBarController alloc] init];
            // 设置跟控制器
            self.window.rootViewController = tabBarVC;
        }
    // 显示出来
    [self.window makeKeyAndVisible];
    if(IOS8_OR_LATER && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)])
    {
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UITabBar appearance] setTranslucent:NO];
    }
    //6.26 获取礼物列表
    [[RootHttpHelper httpHelper] requestGiftList];
    //8.1 获取座驾列表
    [[RootHttpHelper httpHelper] requestHorseList];

    [self wxlogin];
}

#pragma mark - ------------------------- 新版私信 --------------------------
#pragma mark - ------------------------- 新版私信 --------------------------
- (void)setupStream{
    if (!self.userModel.token) {
        return;
    }
    self.isLogin = YES;
    if (!self.imclient) {
        self.imclient=[[JuSiIMClient alloc] init:XMPPDOMAIN];
        self.imclient.delegate=self;
    } else {
        if (![self.imclient connected]) {
            self.imclient=[[JuSiIMClient alloc] init:XMPPDOMAIN];
            self.imclient.delegate=self;
        }
    }
}
- (void)teardownStream
{
    NSLog(@"t1:teardownStream");
    [self.imclient disconnect];
    self.imclient.delegate=nil;
}
- (void)goOnline
{
    imdisconnectedCount = 0;
    NSLog(@"t1:goOnline");
    NSDictionary *presence=[NSDictionary dictionaryWithObjectsAndKeys:self.userModel.user.id,@"userid",self.userModel.token,@"token", nil];
    [[UserDBHelper userDBHelper] truncateGroupMessage];
    [self.imclient invoke:@"presence" withArgs:presence];
}
- (void)dealloc
{
    [self teardownStream];
}
-(void)imConnectedEvent{
    self.isConnet = YES;
    NSLog(@"t1:im connected");
    [self goOnline];
}
-(void)imDisconnectedEvent{
    self.isConnet = NO;
    imdisconnectedCount++;
    NSLog(@"t1:im disconnected");
    if (imdisconnectedCount < 10) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupStream];
        });
    }
    
    
}
-(void)imMsgReceived:(NSString *)method andParams:(NSDictionary *)params{
    NSLog(@"================= %@ ================",method);
    NSLog(@"================= %@ ================",params);
    if ([method isEqualToString:@"ping"]) {
        self.isConnet = YES;
        [self addPingAction];
    }
    if ([method isEqualToString:@"groupchat"]) {
        NSLog(@"%@",params);
        NSDictionary *userinfo;
        NSString *groupid;
        userinfo = params[@"userinfo"];
        groupid=[params[@"to"] stringByReplacingOccurrencesOfString:@"G" withString:@""];
        if ([groupid isEqualToString:@"1"]) {
            NSString *name=@"";
            NSString *userid=@"";
            NSString *from_roomnumber=@"";
            NSString *time=@"";
            if ([userinfo.allKeys containsObject:@"roomnumber"]) {
                from_roomnumber=userinfo[@"roomnumber"];
            }
            if ([userinfo.allKeys containsObject:@"userid"]) {
                userid=userinfo[@"userid"];
            }
            if ([userinfo.allKeys containsObject:@"name"]) {
                name=userinfo[@"name"];
            }
            if ([userinfo.allKeys containsObject:@"time"]) {
                time=userinfo[@"time"];
            }
            groupid=[params[@"to"] stringByReplacingOccurrencesOfString:@"G" withString:@""];
            [[UserDBHelper userDBHelper] insertGroupMessage:userid fromUsernumber:from_roomnumber andNickname:name andMsg:params[@"body"][@"content"] andType:@"0" andRoomname:@"room" andTime:time];
            [[UserDBHelper userDBHelper] insertGroupMessage:userid fromUsernumber:from_roomnumber andNickname:name andMsg:params[@"body"][@"content"] andType:@"0" andRoomname:@"room" andTime:time];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETGROUPMSG" object:nil];
    }
    if ([method isEqualToString:@"chat"]) {
        NSLog(@"%@",params);
        NSString *toUserid,*otheruserid;
        NSDictionary *userinfo,*fileinfo,*body,*giftinfo,*locinfo,*informinfo;
        NSString *dateTime = params[@"ts"];
//        NSString *groupid;
        userinfo = params[@"userinfo"];
        toUserid = _userModel.user.id;
        otheruserid = userinfo[@"userid"];
        if ([params objectForKey:@"fileinfo"]) {
            fileinfo = params[@"fileinfo"];
//            groupid=[params[@"to"] stringByReplacingOccurrencesOfString:@"G" withString:@""];
            if (![userinfo[@"userid"] isEqualToString:self.userModel.user.id]) {
                if ([fileinfo[@"time"] integerValue] > 0) {
                    [[UserDBHelper userDBHelper] insertMessage:userinfo[@"userid"] toUserid:toUserid otherUserid:otheruserid andNickname:userinfo[@"name"] andVoice_time:fileinfo[@"time"] andMsg:[NSString convertToJsonData:fileinfo] andType:@"2" andPicid:@"-1" andDateTime:dateTime andOwner:self.userModel.user.id andInviteType:@"" andRoomnumber:@"" andTicketid:@"" andValied:@""];
                } else {
                    if ([fileinfo.allKeys containsObject:@"reviewcount"] && [fileinfo[@"reviewcount"] integerValue] > 0) {
                        [[UserDBHelper userDBHelper] insertMessage:userinfo[@"userid"] toUserid:toUserid otherUserid:otheruserid andNickname:userinfo[@"name"] andVoice_time:@"0" andMsg:fileinfo[@"filename"] andType:@"5" andPicid:fileinfo[@"picid"] andDateTime:dateTime andOwner:self.userModel.user.id andInviteType:@"" andRoomnumber:@"" andTicketid:@"" andValied:@""];
                    } else {
                        [[UserDBHelper userDBHelper] insertMessage:userinfo[@"userid"] toUserid:toUserid otherUserid:otheruserid andNickname:userinfo[@"name"] andVoice_time:@"0" andMsg:fileinfo[@"filename"] andType:@"1" andPicid:@"-1" andDateTime:dateTime andOwner:self.userModel.user.id andInviteType:@"" andRoomnumber:@"" andTicketid:@"" andValied:@""];
                    }
                }
            }
            
        } else if ([params objectForKey:@"informinfo"]) {
            informinfo = params[@"informinfo"];
            if ([informinfo[@"picscreenshotid"] isEqualToString:@""]) {
                NSDictionary *inviteinfo = params[@"informinfo"];
                if ([inviteinfo[@"informtype"] boolValue]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadOrderInfo" object:nil];
                    return;
                }
            } else {
                [[UserDBHelper userDBHelper] upDataJieTu:informinfo[@"picscreenshotid"]];
            }
            
        } else if ([params objectForKey:@"giftinfo"]) {
            giftinfo = params[@"giftinfo"];
            
            [[UserDBHelper userDBHelper] insertMessage:userinfo[@"userid"] toUserid:toUserid otherUserid:otheruserid andNickname:userinfo[@"name"] andVoice_time:@"0" andMsg:[NSString convertToJsonData:giftinfo] andType:@"3" andPicid:@"-1" andDateTime:dateTime andOwner:self.userModel.user.id andInviteType:@"" andRoomnumber:@"" andTicketid:@"" andValied:@""];
        }
        else if ([params objectForKey:@"locationinfo"]) {
            locinfo = params[@"locationinfo"];
            [[UserDBHelper userDBHelper] insertMessage:userinfo[@"userid"] toUserid:toUserid otherUserid:otheruserid andNickname:userinfo[@"name"] andVoice_time:@"0" andMsg:[NSString convertToJsonData:locinfo] andType:@"4" andPicid:@"-1" andDateTime:dateTime andOwner:self.userModel.user.id andInviteType:@"" andRoomnumber:@"" andTicketid:@"" andValied:@""];
        }
        else if ([params objectForKey:@"extrainfo"]) {
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:params[@"extrainfo"]];
            body = params[@"body"];
            [temp setValue:body[@"content"] forKey:@"content"];
//            extrainfo = params[@"extrainfo"];
            [[UserDBHelper userDBHelper] insertMessage:userinfo[@"userid"] toUserid:toUserid otherUserid:otheruserid andNickname:userinfo[@"name"] andVoice_time:@"0" andMsg:[NSString convertToJsonData:temp] andType:@"8" andPicid:@"-1" andDateTime:dateTime andOwner:self.userModel.user.id andInviteType:@"" andRoomnumber:@"" andTicketid:@"" andValied:@""];
        }
        else {
            
            body = params[@"body"];
            if (![userinfo[@"userid"] isEqualToString:self.userModel.user.id]) {
                
                if ([params.allKeys containsObject:@"inviteinfo"]) {
                    NSDictionary *inviteinfo = params[@"inviteinfo"];
                    if (![inviteinfo[@"valied"] boolValue]) {
                        [[UserDBHelper userDBHelper] msgListUploadInvalid:inviteinfo[@"ticketid"]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadPeiBanRoomInvite" object:nil userInfo:@{@"ticketid":inviteinfo[@"ticketid"]}];
                    } else {
                        [[UserDBHelper userDBHelper] insertMessage:userinfo[@"userid"] toUserid:toUserid otherUserid:otheruserid andNickname:userinfo[@"name"] andVoice_time:@"0" andMsg:body[@"content"] andType:@"6" andPicid:@"-1" andDateTime:dateTime andOwner:self.userModel.user.id andInviteType:inviteinfo[@"invite_type"] andRoomnumber:inviteinfo[@"roomnumber"] andTicketid:inviteinfo[@"ticketid"] andValied:inviteinfo[@"valied"]];
                    }
                } else {
                    [[UserDBHelper userDBHelper] insertMessage:userinfo[@"userid"] toUserid:toUserid otherUserid:otheruserid andNickname:userinfo[@"name"] andVoice_time:@"0" andMsg:body[@"content"] andType:@"0" andPicid:@"-1" andDateTime:dateTime andOwner:self.userModel.user.id andInviteType:@"" andRoomnumber:@"" andTicketid:@"" andValied:@""];
                }
            }
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETMSG" object:nil];
    }
}

-(void)imConnectFailedEvent:(int)code description:(NSString *)description{
    
}


//添加ping
- (void)addPingAction
{
    NSMutableDictionary * params=[NSMutableDictionary dictionary];
    [params setObject:@"ping" forKey:@"action"];
    [self.imclient invoke:@"ping" withArgs:params];
}
- (void)wxlogin
{
    [WXApi registerApp:kwxAppId universalLink:kwxLink];

}

#pragma mark - ---------------------- 第三方重载方法 --------------------------
- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity  API_AVAILABLE(ios(13.0)){
    [WXApi handleOpenUniversalLink:userActivity delegate:self];
    return;
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url scheme] isEqualToString:kwxScheme])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([[url scheme] isEqualToString:kqqScheme])
    {
        [QQApiInterface handleOpenURL:url delegate:[[QQHelper alloc] init]];//18.5.31修改
        if (YES == [TencentOAuth CanHandleOpenURL:url])
        {
            return [TencentOAuth HandleOpenURL:url];
        }
        //return [QQApiInterface handleOpenURL:url delegate:[[QQHelper alloc] init]];
        //return [TencentOAuth HandleOpenURL:url];
    }
//    else if ([[url scheme] isEqualToString:kwbScheme])
//    {
//        return [WeiboSDK handleOpenURL:url delegate:self];
//    }
    return NO;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:kwxScheme])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([[url scheme] isEqualToString:kqqScheme])
    {
        [QQApiInterface handleOpenURL:url delegate:[[QQHelper alloc] init]];//18.5.31修改
        if (YES == [TencentOAuth CanHandleOpenURL:url])
        {
            return [TencentOAuth HandleOpenURL:url];
        }
        //return [QQApiInterface handleOpenURL:url delegate:[[QQHelper alloc] init]];
        //return [TencentOAuth HandleOpenURL:url];
    }
//    else if ([[url scheme] isEqualToString:kwbScheme])
//    {
//        return [WeiboSDK handleOpenURL:url delegate:self];
//    }
    return NO;
}

#pragma mark ------------------------ 微信回调 ---------------------------
- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegate_ReceiveResponse" object:nil];
        if (self.liveShare) {
            self.liveShare();
        }
        if (self.endLiveShare) {
            self.endLiveShare();
        }
        switch (resp.errCode)
        {
            case WXErrCodeUserCancel:
                break;
            case WXErrCodeSentFail:
                break;
            case WXSuccess:
                if (self.isshareGetCode){
                    if (self.showID!=nil){ //6.6 修改 房间id不为nil 去分享直播间或抢红包
                        if (self.hongbaoID!=nil) {
                            [self shareWithHongBaoID];//分享抢红包
                        }
                        else if (self.taskID!=nil)
                        {
                            [self shareWithUrl:[NSString stringWithFormat:@"%@?id=%@",live_share_success,self.taskID]];
                        }
                        else
                        {
                            [self shareRoomWithShowID];//分享直播间
                        }
                    }
                    else{ //不分享房间 去签到
                        if (self.isSignSuccess) {
                            [self shareWithSign];//签到领币
                        }
                    }
                }else
                {
                    if (self.shareGetWitgdraw) {
                       self.shareGetWitgdraw();
                    }
                }
                break;
            default:
                break;
        }
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *oauthResp = (SendAuthResp *)resp;
        if (oauthResp.errCode == WXErrCodeAuthDeny)
        {
            [[HudHelper hudHepler]showShortTips:self.window tips:@"您已拒绝微信登录"];
        }
        else if (oauthResp.errCode == WXErrCodeUserCancel)
        {
            [[HudHelper hudHepler]showShortTips:self.window tips:@"您已取消微信登录"];
        }
        else if (oauthResp.errCode == WXSuccess)            //登录成功
        {
            NSString * wxCode =oauthResp.code;
            if (self.wxGetAccess_token) {
              self.wxGetAccess_token(wxCode);
              [[HudHelper hudHepler]showShortTips:self.window tips:@"授权成功,微信登录中"];
            }
            else
            {
               [[HudHelper hudHepler]showShortTips:self.window tips:@"出错了,请重试"];
            }
        }
    }
    // 微信支付回调(PayResp)已删除：微信支付整体下线，充值走苹果内购 IAP。
    // 微信登录(SendAuthResp)/分享回调保留在上面的分支。
}
- (void)shareWithUrl:(NSString *)shareur
{
    [[RootHttpHelper httpHelper] achieveCommonGetURL:shareur andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue]==200)
        {
        }
    }];
}
//抢红包分享
- (void)shareWithHongBaoID
{
    [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"share_success_qianghongbao?sid=%@",self.hongbaoID] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue]==200)
        {
            if (self.currentUserID!=nil) {
                if ([SharedAppDelegate.userModel.user.id isEqualToString:self.currentUserID])
                {
                    if (self.currentBalance!=nil) {
                        SharedAppDelegate.userModel.user.balance=self.currentBalance;
                        if (successData[@"api_msg"]!=nil) {
                            [[HudHelper hudHepler]showShortTips:self.window tips:successData[@"api_msg"]];
                        }
                    }
                }
            }
        }
    }];
}
//签到分享
- (void)shareWithSign
{

}
//分享直播间
- (void)shareRoomWithShowID
{

}
/*
#pragma mark ------------------------ 微博回调 ---------------------------
#pragma mark  微博回调
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{}
#pragma mark  微博响应信息，如认证是否成功
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegate_ReceiveResponse" object:nil];
        if (self.liveShare) {
            self.liveShare();
        }
        if (self.endLiveShare) {
            self.endLiveShare();
        }
        switch (response.statusCode)
        {
            case WeiboSDKResponseStatusCodeUserCancel:
//                [[HudHelper hudHepler]showShortTips:self.window tips:@"您已取消分享到微博"];
                break;
            case WeiboSDKResponseStatusCodeSentFail:
//                [[HudHelper hudHepler]showShortTips:self.window tips:@"发送失败"];
                break;
            case WeiboSDKResponseStatusCodeSuccess:
                                                                                                                                             
                [[HudHelper hudHepler]showShortTips:self.window tips:@"已成功分享到微博"];
                if (self.isshareGetCode) {
//                    [self getsharecode];
                    if (self.roomNumber==nil) {
                        return;
                    }
                    if (self.showID!=nil) {//4.28
                        //1021
                        [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"%@?roomnumber=%@&showid=%@",live_share_success,self.roomNumber,self.showID] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
                            
                        }];
                    }
                }else
                {
                    if (self.shareGetWitgdraw) {
                        self.shareGetWitgdraw();
                    }
                }
                break;
            default:
                break;
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])  //授权
    {//1011
        if ((int)response.statusCode == 0) {
        WBAuthorizeResponse *authorize = (WBAuthorizeResponse *)response;
         self.wbGetUserInfo(authorize.accessToken,authorize.userID);
         [[HudHelper hudHepler]showShortTips:self.window tips:@"授权成功,微博登录中"];
        }
        else if ((int)response.statusCode == -1)
        {
         [[HudHelper hudHepler]showShortTips:self.window tips:@"取消微博登录"];
        }
    }
}
*/
//创建本地通知
- (void)requestAuthor
{
    // 获取通知中心--单例
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //设置代理
    center.delegate = self;
    //获取用户的推送授权 iOS 10新方法
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                          }];
    //获取当前的通知设置，UNNotificationSettings 是只读对象，readOnly，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];
}
//应用内展示通知:
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    // 如果不想显示某个通知，可以直接用空 options 调用 completionHandler: // completionHandler([])
//
//    completionHandler(UNNotificationPresentationOptionBadge + UNNotificationPresentationOptionSound+ UNNotificationPresentationOptionAlert);
//    [self removeBadge];
//}

//- (void)removeBadge
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //移除角标
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    });
//}
//在用户与你推送的通知进行交互时被调用：
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
//    completionHandler();
//    NSLog(@"userInfo--%@",response.notification.request.content.userInfo);
//}
#pragma mark ------------------------ 个推相关方法和代理 ---------------------------
#pragma mark  个推用户注册APNS
- (void)registerUserNotification
{
    if (IOS10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{ //4.11 修改
                  [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    }else if(IOS8_10){//iOS8-iOS10
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
#pragma mark  自定义：APP被“推送”启动时处理推送处理（APP 未启动--》启动）
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions
{
    if (!launchOptions)
        return;
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
       
    }
}
#pragma mark  APP已经接收到“远程”通知(推送) - 透传推送消息  iOS7之后会走下面的方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    completionHandler(UIBackgroundFetchResultNewData);
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //这里写APP正在运行时，推送过来消息的处理
        if([[ToolHelper toolHelper] isBlankString:_userModel.token])  //无值
        {
            LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
            BaseNavigationController * navigationView = [[BaseNavigationController alloc]initWithRootViewController:loginView];
            self.window.rootViewController = navigationView;
        }
        else
        {
            //APP正在前台运行，推送过来消息的处理
            [self goToViewControllerWith:userInfo withAPP:YES];
        }
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        if([[ToolHelper toolHelper] isBlankString:_userModel.token])  //无值
        {
            LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
            BaseNavigationController * navigationView = [[BaseNavigationController alloc]initWithRootViewController:loginView];
            self.window.rootViewController = navigationView;
        }
        else
        {
            //APP在后台运行，推送过来消息的处理
            [self goToViewControllerWith:userInfo withAPP:NO];
        }
        
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        //APP没有运行，推送过来消息的处理
        if([[ToolHelper toolHelper] isBlankString:_userModel.token])  //无值
        {
            LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
            BaseNavigationController * navigationView = [[BaseNavigationController alloc]initWithRootViewController:loginView];
            self.window.rootViewController = navigationView;
        }
        else
        {   //APP没有运行，推送过来消息的处理
            [self goToViewControllerWith:userInfo withAPP:NO];
        }
    }
}
#pragma mark  APP已经接收到“远程”通知(推送) - 透传推送消息  iOS7之前会走下面的方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if([[ToolHelper toolHelper] isBlankString:_userModel.token])  //无值
    {
        LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
        BaseNavigationController * navigationView = [[BaseNavigationController alloc]initWithRootViewController:loginView];
        self.window.rootViewController = navigationView;
    }
    else
    {
       [self goToViewControllerWith:userInfo withAPP:NO];
    }
}
/// 4.12 收到推送消息点击进入相应的页面
- (void)goToViewControllerWith:(NSDictionary *)userInfo withAPP:(BOOL)isruning
{

}
- (void)startLive:(NSString *)userid
{
    

}
- (void)startOneToOneLive:(NSString *)userid
{

}
- (void)requestZhuBoData:(NSString *)haoma with:(NSString *)nick with:(NSString *)head withUserid:(NSString *)userid
{
    
}
#pragma mark - 进入直播房间
- (void)accrssLiveRoom:(NSString *)userid//主播id
{

}

#pragma mark  重载方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *myToken;
    //Xcode11打的包，iOS13获取Token有变化
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
        if (![deviceToken isKindOfClass:[NSData class]]) {
            //记录获取token失败的描述
            return;
        }
        const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
        NSString *myToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        NSLog(@"deviceToken1:%@", myToken);
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:myToken forKey:@"apnstoken"];
        [userDefaults synchronize];
        //把这个myToken传给小王，让他记录到apnstoken里面
//        NSMutableDictionary *params=[NSMutableDictionary dictionary];
//        [params setObject:myToken forKey:@"apnstoken"];
//        NSLog(@"apnstoken == %@",myToken);
//        [[RootHttpHelper httpHelper] achieveCommonPostURL:update_apnstoken andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {}];
    } else {
        myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"deviceToken2 is: %@", myToken);
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:myToken forKey:@"apnstoken"];
        [userDefaults synchronize];
        //把这个myToken传给小王，让他记录到apnstoken里面
//        NSMutableDictionary *params=[NSMutableDictionary dictionary];
//        [params setObject:myToken forKey:@"apnstoken"];
//        NSLog(@"apnstoken == %@",myToken);
//        [[RootHttpHelper httpHelper] achieveCommonPostURL:update_apnstoken andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {}];
    }
}
- (void)updateMyApnsToken
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:[userDefaults objectForKey:@"apnstoken"] forKey:@"apnstoken"];
    [[RootHttpHelper httpHelper] achieveCommonPostURL:update_apnstoken andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {}];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"您将收不到推送~~~~~~~");
}
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -------------------- 初始化AppDelegate ------------------------
+ (AppDelegate *)appDelegate
{
    
//    NSLog(@" 当前线程  %@",[NSThread currentThread]);
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    
    if (SharedAppDelegate.rankDic==nil) {
        //2018.1.6 添加获取等级列表和比例
        [[RootHttpHelper httpHelper] requestBalanceToBiLi];
    }
    if (SharedAppDelegate.horseDic==nil) {
        //2018.11.24 添加获取座驾列表
        [[RootHttpHelper httpHelper] requestHorseList];
    }
    if (SharedAppDelegate.giftDic==nil) {
        //2018.11.24 添加获取礼物列表
        [[RootHttpHelper httpHelper] requestGiftList];
    }
    isPush = YES;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied && self.nonceCityCode == nil) {
        //用户允许访问地理位置  并且没有保存用户的地理坐标
        [_locationManager startUpdatingLocation];
    }
//    if (!self.isConnet) {
        [self setupStream];
//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if (!xmppStream.isConnected){
        [self setupStream];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
}
/// 2.14  内存报警时清除缓存
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //清除缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];
}

//copy form TimChat appdelegate
- (void)pushToChatViewControllerWith:(UserInfoModel *)user
{

}
-(void)pushToOtherUserPageWith:(NSString *)userId
{
}


//1.16
- (void)popupErrorMsg:(NSString *)msg
{
    [[HudHelper hudHepler]showLongTips:self.window tips:msg];
}
- (void)popupErrorTitle:(NSString *)title
{
    [[HudHelper hudHepler]showShortTips:self.window tips:title];
}
//广告图片
/**
 *  初始化广告页面
 */
//获取当前手机机型
- (NSString *)getCurrentModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])  return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])  return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    return platform;
}
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}
- (void)getAdvertisingImage
{
    //查看有没有下载的图片
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults objectForKey:@"adImageName"]];
    NSString *url =[kUserDefaults objectForKey:@"adurl"];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {
        //显示图片
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.push_url=url;
        advertiseView.filePath = filePath;
        [advertiseView show];
    }
    NSString* phoneModel  = [self getCurrentModel];
    NSString *width;
    NSString *height;
    if (SCREEN_WIDTH==320)
    {
        width =@"320";
        if (SCREEN_HEIGHT==480)
        {
            height =@"480";
        }
        else
        {
            height =@"568";
        }
    }
    if (SCREEN_WIDTH==375)
    {
        width =@"375";
        if (SCREEN_HEIGHT==667)
        {
            height =@"667";
        }
    }
    if (SCREEN_WIDTH==414)
    {
        width =@"414";
        if (SCREEN_HEIGHT==736)
        {
            height =@"736";
        }
    }
    //8.28 修改字典为可变字典
    NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
    [params setValue:width forKey:@"width"];
    [params setValue:height forKey:@"height"];
    [params setValue:phoneModel forKey:@"iphone"];
    // TODO 请求广告接口
    NSString *urlStr =[NSString stringWithFormat:@"%@%@/ios_welcome",DATAAPI,APIVersion];
    // 从后台请求广告图片
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:urlStr andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
        NSString *adImageUrl;
        NSString *pushurl;
        if ([successData[@"api_code"] integerValue]==200)
        {
            NSMutableArray *data = [[NSMutableArray alloc]initWithArray:[successData objectForKey:@"data"]];
            if ([kUserDefaults objectForKey:@"adurl"]!=nil||![[kUserDefaults objectForKey:@"adurl"] isEqualToString:@""]) {
                [kUserDefaults removeObjectForKey:@"adurl"];
                [kUserDefaults synchronize];
            }
            if ([[successData allKeys]containsObject:@"imgs"]) {
                NSMutableArray *imgData = [[NSMutableArray alloc]initWithArray:[successData objectForKey:@"imgs"]];
                for (NSMutableDictionary *dic in imgData)
                {
                    adImageUrl = dic[@"pic"];
                    pushurl = dic[@"url"];
                    if (![pushurl isKindOfClass:[NSNull class]]) {
                        [kUserDefaults setValue:pushurl forKey:@"adurl"];
                        [kUserDefaults synchronize];
                    }
                }
            }
            else{
                for (NSString *adUrl in data)
                {
                    adImageUrl = [NSString stringWithFormat:@"%@",adUrl];
                }
            }
            
            // 获取图片名:43-130P5122Z60-50.jpg
            NSArray *stringArr = [adImageUrl componentsSeparatedByString:@"/"];
            NSString *imageName = stringArr.lastObject;
            //9.6 如果没有图片链接地址  则删除保存的老的图片
            if ([adImageUrl isEqualToString:@""])
            {
                [self deleteOldImage];
            }
            // 拼接沙盒路径
            NSString *filePath = [self getFilePathWithImageName:imageName];
            BOOL isExist = [self isFileExistWithFilePath:filePath];
            if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
                [self downloadAdImageWithUrl:adImageUrl imageName:imageName andUrl:pushurl];
            }
        }
        
        
    }];
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imgUrl imageName:(NSString *)imageName andUrl:(NSString *)pushUrl
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName];//保存文件的名称
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:pushUrl forKey:@"adurl"];
            [kUserDefaults setValue:imageName forKey:@"adImageName"];
            // 如果有广告链接，将广告链接也保存下来
            //[kUserDefaults setValue:imgUrl forKey:adUrl];
            [kUserDefaults synchronize];
            
        }else{
            NSLog(@"保存失败");
        }
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults objectForKey:@"adImageName"];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}
/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    return nil;
}
//3.7
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape;
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
    }
}



@end

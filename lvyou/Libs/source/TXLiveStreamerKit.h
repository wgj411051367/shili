#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TXLiteClient.h"
#import "TXLiteAVSDK.h"

@interface TXLiveStreamerKit: NSObject

/**
 @abstract 初始化方法
 @discussion 创建带有默认参数的 kit
 
 @warning kit只支持单实例推流，构造多个实例会出现异常
 */
- (instancetype) initWithDefaultCfg;
@property (assign, nonatomic) BOOL chatPush;
@property (assign, nonatomic) BOOL wantStop;
@property (assign, nonatomic) BOOL firstJoin;//8.15添加
@property (assign, nonatomic)int joinleave;
@property (assign, nonatomic)NSInteger joinid;

@property (assign, nonatomic)int pkUserCount;// pk人数
@property (assign, nonatomic) BOOL isPK;//8.15添加
@property (assign, nonatomic) BOOL isPush;//8.15添加
@property (assign, nonatomic) BOOL isAudience;

@property (copy, nonatomic) NSMutableArray *userinfoArr;
#pragma mark - 腾讯云 TRTC
/**
 @abstract rtc接口类
 */
@property (nonatomic, strong) TXLiteClient * txKit;

@property (nonatomic, strong) V2TXLivePusher *pusher;
@property (assign,nonatomic) V2TXLiveMode puserMode;
/*
 @abstract start call的回调函数
 */
@property (nonatomic, copy)void (^onCallStart)(int status);
/*
 @abstract stop call的回调函数
 */
@property (nonatomic, copy)void (^onCallStop)(int status);

/*
 @abstract  2018.8.15 user offline call 用户掉线的回调函数
 */
@property (nonatomic, copy)void (^onOffLine)(int status);

@property (nonatomic, copy)void (^onUserJoin)(int status);
/*
 @abstract 加入channel回调
 */
@property (nonatomic, copy)void (^onChannelJoin)(int status);
/*
 @abstract 呼叫开始
 */
@property (nonatomic, readwrite) BOOL callstarted;
/*
 @abstract 加入通道
 */
-(void)joinChannel:(NSString *)channelName andSource:(id <TRTCCloudDelegate>)source;
/*
 @abstract 离开通道
 */
-(void)leaveChannel;

/*
 @abstract 更新连麦用户数据 根据现有连麦用户重新画界面 uid离开的人是谁
 */
@property (nonatomic, copy)void (^uploadLianMaiInfo)(NSMutableArray *info,NSUInteger uid);

@property (nonatomic, copy)void (^localVideoStateChange)(void);
#pragma 窗口相关配置
/*
 @abstract 小窗口图层
 */
@property (nonatomic, readwrite) NSInteger rtcLayer;
/*
 @abstract 第二个小窗口图层
 */
@property (nonatomic, readwrite) NSInteger rtcLayer2;
/**
 @abstract 小窗口图层的大小
 */
@property (nonatomic, readwrite) CGRect winRect;
/**
 @abstract 第二个小窗口图层的大小
 */
@property (nonatomic, readwrite) CGRect winRect2;
/*
 @abstract 用户自定义图层
 */
@property (nonatomic, readwrite) NSInteger customViewLayer;
/*
 @abstract 用户自定义图层的大小
 */
@property (nonatomic, readwrite) CGRect customViewRect;
/*
 @abstract 自定义图层母类，可往里addview
 */
@property (nonatomic, readwrite)UIView * contentView;
/**
 @abstract 主窗口和小窗口切换
 */
@property (nonatomic, readwrite) BOOL selfInFront;

// 删除旁路推流地址
- (void)removePushStream;

- (void)initTXLivePusherisRTC:(BOOL)isRTC with:(UIView *)hostView;

- (void)setEncoderMirror:(BOOL)isMirror;
- (void)stopPusher;
- (void)startPusher;
// 闪光灯
- (BOOL)isCameraTorchSupported:(BOOL)isFlash;
@end

//
//  KSYKitDemoVC.h
//  KSYGPUStreamerDemo
//
//  Created by yiqian on 6/23/16.
//  Copyright © 2016 ksyun. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RoomAvatarView.h"
#import "TXLiteClient.h"
#import "TXLiteAVSDK_Professional/TRTCCloud.h"


typedef void (^RTCVideoDataBlock)(CVPixelBufferRef pixelBuffer ,int remoteCount);
typedef void (^RTCAudioDataBlock)(void* buffer,int sampleRate,int samples,int bytesPerSample,int channels,int64_t pts);


@interface TXLiteClient:NSObject

-(instancetype)initWithAppId:(NSString *)appId
                    delegate:(id<TRTCCloudDelegate>)delegate;
@property (strong, nonatomic) TRTCCloud *trtcCloud;
@property (assign, nonatomic) TRTCRoleType clientRole;
@property (nonatomic, assign) NSInteger userid;
@property (assign, nonatomic) NSInteger twoVideo;  // 第二个视频 代表的房间号
@property (assign, nonatomic) NSInteger threeVideo;// 第三个视频 代表的房间号
@property (assign, nonatomic) CGFloat pkViewY;// pk时Y轴

@property (nonatomic, assign) BOOL isPK;
@property (strong, nonatomic) TRTCTranscodingConfig *config;
@property (strong, nonatomic) TRTCMixUser *local;
@property (strong, nonatomic) TRTCMixUser *remote1;
@property (strong, nonatomic) TRTCMixUser *remote2;
@property (strong, nonatomic) TRTCMixUser *remote3;
@property (strong, nonatomic) TRTCMixUser *remote4;

@property (nonatomic, assign) BOOL isCustomSource;
@property (nonatomic, assign) BOOL joined;
@property (nonatomic, copy) NSDictionary *userInfoDic;
@property (nonatomic, copy) NSMutableArray *userInfoArr;
@property (nonatomic, copy) NSString *roomnumber;
@property (nonatomic, copy) NSString *roomnumberPK;
@property (nonatomic, assign) BOOL isHost;

/*
 @abstract 是否静音
 */
@property (assign, nonatomic) BOOL isMuted;

/*
 @abstract 加入通道
 */
-(void)joinChannel:(NSString *)channelName andSource:(id<TRTCCloudDelegate>)source;


@property(nonatomic, copy) void(^joinChannelBlock)(NSString* channel, NSUInteger uid, NSInteger elapsed);
/*
 @abstract 离开通道
 */
-(void)leaveChannel;

@property(nonatomic, copy) void(^leaveChannelBlock)(NSInteger stat);
/*
 @abstract 发送视频数据到云端
 */
-(void)ProcessVideo:(CVPixelBufferRef)buf
           timeInfo:(CMTime)pts;



- (void)setLiveTranscoding;
- (void)addThreePkUser;

- (void)addOtherRemoteLayoutUser:(NSString *)roomnumber withArr:(NSMutableArray *)infoArr;

@end

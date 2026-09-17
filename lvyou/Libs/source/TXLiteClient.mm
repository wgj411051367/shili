//
//  KSYKitDemoVC.h
//  KSYGPUStreamerDemo
//
//  Created by yiqian on 6/23/16.
//  Copyright © 2016 ksyun. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "TXLiteClient.h"
#import <CoreVideo/CVPixelBuffer.h>
#include "libyuv.h"
#import "Appdelegate.h"

#import "GenerateTestUserSig.h"

@interface TXLiteClient()<TRTCCloudDelegate>{
    unsigned char *_videoBuffer;
    int32_t _videoBufferSize;
//    BOOL _joined;
    id<TRTCCloudDelegate> _delegate;
    
    NSMutableArray *mixUsers;
}


@property (strong, nonatomic) NSString * appId;
@property(nonatomic, copy) void(^internJoinChannelBlock)(NSString* channel, NSUInteger uid, NSInteger elapsed);


-(void)processRemoteVideoWithYbuffer:(void* )ybuffer
                             Ubuffer:(void* )ubuffer
                             Vbuffer:(void* )vbuffer
                             YStride:(int)yStride
                             UStride:(int)uStride
                             VStride:(int)vStride
                              Height:(int)height
                               Width:(int)width
                         RemoteCount:(int)remoteCount;//几号位视频，从1开始
@end



@implementation TXLiteClient

- (instancetype)init {
    return [self initWithAppId:nil delegate:nil];
}
- (instancetype)initWithAppId:(NSString *)appId
                     delegate:(id<TRTCCloudDelegate>)delegate;
{
    self = [super init];
    if (self) {
        _appId = appId;
        _joinChannelBlock = nil;
        _leaveChannelBlock = nil;
        _joined = NO;
        _isMuted = NO;
        _videoBufferSize = 1920 * 1088 * 3 / 2;
        _videoBuffer = (unsigned char *)malloc(_videoBufferSize);
//        _videoDataCallback = nil;
        _delegate = delegate;
    }
    return self;
}

-(void)joinChannel:(NSString *)channelName andSource:(id <TRTCCloudDelegate>)source
{
    
    if (source!=nil) {
        self.isCustomSource=true;
    }
    else {
        self.isCustomSource=false;
    }
    if (!_userInfoArr) {
        _userInfoArr = [NSMutableArray array];
//    } else {
//        [_userInfoArr removeAllObjects];
    }
    
    NSLog(@"TRCT version is %@",[TRTCCloud getSDKVersion]);
    if(!_trtcCloud){
        NSLog(@"rtc engine init fail");
        return;
    }
    
    
//    [_trtcCloud enableCustomVideoCapture:TRTCVideoStreamTypeBig enable:YES];
    
//    TRTCRenderParams *param = [[TRTCRenderParams alloc] init];
//    param.fillMode   = TRTCVideoFillMode_Fill;
//    param.mirrorType = TRTCVideoMirrorTypeAuto;
//    [_trtcCloud setLocalRenderParams:param];

    
    TRTCParams *params = [TRTCParams new];
    params.sdkAppId = SDKAppID;
    params.strRoomId = channelName;
    self.roomnumber = channelName;
    params.userId = SharedAppDelegate.userModel.user.haoma;
    params.role = TRTCRoleAnchor;
    params.userSig = TXTRCTUserSig;
    if (self.isHost) {
        params.streamId = [NSString stringWithFormat:@"56853_%@",SharedAppDelegate.userModel.user.haoma];
        
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
        [self.trtcCloud setVideoEncoderParam:encoder];

        TRTCNetworkQosParam *qosParams = [[TRTCNetworkQosParam alloc] init];
        qosParams.preference = TRTCVideoQosPreferenceClear;
        [self.trtcCloud setNetworkQosParam:qosParams];

        TRTCRenderParams *renderparams = [[TRTCRenderParams alloc] init];
        renderparams.mirrorType = TRTCVideoMirrorTypeEnable;
        [self.trtcCloud setLocalRenderParams:renderparams];
        [self.trtcCloud setVideoEncoderMirror:YES];
    }
    
    
    
    
    [_trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE];
    [_trtcCloud startLocalAudio:TRTCAudioQualityDefault];
    [_trtcCloud setAudioCaptureVolume:100];
    
    
}

- (void)setClientRole:(TRTCRoleType)clientRole {
    _clientRole = clientRole;
    [_trtcCloud switchRole:clientRole];
    
}



#pragma mark -- 管理旁路推流转码
- (void)setLiveTranscoding {
    
    CGFloat width = 720.0;
    CGFloat height = 1280.0;

    // 主播摄像头的画面位置
    if (!self.local) {
        self.local = [TRTCMixUser new];
        self.local.userId = [AppDelegate appDelegate].userModel.user.haoma;
        self.local.zOrder = 0;   // zOrder 为0代表主播画面位于最底层
        self.local.roomID = nil; // 本地用户不用填写 roomID，远程需要
    }
    if (self.isPK) {
        self.local.rect   = CGRectMake(0, height/4, width/2, 640);
        
        self.remote1.rect = CGRectMake(width/2, height/4,width/2, 640);
        self.remote1.userId = [NSString stringWithFormat:@"%ld",self.twoVideo];
        self.remote1.roomID = self.roomnumber;
        self.config.mixUsers = @[self.local,self.remote1];
        [self.trtcCloud setMixTranscodingConfig:self.config];
    }
    


    NSLog(@"TRTC 管理旁路推流转码");
}

- (TRTCTranscodingConfig *)config {
    if (!_config) {
        CGFloat width = 720.0;
        CGFloat height = 1280.0;
        _config = [[TRTCTranscodingConfig alloc] init];
        // 设置分辨率为720 × 1280, 码率为1500kbps，帧率为20FPS
        _config.videoWidth      = width;
        _config.videoHeight     = height;
        _config.videoBitrate    = 1500;
        _config.videoFramerate  = 15;
        _config.videoGOP        = 3;
        _config.audioSampleRate = 48000;
        _config.audioBitrate    = 64;
        _config.audioChannels   = 2;
//        _config.streamId = [NSString stringWithFormat:@"56853_%@",SharedAppDelegate.userModel.user.haoma];
        // 采用预排版模式
        _config.mode = TRTCTranscodingConfigMode_Manual;
    }
    return _config;
}

- (TRTCMixUser *)remote1 {
    if (!_remote1) {
        _remote1 = [TRTCMixUser new];
        _remote1.zOrder = 1;
    }
    return _remote1;
}

- (TRTCMixUser *)remote2 {
    if (!_remote2) {
        _remote2 = [TRTCMixUser new];
        _remote2.zOrder = 2;
    }
    return _remote2;
}

- (TRTCMixUser *)remote3 {
    if (!_remote3) {
        _remote3 = [TRTCMixUser new];
        _remote3.zOrder = 3;
    }
    return _remote3;
}

- (TRTCMixUser *)remote4 {
    if (!_remote4) {
        _remote4 = [TRTCMixUser new];
        _remote4.zOrder = 4;
    }
    return _remote4;
}

- (void)addOtherRemoteLayoutUser:(NSString *)roomnumber withArr:(NSMutableArray *)infoArr {

    if (!mixUsers) {
        mixUsers = [NSMutableArray array];
    }
    CGFloat width = 720.0;
    CGFloat height = 1280.0;
    CGFloat bigWidth = (width/4.0)*3.0-40;
    CGFloat bigHeight = bigWidth*2;
    CGFloat y = (height-bigHeight)/2.0 + 120;
    
    CGFloat smallWidth = width/4;
    CGFloat smallHeight = bigHeight/4;

    
    if (!self.local) {
        self.local = [TRTCMixUser new];
        self.local.userId = [AppDelegate appDelegate].userModel.user.haoma;
        self.local.rect = CGRectMake(0, 0, width, height);
        self.local.zOrder = 0;   // zOrder 为0代表主播画面位于最底层
        self.local.roomID = nil; // 本地用户不用填写 roomID，远程需要
    }
    self.local.rect = CGRectMake(0, 0, width, height);
    
    NSMutableArray *layoutArr = [NSMutableArray array];
    [layoutArr addObject:self.local];
    
//    for (NSString *roomnumber in infoArr) {
//        NSInteger pos = [infoArr indexOfObject:roomnumber];
//        switch (pos) {
//            case 0:
                self.remote1.rect = CGRectMake(bigWidth, y,smallWidth, smallHeight);
                self.remote1.userId = roomnumber;
                self.remote1.roomID = self.roomnumber;
                [layoutArr addObject:self.remote1];
//                break;
//            case 1:
//                self.remote2.rect = CGRectMake(bigWidth, y+=smallHeight,smallWidth, smallHeight);
//                self.remote2.userId = roomnumber;
//                self.remote2.roomID = self.roomnumber;
//                [layoutArr addObject:self.remote2];
//                break;
//            case 2:
//                self.remote3.rect = CGRectMake(bigWidth, y+=smallHeight,smallWidth, smallHeight);
//                self.remote3.userId = roomnumber;
//                self.remote3.roomID = self.roomnumber;
//                [layoutArr addObject:self.remote3];
//                break;
//            case 3:
//                self.remote4.rect = CGRectMake(bigWidth, y+=smallHeight,smallWidth, smallHeight);
//                self.remote4.userId = roomnumber;
//                self.remote4.roomID = self.roomnumber;
//                [layoutArr addObject:self.remote4];
//                break;
//            default:
//                break;
//        }
//    }
    NSLog(@"有人 %@",layoutArr);
    self.config.mixUsers = layoutArr;
    [self.trtcCloud setMixTranscodingConfig:self.config];
    
}


-(void)leaveChannel
{
//    if(_joined)
//    {
    [_trtcCloud exitRoom];
    [_trtcCloud stopLocalAudio];
    [_trtcCloud stopPublishing];
    [_trtcCloud stopAllRemoteView];
    [_trtcCloud stopLocalPreview];
    [self.userInfoArr removeAllObjects];
//        _joined = NO;
//    }
    
    //clear local resource
//    if(_videoSource)
//    {
//        [_videoSource Detach];
//        _videoSource = nil;
//    }

}

-(void)dealloc{
    NSLog(@"TXLiteClient dealloc");
    if(_videoBuffer)
    {
        free(_videoBuffer);
        _videoBuffer = nil;
    }
}


-(void)ProcessVideo:(CVPixelBufferRef)pixelBuffer
           timeInfo:(CMTime)pts
{
    if(!_joined)
        return;
    
    
    TRTCVideoFrame *videoFrame = [[TRTCVideoFrame alloc] init];
    videoFrame.bufferType = TRTCVideoBufferType_PixelBuffer;
    videoFrame.pixelFormat = TRTCVideoPixelFormat_NV12;
    videoFrame.pixelBuffer = pixelBuffer;
    
    [_trtcCloud sendCustomVideoData:TRTCVideoStreamTypeBig frame:videoFrame];
}

- (void)setIsMuted:(BOOL)isMuted {
    _isMuted = isMuted;
    
}

@end

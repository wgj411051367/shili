#import "TXLiveStreamerKit.h"
#import "Appdelegate.h"

@interface TXLiveStreamerKit()<TRTCCloudDelegate> {
}

@property CMTime localAudioPts;
@property CMTime videoPts;

@end

@implementation TXLiveStreamerKit

- (instancetype) initWithDefaultCfg {
    self = [super init];
    __weak typeof(self)weak_kit = self;
    _txKit = [[TXLiteClient alloc] initWithAppId:TRTCSDKAppID delegate:weak_kit];
    _txKit.trtcCloud = [TRTCCloud sharedInstance];
    _txKit.trtcCloud.delegate = weak_kit;

    return self;
}
- (void)initTXLivePusherisRTC:(BOOL)isRTC with:(UIView *)hostView {
    self.puserMode = isRTC?V2TXLiveMode_RTC:V2TXLiveMode_RTMP;
    self.pusher = [[V2TXLivePusher alloc] initWithLiveMode:self.puserMode];
    V2TXLiveVideoEncoderParam *params = [[V2TXLiveVideoEncoderParam alloc] init];
    // 分辨率
    params.videoResolution = V2TXLiveVideoResolution1280x720;
    // 横屏还是竖屏
    params.videoResolutionMode = V2TXLiveVideoResolutionModePortrait;
    // 码率
    params.videoBitrate = 1500;
    params.minVideoBitrate = 1500;
    // 采集帧率
    params.videoFps = 20;
    [self.pusher setVideoQuality:params];
    [self.pusher setAudioQuality:V2TXLiveAudioQualityMusic];
    [self startPusher];
    
    [self.pusher setRenderView:hostView];
}


- (void)startPusher {
    [self.pusher startCamera:YES];
    [self.pusher startMicrophone];
}

- (void)stopPusher {
    [self.pusher stopCamera];
    [self.pusher stopMicrophone];
    [self.pusher stopPush];
    [self.pusher setObserver:nil];
    [self.pusher setRenderView:nil];
    self.pusher = nil;
    
    [self.txKit.trtcCloud setLocalVideoProcessDelegete:nil pixelFormat:TRTCVideoPixelFormat_NV12 bufferType:TRTCVideoBufferType_PixelBuffer];
}

-(void)becomeActive
{
    _localAudioPts = kCMTimeInvalid;
}

-(void)resignActive
{
}

- (instancetype)init {
    return [self initWithDefaultCfg];
}
- (void)dealloc {
    NSLog(@"TXLiveStreamerKit dealloc");
    if (_txKit) {
        [_txKit leaveChannel];
        _txKit = nil;
    }
    if(_contentView)
    {
        _contentView = nil;
    }
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    [dc removeObserver:self
                  name:UIApplicationDidBecomeActiveNotification
                object:nil];
    [dc removeObserver:self
                  name:UIApplicationWillResignActiveNotification
                object:nil];
}

#pragma mark -rtc
-(void)joinChannel:(NSString *)channelName andSource:(id <TRTCCloudDelegate>)source
{
    [_txKit joinChannel:channelName andSource:source];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//4.16不允许休眠
}
-(void)leaveChannel
{
    [_txKit leaveChannel];
    [self.userinfoArr removeAllObjects];
    self.joinleave=0;
}

#pragma mark -- 开始推流
- (void)startPushStream{
    

}

- (void)removePushStream {
    self.txKit.config = nil;
    [self.txKit.trtcCloud setMixTranscodingConfig:nil];

}


- (void)sendChangeLiveUrlMsg{
}



#pragma mark - TRTCCloudDelegate 腾讯云
- (void)onEnterRoom:(NSInteger)result {
    if (result > 0) {
        // 加入通道后的回调
        self.txKit.joined = YES;
        
        if(self.txKit.joinChannelBlock)
            self.txKit.joinChannelBlock(@"",0,0);
        NSLog(@"test:通道加入成功");
    }
    
}

- (void)onCameraDidReady {
    
    NSLog(@"test:相机准备好了");
}

- (void)onExitRoom:(NSInteger)reason {
    // 离开通道后的回调
    if (reason == 0) {
        // 主动退出
        NSLog(@"test:主动退出房间");
    } else if (reason == 1) {
        // 被服务器提出
        NSLog(@"test:被服务器踢出房间");
    } else if (reason == 2) {
        // 当前通道被解散
        NSLog(@"test:房间通道关闭");
    }
    if (self.txKit.leaveChannelBlock) {
        self.txKit.leaveChannelBlock(reason);
    }
}

// 感知远端用户视频状态的变化，并更新开启了摄像头的用户列表(mCameraUserList)
- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available {
    NSLog(@"test:有人的视频状态发生变化 uid:%@ state:%d",userId,available);
}


- (void)onRemoteVideoStatusUpdated:(NSString *)userId streamType:(TRTCVideoStreamType)streamType streamStatus:(TRTCAVStatusType)status reason:(TRTCAVStatusChangeReason)reason extrainfo:(NSDictionary *)info {
    NSLog(@"test:有人的视频状态发生变化 uid:%@ state:%ld reason:%ld info = %@",userId,status,reason,info);
    if (self.isAudience) {
        // 是观众不做推流动作
        return;
    }
    if (status == TRTCAVStatusStopped) {
        [self.txKit addOtherRemoteLayoutUser:[NSString stringWithFormat:@"%@",userId] withArr:[self.userinfoArr mutableCopy]];
    }
    if (status == TRTCAVStatusPlaying) {
        if (!self.isPK) {
            if ([self.userinfoArr containsObject:[NSString stringWithFormat:@"%@",userId]]) {
                [self.txKit addOtherRemoteLayoutUser:[NSString stringWithFormat:@"%@",userId] withArr:[self.userinfoArr mutableCopy]];
                [self performSelector:@selector(startPushStream) withObject:nil afterDelay:0.2];
            }
            
        } else {
            if ([userId integerValue] == self.txKit.twoVideo || [userId integerValue] == self.txKit.threeVideo) {
                [self.txKit setLiveTranscoding];
                [self performSelector:@selector(startPushStream) withObject:nil afterDelay:0.2];
            }
        }
    }
}


- (void)onRemoteUserEnterRoom:(NSString *)userId {
    NSLog(@"test:有人进来了 %@",userId);
    self.joinid = [userId integerValue];;
    self.joinleave++;
    if (!_userinfoArr) {
        _userinfoArr = [NSMutableArray array];
    }
    [_userinfoArr addObject:userId];
    if (self.joinleave>0) {
        if(_onUserJoin) {
            _onUserJoin(200);//2018.8.15 添加其他用户又回来了的回调
        }
        if(_onCallStart) {
            _onCallStart(200);
        }
        _callstarted=YES;
        if (!self.isPK) {
            if (_uploadLianMaiInfo) {
                _uploadLianMaiInfo(self.userinfoArr,0);
            }
        }
    }
}


- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason {
    NSLog(@"test:有人离开了 %@",userId);
    self.joinleave--;
    if ([self.userinfoArr containsObject:userId]) {
        [self.userinfoArr removeObject:userId];
    }
    
    if (!self.isPK) {
        if (_uploadLianMaiInfo) {
            _uploadLianMaiInfo(self.userinfoArr,[userId integerValue]);
        }
    }
    if (self.joinleave<=0){
        if (_onOffLine) {
            _onOffLine(reason); //2018.8.15 添加其他用户掉线的回调
        }
        if(_onCallStop) {
            _onCallStop(reason);//其他用户离开的回调
        }
        _callstarted=NO;
    }
}


- (void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(NSDictionary *)extInfo {
    NSLog(@"test: onError %@:%ld",errMsg,(long)errCode);
}

- (void)onCdnStreamStateChanged:(NSString *)cdnUrl status:(int)status code:(int)code msg:(NSString *)msg extraInfo:(NSDictionary *)info {
    if (code == 0) {
        NSLog(@"test:推流成功");
    } else {
        NSLog(@"test:推流失败，错误码code %d  status %d 错误详情 %@",code,status,msg);
    }
}

- (void)onSetMixTranscodingConfig:(int)err errMsg:(NSString *)errMsg {
    NSLog(@"test: onSetMixTranscodingConfig error:%d msg:%@",err,errMsg);
}

@end

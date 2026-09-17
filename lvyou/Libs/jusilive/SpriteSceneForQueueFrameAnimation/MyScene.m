//
//  MyScene.m
//  TexturePacker-SpriteKit
//
//  Created by joachim on 23.09.13.
//  Copyright (c) 2013 CodeAndWeb. All rights reserved.
//

#import "MyScene.h"
#import "MyTextureAtlas.h"
#import "SLGiftAnimationView.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //[self initScene];
    }
    return self;
}

-(void)initScene
{
    // load the atlas explicitly, to avoid frame rate drop when starting a new animation
    //self.atlas = [SKTextureAtlas atlasNamed:@"4004"];
    //textureAtlasCache=[NSMutableDictionary dictionary];
}
//2018.8.7 添加
- (void)showSVGAParserWithUrl:(NSDictionary *)info
{
    NSString *dir=[info objectForKey:@"img"];
    NSString *name=[info objectForKey:@"prefix"];
    NSString *plist=[dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.svga",name]];
    NSData *data = [NSData dataWithContentsOfFile:plist];
    self.parser = [[SVGAParser alloc] init];
    self.player = [[SVGAPlayer alloc] init];
    [self.player setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
     self.player.userInteractionEnabled=YES;
     self.player.delegate=self;
     self.player.contentMode=UIViewContentModeScaleAspectFill; //填充整个页面
     self.player.loops =1;
     self.player.clearsAfterStop = YES;
    NSString *audio_path=[dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",name]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:audio_path]) {
        [self playBackgroundMusic:audio_path repeat:[[info objectForKey:@"repeat"] intValue]];
    }
    __weak typeof(self)weakself =self;
    [self.parser parseWithData:data cacheKey:name completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            weakself.player.videoItem = videoItem;
            [weakself.player startAnimation];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [weakself stop];
    }];
    [self.view addSubview:weakself.player];
}
// 播放完成的回调 进行下一次的播放
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player;
{
    [self stop];
}
-(void)showCPPGift:(NSDictionary *)info{
    NSString *dir=[info objectForKey:@"img"];
    NSString *name=[info objectForKey:@"prefix"];
    NSString *plist=[dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];
    if(self.textureAtlasUse==nil)
    {
        self.textureAtlasUse=[[MyTextureAtlas alloc] initWithFile:plist];
    }
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plist];
    NSArray *texture_list=[data objectForKey:@"images"];
    NSMutableArray *images=[NSMutableArray array];
    for (NSDictionary *texture_item in texture_list) {
        [images addObjectsFromArray:[texture_item objectForKey:@"subimages"]];
    }
    // ... attach the action with the walk animation, and add it to our scene
    //4.18做此修改是因为有些特效礼物是从0001开始的 之前的代码无法识别 不能播放动画
    NSMutableArray *tmp=[NSMutableArray array];
    [self sortedArrayUsingComparatorWithImages:images];
     NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *arr=[animationArr sortedArrayUsingComparator:cmptr];
    dataArr=[NSArray array];
    dataArr=arr;
    SKSpriteNode *sprite;
    if (dataArr.count>0) {
        sprite = [SKSpriteNode spriteNodeWithTexture:[self.textureAtlasUse textureNamed:[NSString stringWithFormat:@"%@",dataArr[0]]]];
    }
    NSUInteger count=images.count;
    if (count>0) {
        for(NSUInteger i=1;i<=count;i++){
            //SKTexture *texture=[self.textureAtlasUse textureNamed:[NSString stringWithFormat:@"%@00%d",name,i]];
            NSString*str=[NSString stringWithFormat:@"%@",dataArr[i-1]];
            SKTexture *texture=[self.textureAtlasUse textureNamed:str];
            if(texture!=nil){
                [tmp addObject:texture];
            }
        }
    }
//    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[self.textureAtlasUse textureNamed:[NSString stringWithFormat:@"%@001",name]]];
    ///SKSpriteNode 这里这么创建  不能设置成变量
    if (dataArr.count>0) {
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[self.textureAtlasUse textureNamed:[NSString stringWithFormat:@"%@",dataArr[0]]]];
        //动画按场景大小缩放
        if (sprite.size.width>self.size.width){
            CGFloat sprite_bili=sprite.size.height/sprite.size.width;
            CGFloat newHeight=self.size.width*sprite_bili;
            [sprite setSize:CGSizeMake(self.size.width, newHeight)];
        }
        sprite.position = CGPointMake(self.size.width/2,self.size.height/2);
        if (images.count==0) {
            sprite.hidden=YES;
        }
        if ([tmp count]==0) {
            sprite.hidden=YES;//1.7 修改
            return;//一般不应该到这里，这里是没有加载到序列帧
        }
        SKAction *singleAction = [SKAction animateWithTextures:tmp timePerFrame:[[info objectForKey:@"rate"] floatValue]];
        SKAction *walk=[SKAction repeatAction:singleAction count:[[info objectForKey:@"repeat"] integerValue]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *audio_path=[dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",name]];
        if ([fileManager fileExistsAtPath:audio_path]) {
            [self playBackgroundMusic:audio_path repeat:[[info objectForKey:@"repeat"] intValue]];
        }
        __weak typeof(self)weakself =self;
        [sprite runAction:walk completion:^{
            [sprite setTexture:nil];
            [sprite removeAllActions];
            [sprite removeAllChildren];
            [sprite removeFromParent];
            [tmp removeAllObjects];
            [weakself stop]; //3.25修改
        }];
        [self addChild:sprite];
    }
}
- (void)sortedArrayUsingComparatorWithImages:(NSMutableArray *)images
{
    NSMutableArray *numArr=[NSMutableArray array];
    animationArr=[NSMutableArray array];
    for(int i=1;i<=[images count];i++){
      NSString *textname=[images[i-1]objectForKey:@"name"];
      NSArray *tempArr=[textname componentsSeparatedByString:@"."];
      NSString *animationName=tempArr[0];
      [numArr addObject:animationName];
       animationArr=numArr;
    }
}
//8.28 关闭礼物动画声音
- (void)stop {
    if(self.textureAtlasUse){
        self.textureAtlasUse=nil;
    }
    if(_backgroundMusicPlayer){
        [_backgroundMusicPlayer stop];
        _backgroundMusicPlayer=nil;
    }
    if (self.player) {
        [self.player removeFromSuperview];
        self.player=nil;
    }
    if (self.parser) {
        self.parser=nil;
    }
    if(_parentView){   //3.25修改
        [((SLGiftAnimationView *)_parentView) playstop];
    }
    if (animationArr) {
        [animationArr removeAllObjects];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.videoplayer.currentItem];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenBackViewAnimationView" object:nil];
    if (_videoplayer) {
        _videoplayer = nil;
        _videoOutput = nil;
        [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink invalidate];
        _displayLink = nil;
    }
    if (_glView) {
        [_glView removeFromSuperview];
        _glView = nil;
    }
    if (_mtView) {
        [_mtView removeFromSuperview];
        _mtView = nil;
    }
}
-(void)dealloc{
    [self stop];
    NSLog(@"myscene  dealloc");
}
- (void)playBackgroundMusic:(NSString *)filename repeat:(int)repeat
{
    if (((SLGiftAnimationView *)_parentView).isSwitchSoundOn==NO) {
        //8.28  不播放声音
        return;
    }
    if(_backgroundMusicPlayer){
        [_backgroundMusicPlayer stop];
        _backgroundMusicPlayer=nil;
    }
    NSError *error;
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filename] error:&error];// AVAudioPlayer对象要设置成全局的
    _backgroundMusicPlayer.numberOfLoops = repeat;//播放次数 0代表1次
    _backgroundMusicPlayer.volume = 0.8;//音量
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
}

- (CGRect)giftPlayerFrame {
//    CGFloat playerRatio = 974.0 / 450.0;//视频长宽比
//    CGFloat playerHeight = ceilf(playerRatio * PLScreenShorterLength());
//    CGFloat topMargin = PLScreenLongerLength() - playerHeight;
    return CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
}


- (void)showMP4ParserWithUrl:(NSDictionary *)info
{
    NSString *dir=[info objectForKey:@"img"];
    NSString *name=[info objectForKey:@"prefix"];
    
//    if (!_filterView) {
//        self.filterView = [[GPUImageView alloc] initWithFrame:[self giftPlayerFrame]];
//        self.filterView.contentMode = UIViewContentModeScaleAspectFill;
//        self.filterView.fillMode = kGPUImageFillModeStretch;
//        self.filterView.backgroundColor = [UIColor clearColor];
//        self.filterView.hidden = YES;
//        [self.view addSubview:self.filterView];
//    }
//
//    [self playVideo:[NSString stringWithFormat:@"%@/%@.mp4",dir,name]];
    NSString *audio_path=[dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",name]];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:audio_path]) {
//        [self playBackgroundMusic:audio_path repeat:[[info objectForKey:@"repeat"] intValue]];
//    }
    
    self.mp4dir=[info objectForKey:@"img"];
    self.mp4name=[info objectForKey:@"prefix"];
    
    
    
    [self play];
    if ([[NSFileManager defaultManager] fileExistsAtPath:audio_path]) {
        [self playBackgroundMusic:audio_path repeat:[[info objectForKey:@"repeat"] intValue]];
    }
}

- (void)showMP4ParserWithUrlName:(NSString *)url {
    self.mp4name=url;
    self.mp4dir = nil;
    [self play];
}


- (void)turnOnOrOffAudio
{
    float playerVolume = 1;
    AVAsset *avAsset = self.videoplayer.currentItem.asset;
    NSArray *audioTracks = [avAsset tracksWithMediaType:AVMediaTypeAudio];

    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:playerVolume atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    AVMutableAudioMix *audioVolMix = [AVMutableAudioMix audioMix];
    [audioVolMix setInputParameters:allAudioParams];
    [self.videoplayer.currentItem setAudioMix:audioVolMix];
}

- (NSURL *)videoURL
{
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"test2" withExtension:@"mp4"];
    
    NSURL *url=[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.mp4",self.mp4dir,self.mp4name]];
    
    if (self.mp4dir == nil) {
        url=[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",self.mp4name]];
        NSLog(@"playanimation = %@",self.mp4name);
    }
    
    return url;
}

- (AVPlayer *)playerForVideoURL
{
    NSURL *url = [self videoURL];
    if (!url) {
        return nil;
    }
    return [AVPlayer playerWithURL:url];
}

- (CGSize)videoSize
{
    if (_videoSize.width == 0 && _videoSize.height == 0) {
        AVPlayer *tempPlayer = [self playerForVideoURL];
        NSArray *tracks = [tempPlayer.currentItem.asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *track = tracks.firstObject;
        CGFloat screenFactor = 1.0 / [UIScreen mainScreen].scale;
        CGSize naturalSize = track.naturalSize;
        _videoSize = CGSizeMake(screenFactor * naturalSize.width, screenFactor * naturalSize.height);
    }

    return _videoSize;
}

- (LHVideoGiftAlphaVideoGLView *)glView
{
    if (!_glView) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive) {
            return nil;
        }
        CGSize videoSize = self.videoSize;
        if (videoSize.width == 0 || videoSize.height == 0 || isnan(videoSize.width || isnan(videoSize.height))) {
            videoSize = CGSizeMake(2 * SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        CGFloat desiredWidth = SCREEN_WIDTH;
        CGFloat desiredHeight = desiredWidth * videoSize.height /(.5f * videoSize.width);
        CGFloat top = SCREEN_HEIGHT - desiredHeight;
        CGRect viewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _glView = [[LHVideoGiftAlphaVideoGLView alloc] initWithFrame:viewFrame];
        _glView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_glView];
    }
    return _glView;
}

- (LHVideoGiftAlphaVideoMetalView *)mtView
{
    if (!_mtView) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive) {
            return nil;
        }
        CGSize videoSize = self.videoSize;
        if (videoSize.width == 0 || videoSize.height == 0 || isnan(videoSize.width || isnan(videoSize.height))) {
            videoSize = CGSizeMake(2 * SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        CGFloat desiredWidth = SCREEN_WIDTH;
        CGFloat desiredHeight = desiredWidth * videoSize.height /(.5f * videoSize.width);
        CGFloat top = SCREEN_HEIGHT - desiredHeight;
        CGRect viewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        NSLog(@"[%@] mtView width: %f  height: %f top: %f",NSStringFromClass(self.class),viewFrame.size.width,viewFrame.size.height,top);
        _mtView = [[LHVideoGiftAlphaVideoMetalView alloc] initWithFrame:viewFrame];
        _mtView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_mtView];
    }
    return _mtView;
}

- (void)setupVideoOutput
{
    NSDictionary *options = @{
        (__bridge NSString *)kCVPixelBufferMetalCompatibilityKey : @YES,
                              (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
                              (__bridge NSString *)kCVPixelBufferOpenGLESCompatibilityKey : @YES
                              };
    self.videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:options];
    self.videoOutput.suppressesPlayerRendering = YES;
    [self.videoOutput requestNotificationOfMediaDataChangeWithAdvanceInterval:.1];
    [self.videoplayer.currentItem addOutput:self.videoOutput];
    
    [self createDisplayLink];
}

- (void)createDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.preferredFramesPerSecond = 30;
    self.displayLink.paused = YES;
}



- (NSTimeInterval)duration
{
    return CMTimeGetSeconds(self.videoplayer.currentItem.asset.duration);
}


- (void)play
{
    __weak typeof(self) weakSelf = self;
    [self loadVideoWithCompletionBlock:^(BOOL success){
        if (success) {
            [weakSelf startPlayer];
        } else {
        }
    }];

}

#pragma mark - CADisplayLink Callback

- (void)displayLinkCallback:(CADisplayLink *)sender
{
    if (!self.videoOutput) {
        return;
    }
    
    NSTimeInterval nextDisplayTime = sender.timestamp + sender.duration;
    CMTime itemTime = [self.videoOutput itemTimeForHostTime:nextDisplayTime];

    if ([self.videoOutput hasNewPixelBufferForItemTime:itemTime] && [UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        CVPixelBufferRef pixelBuffer = [self.videoOutput copyPixelBufferForItemTime:itemTime
                                                 itemTimeForDisplay:nil];
        if (pixelBuffer) {
   
            if (YES) {
                [self.mtView displayPixelBuffer:pixelBuffer];
            }
            else {
                [self.glView displayPixelBuffer:pixelBuffer];
                CVPixelBufferRelease(pixelBuffer);
            }
        
            //NSTimeInterval timeInterval = CMTimeGetSeconds(itemTime);
        }
    }
}

- (void)loadVideoWithCompletionBlock:(void (^)(BOOL success))completionBlock
{
    self.videoplayer = [self playerForVideoURL];
    if (!self.videoplayer) {
        if (completionBlock) {
            completionBlock(NO);
        }
        return;
    }
    
    self.videoplayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.videoplayer.currentItem];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.videoplayer.currentItem.asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setupVideoOutput];
                if (completionBlock) {
                    completionBlock(YES);
                }
            });
        }];
    });
}

- (void)videoDidPlayToEndTime:(NSNotification *)notification
{
    [self stop];
//    [self restart];
}


- (void)restart
{
    [self.videoplayer seekToTime:kCMTimeZero
            toleranceBefore:kCMTimeZero
             toleranceAfter:kCMTimeZero];
    

}
- (void)startPlayer
{
    [self turnOnOrOffAudio];
    [self.videoplayer play];
    if (!self.displayLink) {
        [self createDisplayLink];
    }
    self.displayLink.paused = NO;
}


@end

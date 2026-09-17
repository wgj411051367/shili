//
//  RoomAvatarView.m
//  biyin
//
//  Created by mac on 2018/12/14.
//  Copyright © 2018年 Shili. All rights reserved.
//

#import "RoomAvatarView.h"
#import "BaseViewController.h"
@implementation RoomAvatarView
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *containerView = [[[UINib nibWithNibName:@"RoomAvatarView" bundle:nil] instantiateWithOwner:self options:nil] firstObject ];
        containerView.frame = self.bounds;
        self.userInteractionEnabled=YES;
        [self addSubview:containerView];
        img = [UIImage imageNamed:@"icon_live_audition_add"];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *containerView = [[[UINib nibWithNibName:@"RoomAvatarView" bundle:nil] instantiateWithOwner:self options:nil] firstObject ];
        containerView.frame = self.bounds;
        self.userInteractionEnabled=YES;
        [self addSubview:containerView];
        img = [UIImage imageNamed:@"icon_live_audition_add"];
    }
    return self;
}

- (void)initWithUid:(NSString *)uid {
    _uid = uid;
    if (!_hostView) {
        _hostView = [[UIView alloc] init];
    }
    _hostView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.hostView.backgroundColor = [UIColor blackColor];
    self.hostView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.hostBGView addSubview:self.hostView];
    
    
//    [self bringSubviewToFront:self.jianbianView];
//    [self bringSubviewToFront:self.jinyanImg];
//    [self bringSubviewToFront:self.shrinkBtn];
//    [self bringSubviewToFront:self.avatarButton];
    
    
//    [self.hostView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//    if (!_canvas) {
//    }
}

+ (instancetype)localSession {
    CGFloat bigWidth = SCREEN_WIDTH/4*3;
    CGFloat bigHeight = bigWidth*2;
    RoomAvatarView *view = [[RoomAvatarView alloc] initWithFrame:CGRectMake(0, 0, bigWidth, bigHeight)];
    [view initWithUid:[AppDelegate appDelegate].userModel.user.haoma];
    return view;
}


- (void)shangMai:(NSDictionary *)user andIsZhuChiMic:(BOOL)isHostMic {
    
    if (currentUser) {
        if ([currentUser.id isEqualToString:user[@"userid"]]) {
            return;
        }
    }
    
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:user error:nil];
    currentUser=model;
    self.roomnumber = model.roomnumber;
    self.jianbianView.hidden = isHostMic;
    self.jianbianViewHeight.constant = 20;
    self.bgView.hidden = YES;

    [_avatarImg sd_setImageWithURL:[[BaseViewController alloc] placeCorpsImg:[[ToolHelper toolHelper] realAvatarUrl:model.userid andUpdate:model.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
    [_avatarBigImg sd_setImageWithURL:[[BaseViewController alloc] placeCorpsImg:[[ToolHelper toolHelper] realAvatarUrl:model.userid andUpdate:model.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
    
//    if (!_beffect) {
//        _beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    }
//    if (!_visualEffectView) {
//        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:self.beffect];
//    }
//    self.visualEffectView.frame = CGRectMake(0, 0, self.width, self.height);
//    [_avatarBigImg addSubview:self.visualEffectView];
    
//    self.jinyanImg.hidden = NO;
//    self.jinyanImg.highlighted = YES;
//    _avatarImg.image = [[UIImage alloc] init];
    
//    _voiceBackNew.hidden=NO;
//    [self startVoiceType:_voiceBackNew];
    
    _nickLab.text = model.nickname;
    _nickLab1.text = model.nickname;
//    self.avatarKuang.hidden = NO;
    
    _jinyanImg.highlighted = YES;
    self.pkInfo.hidden = NO;
    _avatarBigImg.hidden = NO;
    self.tag = [self.roomnumber integerValue];
}



- (void)shangMaiModel:(UserInfoModel *)userModel {
    
    if (currentUser) {
        if ([currentUser.id isEqualToString:userModel.id]) {
            return;
        }
    }
    
    self.jianbianViewHeight.constant = 20;

    currentUser=userModel;
    [_avatarImg sd_setImageWithURL:[[BaseViewController alloc] placeCorpsImg:[[ToolHelper toolHelper] realAvatarUrl:userModel.userid andUpdate:userModel.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
    [_avatarBigImg sd_setImageWithURL:[[BaseViewController alloc] placeCorpsImg:[[ToolHelper toolHelper] realAvatarUrl:userModel.userid andUpdate:userModel.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
    
    if (!_beffect) {
        _beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    if (!_visualEffectView) {
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:self.beffect];
    }
    self.visualEffectView.frame = CGRectMake(0, 0, self.width, self.height);
    [_avatarBigImg addSubview:self.visualEffectView];

    _nickLab.text=userModel.nickname;
    
    _jinyanImg.highlighted = YES;

}

-(BOOL)isEmpty{

    if ([self.uid isEqualToString:@"-1"] || [self.nickLab.text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}
-(void)emptyMai{
    self.uid = @"-1";
//    if (self.tag==5007) {
//        _avatarImg.image=[UIImage imageNamed:@"voice_zuowei"];
//    }
//    else{
    self.pkInfo.hidden = YES;
    self.jianbianView.hidden = YES;
//    self.jinyanImg.hidden = YES;
    _jinyanImg.highlighted = YES;
    self.jianbianView.backgroundColor = [UIColor clearColor];
    [self.hostView removeFromSuperview];
    self.hostView = nil;
    self.avatarImg.image=[[UIImage alloc] init];
    self.avatarBigImg.image=[[UIImage alloc] init];

//    空麦位时移除高斯模糊蒙层
    self.beffect = nil;
    [self.visualEffectView removeFromSuperview];
    
    self.tag = 0;
    currentUser=nil;
    
    self.nickLab.text = @"";
    self.nickLab1.text = @"";
    self.clearMeiliBtn.hidden = YES;
    
    self.bgView.backgroundColor = [UIColor gradientColorImageFromColors:@[[UIColor colorWithHex:0x4B2B55],[UIColor colorWithHex:0x32125A]] gradientType:GradientTypeLeftToRight imgSize:self.size];
    self.bgView.hidden = YES;
    self.roomnumber = @"";
    
    self.pkWinnerImg.hidden = YES;
}


-(void)lockMai{
    self.voiceBack.image=[UIImage imageNamed:@"voice_lock"];
}
- (void)hiddenJinYanImg {
    self.jinyanImg.hidden = YES;
}

- (void)startVoiceType:(UIImageView *)img
{
    _voiceBackNew.hidden=NO;
    NSArray *images=[NSArray arrayWithObjects:
                     [UIImage imageNamed:@"voice_001"],
                     [UIImage imageNamed:@"voice_002"],
                     [UIImage imageNamed:@"voice_003"],
                     [UIImage imageNamed:@"voice_004"],nil];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.animationImages=images;
    img.animationDuration = 1;
    img.animationRepeatCount = 0;
    [img startAnimating];
}
- (void)stopVoiceType:(UIImageView *)img
{
    _voiceBackNew.hidden=YES;
    [img stopAnimating];
}

-(void)voiceMai{
    if (!currentUser) {
        return;
    }
//    _jinyanImg.hidden = YES;
    _jinyanImg.highlighted = YES;
//    _jinyanImgWidth.constant = 0;
//
//    [self startVoiceType:_voiceBackNew];
}
-(void)unvoiceMai{
    if (!currentUser) {
        return;
    }
    _jinyanImg.highlighted = NO;
//    _jinyanImgWidth.constant = 18;
//    _jinyanImg.hidden = NO;
//
//    [self stopVoiceType:_voiceBackNew];
}

- (void)videoSwitch:(BOOL)state {
    // state : 0表示隐藏遮照  1表示显示遮照
    if ([self isEmpty]) {
        self.videoOffView.hidden = YES;
    } else {
        self.videoOffView.hidden = !state;
    }
    
}


-(void)unlockMai{
    if ([self isEmpty]) {
        [self emptyMai];
    }
}

- (IBAction)muteAction:(id)sender {
    _jinyanImg.highlighted = !_jinyanImg.highlighted;
    
    if (_jinyanImg.highlighted) {
        [self.livePlayer resumeAudio];
    } else {
        [self.livePlayer pauseAudio];
    }
    
    if (self.uploadPKVoiceMuteBlock) {
        self.uploadPKVoiceMuteBlock();
    }
}

-(void)setMuteMai:(BOOL)b{
    // YES 表示没有被主播静音
    // NO  表示已经被主播静音
//    _jinyanImg.hidden=b;
    _jinyanImg.highlighted = !b;
    
    if (_jinyanImg.highlighted) {
        [self.livePlayer resumeAudio];
    } else {
        [self.livePlayer pauseAudio];
    }
//    _jinyanImgWidth.constant = b?0:18;
    
//    self.muteLab.hidden = b;
//
//    if (_jinyanImgWidth.constant > 0) {
//        [self stopVoiceType:_voiceBackNew];
//    } else {
//        if (b) {
//            [self startVoiceType:_voiceBackNew];
//        } else {
//            [self stopVoiceType:_voiceBackNew];
//        }
//    }
}


- (void)setSpeak:(BOOL)speak {
    if (speak) { // 开始说话
        // _jinyanImgWidth == 0 表示静音标志隐藏了，是能说话的状态
        if (_jinyanImgWidth.constant == 0) {
            [self startVoiceType:_voiceBackNew];
        }
    } else { // 停止说话
        [self stopVoiceType:_voiceBackNew];
    }
}



- (void)upDataMeiLiValue:(NSString *)value {
    
    self.meiliLab.text = value;
//    CGFloat width = [[BaseViewController alloc] widthForString:value fontSize:10 andHeight:16];
//    self.meiliView.backgroundColor = [UIColor gradientColorImageFromColors:@[[UIColor colorWithHex:0xFAD961],[UIColor colorWithHex:0xF76B1C]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([value isEqualToString:@"0"]?31:width+4+17, 30)];
//
}

//播放svga
- (void)showSVGAParserWithUrl:(NSString *)name
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:name ofType:@"svga"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    self.parser = [[SVGAParser alloc] init];
    self.player = [[SVGAPlayer alloc] init];
    [self.player setFrame:CGRectMake(self.avatarImg.x, 0, self.avatarImg.width*1.1, self.avatarImg.width*1.1)];
    self.player.userInteractionEnabled=NO;
    self.player.backgroundColor=[UIColor clearColor];
    self.player.delegate=self;
    self.player.contentMode=UIViewContentModeScaleAspectFill; //填充整个页面
    self.player.loops =3;//播放3次
    self.player.clearsAfterStop = YES;
    __weak typeof(self)weakself =self;
    [self.parser parseWithData:data cacheKey:name completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            weakself.player.videoItem = videoItem;
            [weakself.player startAnimation];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [weakself stop];
    }];
    [self addSubview:weakself.player];
    [self bringSubviewToFront:weakself.player];
}
// 播放完成的回调 进行下一次的播放
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player;
{
    [self stop];
}
- (void)stop {
    if (self.player) {
        [self.player removeFromSuperview];
        self.player=nil;
    }
    if (self.parser) {
        self.parser=nil;
    }
    self.avatarImg.userInteractionEnabled=YES;
}

-(void)dealloc{
    NSLog(@"RoomAvatarView  dealloc");
}


- (void)initLivePlayer {
    if (!_livePlayer) {
        _livePlayer = [[V2TXLivePlayer alloc] init];
        [_livePlayer setCacheParams:1 maxTime:5];
        [_livePlayer setObserver:self];
        [_livePlayer setRenderFillMode:V2TXLiveFillModeFill];
        [_livePlayer setRenderView:self.playerView];
    }
    [self sendSubviewToBack:self.avatarBigImg];
    self.inviteLab.hidden = YES;
}

- (void)startLivePlayRTC:(NSString *)url {
    
    [_livePlayer startLivePlay:url];
}

- (void)destroyPlayer {
    if (_livePlayer) {
        [_livePlayer stopPlay];
        
        [_livePlayer setObserver:nil];
        [_livePlayer setRenderView:nil];
        _livePlayer = nil;
        
    }
    self.pkWinnerImg.hidden = YES;
    self.pkInfo.hidden = YES;
}

- (void)pkResultWinRoomnumber:(NSString *)roomnumber {
    if ([self.roomnumber isEqualToString:@""]) {
        return;
    }
    self.pkWinnerImg.hidden = NO;
    if ([roomnumber isEqualToString:@""]) {
        // 平局
        self.pkWinnerImg.image = [UIImage imageNamed:@"icon_pk_equal"];
    } else if ([roomnumber containsString:self.roomnumber]) {
        // 赢
        self.pkWinnerImg.image = [UIImage imageNamed:@"icon_pk_winner"];
    } else {
        // 输
        self.pkWinnerImg.image = [UIImage imageNamed:@"icon_pk_loser"];
    }
}

- (void)onError:(id<V2TXLivePlayer>)player code:(V2TXLiveCode)code message:(NSString *)msg extraInfo:(NSDictionary *)extraInfo {
    if (code == V2TXLIVE_ERROR_DISCONNECTED) {
        // 连接断开
        if (self.playerDisconnected) {
            self.playerDisconnected(currentUser.roomnumber,currentUser.nickname);
        }
    }
    NSLog(@"V2TXLivePlayer onError code = %ld msg = %@  extraInfo = %@",code,msg,extraInfo);
}

- (void)onWarning:(id<V2TXLivePlayer>)player code:(V2TXLiveCode)code message:(NSString *)msg extraInfo:(NSDictionary *)extraInfo {
    NSLog(@"V2TXLivePlayer onWarning code = %ld msg = %@  extraInfo = %@",code,msg,extraInfo);
}
@end

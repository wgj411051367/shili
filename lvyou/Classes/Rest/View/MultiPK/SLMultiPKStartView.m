//
//  SLMultiPKStartView.m
//  tianma
//
//  Created by imac on 2023/6/13.
//  Copyright © 2023 Shili. All rights reserved.
//

#import "SLMultiPKStartView.h"
#import "RoomAvatarView.h"
#import "AppDelegate.h"
#import "RootHttpHelper.h"

@interface SLMultiPKStartView()
{
 
    NSTimer *pkTimer;
    NSTimer *cfTimer;
    
    NSMutableDictionary *valueDic;
    
    BOOL isShowWinner;
}


@property (weak, nonatomic) IBOutlet UIButton *duankaiBtn;
@property (nonatomic, copy) NSMutableArray <RoomAvatarView *>*avatarArr;

@property (nonatomic, assign) NSInteger pkCount;
@property (nonatomic, assign) NSInteger cfCount;
@property (nonatomic, assign) BOOL isHost;
@end

@implementation SLMultiPKStartView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initView:(NSArray *)arr {
    if (!_avatarArr) {
        _avatarArr = [NSMutableArray array];
    }
    if (!valueDic) {
        valueDic = [NSMutableDictionary dictionary];
    }
    
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *info = arr[i];
        
        if (i == 0) {
            _faqiren = info[@"roomnumber"];
        }
        CGFloat w = [info[@"w"] floatValue] * self.frame.size.width;
        CGFloat h = [info[@"h"] floatValue] * self.frame.size.height;
        
        CGFloat x = [info[@"x"] floatValue] * self.frame.size.width;
        CGFloat y = [info[@"y"] floatValue] * self.frame.size.height;
        RoomAvatarView *view;
        if (_avatarArr.count > i && [_avatarArr[i] isKindOfClass:[RoomAvatarView class]]) {
            view = _avatarArr[i];
        } else {
            view = [[RoomAvatarView alloc] init];
            [self addSubview:view];
            [self sendSubviewToBack:view];
            [_avatarArr addObject:view];
        }
        [view upDataMeiLiValue:@"0"];
        view.frame = CGRectMake(x, y, w, h);
        view.avatarButton.tag = i;
        if ([view.roomnumber isEqualToString:info[@"roomnumber"]]) {
            continue;
        }
        view.roomnumber = info[@"roomnumber"];
        if ([info[@"roomnumber"] isEqualToString:self.roomnumber]) {
            view.avatarBigImg.hidden = YES;
            if (self.uploadZhuBoFrame) {
                self.uploadZhuBoFrame(view.frame);
            }
        } else {
            // 不是自己的房间才可以点击
            [view.avatarButton addTarget:self action:@selector(avatarAction:) forControlEvents:UIControlEventTouchUpInside];
            view.avatarButton.hidden = NO;
        }
        
        if ([info[@"roomnumber"] isEqualToString:@""]) {
            if ([_faqiren isEqualToString:[AppDelegate appDelegate].userModel.user.haoma]) {
                view.inviteLab.hidden = NO;
            }
            continue;
        }
        view.inviteLab.hidden = YES;
        
        view.tag = [info[@"roomnumber"] integerValue];
        
        __weak typeof(self) weakself = self;
        view.playerDisconnected = ^(NSString *roomnumber, NSString *nickname) {
            // 如果是发起人掉线 就结束本场pk
            if ([weakself.faqiren isEqualToString:roomnumber]) {
                if (weakself.pkDisconnectedClick) {
                    weakself.pkDisconnectedClick();
                }
            } else {
                if ([weakself.faqiren isEqualToString:[AppDelegate appDelegate].userModel.user.haoma]) {
                    if (weakself.pkLeaveClick) {
                        weakself.pkLeaveClick(roomnumber,nickname);
                    }
                }
            }
        };
        
        view.uploadPKVoiceMuteBlock = ^{
            [weakself uploadPKVoiceMuteState];
        };
    }
}


- (void)uploadPKVoiceMuteState {
    
    if (self.isHost) {
        NSMutableArray *rooms = [NSMutableArray array];
        for (RoomAvatarView *view in _avatarArr) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:view.roomnumber forKey:@"roomnumber"];
            [dic setObject:view.jinyanImg.highlighted?@"0":@"1" forKey:@"is_mute"];
            [rooms addObject:dic];
        }
        if (self.uploadZhuBoVoice) {
            self.uploadZhuBoVoice(rooms);
        }
    }
    
}

- (void)uploadPK_Value:(NSArray *)rooms {
    if (isShowWinner) {
        return;
    }
    for (NSDictionary *value in rooms) {
        [valueDic setValue:value[@"pkvalue"] forKey:value[@"roomnumber"]];
    }
    for (RoomAvatarView *view in _avatarArr) {
        
        if ([valueDic.allKeys containsObject:view.roomnumber]) {
            [view upDataMeiLiValue:valueDic[view.roomnumber]];
        }
    }
    
    if (cfTimer) {
        [self showWinnerState];
        isShowWinner = YES;
    }
}




- (void)showWinnerState {
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    for (RoomAvatarView *view in _avatarArr) {
        if (![view.roomnumber isEqualToString:@""]) {
            [temp setValue:view.meiliLab.text forKey:view.roomnumber];
        }
    }
    [self uploadPKEndValue:temp];
}

- (void)uploadPKEndValue:(NSMutableDictionary *)rooms {

    NSInteger maxScore = NSIntegerMin;  // 初始化最高分为最小整数
    NSMutableArray *winners = [NSMutableArray array];

    // 遍历字典，查找最高分和获胜者
    for (NSString *player in rooms) {
        NSInteger score = [rooms[player] integerValue];
        if (score > maxScore) {
            maxScore = score;
            [winners removeAllObjects];  // 清空之前的获胜者
            [winners addObject:player];  // 添加新的获胜者
        } else if (score == maxScore) {
            [winners addObject:player];  // 如果分数相同，则添加为获胜者
        }
    }
    
    NSString *winnerStr;
    
    if (winners.count > 0) {
        NSLog(@"获胜者: %@", [winners componentsJoinedByString:@", "]);
        winnerStr = [winners componentsJoinedByString:@", "];
    }
    
    if (winners.count == 0 || winners.count == rooms.count) {
        NSLog(@"比赛结果为平局或者所有选手都输了");
        winnerStr = @"";
    }
    
    
    for (RoomAvatarView *view in _avatarArr) {
        [view pkResultWinRoomnumber:winnerStr];
    }
}

- (void)avatarAction:(UIButton *)sender {
    RoomAvatarView *view = _avatarArr[sender.tag];
    if ([view.roomnumber isEqualToString:@""]) {
        // 邀请
        NSLog(@"邀请");
        if (cfTimer) {
            [self makeToast:@"已经进入惩罚阶段，无法邀请" duration:1.5 position:ToastDefaultPosition];
            return;
        }
        if (self.inviteOtherHostClick) {
            self.inviteOtherHostClick();
        }
    } else {
        if (self.gotoOtherRoomClick) {
            self.gotoOtherRoomClick([NSString stringWithFormat:@"%ld",view.tag],view.nickLab1.text,self.isHost);
        }
    }
    
}


- (void)startPkTimer {
    
    self.timeLab.hidden = YES;
    self.pkingView.hidden = NO;
    
    if (!pkTimer) {
        self.pkCount = self.pkCount_now;
        self.pkTime.text = [self formatPlayTimer:self.pkCount];
        __weak typeof(self) weakself = self;
        pkTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            weakself.pkCount--;
            if (weakself.pkCount < 0) {
                [weakself stopPkTimer];
                if ([[AppDelegate appDelegate].userModel.user.haoma isEqualToString:weakself.faqiren]) {
                    [weakself startCFTimer];
                    if (weakself.pkFinishClick) {
                        weakself.pkFinishClick();
                    }
                }
                return;
            }
            weakself.pkTime.text = [weakself formatPlayTimer:weakself.pkCount];
        }];
    } else {
        self.pkCount = self.pkCount_now;
        self.pkTime.text = [self formatPlayTimer:self.pkCount];
    }
}

- (void)stopPkTimer {
    if (pkTimer) {
        [pkTimer invalidate];
        pkTimer = nil;
        self.pkCount = 300;
    }
}


- (void)startCFTimer {
    
    [self stopPkTimer];
    self.timeLab.hidden = NO;
    self.pkingView.hidden = YES;
    
    if (!cfTimer) {
        self.cfCount = self.pkCFCount_now;
        self.timeLab.text = [NSString stringWithFormat:@"惩罚 %@",[self formatPlayTimer:self.cfCount]];
        __weak typeof(self) weakself = self;
        cfTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            weakself.cfCount--;
            if (weakself.cfCount < 0) {
                [weakself stopCFTimer];
                [weakself pkStopBtnAction:nil];
                
                return;
            }
            weakself.timeLab.text = [NSString stringWithFormat:@"惩罚 %@",[weakself formatPlayTimer:weakself.cfCount]];
            
        }];
    }
    
    [self showWinnerState];
    isShowWinner = YES;
}

- (void)stopCFTimer {
    if (cfTimer) {
        [cfTimer invalidate];
        cfTimer = nil;
    }
}

- (void)destroy {

    [self stopPkTimer];
    [self stopCFTimer];
    
    
    for (RoomAvatarView *view in _avatarArr) {
        [view destroyPlayer];
    }

}

- (void)dealloc {
    NSLog(@"TianMaMultiPKStartView dealloc");
}

- (NSString *)formatPlayTimer:(NSTimeInterval)duration
{
    int minute = 0,secend = duration;
    minute = (secend % 3600)/60;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
}

// 断开
- (IBAction)pkStopBtnAction:(id)sender {
    if (![_faqiren isEqualToString:[AppDelegate appDelegate].userModel.user.haoma]) {
        // 非发起人 断开pk，中途离场
        if (self.pkLeaveClick) {
            self.pkLeaveClick(@"",@"");
        }
    } else {
        if (self.pkStopClick) {
            self.pkStopClick(YES);
        }
    }
}


// 开始拉取视频
- (void)pullMultiPkRoomnumber:(NSArray *)info {
    
    self.isHost = NO; // 是否是参与主播
    self.duankaiBtn.hidden = YES;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in info) {
        if ([dic[@"userid"] isEqualToString:[AppDelegate appDelegate].userModel.user.id]) {
            self.isHost = YES;
            self.duankaiBtn.hidden = NO;
        }
        [temp addObject:dic];
    }
    
    int i = 0;
    for (NSDictionary *dict in temp) {
        if ([dict[@"roomnumber"] isEqualToString:@""]) {
            i++;
            continue;
        }
        [_avatarArr[i] shangMai:dict andIsZhuChiMic:YES];
        _avatarArr[i].jingyanBtn.hidden = !self.isHost;
        if (![dict[@"roomnumber"] isEqualToString:self.roomnumber]) {
            
            if (_avatarArr[i].livePlayer) {
                i++;
                continue;
            }
            
            [_avatarArr[i] initLivePlayer];
            
            
            if (self.isHost) {
                // 参与主播拉取rtc流
                __weak typeof(self) weakself = self;
                [self getTRCTuserSig:[AppDelegate appDelegate].userModel.user.haoma withBlock:^{
                    NSString *url = [NSString stringWithFormat:@"trtc://cloud.tencent.com/play/56853_%@?sdkappid=%@&userId=%@&usersig=%@",dict[@"roomnumber"],TRTCSDKAppID,[AppDelegate appDelegate].userModel.user.haoma,TXTRCTUserSig];
                    [weakself.avatarArr[i] startLivePlayRTC:url];
                }];
                
            } else {
                // 观众拉取 rtmp流
                [_avatarArr[i] startLivePlayRTC:dict[@"stream"]];
            }
        } else {
            _avatarArr[i].avatarBigImg.hidden = YES;
        }
        i++;
    }
}

- (void)getTRCTuserSig:(NSString *)roomId withBlock:(void(^)(void))block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[AppDelegate appDelegate].userModel.token forKey:@"token"];
    [[RootHttpHelper httpHelper] achieveCommonPostURL:@"trtc/getKey" andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
        NSLog(@"trct SuccessData = %@",successData);
        if ([successData[@"api_code"] intValue] == 200) {
            TXTRCTUserSig = successData[@"data"];
            block();
        }
    }];
}

- (void)uploadZhuBoVoiceState:(NSMutableArray *)rooms {
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in rooms) {
        [temp setValue:dict[@"is_mute"] forKey:dict[@"roomnumber"]];
    }
    
    for (RoomAvatarView *view in _avatarArr) {
        if ([temp.allKeys containsObject:view.roomnumber]) {
            [view setMuteMai:[temp[view.roomnumber] boolValue]];
        }
    }
}


- (void)destroyHostWith:(NSString *)roomnumber {
    for (RoomAvatarView *view in _avatarArr) {
        if ([view.roomnumber isEqualToString:roomnumber]) {
            [view destroyPlayer];
            [view emptyMai];
            if ([_faqiren isEqualToString:[AppDelegate appDelegate].userModel.user.haoma]) {
                view.inviteLab.hidden = NO;
            } else {
                view.inviteLab.hidden = YES;
            }
        }
    }
}


- (void)uploadAvatarFrame:(NSMutableArray *)arr {
    
    NSInteger tagToMove = 0;

    NSIndexSet *indexes = [_avatarArr indexesOfObjectsPassingTest:^BOOL(RoomAvatarView *roomView, NSUInteger idx, BOOL *stop) {
        return roomView.tag == tagToMove;
    }];

    NSMutableArray *objectsToMove = [[_avatarArr objectsAtIndexes:indexes] mutableCopy];
    [_avatarArr removeObjectsAtIndexes:indexes];
    [_avatarArr addObjectsFromArray:objectsToMove];

    
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *info = arr[i];
        CGFloat w = [info[@"w"] floatValue] * self.frame.size.width;
        CGFloat h = [info[@"h"] floatValue] * self.frame.size.height;
        
        CGFloat x = [info[@"x"] floatValue] * self.frame.size.width;
        CGFloat y = [info[@"y"] floatValue] * self.frame.size.height;
        
        RoomAvatarView *view = _avatarArr[i];
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = CGRectMake(x, y, w, h);
            if ([info[@"roomnumber"] isEqualToString:self.roomnumber]) {
                if (self.uploadZhuBoFrame) {
                    self.uploadZhuBoFrame(view.frame);
                }
            }
        }];
        view.avatarButton.tag = i;
        view.tag = [info[@"roomnumber"] integerValue];
        
    }
}

@end

//
//  RoomAvatarView.h
//  biyin
//
//  Created by mac on 2018/12/14.
//  Copyright © 2018年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGA.h"
#import "UserInfoModel.h"
#import <TXLiteAVSDK_Professional/V2TXLivePlayer.h>
#import <TXLiteAVSDK_Professional/V2TXLivePlayerObserver.h>
@interface RoomAvatarView : UIView<SVGAPlayerDelegate,V2TXLivePlayerObserver>
{
    UserInfoModel *currentUser;
    UIImage *img;
}
@property (weak, nonatomic) IBOutlet UILabel *inviteLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *jianbianView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jianbianViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *voiceBack;

@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *nickLab1;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *jinyanImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jinyanImgWidth;
@property (weak, nonatomic) IBOutlet UIButton *jingyanBtn;

@property (weak, nonatomic) IBOutlet UIView *videoOffView;
@property (weak, nonatomic) IBOutlet UIImageView *voiceBackNew;
@property (weak, nonatomic) IBOutlet UIImageView *avatarBigImg;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;

@property (weak, nonatomic) IBOutlet UILabel *muteLab;



@property (nonatomic, assign) NSInteger posCount;
@property (nonatomic, assign) BOOL isChatRoom;
@property (nonatomic, copy) NSString *microomRole;
@property (nonatomic, copy) NSString *roomType;
@property(nonatomic,strong)SVGAParser *parser;
@property(nonatomic,strong)SVGAPlayer *player;

@property(nonatomic,strong)UIBlurEffect *beffect;
@property(nonatomic,strong)UIVisualEffectView *visualEffectView;

@property (weak, nonatomic) IBOutlet UIButton *clearMeiliBtn;
@property (weak, nonatomic) IBOutlet UIImageView *offLineImg;

@property (nonatomic, strong) V2TXLivePlayer *livePlayer;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *meiliView;
@property (weak, nonatomic) IBOutlet UILabel *meiliLab;

@property (weak, nonatomic) IBOutlet UIView *pkInfo;
@property (nonatomic, copy) NSString *roomnumber;

@property (nonatomic, assign) BOOL is_meeting;

@property (weak, nonatomic) IBOutlet UIImageView *pkResult;
@property (weak, nonatomic) IBOutlet UIImageView *pkWinnerImg;

@property (nonatomic, copy) void (^uploadPKVoiceMuteBlock)(void);

- (void)pkResultWinRoomnumber:(NSString *)roomnumber;

- (void)shangMai:(NSDictionary *)user andIsZhuChiMic:(BOOL)isHostMic;
- (void)shangMaiModel:(UserInfoModel *)userModel;
-(void)emptyMai;
-(void)lockMai;
-(void)voiceMai;
-(void)unvoiceMai;
-(void)unlockMai;
- (void)videoSwitch:(BOOL)state;
-(void)setMuteMai:(BOOL)b;
-(BOOL)isEmpty;
- (void)showSVGAParserWithUrl:(NSString *)name;
- (void)upDataMeiLiValue:(NSString *)value;


@property (weak, nonatomic) IBOutlet UIView *hostBGView;


@property (strong, nonatomic) UIView *hostView;
//@property (strong, nonatomic) UIView *hostingView;
@property (copy, nonatomic) NSString *uid;

- (void)initWithUid:(NSString *)uid;
+ (instancetype)localSession;

- (void)hiddenJinYanImg;

- (void)setSpeak:(BOOL)speak;


- (void)initLivePlayer;
- (void)destroyPlayer;
- (void)startLivePlayRTC:(NSString *)url;

@property (nonatomic, copy) void (^playerDisconnected)(NSString *roomnumber,NSString *nickname);
@end

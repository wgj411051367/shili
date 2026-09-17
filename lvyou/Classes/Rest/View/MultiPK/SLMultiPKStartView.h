//
//  SLMultiPKStartView.h
//  tianma
//
//  Created by imac on 2023/6/13.
//  Copyright © 2023 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RoomAvatarView;
@interface SLMultiPKStartView : UICollectionReusableView

@property (nonatomic, copy) NSString *roomnumber;
@property (nonatomic, copy) NSString *faqiren;

@property (weak, nonatomic) IBOutlet UIView *pkingView; // pkview
@property (weak, nonatomic) IBOutlet UILabel *pkTime;   // pk进行时
@property (weak, nonatomic) IBOutlet UILabel *timeLab; // 准备阶段、惩罚阶段

@property (nonatomic, assign) NSInteger pkCount_now; // pk时间 单位秒
@property (nonatomic, assign) NSInteger pkCFCount_now; // 惩罚时间 单位秒


@property (nonatomic, copy) void (^pkLeaveClick)(NSString *roomnumber,NSString *nickname); // pk中途离场
@property (nonatomic, copy) void (^pkStopClick)(BOOL isZhuDong); // pk主动断开
@property (nonatomic, copy) void (^gotoOtherRoomClick)(NSString *roomnumber,NSString *nickname,BOOL isHost); // 跳转其他房间

@property (nonatomic, copy) void (^inviteOtherHostClick)(void); // 断开

@property (nonatomic, copy) void (^pkDisconnectedClick)(void); // 断开

@property (nonatomic, copy) void (^pkFinishClick)(void); // pk倒计时结束
@property (nonatomic, copy) void (^pkEndClick)(void); // pk惩罚结束

@property (nonatomic, copy) void (^uploadZhuBoFrame)(CGRect frame); // pk惩罚结束

@property (nonatomic, copy) void (^uploadZhuBoVoice)(NSMutableArray *rooms);

- (void)initView:(NSArray *)arr;
- (void)uploadPK_Value:(NSArray *)rooms;
- (void)startPkTimer;
- (void)startCFTimer;
- (void)stopPkTimer;
- (void)stopCFTimer;
- (void)destroy;

- (void)pullMultiPkRoomnumber:(NSArray *)info;
- (void)uploadZhuBoVoiceState:(NSMutableArray *)rooms;
- (void)destroyHostWith:(NSString *)roomnumber;
- (void)uploadAvatarFrame:(NSMutableArray *)arr;
@end

NS_ASSUME_NONNULL_END

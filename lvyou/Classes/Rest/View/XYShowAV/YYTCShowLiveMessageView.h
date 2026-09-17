//
//  TCShowLiveMessageView.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTCShowLiveMsg.h"
#import "SVGA.h"
typedef void(^msgTableCellSelect)(YYTCShowLiveMsg *msg);
typedef void(^msgTableCellSelectdissmiss)(void);
@protocol YYTCShowLiveMessageViewDelegate <NSObject>

- (void)msgViewDidScroll:(UIScrollView *)scrollView;
- (void)msgViewEndScroll:(UIScrollView *)scrollView;
@end
@interface YYTCShowLiveMessageView : UIView<UITableViewDataSource, UITableViewDelegate>
{
@protected
    // UITableView         *_tableView;        // 消息列表
    NSInteger           _msgCount;          // 统计点评的赞数
    
    BOOL                _isPureMode;
    BOOL                _canScrollToBottom; // 当前可以滑动到底部
    float               _lastContentOffset; // tableview当前内容位置
}
@property (weak, nonatomic) id<YYTCShowLiveMessageViewDelegate> delegate;
// 位置定时器
@property (nonatomic, strong) NSTimer       *contentOffsetTimer;

@property (nonatomic, copy) msgTableCellSelect block;
@property (nonatomic, copy) msgTableCellSelectdissmiss blockdissmiss;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *liveMessages;     // 缓存的消息数量
// 消息数量，评论数
@property (nonatomic, readonly) NSInteger msgCount;

// 即时显示的
// 插入user的message
- (void)insertText:(NSString *)message from:(UserInfoModel *)user;

- (void)insertTCShowMsg:(YYTCShowLiveMsg *)item andLeft:(BOOL)isLeft andisMsg:(BOOL)isMsg;

- (void)insertMsg:(id<NSObject>)msg;

// 主要是上线消息
- (void)insertOnlineFrom:(UserInfoModel *)user;

// 延迟显示
//- (void)insertCachedMsg:(TCShowLiveMsg *)item;

- (void)changeToMode:(BOOL)pure;


- (void)updateTableViewFrame:(CGFloat)heigt offsert:(CGFloat)scrolloff;

@end


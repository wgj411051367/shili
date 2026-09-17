// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveHotListViewController.h
//  beibei
//
//  Created by dev on 16/6/27.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseViewController.h"

@interface LiveHotListViewController : BaseViewController
@property (nonatomic,assign) CGRect rect;

@property (nonatomic, copy) void (^gotoRecommend)(NSInteger index);

// 暂停定时
- (void)pauseRecommendChange;
//继续计时
-(void)continueTimer;
@end

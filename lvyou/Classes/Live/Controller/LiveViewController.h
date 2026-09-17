// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveViewController.h
//  beibei
//
//  Created by dev on 16/6/27.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "IndexViewController.h"
#import "HomeTanKuang.h"
@interface LiveViewController : IndexViewController

@property (strong, nonatomic) UIScrollView *liveScroll;
/// 2.17
//@property (strong,nonatomic)HMSegmentedControl *segmentControl;
@property (strong,nonatomic)NSMutableArray *viewControllers;

- (void)pushToWebWith:(NSString *)loadurl with:(NSString *)titlelab and:(NSString *)imgurl;

@end

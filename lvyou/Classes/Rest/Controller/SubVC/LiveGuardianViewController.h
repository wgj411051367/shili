// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveGuardianViewController.h
//  beibei
//
//  Created by dev on 16/8/2.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseViewController.h"

@interface LiveGuardianViewController : BaseViewController

@property (nonatomic,assign) CGRect rect;

@property (strong, nonatomic) IBOutlet UIView *barView;
@property (strong, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic)NSMutableArray *guardLists;


@property (strong, nonatomic) BeginLiveModel *beginLiveModel;

@end

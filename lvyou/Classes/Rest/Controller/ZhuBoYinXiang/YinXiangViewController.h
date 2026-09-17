// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2017 Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com.cn
//
// ///////////////////////////////////////////////////////////////////////////
//
//  SignatureEditViewController.h
//  beibei
//
//  Created by apple on 16/7/9.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseViewController.h"
#import "XiangModel.h"
@interface YinXiangViewController : BaseViewController
@property (strong, nonatomic) UIScrollView *scroll;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *selectArr;
//房间号
@property (nonatomic, strong) NSString *roomNumber;
@end

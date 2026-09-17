// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveHotCell.h
//  beibei
//
//  Created by dev on 16/6/28.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveHotCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic)  NSString *personId;

@property (strong, nonatomic) IBOutlet UIImageView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *imgeView;
@property (strong, nonatomic) IBOutlet UIImageView *sexView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *location;
//@property (strong, nonatomic) IBOutlet UILabel *space;
@property (strong, nonatomic) IBOutlet UILabel *watch;
@property (strong, nonatomic) IBOutlet UILabel *watchLab;
@property (strong, nonatomic) IBOutlet UIButton *liveBtn;
//@property (strong, nonatomic) IBOutlet UIButton *VRliveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@property (weak, nonatomic) IBOutlet UIImageView *levelImg;
@property (weak, nonatomic) IBOutlet UILabel *levelNum;
/// 4.24
@property (strong, nonatomic) IBOutlet UIImageView *ImageView1;

@property (strong, nonatomic) IBOutlet UIImageView *ImageView2;
@property (nonatomic,copy) void (^userHeadBtnClick)(NSString *);

//9.14 添加印象标签
@property (weak, nonatomic) IBOutlet UIButton *yinxiangLabOne;
@property (weak, nonatomic) IBOutlet UIButton *yinxiangLabTwo;
@property (weak, nonatomic) IBOutlet UIButton *yinxiangLabThree;

@end

// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveGuardianCell.h
//  beibei
//
//  Created by dev on 16/8/3.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveGuardianCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet UIImageView *level;
@property (weak, nonatomic) IBOutlet UIImageView *cancel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;

@property (strong, nonatomic) IBOutlet UIImageView *vipImg;
@end

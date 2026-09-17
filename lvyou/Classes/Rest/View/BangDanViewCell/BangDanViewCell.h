// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  BangDanViewCell
//  beibei
//
//  Created by dev on 16/6/28.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BangDanViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *levelImg;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *listLab;
@property (weak, nonatomic) IBOutlet UILabel *paimingLab;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
- (void)setCellAtIndexPath:(NSIndexPath*)indexPath andArr:(NSMutableArray *)dataArr andType:(BOOL)iszhubo;
@end

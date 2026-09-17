//
//  PersonalCell.m
//  binfen
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 Shili. All rights reserved.
//

#import "PersonalTableCell.h"

// 定义一个重用标识
static NSString *PersonalTableCellName = @"PersonalTableCell";

@implementation PersonalTableCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 先去缓存池找可重用的cell
    PersonalTableCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalTableCellName];
    // 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:PersonalTableCellName owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

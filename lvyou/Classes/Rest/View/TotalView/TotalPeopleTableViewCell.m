//
//  TotalPeopleTableViewCell.m
//  wenxin
//
//  Created by dev on 2019/4/26.
//  Copyright © 2019 Shili. All rights reserved.
//

#import "TotalPeopleTableViewCell.h"



// 定义一个重用标识
static NSString *TotalPeopleTableViewCellName = @"TotalPeopleTableViewCell";

@implementation TotalPeopleTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 先去缓存池找可重用的cell
    TotalPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TotalPeopleTableViewCellName];
    // 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:TotalPeopleTableViewCellName owner:nil options:nil] lastObject];
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

//
//  RedPackRecordCell.m
//  liveios
//
//  Created by imac on 2022/9/21.
//  Copyright © 2022 Shili. All rights reserved.
//

#import "RedPackRecordCell.h"

// 定义一个重用标识
static NSString *RedPackRecordCellName = @"RedPackRecordCell";

@implementation RedPackRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 先去缓存池找可重用的cell
    RedPackRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:RedPackRecordCellName];
    // 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:RedPackRecordCellName owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

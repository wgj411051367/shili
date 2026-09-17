// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveHotCell.m
//  beibei
//
//  Created by dev on 16/6/28.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "NobleCell.h"

// 定义一个重用标识
static NSString *GuiZuViewCellName = @"NobleCell";

@implementation NobleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 先去缓存池找可重用的cell
    NobleCell *cell = [tableView dequeueReusableCellWithIdentifier:GuiZuViewCellName];
    // 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil)
    {
        cell =[[[NSBundle mainBundle] loadNibNamed:GuiZuViewCellName owner:nil options:nil] lastObject];
    }
    return cell;
}

@end

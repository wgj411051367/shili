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

#import "LiveHotCell.h"

// 定义一个重用标识
static NSString *XYLiveHotViewCellName = @"LiveHotCell";

@implementation LiveHotCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 先去缓存池找可重用的cell
    LiveHotCell *cell = [tableView dequeueReusableCellWithIdentifier:XYLiveHotViewCellName];
    // 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:XYLiveHotViewCellName owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)userHeadClick:(id)sender
{
    if (self.userHeadBtnClick)
    {
        self.userHeadBtnClick(self.personId);
    }
}

@end

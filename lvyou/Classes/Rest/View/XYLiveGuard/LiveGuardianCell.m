// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveGuardianCell.m
//  beibei
//
//  Created by dev on 16/8/3.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "LiveGuardianCell.h"

@implementation LiveGuardianCell

// 定义一个重用标识
static NSString *XYLiveGuardViewCellName = @"LiveGuardianCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 先去缓存池找可重用的cell
    LiveGuardianCell *cell = [tableView dequeueReusableCellWithIdentifier:XYLiveGuardViewCellName];
    // 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:XYLiveGuardViewCellName owner:nil options:nil] lastObject];
    }
    return cell;
}

@end

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

#import "BangDanViewCell.h"
#import "RankingLiistModel.h"
#import "RankPeopleModel.h"
#import "AppDelegate.h"
#import "SDWebImage.h"
#import "BaseViewController.h"
// 定义一个重用标识
static NSString *BangDanViewCellName = @"BangDanViewCell";

@implementation BangDanViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 先去缓存池找可重用的cell
    BangDanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BangDanViewCellName];
    // 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:BangDanViewCellName owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setCellAtIndexPath:(NSIndexPath*)indexPath andArr:(NSMutableArray *)dataArr andType:(BOOL)iszhubo
{
    RankingLiistModel *rankingLiistModel = dataArr[indexPath.row+3];
    self.avatarImg.contentMode=UIViewContentModeScaleAspectFill;
    self.avatarImg.clipsToBounds=YES;
    UserInfoModel *personModel;
    NSString *total=rankingLiistModel.total;
    if(iszhubo == YES)
    {
        personModel= [[UserInfoModel alloc]initWithDictionary:rankingLiistModel.receiver error:nil];
        self.listLab.text=[NSString stringWithFormat:@"共收到%@%@",total,[[BaseViewController alloc]jiFenNum]];
    }
    else
    {
        personModel= [[UserInfoModel alloc]initWithDictionary:rankingLiistModel.consumer error:nil];
        self.listLab.text=[NSString stringWithFormat:@"共贡献%@%@",total,[[BaseViewController alloc]jiFenNum]];
        
    }
    [self.avatarImg sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:personModel.id andUpdate:personModel.update_avatar_time]]];
    
    self.nickname.text=personModel.nickname;
    RankPeopleModel * rankPeopleModel = [[RankPeopleModel alloc] initWithDictionary:[SharedAppDelegate.rankDic objectForKey:personModel.rank_id] error:nil];
    if (rankPeopleModel.img!=nil) {
        [self.levelImg sd_setImageWithURL:[self placeImg:rankPeopleModel.img]];
    }
    if([personModel.gender isEqualToString:@"0"]){
        [self.sexImg setImage:[UIImage imageNamed:@"icon_live_sex"]];
    }else{
        [self.sexImg setImage:[UIImage imageNamed:@"icon_live_sex_boy"]];
    }
    if ([personModel.is_follow isEqualToString:@"0"]) {
        [self.attentionBtn setImage:[UIImage imageNamed:@"icon_message_follow"] forState:UIControlStateNormal];
//        self.attentionBtn.layer.borderColor=RGBACOLOR(204, 204, 204, 1).CGColor;
//        [self.attentionBtn setTitle:@"已关注" forState:0];
//        [self.attentionBtn setTitleColor:RGBACOLOR(204, 204, 204, 1) forState:0];
    }else{
        [self.attentionBtn setImage:[UIImage imageNamed:@"icon_message_followed"] forState:UIControlStateNormal];
//        self.attentionBtn.layer.borderColor=colorHead.CGColor;
//        [self.attentionBtn setTitle:@"关注" forState:0];
//        [self.attentionBtn setTitleColor:colorHead forState:0];
    }
    self.paimingLab.text=[NSString stringWithFormat:@"NO.%ld",indexPath.row+4];
}
- (NSURL *)placeImg:(NSString*)addr
{
    //判断是不是全路径
    if([[ToolHelper toolHelper] ReplacingCharActer:addr]){
        //全路径
        return [NSURL URLWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        //        拼接路径
        return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",IMAGEAPI,addr]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}
@end

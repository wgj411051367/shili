// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  QDCollectionView.m
//  beibei
//
//  Created by  on 16/7/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "QDCollectionView.h"
#import "AnchorModel.h"
#import "ToolHelper.h"
#import "BaseViewController.h"
@implementation QDCollectionView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"QDCollectionView" owner:self options:nil];
        // 如果路径不存在
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//     CAGradientLayer *layer4 = [self getBlackGradientWithFrame:self.bounds];
//     [_footbgImage.layer insertSublayer:layer4 atIndex:0];
}

- (void)configCellContent:(NSIndexPath *)indexPath andArray:(NSMutableArray *)dataArr
{
    
    self.jianbianView.backgroundColor = [UIColor gradientFromColor:[UIColor colorWithHex:0x000000 alpha:0] toColor:[UIColor colorWithHex:0x000000] withHeight:self.jianbianView.height];
    self.jianbianView.alpha = 0.2666;
    
    AnchorModel*anchor = dataArr[indexPath.row];
    self.coverImg.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImg.clipsToBounds = YES;
    if (anchor.anchor.live_banner) {
        [self.coverImg sd_setImageWithURL:[BaseViewController placeImg2:anchor.anchor.live_banner] placeholderImage:[UIImage imageNamed:placeCoverImage]];
    }else{
        [self.coverImg sd_setImageWithURL:[BaseViewController placeImg2:[[ToolHelper toolHelper] realAvatarUrl:anchor.anchor.id andUpdate:anchor.anchor.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeCoverImage]];
    }
    
    [[BaseViewController alloc] showThelevel:anchor.anchor.rank_id and:self.levelImg and:self.levellab isZhuBo:NO];
    //有图片1
    if (![self isBlankString:anchor.img1])
    {
        self.ImageView1.hidden=NO;
        self.ImageView1.contentMode = UIViewContentModeScaleAspectFill;
        self.ImageView1.clipsToBounds = YES;
        [self.ImageView1 sd_setImageWithURL:[BaseViewController placeImg2:anchor.img1] placeholderImage:[UIImage imageNamed:@"live"]];
    }
    else{
        self.ImageView1.hidden=YES;
    }
    //有图片2
    if (![self isBlankString:anchor.img2])
    {
        self.ImageView2.hidden=NO;
        self.ImageView2.contentMode = UIViewContentModeScaleAspectFill;
        self.ImageView2.clipsToBounds = YES;
        [self.ImageView2 sd_setImageWithURL:[BaseViewController placeImg2:anchor.img2] placeholderImage:[UIImage imageNamed:@"live"]];
    }
    else{
        self.ImageView2.hidden=YES;
    }
    //            self.liveBtn.hidden=NO;
            self.onlinenum.hidden=NO;
    

    self.liveBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.liveBtn.layer.masksToBounds=YES;
    //如果是直播就显示直播按钮 如过休息显示休息中
    self.liveBtn.hidden = YES;
    if (![self isBlankString:anchor.endtime])
    {
//        [self.liveBtn setTitle:@"休息中" forState:UIControlStateNormal];
        self.onlinenum.hidden=YES;
    }
    else if ([self isBlankString:anchor.endtime])
    {
//        if ([anchor.isPayMode isEqualToString:@"2"])
//        {
//            [self.liveBtn setTitle:@"收费房" forState:UIControlStateNormal];
//        }
//        else if ([anchor.isPayMode isEqualToString:@"1"])
//        {
//            [self.liveBtn setTitle:@"收费房" forState:UIControlStateNormal];
//        }
//        else
        if (![self isBlankString:anchor.anchor.pwd])
        {
            self.liveBtn.hidden = NO;
//            [self.liveBtn setTitle:@"密码房" forState:UIControlStateNormal];
        }
//        else
//        {
//            [self.liveBtn setTitle:@"直播中" forState:UIControlStateNormal];
//        }
    }
    
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 2;
    shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.25];
    shadow.shadowOffset =CGSizeMake(0,2);
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:anchor.anchor.nickname];
    [attriString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]} range:NSMakeRange(0, [anchor.anchor.nickname length])];
    [attriString addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]} range:NSMakeRange(0, [anchor.anchor.nickname length])];
    [attriString addAttributes:@{NSShadowAttributeName:shadow} range:NSMakeRange(0, [anchor.anchor.nickname length])];
    
    self.nickname.attributedText = attriString;
    
    self.onlinenum.text = anchor.people_num;
    if (![anchor.location isEqualToString:@""])
    {
        self.location.text = anchor.location;
    }
    else
    {
        self.location.text = @"火星";
    }

}

- (BOOL)isBlankString:(NSString *)string
{
    if (!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}



@end

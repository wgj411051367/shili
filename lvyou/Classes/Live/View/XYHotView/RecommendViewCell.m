//
//  RecommendViewCell.m
//  liveios
//
//  Created by dev on 2020/4/23.
//  Copyright © 2020 Shili. All rights reserved.
//

#import "RecommendViewCell.h"
#import "AnchorModel.h"
#import "BaseViewController.h"

@implementation RecommendViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.jianbianVIew.backgroundColor = [UIColor gradientFromColor:[UIColor colorWithHex:0x000000 alpha:0] toColor:[UIColor colorWithHex:0x000000] withHeight:self.jianbianVIew.height];
    self.jianbianVIew.alpha = 0.2666;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RecommendViewCell" owner:self options:nil];
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

- (void)setCellUI:(AnchorModel *)anchor atIndexPath:(NSIndexPath*)indexPath {
    if (anchor) {
        self.placholderImg.hidden = YES;
        if (anchor.anchor.live_banner && ![anchor.anchor.live_banner isEqualToString:@""]) {
            [self.cover sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.anchor.live_banner] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        }else{
            [self.cover sd_setImageWithURL:[[BaseViewController alloc] placeImg:[[ToolHelper toolHelper] realAvatarUrl:anchor.anchor.id andUpdate:anchor.anchor.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        }
        if (![[BaseViewController alloc] isBlankString:anchor.img1])
        {
            self.imgView_1.hidden=NO;
            self.imgView_1.contentMode = UIViewContentModeScaleAspectFill;
            self.imgView_1.clipsToBounds = YES;
            [self.imgView_1 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.img1] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        } else {
            self.imgView_1.hidden = YES;
        }
        /// 4.24 有图片2
        if (![[BaseViewController alloc] isBlankString:anchor.img2])
        {
            self.imgView_2.hidden=NO;
            self.imgView_2.contentMode = UIViewContentModeScaleAspectFill;
            self.imgView_2.clipsToBounds = YES;
            [self.imgView_2 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.img2] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        } else {
            self.imgView_2.hidden = YES;
        }
        self.nickname.text = anchor.anchor.nickname;
        [[BaseViewController alloc] showThelevel:anchor.anchor.rank_id and:self.levelImg and:self.levelLab isZhuBo:NO];
        self.jianbianVIew.backgroundColor = [UIColor gradientFromColor:[UIColor colorWithHex:0x000000 alpha:0] toColor:[UIColor colorWithHex:0x000000] withHeight:self.jianbianVIew.height];
        self.jianbianVIew.alpha = 0.2666;
        
        self.liveBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.liveBtn.layer.masksToBounds=YES;
        self.liveBtn.hidden = YES;
        //如果是直播就显示直播按钮 如过休息显示休息中
        if (![[BaseViewController alloc] isBlankString:anchor.endtime])
        {
            [self.liveBtn setTitle:@"休息中" forState:UIControlStateNormal];
            
        }
        else if ([[BaseViewController alloc] isBlankString:anchor.endtime])
        {
            if ([anchor.isPayMode isEqualToString:@"2"])
            {
                [self.liveBtn setTitle:@"收费房" forState:UIControlStateNormal];
            }
            else if ([anchor.isPayMode isEqualToString:@"1"])
            {
                [self.liveBtn setTitle:@"收费房" forState:UIControlStateNormal];
            }
            else if (![[BaseViewController alloc] isBlankString:anchor.anchor.pwd])
            {
                self.liveBtn.hidden = NO;
//                [self.liveBtn setTitle:@"密码房" forState:UIControlStateNormal];
            }
            else
            {
                self.liveBtn.hidden = YES;
//                [self.liveBtn setTitle:@"直播中" forState:UIControlStateNormal];
            }
        }
    }    
}
@end

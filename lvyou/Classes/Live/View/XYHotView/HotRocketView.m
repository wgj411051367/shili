//
//  HotRocketView.m
//  liveios
//
//  Created by dev on 2020/4/17.
//  Copyright © 2020 Shili. All rights reserved.
//

#import "HotRocketView.h"
#import "AnchorModel.h"
#import "BaseViewController.h"

@implementation HotRocketView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)hotTopBtnAction:(UIButton *)sender {
    if (self.hotTopClick) {
        self.hotTopClick(sender.tag-100);
    }
}

- (void)uploadData:(NSMutableArray *)dataArr {
    self.placholderImg_1.hidden = NO;
    self.placholderImg_2.hidden = NO;
    self.placholderImg_3.hidden = NO;
    self.imgView_1_1.hidden=YES;
    self.imgView_1_2.hidden=YES;
    self.imgView_2_1.hidden=YES;
    self.imgView_2_2.hidden=YES;
    self.imgView_1_3.hidden=YES;
    self.imgView_2_3.hidden=YES;
    if (dataArr.count > 0) {
        self.placholderImg_1.hidden = YES;
        AnchorModel* anchor = dataArr[0];
        if (anchor.anchor.live_banner && ![anchor.anchor.live_banner isEqualToString:@""]) {
            [self.cover_1 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.anchor.live_banner] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        }else{
            [self.cover_1 sd_setImageWithURL:[[BaseViewController alloc] placeImg:[[ToolHelper toolHelper] realAvatarUrl:anchor.anchor.id andUpdate:anchor.anchor.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        }
        if (![[BaseViewController alloc] isBlankString:anchor.img1])
        {
            self.imgView_1_1.hidden=NO;
            self.imgView_1_1.contentMode = UIViewContentModeScaleAspectFill;
            self.imgView_1_1.clipsToBounds = YES;
            [self.imgView_1_1 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.img1] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        } else {
            self.imgView_1_1.hidden = YES;
        }
        /// 4.24 有图片2
        if (![[BaseViewController alloc] isBlankString:anchor.img2])
        {
            self.imgView_2_1.hidden=NO;
            self.imgView_2_1.contentMode = UIViewContentModeScaleAspectFill;
            self.imgView_2_1.clipsToBounds = YES;
            [self.imgView_2_1 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.img2] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        } else {
            self.imgView_2_1.hidden = YES;
        }
        if ([anchor.showtitle isEqualToString:@""]) {
            self.nickname_1.text = anchor.anchor.nickname;
        } else {
            self.nickname_1.text = anchor.showtitle;
        }
        [[BaseViewController alloc] showThelevel:anchor.anchor.rank_id and:self.levelImg_1 and:self.levelLab_1 isZhuBo:NO];
        self.jianbianVIew_1.backgroundColor = [UIColor gradientFromColor:[UIColor colorWithHex:0x000000 alpha:0] toColor:[UIColor colorWithHex:0x000000] withHeight:self.jianbianVIew_1.height];
        self.jianbianVIew_1.alpha = 0.2666;
        
        self.liveBtn_1.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.liveBtn_1.layer.masksToBounds=YES;
        
        //如果是直播就显示直播按钮 如过休息显示休息中
        if (![[BaseViewController alloc] isBlankString:anchor.endtime])
        {
            [self.liveBtn_1 setTitle:@"休息中" forState:UIControlStateNormal];
            
        }
        else if ([[BaseViewController alloc] isBlankString:anchor.endtime])
        {
            if ([anchor.isPayMode isEqualToString:@"2"])
            {
                [self.liveBtn_1 setTitle:@"收费房" forState:UIControlStateNormal];
            }
            else if ([anchor.isPayMode isEqualToString:@"1"])
            {
                self.liveBtn_1.hidden = NO;
                [self.liveBtn_1 setTitle:@"收费房" forState:UIControlStateNormal];
            }
            else if (![[BaseViewController alloc] isBlankString:anchor.anchor.pwd])
            {
                [self.liveBtn_1 setTitle:@"密码房" forState:UIControlStateNormal];
            }
            else
            {
                self.liveBtn_1.hidden = YES;
                [self.liveBtn_1 setTitle:@"直播中" forState:UIControlStateNormal];
            }
        }
    }
    
    
    if (dataArr.count > 1) {
        self.placholderImg_2.hidden = YES;
        AnchorModel* anchor = dataArr[1];
        if (anchor.anchor.live_banner && ![anchor.anchor.live_banner isEqualToString:@""]) {
            [self.cover_2 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.anchor.live_banner] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        }else{
            [self.cover_2 sd_setImageWithURL:[[BaseViewController alloc] placeImg:[[ToolHelper toolHelper] realAvatarUrl:anchor.anchor.id andUpdate:anchor.anchor.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        }
        if (![[BaseViewController alloc] isBlankString:anchor.img1])
        {
            self.imgView_1_2.hidden=NO;
            self.imgView_1_2.contentMode = UIViewContentModeScaleAspectFill;
            self.imgView_1_2.clipsToBounds = YES;
            [self.imgView_1_2 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.img1] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        } else {
            self.imgView_1_2.hidden = YES;
        }
        /// 4.24 有图片2
        if (![[BaseViewController alloc] isBlankString:anchor.img2])
        {
            self.imgView_2_2.hidden=NO;
            self.imgView_2_2.contentMode = UIViewContentModeScaleAspectFill;
            self.imgView_2_2.clipsToBounds = YES;
            [self.imgView_2_2 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.img2] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        } else {
            self.imgView_2_2.hidden = YES;
        }
        self.nickname_2.text = anchor.anchor.nickname;
        [[BaseViewController alloc] showThelevel:anchor.anchor.rank_id and:self.levelImg_2 and:self.levelLab_2 isZhuBo:NO];
        self.jianbianVIew_2.backgroundColor = [UIColor gradientFromColor:[UIColor colorWithHex:0x000000 alpha:0] toColor:[UIColor colorWithHex:0x000000] withHeight:self.jianbianVIew_2.height];
        self.jianbianVIew_2.alpha = 0.2666;
        
        self.liveBtn_2.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.liveBtn_2.layer.masksToBounds=YES;
        //如果是直播就显示直播按钮 如过休息显示休息中
        self.liveBtn_2.hidden = NO;
        if (![[BaseViewController alloc] isBlankString:anchor.endtime])
        {
            [self.liveBtn_2 setTitle:@"休息中" forState:UIControlStateNormal];
            
        }
        else if ([[BaseViewController alloc] isBlankString:anchor.endtime])
        {
            if ([anchor.isPayMode isEqualToString:@"2"])
            {
                [self.liveBtn_2 setTitle:@"收费房" forState:UIControlStateNormal];
            }
            else if ([anchor.isPayMode isEqualToString:@"1"])
            {
                [self.liveBtn_2 setTitle:@"收费房" forState:UIControlStateNormal];
            }
            else if (![[BaseViewController alloc] isBlankString:anchor.anchor.pwd])
            {
                self.liveBtn_2.hidden = NO;
                [self.liveBtn_2 setTitle:@"密码房" forState:UIControlStateNormal];
            }
            else
            {
                self.liveBtn_2.hidden = YES;
                [self.liveBtn_2 setTitle:@"直播中" forState:UIControlStateNormal];
            }
        }
    }
    if (dataArr.count > 2) {
        self.placholderImg_3.hidden = YES;
        AnchorModel* anchor = dataArr[2];
        if (anchor.anchor.live_banner && ![anchor.anchor.live_banner isEqualToString:@""]) {
            [self.cover_3 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.anchor.live_banner] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        }else{
            [self.cover_3 sd_setImageWithURL:[[BaseViewController alloc] placeImg:[[ToolHelper toolHelper] realAvatarUrl:anchor.anchor.id andUpdate:anchor.anchor.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        }
        if (![[BaseViewController alloc] isBlankString:anchor.img1])
        {
            self.imgView_1_3.hidden=NO;
            self.imgView_1_3.contentMode = UIViewContentModeScaleAspectFill;
            self.imgView_1_3.clipsToBounds = YES;
            [self.imgView_1_3 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.img1] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        } else {
            self.imgView_1_3.hidden = YES;
        }
        /// 4.24 有图片2
        if (![[BaseViewController alloc] isBlankString:anchor.img2])
        {
            self.imgView_2_3.hidden=NO;
            self.imgView_2_3.contentMode = UIViewContentModeScaleAspectFill;
            self.imgView_2_3.clipsToBounds = YES;
            [self.imgView_2_3 sd_setImageWithURL:[[BaseViewController alloc] placeImg:anchor.img2] placeholderImage:[UIImage imageNamed:placeCoverImage]];
        } else {
            self.imgView_2_3.hidden = YES;
        }
        if ([anchor.showtitle isEqualToString:@""]) {
            self.nickname_3.text = anchor.anchor.nickname;
        } else {
            self.nickname_3.text = anchor.showtitle;
        }
        [[BaseViewController alloc] showThelevel:anchor.anchor.rank_id and:self.levelImg_3 and:self.levelLab_3 isZhuBo:NO];
        self.jianbianVIew_3.backgroundColor = [UIColor gradientFromColor:[UIColor colorWithHex:0x000000 alpha:0] toColor:[UIColor colorWithHex:0x000000] withHeight:self.jianbianVIew_3.height];
        self.jianbianVIew_3.alpha = 0.2666;
        
        self.liveBtn_3.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.liveBtn_3.layer.masksToBounds=YES;
        //如果是直播就显示直播按钮 如过休息显示休息中
        self.liveBtn_3.hidden = YES;
        if (![[BaseViewController alloc] isBlankString:anchor.endtime])
        {
            [self.liveBtn_3 setTitle:@"休息中" forState:UIControlStateNormal];
            
        }
        else if ([[BaseViewController alloc] isBlankString:anchor.endtime])
        {
            if ([anchor.isPayMode isEqualToString:@"2"])
            {
                [self.liveBtn_3 setTitle:@"收费房" forState:UIControlStateNormal];
            }
            else if ([anchor.isPayMode isEqualToString:@"1"])
            {
                [self.liveBtn_3 setTitle:@"收费房" forState:UIControlStateNormal];
            }
            else if (![[BaseViewController alloc] isBlankString:anchor.anchor.pwd])
            {
                self.liveBtn_3.hidden = NO;
//                [self.liveBtn_3 setTitle:@"密码房" forState:UIControlStateNormal];
            }
            else
            {
                self.liveBtn_3.hidden = YES;
//                [self.liveBtn_3 setTitle:@"直播中" forState:UIControlStateNormal];
            }
        }
    }
}

@end

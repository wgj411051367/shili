//
//  RecommendViewCell.h
//  liveios
//
//  Created by dev on 2020/4/23.
//  Copyright © 2020 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AnchorModel;
@interface RecommendViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_2;
@property (weak, nonatomic) IBOutlet UIView *jianbianVIew;
@property (weak, nonatomic) IBOutlet UIImageView *levelImg;
@property (weak, nonatomic) IBOutlet UILabel *levelLab;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *placholderImg;


- (void)setCellUI:(AnchorModel *)anchor atIndexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END

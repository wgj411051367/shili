//
//  LiveWishViewCell.h
//  liveios
//
//  Created by dev on 2021/4/21.
//  Copyright © 2021 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveWishViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *wishBGImg;
@property (weak, nonatomic) IBOutlet UIImageView *giftImg;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImgAspect;

@end

NS_ASSUME_NONNULL_END

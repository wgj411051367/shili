//
//  LiveWishScrollView.h
//  liveios
//
//  Created by dev on 2021/4/21.
//  Copyright © 2021 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveWishScrollView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (nonatomic, copy) NSArray *dataSource;

- (void)initView;
@end

NS_ASSUME_NONNULL_END

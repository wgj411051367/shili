//
//  LiveWishScrollView.m
//  liveios
//
//  Created by dev on 2021/4/21.
//  Copyright © 2021 Shili. All rights reserved.
//

#import "LiveWishScrollView.h"
#import "LiveWishViewCell.h"
#import "TiePianBanner.h"
#import "BaseViewController.h"
@interface LiveWishScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger count;
    
    NSInteger index;
}
@property (nonatomic, copy) NSTimer *timer;
@end

@implementation LiveWishScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)initView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    layout.minimumInteritemSpacing = 0*ScreenBiLi;
    layout.minimumLineSpacing = 0*ScreenBiLi;
    layout.sectionInset = UIEdgeInsetsMake(0*ScreenBiLi, 0*ScreenBiLi, 0*ScreenBiLi, 0*ScreenBiLi);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collection.collectionViewLayout = layout;
    _collection.showsHorizontalScrollIndicator = NO;
    _collection.pagingEnabled = YES;
    [_collection registerClass:[LiveWishViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.collection reloadData];
    
    if (!_timer) {
        index = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(pagingTimer) userInfo:nil repeats:YES];
    }
}

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)pagingTimer {

    index = index + 1;
    index = index >= self.dataSource.count ? 0 : index;
    [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}




#pragma mark -----------------UICollectionViewDelegateFlowLayout----------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
    
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveWishViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    TiePianBanner *model = self.dataSource[indexPath.row];
    
    [cell.wishBGImg sd_setImageWithURL:[[BaseViewController alloc] placeImg:model.img_bg]];
    [cell.giftImg sd_setImageWithURL:[[BaseViewController alloc] placeImg:model.img]];
    
    
    if (model.getnum && model.max_num) {
        if ([model.getnum integerValue] >= [model.max_num integerValue]) {
            cell.numLab.text = @"已完成";
        } else {
            cell.numLab.text = [NSString stringWithFormat:@"%@/%@",model.getnum,model.max_num];
        }
    }
    
    
    return cell;
}




@end

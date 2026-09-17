//
//  RecommendView.m
//  liveios
//
//  Created by dev on 2020/4/17.
//  Copyright © 2020 Shili. All rights reserved.
//

#import "RecommendView.h"
#import "AnchorModel.h"
#import "BaseViewController.h"
#import "RecommendViewCell.h"


static const CGFloat   kClockSec     = 0.02;
@interface RecommendView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    CGFloat pointX;
    BOOL isStartMove;
}
@property (nonatomic, copy) NSMutableArray *viewsArr;
@property (nonatomic,weak)NSTimer *clock;
@property (nonatomic, copy) NSMutableArray *dataArr;

@end

@implementation RecommendView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    pointX = 0;
    [self.recommendBGView addSubview:self.collectionView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseTimer) name:@"HotRecommendStopAnimation" object:nil];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 117) collectionViewLayout:layout];
        //注册cell
        [_collectionView registerClass:[RecommendViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //11.28
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
        //调用刷新方法
        //        [self setupRefresh];
    }
    return _collectionView;
}

#pragma mark - CollectionView的代理方法
#pragma mark - 分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - 每组Cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

#pragma mark - 设置每个Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(117, 117);
}

#pragma mark - 设置每个Cell的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //前两个代表距离上边距和左边距的距离
    //后两个代理距离下边距和右边距的距离
    return UIEdgeInsetsMake(0, 7, 0, 7);
}

#pragma mark - 设置每个Cell水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark - 设置每个Cell垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark - 初始化Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecommendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    AnchorModel *model = _dataArr[indexPath.row];
    if ([model.id isEqualToString:@"-99999"]) {// 表示没有人
        cell.placholderImg.hidden = NO;
        cell.placholderImg.image = [UIImage imageNamed:model.placeholder_img];
    } else {
        [cell setCellUI:model atIndexPath:indexPath];
//        cell.ta
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AnchorModel *model = _dataArr[indexPath.row];
    if (![model.id isEqualToString:@"-99999"]) {
        if (self.recommendClick) {
            self.recommendClick(model);
        }
    }
    
}


- (IBAction)moreBtnAction:(id)sender {
    if (self.hotMoreClick) {
        self.hotMoreClick();
    }
}



- (void)uploadData:(NSMutableArray *)dataArr {
    _dataArr = [dataArr mutableCopy];
    [self.collectionView reloadData];
    if (!_clock) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kClockSec target:self selector:@selector(checkAndBiu) userInfo:nil repeats:YES];
        _clock = timer;
    } else {
        pointX = 0.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!isStartMove) {
                [self continueTimer];
            }
        });
        
    }
}




#pragma mark -- 私有方法
- (void)checkAndBiu {
    pointX -= -0.5;
    isStartMove = YES;
    [self.collectionView setContentOffset:CGPointMake(pointX, 0) animated:NO];
}



-(NSTimer *)clock {
    if (!_clock) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kClockSec target:self selector:@selector(checkAndBiu) userInfo:nil repeats:YES];
        _clock = timer;
    }
    return _clock;
}

//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer{
    [_clock setFireDate:[NSDate distantFuture]];
    self.stopBtn.hidden = YES;
    isStartMove = NO;
    NSLog(@"定时器关闭");
}
//继续计时
-(void)continueTimer{
    [_clock setFireDate:[NSDate distantPast]];
    isStartMove = YES;
    NSLog(@"定时器开启");
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x;
    pointX = xOffset;
//    NSLog(@"偏移想 = %f",xOffset);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x;
//    pointX = xOffset;
    NSLog(@"scrollViewWillBeginDragging = %f",xOffset);
}

@end

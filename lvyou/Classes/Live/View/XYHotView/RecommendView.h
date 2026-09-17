//
//  RecommendView.h
//  liveios
//
//  Created by dev on 2020/4/17.
//  Copyright © 2020 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionReusableView+Touch.h"
NS_ASSUME_NONNULL_BEGIN
@class AnchorModel;
@interface RecommendView : UICollectionReusableView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void (^hotMoreClick)(void);
@property (nonatomic, copy) void (^recommendClick)(AnchorModel *model);

@property (weak, nonatomic) IBOutlet UIView *recommendBGView;

@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

- (void)uploadData:(NSMutableArray *)dataArr;

//暂停定时器(只是暂停,并没有销毁timer)
-(void)pauseTimer;
//继续计时
-(void)continueTimer;

@end

NS_ASSUME_NONNULL_END

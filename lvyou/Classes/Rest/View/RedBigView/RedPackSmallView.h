//
//  RedPackSmallView.h
//  liveios
//
//  Created by imac on 2022/9/21.
//  Copyright © 2022 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RedPackSmallView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *openImage;
@property (weak, nonatomic) IBOutlet UIView *guizeView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *timeCount;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLab;
@property (nonatomic, copy) NSString *game_id;
@property (nonatomic, copy) NSString *max;
@property (nonatomic, copy) NSString *get;

- (void)initView;
- (void)uploadTimeCount:(NSInteger)count;
- (void)uploadProgress:(NSString *)count max:(NSString *)max;

@property (nonatomic, copy) void (^clickMoreRedPcak)(BOOL isOpen);
@end

NS_ASSUME_NONNULL_END

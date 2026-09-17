//
//  HotRocketView.h
//  liveios
//
//  Created by dev on 2020/4/17.
//  Copyright © 2020 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotRocketView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *cover_1;
@property (weak, nonatomic) IBOutlet UIImageView *cover_2;
@property (weak, nonatomic) IBOutlet UIImageView *cover_3;

@property (weak, nonatomic) IBOutlet UIImageView *imgView_1_1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_1_2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_1_3;

@property (weak, nonatomic) IBOutlet UIImageView *imgView_2_1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_2_2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_2_3;

@property (weak, nonatomic) IBOutlet UIView *jianbianVIew_1;
@property (weak, nonatomic) IBOutlet UIView *jianbianVIew_2;
@property (weak, nonatomic) IBOutlet UIView *jianbianVIew_3;

@property (weak, nonatomic) IBOutlet UIImageView *levelImg_1;
@property (weak, nonatomic) IBOutlet UIImageView *levelImg_2;
@property (weak, nonatomic) IBOutlet UIImageView *levelImg_3;

@property (weak, nonatomic) IBOutlet UILabel *levelLab_1;
@property (weak, nonatomic) IBOutlet UILabel *levelLab_2;
@property (weak, nonatomic) IBOutlet UILabel *levelLab_3;

@property (weak, nonatomic) IBOutlet UILabel *nickname_1;
@property (weak, nonatomic) IBOutlet UILabel *nickname_2;
@property (weak, nonatomic) IBOutlet UILabel *nickname_3;

@property (weak, nonatomic) IBOutlet UIButton *liveBtn_1;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn_3;

@property (weak, nonatomic) IBOutlet UIImageView *placholderImg_1;
@property (weak, nonatomic) IBOutlet UIImageView *placholderImg_2;
@property (weak, nonatomic) IBOutlet UIImageView *placholderImg_3;

@property (nonatomic, copy) void (^hotTopClick)(NSInteger index);

- (void)uploadData:(NSMutableArray *)dataArr;
@end

NS_ASSUME_NONNULL_END

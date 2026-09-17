//
//  OpenShouHuView.h
//  liveios
//
//  Created by dev on 2019/5/8.
//  Copyright © 2019 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeginLiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenShouHuView : UIView
@property (weak, nonatomic) IBOutlet UIButton *shouHuBtn1;
@property (weak, nonatomic) IBOutlet UIButton *shouHuBtn2;
@property (weak, nonatomic) IBOutlet UIButton *shouHuBtn3;
@property (weak, nonatomic) IBOutlet UIButton *shouHuBtn4;
@property (weak, nonatomic) IBOutlet UILabel *shouHuDayLab1;
@property (weak, nonatomic) IBOutlet UILabel *shouHuDayLab2;
@property (weak, nonatomic) IBOutlet UILabel *shouHuDayLab3;
@property (weak, nonatomic) IBOutlet UILabel *shouHuDayLab4;
@property (weak, nonatomic) IBOutlet UILabel *shouHuMoneyLab1;
@property (weak, nonatomic) IBOutlet UILabel *shouHuMoneyLab2;
@property (weak, nonatomic) IBOutlet UILabel *shouHuMoneyLab3;
@property (weak, nonatomic) IBOutlet UILabel *shouHuMoneyLab4;
@property (weak, nonatomic) IBOutlet UILabel *shouHuGivingLab1;
@property (weak, nonatomic) IBOutlet UILabel *shouHuGivingLab2;
@property (weak, nonatomic) IBOutlet UILabel *shouHuGivingLab3;
@property (weak, nonatomic) IBOutlet UILabel *shouHuGivingLab4;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (nonatomic, copy) NSMutableArray *btnArr;
@property (nonatomic, copy) NSMutableArray *dayLabArr;
@property (nonatomic, copy) NSMutableArray *moneyLabArr;
@property (nonatomic, copy) NSMutableArray *givingArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;

@property (nonatomic, copy) NSArray *shouHuArr;

@property (strong, nonatomic) BeginLiveModel *beginModel;

@property (copy, nonatomic) void (^buyBtnClick)(NSDictionary *params);

- (IBAction)dismissShouHuView:(id)sender;
- (void)showView;
- (void)initArr;
@end

NS_ASSUME_NONNULL_END

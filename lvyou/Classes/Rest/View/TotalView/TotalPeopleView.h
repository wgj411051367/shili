//
//  TotalPeopleView.h
//  wenxin
//
//  Created by dev on 2019/4/26.
//  Copyright © 2019 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UserListURL) {
    UserListNormalURL   = 0,      // 观众
    UserListGuiBinURL   = 1,      // 贵族
    UserListGuardURL    = 2,      // 守护
    UserListFansURL     = 3       // 粉丝
};

@protocol TotalPeopleViewDelegate <NSObject>

- (void)touchUserAvatar:(NSString *)userid;

- (void)totalPeopleViewBuyShouHu;
- (void)totalPeopleViewBuyGuiZu;
- (void)totalPeopleViewDismiss;
@end

@interface TotalPeopleView : UIView
@property (weak, nonatomic) IBOutlet UILabel *shouhuLab;
@property (weak, nonatomic) IBOutlet UILabel *shouhuLine;
@property (weak, nonatomic) IBOutlet UIButton *shouhuBtn;

@property (weak, nonatomic) IBOutlet UILabel *guizuLab;
@property (weak, nonatomic) IBOutlet UILabel *guizuLine;
@property (weak, nonatomic) IBOutlet UIButton *guizuBtn;

@property (weak, nonatomic) IBOutlet UILabel *guanzhongLab;
@property (weak, nonatomic) IBOutlet UILabel *guanzhongLine;
@property (weak, nonatomic) IBOutlet UIButton *guanzhongBtn;

@property (weak, nonatomic) IBOutlet UITableView *shouhuTableView;
@property (weak, nonatomic) IBOutlet UITableView *guizuTableView;
@property (weak, nonatomic) IBOutlet UITableView *guanzhongTableView;

@property (nonatomic, copy) NSMutableArray *shouhuArr;
@property (nonatomic, copy) NSMutableArray *guizuArr;
@property (nonatomic, copy) NSMutableArray *guanzhongArr;

@property (weak, nonatomic) id<TotalPeopleViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *gzBtn;
@property (weak, nonatomic) IBOutlet UIButton *shBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyShouHuBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyGuizuBtnHeight;

@property (assign, nonatomic) BOOL isHost;
@property (nonatomic, copy) NSString *roomnumber;
//开通守护回调
@property (copy, nonatomic) void (^shouhuBtnClick)();
//开通贵族回调
@property (copy, nonatomic) void (^guizuBtnClick)();

@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIButton *bgView;

- (void)initView;
- (void)showView:(UIButton *)sender;

- (void)dismissView;

- (void)setupRefresh;
@end

NS_ASSUME_NONNULL_END

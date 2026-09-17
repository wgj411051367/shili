//
//  RedPackBigView.h
//  liveios
//
//  Created by imac on 2022/9/20.
//  Copyright © 2022 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UserInfoModel;

@interface RedPackBigView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *firstView; // 抢红包第一级页面
@property (weak, nonatomic) IBOutlet UIImageView *firstAvatar; // 头像
@property (weak, nonatomic) IBOutlet UILabel *firstName;     // 主播昵称的红包
@property (weak, nonatomic) IBOutlet UILabel *firstTotalMoney; // 红包总金额
@property (weak, nonatomic) IBOutlet UIView *firstTimeView;     // 倒计时View
@property (weak, nonatomic) IBOutlet UILabel *firstTimeCount; // 倒计时Label


@property (weak, nonatomic) IBOutlet UIView *qiangView; // 抢了之后的页面
@property (weak, nonatomic) IBOutlet UIImageView *qiangTitleImg; // 是否抢到的文字图片
@property (weak, nonatomic) IBOutlet UIImageView *qiangAvatar; // 头像
@property (weak, nonatomic) IBOutlet UILabel *qiangName;    // 主播的昵称的红包
@property (weak, nonatomic) IBOutlet UIView *qiangMoneyView;    // 是否抢到钻石的View
@property (weak, nonatomic) IBOutlet UILabel *qiangMoneyLab;    // 抢到的钻石数

@property (weak, nonatomic) IBOutlet UIView *recordView;    // 查看手气列表页
@property (weak, nonatomic) IBOutlet UILabel *recordNoMoneyLab; //没有抢到红包的Label提示
@property (weak, nonatomic) IBOutlet UIView *recordMoneyView;   //  抢到红包的view
@property (weak, nonatomic) IBOutlet UILabel *recordContentLab; // 抢到了多少钻石
@property (weak, nonatomic) IBOutlet UILabel *recordMoneyLab; // 抢到了多少钻石
@property (weak, nonatomic) IBOutlet UITableView *tableView;    // 底部抢到的人数

@property (nonatomic, copy) NSString *redpackID; // 红包id

- (void)showView:(NSString *)redPackID;
- (void)initView:(UserInfoModel *)model;
- (void)uploadTimeCount:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END

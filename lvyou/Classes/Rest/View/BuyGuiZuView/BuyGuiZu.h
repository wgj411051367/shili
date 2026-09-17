//
//  InviteView.h
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyGuiZu : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSString *roomnumber;
    int page;
}
//背景view
@property(nonatomic,strong)UIView *backView;
//标题
@property(nonatomic,strong)UILabel*titleLab;
//人气
@property(nonatomic,strong)UILabel*renqiLab;
//贵宾数
@property(nonatomic,strong)UILabel*guibinLab;
@property(nonatomic,strong)UIView *guibinView;
//皇冠👑图标
@property(nonatomic,strong)UIImageView*guibinImg;
//描述文字
@property(nonatomic,strong)UILabel*textLab;
//开通按钮
@property(nonatomic,strong)UIButton *buyBtn;
@property(nonatomic,strong)UIButton *buyBtnTwo;
//贵宾列表
@property(nonatomic,strong)UITableView *guibinTable;

@property(nonatomic,strong)NSMutableArray *DataArray;



- (instancetype)initWithFrame:(CGRect)frame andGuiZuNum:(NSString *)guizu_num andRenQi:(int)renqiNum andRoomnumber:(NSString *)roomNumber andArr:(NSMutableArray *)dataArr;

@property (nonatomic,weak)id delegate;

@end

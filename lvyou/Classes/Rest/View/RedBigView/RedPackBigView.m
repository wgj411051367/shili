//
//  RedPackBigView.m
//  liveios
//
//  Created by imac on 2022/9/20.
//  Copyright © 2022 Shili. All rights reserved.
//

#import "RedPackBigView.h"
#import "BaseViewController.h"
#import "RedPackRecordCell.h"
#import "RedPackItemsModel.h"
@interface RedPackBigView()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
}
@end
@implementation RedPackBigView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


// 关闭弹窗
- (IBAction)closeBtnAction:(id)sender {
    self.recordView.hidden = YES;
    self.hidden = YES;
}

// 查看手气返回
- (IBAction)backBtnAction:(id)sender {
    self.recordView.hidden = YES;
}

// 查看手气
- (IBAction)nextBtnAction:(id)sender {
    self.recordView.hidden = NO;
    [self getRecordDataInfo];
}

- (void)showView:(NSString *)redPackID {
    self.hidden = NO;
    if ([self.redpackID isEqualToString:redPackID]) {
        // 相同不做处理
    } else {
        self.redpackID = redPackID;
        // 红包id不同了
    }
    
}
- (IBAction)openReadAction:(id)sender {
    [self openRead];
}

- (void)openRead {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.redpackID forKey:@"game_id"];
    [params setValue:[AppDelegate appDelegate].userModel.token forKey:@"token"];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:[NSString stringWithFormat:@"%@%@/%@",DATAAPI,@"v4",@"roomRedpackage/getRedpackage"] andController:nil andView:self andParams:params andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue] == 200) {
            self.firstView.hidden = YES;
            self.qiangView.hidden = NO;
            if ([successData[@"get_money"] integerValue] > 0) {
                self.qiangTitleImg.image = [UIImage imageNamed:@"icon_live_red_pack_rob"];
                self.qiangMoneyView.hidden = NO;
                self.qiangMoneyLab.text = [NSString stringWithFormat:@"%@",successData[@"get_money"]];
                self.recordMoneyView.hidden = NO;
                self.recordNoMoneyLab.hidden = YES;
                self.recordMoneyLab.text = [NSString stringWithFormat:@"%@",successData[@"get_money"]];
                self.recordContentLab.hidden = NO;
            } else {
                self.qiangTitleImg.image = [UIImage imageNamed:@"icon_live_red_pack_rob_no"];
                self.qiangMoneyView.hidden = YES;
                self.recordMoneyView.hidden = YES;
                self.recordNoMoneyLab.hidden = NO;
                self.recordContentLab.hidden = YES;
            }
            [[HudHelper hudHepler] showLongTips:self tips:successData[@"api_msg"]];
        } else {
            [[HudHelper hudHepler] showLongTips:self tips:successData[@"api_msg"]];
        }
    }];
}

- (void)initView:(UserInfoModel *)model {
    self.firstName.text = [NSString stringWithFormat:@"%@的红包",model.nickname];
    [self.firstAvatar sd_setImageWithURL:[BaseViewController placeImg2:model.avatar]];
    self.firstAvatar.layer.borderColor = [UIColor colorWithHex:0xF97E55].CGColor;
    self.firstAvatar.layer.borderWidth = 2;
    
    
    self.qiangName.text = [NSString stringWithFormat:@"%@的红包",model.nickname];
    [self.qiangAvatar sd_setImageWithURL:[BaseViewController placeImg2:model.avatar]];
    self.qiangAvatar.layer.borderColor = [UIColor colorWithHex:0xF97E55].CGColor;
    self.qiangAvatar.layer.borderWidth = 2;
    
}

- (void)uploadTimeCount:(NSInteger)count {
    NSInteger min = count / 60;
    NSInteger sec = count % 60;
    self.firstTimeCount.text = [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}

- (void)getRecordDataInfo {
    if (!dataSource) {
        dataSource = [NSMutableArray array];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.redpackID forKey:@"game_id"];
    [params setValue:[AppDelegate appDelegate].userModel.token forKey:@"token"];
    [[RootHttpHelper httpHelper] achieveCommonGetURL:@"roomRedpackage/rank" andController:nil andView:self andParams:params andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue] == 200) {
            [dataSource removeAllObjects];
            NSArray *tempArr = successData[@"data"];
            for (int i = 0; i < tempArr.count; i++) {
//                RedPackItemsModel *model = [[RedPackItemsModel alloc] initWithDictionary:tempArr[i] error:nil];
                [dataSource addObject:tempArr[i]];
            }
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - TableView的代理方法
#pragma mark - 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

#pragma mark - 每个Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


#pragma mark - 初始化Cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RedPackRecordCell * cell = [RedPackRecordCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *model = dataSource[indexPath.item];
    cell.nickname.text = model[@"nickname"];
    [cell.avatar sd_setImageWithURL:[BaseViewController placeImg2:model[@"avatar"]]];
    cell.money.text = model[@"money"];
    if (indexPath.item == 0) {
        cell.bestTip.hidden = NO;
    } else {
        cell.bestTip.hidden = YES;
    }
    return cell;
}

@end

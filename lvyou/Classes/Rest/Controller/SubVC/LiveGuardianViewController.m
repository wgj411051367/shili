// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveGuardianViewController.m
//  beibei
//
//  Created by dev on 16/8/2.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "LiveGuardianViewController.h"
#import "LiveGuardianCell.h"
#import "RankPeopleModel.h"
/*
   管理员页面
 */
@interface LiveGuardianViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    LiveGuardListModel *liveGuardListModel;
    
    LiveGuardModel *liveGuardModel;
    
    RankPeopleModel *rankPeopleModel;
}
@end

@implementation LiveGuardianViewController
@synthesize
table,
barView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 显示导航条
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - View从superView中移除时
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 隐藏导航条
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 初始化界面
-(void)initView
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    barView.backgroundColor = colorHead;
    
    //初始化TableView
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    table.separatorStyle = UITableViewScrollPositionNone;
    table.showsVerticalScrollIndicator = NO;
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
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
    return _guardLists.count;
}

#pragma mark - 每个Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57.0;
}

#pragma mark - 初始化Cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveGuardianCell * rCell = [LiveGuardianCell cellWithTableView:tableView];
    
    [self configBlackListCell:rCell atIndexPath:indexPath];
    
    return rCell;
}

#pragma mark - 设置Cell内容
-(void)configBlackListCell:(LiveGuardianCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    liveGuardListModel = [_guardLists objectAtIndex:indexPath.row];
    liveGuardModel = liveGuardListModel.guard;
    
    //判断头像的avatar是不是全路径
    if([[ToolHelper toolHelper] ReplacingCharActer:liveGuardModel.avatar]){
        
        [cell.headImg sd_setImageWithURL:[self placeCorpsImg:liveGuardModel.avatar] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
    }else{
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEAPI,liveGuardModel.avatar]] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
    }
    
    cell.name.text = liveGuardModel.nickname;
    if([liveGuardModel.gender isEqualToString:@"0"]){
        
        [cell.sex setImage:[UIImage imageNamed:@"icon_live_sex"]];
    }else{
        
        [cell.sex setImage:[UIImage imageNamed:@"icon_live_sex_boy"]];
    }
    //2018.10.31显示等级
    [self showThelevel:liveGuardModel.rank_id and:cell.level and:cell.levelLabel isZhuBo:NO];
    [cell.cancel setImage:[UIImage imageNamed:@"icon_liveguard_cancel"]];
    cell.cancelBtn.tag = indexPath.row;
    
    [cell.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"++++++++++++点击的是第: %ld",(long)indexPath.row);
}

#pragma mark - 取消管理员操作
- (void)cancelBtnAction:(UIButton *)sender
{
    NSLog(@"+++++++++++++取消管理员操作");
    liveGuardListModel = [_guardLists objectAtIndex:sender.tag];
    //调用取消管理员的接口
    [[RootHttpHelper httpHelper] achieveCommonPostURL:[NSString stringWithFormat:@"live/%@/guard/%@",_beginLiveModel.anchor.haoma,liveGuardListModel.guard.id] andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        
        NSLog(@"+++++++++++++请求到的数据调用取消管理员的接口: %@",successData);
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        if(code == 200)
        {
            [[MessageHelper messageHelper] showSuccessMessage:self title:@"" sub:@"取消管理员成功!"];
        }
        else
        {
            [[MessageHelper messageHelper] showSuccessMessage:self title:@"" sub:[successData objectForKey:@"api_msg"]];
        }
        [self showGuardList];
    }];
}

#pragma mark - 展示管理员列表
- (void)showGuardList
{
    //获取场控列表
    [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"%@%@%@",liveGuardForepart,_beginLiveModel.anchor.haoma ,liveGuardHeel] andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        
        NSLog(@"+++++++++++++请求到的数据showGuardList: %@",successData);
        [_guardLists removeAllObjects];
        for (NSMutableDictionary * model in [successData objectForKey:@"data"])
        {
            NSError *err = nil;
            liveGuardListModel = [[LiveGuardListModel alloc] initWithDictionary:model error:&err];
            [_guardLists addObject:liveGuardListModel];
        }
        [table reloadData];
    }];
}

#pragma mark - 返回按键
- (IBAction)blackBtnAction:(UIButton *)sender
{
    NSLog(@"+++++++++++++返回按键");
    [self closeVC];
}

@end

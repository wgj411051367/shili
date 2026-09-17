// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveContributionViewController.m
//
//
//  Created by dev on 16/8/23.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "LiveContributionViewController.h"
#import "BangDanViewCell.h"
#import "UserListView.h"
#import "RankingLiistModel.h"
#import "RankPeopleModel.h"
@interface LiveContributionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isZhubo;
    RankingLiistModel *rankingListModel;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong,nonatomic)UITableView *table;
@property (strong,nonatomic)UserListView *userHeadView;
@property (strong,nonatomic)NSString *dataUrl;
@property (strong,nonatomic)NSString *typeName;

@end

@implementation LiveContributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化界面
    [self initView];
}
#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
#pragma mark - View从superView中移除时
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - 初始化页面
- (void)initView
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    self.navHeight.constant = NavigationBar_HEIGHT;
    self.titleLab.text=self.navigationItem.title;
    self.backView.backgroundColor = colorHead;
//    [self setCAGradientLayer:self.backView];
    [self.dayView setBackgroundColor:RGBACOLOR(255, 255, 255, 0.45)];
    
    isZhubo=NO;
    self.typeName=@"this_turn";
    self.dataUrl=[NSString stringWithFormat:@"%@",rankinglist_person];
    [self loadLiveData];
    if (@available(iOS 11.0, *)){
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.table];
    
    
    
}
- (void)setCAGradientLayer:(UIView *)view
{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = view.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1.12, 0.98);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:72/255.0 green:207/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:34/255.0 green:162/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [view.layer insertSublayer:gl atIndex:0];
}

- (IBAction)backBtnAction:(id)sender {
    [self dismiss];
}

- (IBAction)changeList:(UIButton *)sender
{
    switch (sender.tag) {
        case 3000:
        {
            [self dayListType];
        }
            break;
        case 3001:
        {
            [self weekListType];
        }
            break;
        case 3003:
        {
            [self monthListType];
        }
            break;
//        case 3003:
//        {
//            [self totalListType];
//        }
//            break;
        default:
            break;
    }
}

- (UserListView *)userHeadView
{
    if (!_userHeadView)
    {
        _userHeadView=[[NSBundle mainBundle] loadNibNamed:@"UserListView" owner:self options:nil].lastObject;
        __weak typeof(self) weakSelf = self;
        _userHeadView.firstAvatarClick = ^(NSInteger id, BOOL type) {
            if (weakSelf.dataArray.count>0) {
                RankingLiistModel *ranklist=weakSelf.dataArray[0];
                UserInfoModel *personModel;
                personModel= [[UserInfoModel alloc]initWithDictionary:ranklist.consumer error:nil];
                [weakSelf pushToHomePage:personModel];
            }
        };
        _userHeadView.secondAvatarClick= ^(NSInteger id, BOOL type) {
            if (weakSelf.dataArray.count>1) {
                RankingLiistModel *ranklist=weakSelf.dataArray[1];
                UserInfoModel *personModel;
                personModel= [[UserInfoModel alloc]initWithDictionary:ranklist.consumer error:nil];
                [weakSelf pushToHomePage:personModel];
            }
        };
        _userHeadView.threeAvatarClick = ^(NSInteger id, BOOL type) {
            if (weakSelf.dataArray.count>2) {
                RankingLiistModel *ranklist=weakSelf.dataArray[2];
                UserInfoModel *personModel;
                personModel= [[UserInfoModel alloc]initWithDictionary:ranklist.consumer error:nil];
                [weakSelf pushToHomePage:personModel];
            }
        };
        _userHeadView.firstAttentionClick = ^(UIButton *btn) {
            [weakSelf attention:btn];
        };
        _userHeadView.secondAttentionClick = ^(UIButton *btn) {
            [weakSelf attention:btn];
        };
        _userHeadView.threeAttentionClick = ^(UIButton *btn) {
            [weakSelf attention:btn];
        };
    }
    return _userHeadView;
}
- (void)dayListType
{
    [self.dayView setBackgroundColor:RGBACOLOR(255, 255, 255, 0.45)];
    self.weekView.backgroundColor=[UIColor clearColor];
    self.monthView.backgroundColor=[UIColor clearColor];
    self.totalView.backgroundColor=[UIColor clearColor];
    self.typeName=@"this_turn";
    isZhubo=NO;
    [self loadLiveData];
}
- (void)weekListType
{
    self.dayView.backgroundColor=[UIColor clearColor];
    self.weekView.backgroundColor=RGBACOLOR(255, 255, 255, 0.45);
    self.monthView.backgroundColor=[UIColor clearColor];
    self.totalView.backgroundColor=[UIColor clearColor];
    self.typeName=@"last_turn";
    isZhubo=NO;
    [self loadLiveData];
}
- (void)monthListType
{
    self.dayView.backgroundColor=[UIColor clearColor];
    self.weekView.backgroundColor=[UIColor clearColor];
    self.monthView.backgroundColor=RGBACOLOR(255, 255, 255, 0.45);
    self.totalView.backgroundColor=[UIColor clearColor];
    self.typeName=@"this_month";
    isZhubo=NO;
    [self loadLiveData];
}

- (void)totalListType
{
    self.dayView.backgroundColor=[UIColor clearColor];
    self.weekView.backgroundColor=[UIColor clearColor];
    self.monthView.backgroundColor=[UIColor clearColor];
    self.totalView.backgroundColor=RGBACOLOR(255, 255, 255, 0.45);
    self.typeName=@"total";
    isZhubo=NO;
    [self loadLiveData];
}
- (UITableView *)table
{
    if (!_table)
    {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navHeight.constant+40, SCREEN_WIDTH, SCREEN_HEIGHT-(self.navHeight.constant+40)) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.estimatedRowHeight = 0;
        _table.estimatedSectionHeaderHeight = 0;
        _table.estimatedSectionFooterHeight = 0;
        _table.separatorStyle = UITableViewScrollPositionNone;
        _table.showsVerticalScrollIndicator = NO;
        _table.backgroundColor = [UIColor clearColor];
        _table.tableHeaderView=self.userHeadView;
        //调用刷新方法
        [self setupRefresh];
    }
    return _table;
}
#pragma mark - 上拉和下拉刷新
#pragma mark-自定义刷新方法
- (void)setupRefresh
{
    __weak typeof(self) weakself = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求数据
        [weakself loadLiveData];
        [weakself.table.mj_header endRefreshing];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _table.mj_header = header;
    //设置文字
    [header setTitle:headerPullToRefreshText forState:MJRefreshStateIdle];
    [header setTitle:headerReleaseToRefreshText forState:MJRefreshStatePulling];
    [header setTitle:headerRefreshingText forState:MJRefreshStateRefreshing];
}

#pragma mark - 贡献榜
- (void)loadLiveData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"num":@"100",@"page":[NSString stringWithFormat:@"%d",0],@"type":self.typeName}];
    if (![self isBlankString:self.userId]) {
        [params setObject:self.userId forKey:@"id"];
    }
    [[RootHttpHelper httpHelper] achieveCommonGetURL:self.dataUrl andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        NSMutableArray *tempArr=[[NSMutableArray alloc]initWithArray:[successData objectForKey:@"data"]];
        [_dataArray removeAllObjects];
        if(code == 200)
        {
           if (![successData[@"data"]isKindOfClass:[NSNull class]]) {
             for (NSDictionary *dic in tempArr)
             {
                rankingListModel=[[RankingLiistModel alloc]initWithDictionary:dic error:nil];
                [_dataArray addObject:rankingListModel];
             }
               if (_dataArray.count>0) {
                   _table.backgroundColor = [UIColor whiteColor];
               }
               else{
                   _table.backgroundColor = [UIColor clearColor];
               }
           }
        }
        [_userHeadView setUserInfo:_dataArray andType:isZhubo];
        [_table reloadData];
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
    if (_dataArray.count >= 3)
    {
        return _dataArray.count - 3;
    }
    else
    {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
#pragma mark - 初始化Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BangDanViewCell * rCell = [BangDanViewCell cellWithTableView:tableView];
    rCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //10.16 添加判断
    if (indexPath.row<self.dataArray.count+3)
    {
        rCell.attentionBtn.tag=indexPath.row+3;
        [rCell.attentionBtn addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
        [rCell setCellAtIndexPath:indexPath andArr:self.dataArray andType:isZhubo];
    }
    return rCell;
}
#pragma mark - Cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RankingLiistModel *rankingLiistModel = self.dataArray[indexPath.row+3];
    if (indexPath.row<_dataArray.count) //row的个数小于数组个数
    {
        UserInfoModel *personModel;
        personModel= [[UserInfoModel alloc]initWithDictionary:rankingLiistModel.consumer error:nil];
        [self pushToHomePage:personModel];
    }
}
- (void)pushToHomePage:(UserInfoModel *)model
{
    

}

#pragma mark - 关注点击事件
- (void)attention:(UIButton *)sender
{
    if (_dataArray.count > sender.tag) {
        rankingListModel = _dataArray[sender.tag];
        UserInfoModel *personModel = [[UserInfoModel alloc]initWithDictionary:rankingListModel.consumer error:nil];
        if([personModel.is_follow isEqualToString:@"0"])  //未关注
        {
            [[RootHttpHelper httpHelper] achieveCommonPostURL:[NSString stringWithFormat:@"follow/%@",personModel.id] andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
                if ([[successData objectForKey:@"api_code"] integerValue] == 200)
                {
                    [self setFollowListIsRemove:NO andUserid:personModel.id];
                    [[MessageHelper messageHelper] showSuccessMessage:self title:@"关注成功" sub:nil];
                    [self loadLiveData];
                }
            }];
        }
        else
        {
            //已关注.点击按钮取消关注
            [[RootHttpHelper httpHelper] achieveCommonPostURL:[NSString stringWithFormat:@"unfollow/%@",personModel.id] andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
                if ([[successData objectForKey:@"api_code"] integerValue] == 200)
                {
                    [self setFollowListIsRemove:NO andUserid:personModel.id];
                    [[MessageHelper messageHelper] showMessage:self title:@"取消关注成功" sub:nil];
                    [self loadLiveData];
                }
            }];
        }
    }
}
- (void)dealloc
{
    NSLog(@"LiveContributionViewController dealloc");
}

@end

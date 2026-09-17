// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveHotListViewController.m
//  beibei
//
//  Created by dev on 16/6/27.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "LiveHotListViewController.h"
#import "LiveHotCell.h"
#import "RootHttpHelper.h"
#import "AppDelegate.h"
#import "SDWebImage.h"
#import "Constants.h"
#import "MBProgressHUD.h"

#import "GameAudienceViewController.h"
#import "shili-Swift.h"
#import "BannerModel.h"
#import "RankPeopleModel.h"
#import "QDCollectionView.h"
#import "shili-Swift.h"

#import "HotRocketView.h"
#import "RecommendView.h"
#import "HotTitleView.h"
/**
 *  直播热门页面
 **/
@interface LiveHotListViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    //轮播图片
    SDCycleScrollView *bannerScrol;
    NSMutableArray *bannerArr;
    NSMutableArray *bannerModelArr;
    UIView *bannerView;
    //分页
    int page;
    AnchorModel * anchorModel;
    BannerModel *bannerModel;
    //8.15 头视图
    UIView *headView;
    //印象标签
    NSMutableDictionary *yinxiangDic;
    //2.28banner图下边的标签
    UIScrollView *tagScroll,*backScroll;
    //game
    UIView *gameView,*gameback;
    UIImageView *gameimage;
    UIButton *gamebtn;
    UILabel *gametitle;
    UIScrollView *gameScroll;
    NSMutableArray *gameArr;
    //火箭推荐
    UIView *line;
    UIView *xianjieView;
    UIImageView *rocketimg;
    UILabel *rocketLab;
    UILabel *firstName,*secondName,*threeName,*fourName,*fiveName,*sixName;
    UIImageView *firstImg,*secondImg,*threeImg,*fourImg,*fiveImg,*sixImg;
    UILabel *firstLocation,*secondLocation,*threeLocation,*fourLocation,*fiveLocation,*sixLocation;
    UIButton *firstPeople,*secondPeople,*threePeople,*fourPeople,*fivePeople,*sixPeople;
    UIImageView *firstBack,*secondBack,*threeBack,*fourBack,*fiveBack,*sixBack;
    UIImageView *firstYingXiang,*secondYingXiang,*threeYingXiang,*fourYingXiang,*fiveYingXiang,*sixYingXiang;
    UIImageView *firstYingXiang1,*secondYingXiang1,*threeYingXiang1,*fourYingXiang1,*fiveYingXiang1,*sixYingXiang1;
    UIButton *firstLive,*secondLive,*threeLive,*fourLive,*fiveLive,*sixLive;
    //热门推荐
    UIView *hotView,*linetwo;
    UIImageView *hotImg;
    UIButton *changeBtn;
    UILabel *hotLab;
    //2018.3.12
    NSTimer *requestTimer;
    NSInteger currenttime;
    
    UIView *noticeView;//公告
    UILabel *noticeLab;
    NSString *notice,*noticeurl;
    
    UIView *backTopView; // 顶部底图
    HotRocketView *rocketView;
    RecommendView *recommendView;
    HotTitleView *titleView;

    BOOL isPause;
    NSInteger danmuInteger;
    
    NSInteger againCount;//  轮回次数
    NSString *pageNum; // 一次刷新多少个数据
    
    
}
@property(assign)BOOL canScroll;
@property(assign)NSInteger viewID;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) UITableView *table;
@property(nonatomic,strong)NSMutableArray <AnchorModel *>*liveDataArray;
@property(nonatomic,strong)NSMutableArray <AnchorModel *>*templiveDataArray1;
@property(nonatomic,strong)NSMutableArray <AnchorModel *>*templiveDataArray2;
@property(nonatomic,strong)NSMutableArray *touTiaoDataArray;
@property(nonatomic,strong)NSMutableArray *xianjieDataArray;
@property(nonatomic,strong)NSMutableArray *recommednArray;

@property (nonatomic, strong) NSTimer *recommendTimer;

@end

@implementation LiveHotListViewController
@synthesize
rect;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _viewID=0;
    //2017.12.18 请求数据
    [self loadLiveData];
    [self initBannerView];
    NSString *time=[[NSUserDefaults standardUserDefaults]objectForKey:@"time"];
    NSString *checktime=[[NSUserDefaults standardUserDefaults]objectForKey:@"checktime"];
    int checkTime=[checktime intValue];
    //BOOL check=[[NSUserDefaults standardUserDefaults]boolForKey:@"check"];
    if (SharedAppDelegate.needCheck){
        //说明是第一次启动
        SharedAppDelegate.needCheck=NO;
        if(checkTime<2){
            checkTime++;
            [[NSUserDefaults standardUserDefaults] setValue:time forKey:@"time"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",checkTime] forKey:@"checktime"];
            [[NSUserDefaults standardUserDefaults] setBool:SharedAppDelegate.needCheck forKey:@"check"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[self requestSignData];
            });
        }
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //2018.4.4推到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //回到前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
//    [self createTimer];
    
    
}
- (void)createTimer
{
    currenttime=kRefreshWithNewaTimeInterval;
    requestTimer = [NSTimer pltScheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeReduce) userInfo:nil];
}
- (void)timeReduce
{
    if (currenttime==0)
    {
        if (requestTimer!=nil)
        {
            [requestTimer invalidate];
            requestTimer = nil;
        }
        [self createTimer];
        [self loadLiveData];
    }
    currenttime--;
}
#pragma mark HOME回到后台
- (void)applicationDidEnterBackground:(UIApplication *)application{
    if (requestTimer!=nil)
    {
        [requestTimer invalidate];
        requestTimer = nil;
    }
}
#pragma mark 回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    [self createTimer];
    [self loadLiveData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (requestTimer!=nil)
    {
        [requestTimer invalidate];
        requestTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 主播标签（tag）列表
- (void)requestTouTiaoData
{
    [self requestGuiZuRecommendData];
    if (!_touTiaoDataArray) {
        _touTiaoDataArray = [NSMutableArray array];
    } else {
        [_touTiaoDataArray removeAllObjects];
    }
    if (!_xianjieDataArray) {
        _xianjieDataArray = [NSMutableArray array];
    } else {
        [_xianjieDataArray removeAllObjects];
    }
    NSString *requesturl=[NSString stringWithFormat:@"%@%@/%@?page=0&num=3",DATAAPI,APIVersion,toutiao];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:requesturl andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        
        if ([successData[@"api_code"] integerValue]==200)
        {
            NSArray *tempArray = [successData objectForKey:@"data"];
            for (int i = 0; i < tempArray.count; i++) {
                NSError *err = nil;
                AnchorModel* anchor = [[AnchorModel alloc] initWithDictionary:tempArray[i] error:&err];
                [_touTiaoDataArray addObject:anchor];
            }
        }
        //初始化Banner
        [self initBannerView];
    }];
}

- (void)requestGuiZuRecommendData {
    if (!_recommednArray) {
        _recommednArray = [NSMutableArray array];
    }
    NSString *requesturl=[NSString stringWithFormat:@"%@%@/%@?page=0&num=10",DATAAPI,@"v4",@"guizhu/recommendList"];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:requesturl andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        
        if ([successData[@"api_code"] integerValue]==200)
        {
            [_recommednArray removeAllObjects];
            NSArray *tempArray = [successData objectForKey:@"data"];
            for (int i = 0; i < tempArray.count; i++) {
                NSError *err = nil;
                
                AnchorModel* anchor = [[AnchorModel alloc] initWithDictionary:tempArray[i] error:&err];
                [_recommednArray addObject:anchor];
            }
            if (recommendView) {
                [recommendView continueTimer];
            }
        }
        //初始化Banner
        [self initBannerView];
    }];
}

#pragma mark - 控制器的view将要布局子控件
- (void)viewWillLayoutSubviews
{
    self.view.frame = rect;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (recommendView) {
        [recommendView continueTimer];
    }
    self.navigationController.navigationBar.barTintColor = [UIColor gradientColorImageFromColors:colorNavColor gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(SCREEN_WIDTH, NavigationBar_HEIGHT)];
    //    [self initNoticeView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (recommendView) {
        [recommendView pauseTimer];
    }
}
- (UITableView *)table
{
    if (!_table)
    {
        _viewID=1;
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TabBar_HEIGHT-NavigationBar_HEIGHT) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor clearColor];
        _table.delegate = self;
        _table.dataSource = self;
        _table.estimatedRowHeight = 0;
        _table.estimatedSectionHeaderHeight = 0;
        _table.estimatedSectionFooterHeight = 0;
        _table.separatorStyle = UITableViewScrollPositionNone;
        _table.showsVerticalScrollIndicator = NO;
        _table.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //调用刷新方法
        [self setupRefresh];
    }
    return _table;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {   _viewID=0;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-19)/2, (SCREEN_WIDTH-19)/2);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(0, 7, 0, 7);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- TabBar_HEIGHT - NavigationBar_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        //        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        //注册cell
        [_collectionView registerClass:[QDCollectionView class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [self setupRefresh];
    }
    return _collectionView;
}
- (void)getJinGangData
{
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@/%@",DATAAPI,APIVersion,ADbanner];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:requestUrl andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue]==200) {
            NSMutableArray *data = [[NSMutableArray alloc]initWithArray:[successData objectForKey:@"data"]];
            for (NSDictionary *dic in data)
            {
                bannerModel = [[BannerModel alloc]initWithDictionary:dic error:nil];
                [gameArr addObject:bannerModel];
            }
        }
    }];
}
#pragma mark - 请求BannerDate
- (void)getBannerDate
{
    bannerModelArr = [[NSMutableArray alloc] init];
    bannerArr = [NSMutableArray array];
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@/%@",DATAAPI,APIVersion,@"adbanner"];//
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:requestUrl andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue]==200) {
            NSMutableArray *data = [[NSMutableArray alloc]initWithArray:[successData objectForKey:@"data"]];
            for (NSDictionary *dic in data)
            {
                bannerModel = [[BannerModel alloc]initWithDictionary:dic error:nil];
                [bannerArr addObject:[NSString stringWithFormat:@"%@%@",IMAGEAPI,bannerModel.banner]];
                [bannerModelArr addObject:bannerModel];
            }
            notice=successData[@"notice"];
            noticeurl=successData[@"noticeurl"];
            [[NSUserDefaults standardUserDefaults]setObject:notice forKey:@"notice"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        [self requestTouTiaoData];
        //初始化Banner
        [self initBannerView];
    }];
}

#pragma mark - 初始化Banner
- (void)initBannerView
{

    if (!headView) {
        //8.15 头视图
        headView=[[UIView alloc] init];
        headView.backgroundColor=[UIColor clearColor];
    }

    if (!rocketView) {
        rocketView = [[NSBundle mainBundle]loadNibNamed:@"HotRocketView" owner:nil options:nil].firstObject;
        __weak typeof(self) weakself = self;
        rocketView.hotTopClick = ^(NSInteger index) {
            if (index >= weakself.touTiaoDataArray.count) {
                return;
            }
            AnchorModel *anch = weakself.touTiaoDataArray[index];
            [weakself joinLiveRoomWithModel:anch];
        };
        [headView addSubview:rocketView];
    }
    
    rocketView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 155*ScreenBiLi);
    [rocketView uploadData:_touTiaoDataArray];
    
    if (!recommendView) {
        recommendView = [[NSBundle mainBundle]loadNibNamed:@"RecommendView" owner:nil options:nil].firstObject;
        __weak typeof(self) weakself = self;
        recommendView.recommendClick = ^(AnchorModel * _Nonnull model) {
            [weakself joinLiveRoomWithModel:model];
        };
        recommendView.hotMoreClick = ^{
            if (weakself.gotoRecommend) {
                weakself.gotoRecommend(1);
            }
        };
        [headView addSubview:recommendView];
    }
    
    recommendView.frame = CGRectMake(0, rocketView.height, SCREEN_WIDTH, 155*ScreenBiLi);
    
    NSMutableArray *array = [NSMutableArray array];
    if (_recommednArray.count > 4) {
        for (int i = 0; i < 10000; i++) {
            [array addObjectsFromArray:_recommednArray];
        }
        [recommendView uploadData:array];
    } else if (_recommednArray.count > 3) {
        AnchorModel *model = [[AnchorModel alloc] init];
        model.id = @"-99999";
        model.placeholder_img = @"icon_recommend_placeholder_5";
        [_recommednArray addObject:model];
        for (int i = 0; i < 10000; i++) {
            [array addObjectsFromArray:_recommednArray];
        }
        [recommendView uploadData:array];
    } else if (_recommednArray.count > 2) {
        for (int i = 5; i > 3; i--) {
            AnchorModel *model = [[AnchorModel alloc] init];
            model.id = @"-99999";
            model.placeholder_img = [NSString stringWithFormat:@"icon_recommend_placeholder_%d",i];
            [_recommednArray addObject:model];
        }
        for (int i = 0; i < 10000; i++) {
            [array addObjectsFromArray:_recommednArray];
        }
        [recommendView uploadData:array];
    } else if (_recommednArray.count > 1) {
        for (int i = 5; i > 2; i--) {
            AnchorModel *model = [[AnchorModel alloc] init];
            model.id = @"-99999";
            model.placeholder_img = [NSString stringWithFormat:@"icon_recommend_placeholder_%d",i];
            [_recommednArray addObject:model];
        }
        for (int i = 0; i < 10000; i++) {
            [array addObjectsFromArray:_recommednArray];
        }
        [recommendView uploadData:array];
    } else if (_recommednArray.count > 0) {
        for (int i = 5; i > 1; i--) {
            AnchorModel *model = [[AnchorModel alloc] init];
            model.id = @"-99999";
            model.placeholder_img = [NSString stringWithFormat:@"icon_recommend_placeholder_%d",i];
            [_recommednArray addObject:model];
        }
        for (int i = 0; i < 10000; i++) {
            [array addObjectsFromArray:_recommednArray];
        }
        [recommendView uploadData:array];
    } else if (_recommednArray.count == 0) {
        for (int i = 5; i > 0; i--) {
             AnchorModel *model = [[AnchorModel alloc] init];
             model.id = @"-99999";
             model.placeholder_img = [NSString stringWithFormat:@"icon_recommend_placeholder_%d",i];
             [_recommednArray addObject:model];
        }
        for (int i = 0; i < 10000; i++) {
            [array addObjectsFromArray:_recommednArray];
        }
        [recommendView uploadData:array];
    }
    
    //轮播图
    if (bannerView==nil) {
        bannerView = [[UIView alloc] init];
        bannerView.backgroundColor = [UIColor clearColor];
        [headView addSubview:bannerView];
    }
    if (bannerArr.count <= 0) {
        bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);//此客户首页轮播图片比例是750：200
    } else {
        bannerView.frame=CGRectMake(7*ScreenBiLi,13*ScreenBiLi+rocketView.height+recommendView.height, SCREEN_WIDTH - (7*ScreenBiLi)*2, 130*ScreenBiLi);//此客户首页轮播图片比例是750：200
        if (!bannerScrol) {
            bannerScrol = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, bannerView.bounds.size.width, bannerView.bounds.size.height) imageNamesGroup:bannerArr];
            bannerScrol.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
            bannerScrol.backgroundColor = [UIColor whiteColor];
            bannerScrol.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
            bannerScrol.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            bannerScrol.autoScroll = YES;
            bannerScrol.placeholderImage = [UIImage imageNamed:@"record_placeholder"];
            bannerScrol.delegate = self;
            bannerScrol.autoScrollTimeInterval = 5;
            bannerScrol.hidesForSinglePage = YES;
            bannerScrol.pageControlDotSize = CGSizeMake(8, 8);
            bannerScrol.currentPageDotColor = colorHead;
            bannerScrol.pageDotColor = [UIColor whiteColor];
            bannerScrol.layer.cornerRadius = 6;
            bannerScrol.layer.masksToBounds = YES;
            //        bannerScrol.layer.
            [bannerView addSubview:bannerScrol];
        } else {
            bannerScrol.imageURLStringsGroup = bannerArr;
        }
    }
    
    
    if (!titleView) {
        titleView = [[NSBundle mainBundle]loadNibNamed:@"HotTitleView" owner:nil options:nil].firstObject;
        [headView addSubview:titleView];
    }
    if (_liveDataArray.count == 0) {
        titleView.frame = CGRectMake(0, rocketView.height+recommendView.height+bannerView.height+(bannerView.height>0?13*ScreenBiLi:0), SCREEN_WIDTH, 0);
    } else {
        titleView.frame = CGRectMake(0, rocketView.height+recommendView.height+bannerView.height+(bannerView.height>0?13*ScreenBiLi:0), SCREEN_WIDTH,38*ScreenBiLi);
    }
    
    headView.frame=CGRectMake(0, 0, SCREEN_WIDTH, rocketView.height+recommendView.height+bannerView.height+(bannerView.height>0?13*ScreenBiLi:0)+(titleView.height>0?titleView.height:15*ScreenBiLi));
    
    if (!_collectionView) {
        if (@available(iOS 11.0, *)){
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.collectionView addSubview:headView];
        [self.view addSubview:self.collectionView];
    } else {
        [self.collectionView reloadData];
    }
//
//    else if(_viewID==1)
//    {
//        if (@available(iOS 11.0, *)) {
//            _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }
//        else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
//        self.table.tableHeaderView=headView;
//        [self.view addSubview:self.table];
//    }
}

// 帝皇推荐定时刷新3秒
- (void)recommendChange {
    
    if (_liveDataArray.count <= 3) {
        return;
    }
    NSMutableArray *temp = [NSMutableArray array];
    temp = [_recommednArray mutableCopy];
    
    AnchorModel *model1 = temp[0];
    AnchorModel *model2 = temp[1];
    AnchorModel *model3 = temp[2];
    
    [_recommednArray removeObjectsInRange:NSMakeRange(0, 3)];
    [_recommednArray addObject:model1];
    [_recommednArray addObject:model2];
    [_recommednArray addObject:model3];
    
    [recommendView uploadData:_recommednArray];
    
}

// 暂停定时
- (void)pauseRecommendChange {
    isPause = YES;
    [self.recommendTimer setFireDate:[NSDate distantFuture]];
}

//继续计时
-(void)continueTimer {
    isPause = NO;
    [self.recommendTimer setFireDate:[NSDate distantPast]];
}
- (void)initGameTagView
{
    if (gameScroll) { //3.9
        [gameScroll removeFromSuperview];
        gameScroll=nil;
    }
    if (gameScroll==nil) {
        gameScroll=[[UIScrollView alloc] init];
    }
    if (gameArr.count <= 0) {
        gameScroll.frame = CGRectMake(0, bannerView.frame.size.height + bannerView.frame.origin.y +noticeView.frame.size.height+tagScroll.frame.size.height+ 4 * ScreenBiLi, SCREEN_WIDTH, 0);
    }
    else
    {
        gameScroll.frame = CGRectMake(0, bannerView.frame.size.height + bannerView.frame.origin.y +noticeView.frame.size.height+tagScroll.frame.size.height+ 4* ScreenBiLi, SCREEN_WIDTH, 80 * ScreenBiLi);
    }
    //广告图下边的view
    gameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gameArr.count* (SCREEN_WIDTH / 5), 80 * ScreenBiLi)];
    gameScroll.backgroundColor = [UIColor whiteColor];
    gameScroll.contentSize = CGSizeMake(gameArr.count * (SCREEN_WIDTH / 5), 80 * ScreenBiLi);
    for (int i = 0; i < gameArr.count; i++)
    {
        int row = i/(gameArr.count) ; // 决定y
        //        计算列号：
        int col = i % (gameArr.count); // 决定x
        int margin = 0 * ScreenBiLi;//间隙
        int width = SCREEN_WIDTH/5;//格子的宽
        int height = SCREEN_WIDTH/5;//格子的高
        BannerModel  *bannerM = gameArr[i];
        gameback = [[UIView alloc] initWithFrame:CGRectMake(16 * ScreenBiLi + col * (width+margin),22 * ScreenBiLi + row * (height+margin), width, height)];
        [self createGameTagView];
        [gameimage sd_setImageWithURL:[self placeImg:[NSString stringWithFormat:@"%@",bannerM.banner]]placeholderImage:[UIImage imageNamed:placeCoverImage]];
        gamebtn.tag = i;
        [gamebtn addTarget:self action:@selector(gameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        gametitle.text = bannerM.title;
        gametitle.textColor=[UIColor blackColor];
        [gameView addSubview:gameback];
    }
    gameScroll.showsVerticalScrollIndicator = NO;
    gameScroll.showsHorizontalScrollIndicator = NO;
    gameScroll.scrollEnabled = YES;
    [gameScroll addSubview:gameView];
    [headView addSubview:gameScroll];
}
#pragma mark -  创建按钮  ------------------------------
- (void)createGameTagView
{
    //按钮
    gamebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gamebtn.bounds = CGRectMake(0, 0, 40*ScreenBiLi, 40 * ScreenBiLi);
    gamebtn.center = CGPointMake((gameback.frame.size.width-40 * ScreenBiLi) / 2, 10 * ScreenBiLi);
    [gameback addSubview:gamebtn];
    gameimage = [[UIImageView alloc] init];
    gameimage.bounds = CGRectMake(0, 0, 40*ScreenBiLi, 40*ScreenBiLi);
    gameimage.center = CGPointMake((gameback.frame.size.width-40*ScreenBiLi)/2, 10*ScreenBiLi);
    gameimage.layer.cornerRadius = 20 * ScreenBiLi;
    gameimage.clipsToBounds = YES;
    [gameback addSubview:gameimage];
    //文字
    gametitle = [[UILabel alloc] init];
    gametitle.font = [UIFont systemFontOfSize:10.0f];
    gametitle.textAlignment = NSTextAlignmentCenter;
    gametitle.bounds = CGRectMake(0, 0, 60 * ScreenBiLi, 40 * ScreenBiLi);
    gametitle.center = CGPointMake((gameback.frame.size.width - 40 * ScreenBiLi)/2, gamebtn.frame.size.height+gamebtn.frame.origin.y+10*ScreenBiLi);
    [gameback addSubview:gametitle];
}
- (void)gameBtnClick:(UIButton *)sender
{
    if (gameArr.count>0) {
        bannerModel = gameArr[sender.tag];
        if ([bannerModel.app_open isEqualToString:@"webview"]) {
            [self pushToBannerWebWithLoadUrl:bannerModel.url withTitle:bannerModel.title andShareUrl:bannerModel.banner];
        }
        else if ([bannerModel.app_open isEqualToString:@"gameroom"]) {
            [self pushToLivingRoomWithRoomnumber:bannerModel.url];
        }
        else
        {
            [self pushToBrowserWithString:bannerModel.url];
        }
    }
}
- (void)pushToLivingRoomWithRoomnumber:(NSString *)number
{
    [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"users/detail/%@?type=roomnumber&platform=ios",number] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        if (successData==nil) {
            return;
        }
        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
        if(code == 200)
        {
            BeginLiveModel * beginLiveModel = [[BeginLiveModel alloc] init];
            beginLiveModel.anchor=[[UserInfoModel alloc]initWithDictionary:successData error:nil];
            GameAudienceViewController * viewerUserLive = [[GameAudienceViewController alloc] init];
            viewerUserLive.bottom_url=successData[@"bottom_url"];
            viewerUserLive.gamePush=YES;
            viewerUserLive.bottom_url_height=successData[@"bottom_url_height"];
            viewerUserLive.beginLiveModel = beginLiveModel;
            viewerUserLive.beginLiveModel.anchor.nickname=successData[@"nickname"];
            viewerUserLive.beginLiveModel.anchor.id=successData[@"id"];
            viewerUserLive.beginLiveModel.anchor.haoma=successData[@"haoma"];
            viewerUserLive.hidesBottomBarWhenPushed                     = YES;
            viewerUserLive.automaticallyAdjustsScrollViewInsets         = NO;
            [self.navigationController pushViewController:viewerUserLive animated:YES];
        }
    }];
}
- (void)initNoticeView
{
    if (noticeView) {
        [noticeView removeFromSuperview];
        noticeView=nil;
    }
    noticeView =[[UIView alloc] init];
    noticeView.backgroundColor=[UIColor whiteColor];
    if (![self isBlankString:notice]) {
        noticeView.frame=CGRectMake(0, bannerView.frame.size.height+bannerView.frame.origin.y+2*ScreenBiLi, SCREEN_WIDTH, Segment_HEIGHT);
        noticeView.userInteractionEnabled=YES;
        noticeView.backgroundColor=[UIColor whiteColor];
        UIImageView *noticeImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, (Segment_HEIGHT-18)/2, 20, 18)];
        noticeImg.image=[UIImage imageNamed:@"icon_notice"];
        [noticeView addSubview:noticeImg];
        
        UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-35, Segment_HEIGHT)];
        backview.backgroundColor=[UIColor clearColor];
        backview.clipsToBounds = YES;
        [noticeView addSubview:backview];
        
        noticeLab =[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, (Segment_HEIGHT-18)/2, 20, 18)];
        noticeLab.text=[NSString stringWithFormat:@"%@",notice];
        noticeLab.textAlignment=NSTextAlignmentLeft;
        noticeLab.textColor=[UIColor blackColor];
        noticeLab.userInteractionEnabled=YES;
        noticeLab.font=[UIFont systemFontOfSize:14.0f];
        [noticeLab sizeToFit];
        [backview addSubview:noticeLab];
        [self startAnimation];
        UIButton *noticeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        noticeBtn.frame=CGRectMake(0, 0, SCREEN_WIDTH, Segment_HEIGHT);
        noticeBtn.backgroundColor=[UIColor clearColor];
        [noticeBtn addTarget:self action:@selector(pushToNiticeVC) forControlEvents:UIControlEventTouchUpInside];
        [noticeView addSubview:noticeBtn];
    }
    [headView addSubview:noticeView];
}
- (void)pushToNiticeVC
{
    if (noticeurl!=nil) {
        [self pushToBannerWebWithLoadUrl:noticeurl withTitle:@"系统公告" andShareUrl:nil];
    }
}
- (void)startAnimation
{
    [UIView beginAnimations:@"Notice" context:NULL];
    [UIView setAnimationDuration:30.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:10000];
    CGRect frame = noticeLab.frame;
    frame.origin.x = -frame.size.width;
    noticeLab.frame = frame;
    [UIView commitAnimations];
}
#pragma mark -  创建按钮  ------------------------------
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //5.19
    if(bannerModelArr.count>0){
        bannerModel = bannerModelArr[index];
        if ([bannerModel.app_open isEqualToString:@"webview"]) {
            [self pushToBannerWebWithLoadUrl:bannerModel.url withTitle:bannerModel.title andShareUrl:bannerModel.banner];
        }
        else
        {
            [self pushToBrowserWithString:bannerModel.url];
        }
    }
}
- (void)pushToBrowserWithString:(NSString *)url
{
    if ([url containsString:@"?"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@&platform=ios",url,SharedAppDelegate.userModel.token]]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@&platform=ios",url,SharedAppDelegate.userModel.token]]];
    }
}


- (void)joinLiveRoomWithModel:(AnchorModel *)model
{
//    if ([self isBlankString:model.endtime])
//    {
        //4.26进入游戏直播房间
        BeginLiveModel * beginLiveModel = [[BeginLiveModel alloc] init];
        beginLiveModel.anchor=model.anchor;
        GameAudienceViewController * viewerUserLive = [[GameAudienceViewController alloc] init];
        viewerUserLive.beginLiveModel = beginLiveModel;
        if (![model.bottom_url isEqualToString:@""])
        {
            viewerUserLive.bottom_url=model.bottom_url;
        }
        else
        {
            viewerUserLive.bottom_url=@"";
        }
        if ([model.isphone isEqualToString:@"0"])//2018.9.21火箭位的主播是pc开播的
        {
            viewerUserLive.isPhone=YES;
        }
        viewerUserLive.bottom_url_height=model.bottom_url_height;
        viewerUserLive.hidesBottomBarWhenPushed                     = YES;
        viewerUserLive.automaticallyAdjustsScrollViewInsets         = NO;
        [self.navigationController pushViewController:viewerUserLive animated:YES];

}
- (void)initHotView
{
    if (hotView) {
        [hotView removeFromSuperview];
        hotView=nil;
    }
    if (hotView==nil)
    {
        hotView=[[UIView alloc] init];
        hotView.backgroundColor=[UIColor clearColor];
        hotView.frame=CGRectMake(0, bannerView.frame.origin.y+bannerView.frame.size.height+noticeView.frame.size.height+tagScroll.frame.size.height+gameScroll.frame.size.height+rocketView.frame.size.height+6*ScreenBiLi, SCREEN_WIDTH, 27*ScreenBiLi);
        [headView addSubview:hotView];
    }
    hotImg=[[UIImageView alloc] init];
    hotImg.frame=CGRectMake(12*ScreenBiLi, 5*ScreenBiLi, 17*ScreenBiLi, 17*ScreenBiLi);
    hotImg.image=[UIImage imageNamed:@"hotimg"];
    [hotView addSubview:hotImg];
    
    hotLab=[[UILabel alloc] initWithFrame:CGRectMake(hotImg.frame.origin.x+hotImg.frame.size.width+5*ScreenBiLi, 5*ScreenBiLi, 80*ScreenBiLi, 17*ScreenBiLi)];
    hotLab.text=@"热门推荐";
    hotLab.textColor=RGBACOLOR(102, 102, 102, 1);
    hotLab.textAlignment=NSTextAlignmentLeft;
    hotLab.font=[UIFont systemFontOfSize:12.0f];
    [hotView addSubview:hotLab];
    
    linetwo=[[UIView alloc] initWithFrame:CGRectMake(0, 26.5*ScreenBiLi, SCREEN_WIDTH, 0.5)];
    linetwo.backgroundColor=RGBACOLOR(216, 216, 216, 1);
    [hotView addSubview:linetwo];
    
    changeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame=CGRectMake(hotView.frame.size.width-65*ScreenBiLi, 2.5*ScreenBiLi, 60*ScreenBiLi, 22*ScreenBiLi);
    [changeBtn setTitle:@"大小图切换" forState:0];
    changeBtn.titleLabel.font=[UIFont systemFontOfSize:9.0f];
    [changeBtn setTitleColor:colorHead forState:0];
    changeBtn.layer.borderWidth=1;
    changeBtn.layer.borderColor=colorHead.CGColor;
    changeBtn.layer.cornerRadius=11*ScreenBiLi;
    changeBtn.layer.masksToBounds=YES;
    [changeBtn addTarget:self action:@selector(changeImageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [hotView addSubview:changeBtn];
}
- (void)changeImageBtnAction
{
    if(_viewID==0)
    {
        if (_collectionView) {
            [_collectionView removeFromSuperview];
        }
        _viewID=1;
        [self loadLiveData];
    }
    else if (_viewID==1)
    {
        if (_table) {
            [_table removeFromSuperview];
        }
        _viewID=0;
        [self loadLiveData];
    }
}

#pragma mark - 上拉和下拉刷新
#pragma mark-自定义刷新方法
- (void)setupRefresh
{
    __weak typeof(self) weakself = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求数据
        [weakself loadLiveData];
    }];
    if (_viewID==1) {
        _table.mj_header = header;
        //        _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //            //上拉加载执行方法
        //            [weakself loadMoreLiveData];
        //        }];
        //设置文字
        [header setTitle:headerPullToRefreshText forState:MJRefreshStateIdle];
        [header setTitle:headerReleaseToRefreshText forState:MJRefreshStatePulling];
        [header setTitle:headerRefreshingText forState:MJRefreshStateRefreshing];
    }else{
        _collectionView.mj_header = header;
        
        MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakself loadMoreLiveData];
        }];
        footer.triggerAutomaticallyRefreshPercent = -50;
        _collectionView.mj_footer = footer;
//        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            //上拉加载执行方法
//            [weakself loadMoreLiveData];
//        }];
        //设置文字
        [header setTitle:headerPullToRefreshText forState:MJRefreshStateIdle];
        [header setTitle:headerReleaseToRefreshText forState:MJRefreshStatePulling];
        [header setTitle:headerRefreshingText forState:MJRefreshStateRefreshing];
    }
}
#pragma mark - 下拉刷新执行方法
-(void)loadLiveData
{
    pageNum = @"30";
    againCount = 0;
    page = 0;
    if (recommendView) {
        [recommendView pauseTimer];
    }
    if (!_liveDataArray) {
        _liveDataArray = [NSMutableArray array];
    }
    if (!_templiveDataArray1) {
        _templiveDataArray1 = [NSMutableArray array];
    }
    if (!_templiveDataArray2) {
        _templiveDataArray2 = [NSMutableArray array];
    }
    NSString *requesturl=[NSString stringWithFormat:@"%@%@/%@",DATAAPI,APIVersion,@"live/list/hot"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"num":pageNum,@"platform":@"ios"}];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:requesturl andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
//        NSLog(@"successData = %@",successData);
        [_liveDataArray removeAllObjects];
        [_templiveDataArray1 removeAllObjects];
        [_templiveDataArray2 removeAllObjects];
        NSArray *tempArray = [successData objectForKey:@"data"];
        for (int i = 0; i < tempArray.count; i++) {
            NSError *err = nil;
            AnchorModel* anchor = [[AnchorModel alloc] initWithDictionary:tempArray[i] error:&err];
            [_liveDataArray addObject:anchor];
            if (i == tempArray.count -1) {
                page += 1;
            }
        }
        [self getBannerDate];
        if (_viewID==0){
            //[_collectionView.collectionViewLayout invalidateLayout];//4.3添加 在调用集合视图上的reloadData之前，尝试对布局无效
            [_collectionView reloadData];
            //停止顶部菊花
            [_collectionView.mj_header endRefreshing];
        }else
        {
            [_table reloadData];
            [_table.mj_header endRefreshing];
        }
    }];
}
#pragma mark - 上拉加载执行方法
-(void)loadMoreLiveData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":[NSString stringWithFormat:@"%d",page],@"num":pageNum,@"platform":@"ios"}];
    NSString *requesturl=[NSString stringWithFormat:@"%@%@/%@",DATAAPI,APIVersion,@"live/list/hot"];
    [[RootHttpHelper httpHelper] achieveCommonPostURL2:requesturl andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
        
        NSArray *tempArray = [successData objectForKey:@"data"];
        
        if (tempArray.count < [pageNum intValue]) {
            againCount += 1;
            
//            if (_templiveDataArray1.count == 0) {
//                _templiveDataArray1 = [_liveDataArray mutableCopy];
//            } else if (_templiveDataArray2.count == 0) {
//                _templiveDataArray2 = [[_liveDataArray subarrayWithRange:NSMakeRange(_templiveDataArray1.count, _liveDataArray.count - _templiveDataArray1.count)] mutableCopy];
//
//            }
            
            if (againCount >= 3) {
                againCount--;
                if (_liveDataArray.count > [pageNum intValue] * 3) {
                    [_liveDataArray removeObjectsInRange:NSMakeRange(0,tempArray.count)];
                    CGPoint point = _collectionView.contentOffset;
                    [_collectionView setContentOffset:CGPointMake(0, point.y - ((tempArray.count/2)*((SCREEN_WIDTH-19)/2 + 5))) animated:NO];
                    [_collectionView.collectionViewLayout invalidateLayout];
                    [_collectionView reloadData];
                    
                    
                    
                }
//                if (_recommednArray.count > 0) {
                    
//                }
//                _templiveDataArray1 = [_templiveDataArray2 mutableCopy];
//                [_templiveDataArray2 removeAllObjects];
                
            }
        }
        for (int i = 0; i < tempArray.count; i++) {
            NSError *err = nil;
            AnchorModel*anchor = [[AnchorModel alloc] initWithDictionary:tempArray[i] error:&err];
            [_liveDataArray addObject:anchor];
            if (i == tempArray.count -1) {
                page += 1;
            }
        }
        if (tempArray.count < [pageNum intValue]) {
            page = 0;
        }
        
        
        
        if (_viewID==0) {
            [_collectionView.collectionViewLayout invalidateLayout];
            [_collectionView reloadData];
            //停止顶部菊花
            [_collectionView.mj_footer endRefreshing];
        }else
        {
            [_table reloadData];
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        
        
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
    return _liveDataArray.count;
}
#pragma mark - 每个Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH+62;//SCREEN_WIDTH
}
#pragma mark - 初始化Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveHotCell * rCell = [LiveHotCell cellWithTableView:tableView];
    //10.16 添加判断
    if (indexPath.row<_liveDataArray.count)
    {
        [self configHotCell:rCell atIndexPath:indexPath];
    }
    return rCell;
}
#pragma mark - 设置Cell内容
-(void)configHotCell:(LiveHotCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AnchorModel*anchor = _liveDataArray[indexPath.row];
    cell.personId = anchor.anchor.id;
    __weak typeof(self)weakself =self;

    cell.headView.contentMode = UIViewContentModeScaleAspectFill;
    cell.headView.clipsToBounds = YES;
    cell.imgeView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imgeView.clipsToBounds = YES;
    /// 4.24 有图片1
    if (![self isBlankString:anchor.img1])
    {
        cell.ImageView1.hidden=NO;
        cell.ImageView1.contentMode = UIViewContentModeScaleAspectFill;
        cell.ImageView1.clipsToBounds = YES;
        [cell.ImageView1 sd_setImageWithURL:[self placeImg:anchor.img1] placeholderImage:[UIImage imageNamed:placeCoverImage]];
    }
    /// 4.24 有图片2
    if (![self isBlankString:anchor.img2])
    {
        cell.ImageView2.hidden=NO;
        cell.ImageView2.contentMode = UIViewContentModeScaleAspectFill;
        cell.ImageView2.clipsToBounds = YES;
        [cell.ImageView2 sd_setImageWithURL:[self placeImg:anchor.img2] placeholderImage:[UIImage imageNamed:placeCoverImage]];
    }
    [cell.headView sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:anchor.anchor.id andUpdate:anchor.anchor.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
    //9.14 印象标签
    if (anchor.yinxiang)
    {
        if (anchor.yinxiang.count==0)//数组个数为0 不显示标签
        {
            cell.yinxiangLabOne.hidden=YES;
            cell.yinxiangLabTwo.hidden=YES;
            cell.yinxiangLabThree.hidden=YES;
        }
        else
        {
            [cell.yinxiangLabOne setTitleColor:colorHead forState:0];
            cell.yinxiangLabOne.titleLabel.textAlignment=NSTextAlignmentCenter;
            cell.yinxiangLabOne.layer.borderColor=colorHead.CGColor;
            cell.yinxiangLabOne.layer.borderWidth=1;
            cell.yinxiangLabOne.layer.masksToBounds=YES;
            if (anchor.yinxiang.count==1) {
                NSString *title=[anchor.yinxiang[0] objectForKey:@"name"];
                if (![title isKindOfClass:[NSNull class]]) {
                    [cell.yinxiangLabOne setTitle:title forState:0];
                }
            }
            if (anchor.yinxiang.count==2) {
                NSString *title=[anchor.yinxiang[0] objectForKey:@"name"];
                if (![title isKindOfClass:[NSNull class]]) {
                    [cell.yinxiangLabOne setTitle:title forState:0];
                }
                if (anchor.yinxiang[1])
                {
                    [cell.yinxiangLabTwo setTitleColor:colorHead forState:0];
                    cell.yinxiangLabTwo.titleLabel.textAlignment=NSTextAlignmentCenter;
                    cell.yinxiangLabTwo.layer.borderColor=colorHead.CGColor;
                    cell.yinxiangLabTwo.layer.borderWidth=1;
                    cell.yinxiangLabTwo.layer.masksToBounds=YES;
                    NSString *name=[anchor.yinxiang[1] objectForKey:@"name"];
                    if (![name isKindOfClass:[NSNull class]]) {
                        [cell.yinxiangLabTwo setTitle:name forState:0];
                    }
                }
            }
            if (anchor.yinxiang.count==3) {
                NSString *title=[anchor.yinxiang[0] objectForKey:@"name"];
                if (![title isKindOfClass:[NSNull class]]) {
                    [cell.yinxiangLabOne setTitle:title forState:0];
                }
                if (anchor.yinxiang[1])
                {
                    [cell.yinxiangLabTwo setTitleColor:colorHead forState:0];
                    cell.yinxiangLabTwo.titleLabel.textAlignment=NSTextAlignmentCenter;
                    cell.yinxiangLabTwo.layer.borderColor=colorHead.CGColor;
                    cell.yinxiangLabTwo.layer.borderWidth=1;
                    cell.yinxiangLabTwo.layer.masksToBounds=YES;
                    NSString *name=[anchor.yinxiang[1] objectForKey:@"name"];
                    if (![name isKindOfClass:[NSNull class]]) {
                        [cell.yinxiangLabTwo setTitle:name forState:0];
                    }
                }
                if (anchor.yinxiang[2])
                {
                    [cell.yinxiangLabThree setTitleColor:colorHead forState:0];
                    cell.yinxiangLabThree.titleLabel.textAlignment=NSTextAlignmentCenter;
                    cell.yinxiangLabThree.layer.borderColor=colorHead.CGColor;
                    cell.yinxiangLabThree.layer.borderWidth=1;
                    cell.yinxiangLabThree.layer.masksToBounds=YES;
                    NSString *threename=[anchor.yinxiang[2] objectForKey:@"name"];
                    if (![threename isKindOfClass:[NSNull class]]) {
                        [cell.yinxiangLabThree setTitle:threename forState:0];
                    }
                }
            }
        }
    }
    cell.liveBtn.hidden=NO;
            //            cell.watch.hidden=NO;
            //            cell.watchLab.hidden=NO;
    
    
    
    [cell.liveBtn setTitleColor:colorHead forState:0];
    cell.liveBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    cell.liveBtn.layer.borderColor=colorHead.CGColor;
    cell.liveBtn.layer.borderWidth=1;
    cell.liveBtn.layer.masksToBounds=YES;
    //如果是直播就显示直播按钮 如过休息显示休息中
    if (![self isBlankString:anchor.endtime])
    {
        [cell.liveBtn setTitle:@"休息中" forState:UIControlStateNormal];
        cell.watch.hidden=YES;
                cell.watchLab.hidden=YES;
    }
    else if ([self isBlankString:anchor.endtime])
    {
        if ([anchor.isPayMode isEqualToString:@"2"])
        {
            [cell.liveBtn setTitle:@"收费房" forState:UIControlStateNormal];
        }
        else if ([anchor.isPayMode isEqualToString:@"1"])
        {
            [cell.liveBtn setTitle:@"收费房" forState:UIControlStateNormal];
        }
        else if (![self isBlankString:anchor.anchor.pwd])
        {
            [cell.liveBtn setTitle:@"密码房" forState:UIControlStateNormal];
        }
        else
        {
            [cell.liveBtn setTitle:@"直播中" forState:UIControlStateNormal];
        }
    }
    //2018.10.31显示等级
    [self showThelevel:anchor.anchor.rank_id and:cell.levelImg and:cell.levelNum isZhuBo:NO];
    if (anchor.anchor.live_banner) { //封面
        
        [cell.imgeView sd_setImageWithURL:[self placeImg:anchor.anchor.live_banner] placeholderImage:[UIImage imageNamed:placeCoverImage]];
    }else{
        [cell.imgeView sd_setImageWithURL:[self placeImg:anchor.anchor.avatar] placeholderImage:[UIImage imageNamed:placeCoverImage]];
    }
    
    if ([anchor.anchor.gender isEqualToString:@"1"])
    {
        [cell.sexView setImage:[UIImage imageNamed:@"icon_live_sex_boy"]];
    }
    else
    {
        [cell.sexView setImage:[UIImage imageNamed:@"icon_live_sex"]];
    }
    cell.name.text = anchor.anchor.nickname;
    if (![anchor.location isEqualToString:@""])
    {
        cell.location.text = anchor.location;
    }
    else
    {
        cell.location.text = @"在火星";
    }
    cell.watch.text = anchor.people_num;
}

#pragma mark - Cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row<_liveDataArray.count) //row的个数小于数组个数
    {
        anchorModel = _liveDataArray[indexPath.row];
        //此处判断 endtime 是否为空 跳转到直播间或者个人详情页面
//        if ([self isBlankString:anchorModel.endtime])
//        {
            //4.26进入游戏直播房间
            [self accrssGameLiveRoom];

    }
}
#pragma mark - 进入游戏直播房间
- (void)accrssGameLiveRoom
{
    BeginLiveModel * beginLiveModel = [[BeginLiveModel alloc] init];
    beginLiveModel.anchor=anchorModel.anchor;
    GameAudienceViewController * viewerUserLive = [[GameAudienceViewController alloc] init];
    viewerUserLive.beginLiveModel = beginLiveModel;
    if (![anchorModel.bottom_url isEqualToString:@""])
    {
        viewerUserLive.bottom_url=anchorModel.bottom_url;
    }
    else
    {
        viewerUserLive.bottom_url=@"";
    }
    if ([anchorModel.isphone isEqualToString:@"0"])//全屏
    {
        viewerUserLive.isPhone=YES;
    }
    viewerUserLive.bottom_url_height=anchorModel.bottom_url_height;
    viewerUserLive.hidesBottomBarWhenPushed                     = YES;
    viewerUserLive.automaticallyAdjustsScrollViewInsets         = NO;
    [self.navigationController pushViewController:viewerUserLive animated:YES];
}

#pragma mark -----------------UICollectionViewDelegateFlowLayout----------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _liveDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QDCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.item<_liveDataArray.count) {
        [cell configCellContent:indexPath andArray:_liveDataArray];
    }
    return cell;
}
#pragma mark - Cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<_liveDataArray.count) {
        anchorModel = _liveDataArray[indexPath.row];
//        if ([self isBlankString:anchorModel.endtime])
//        {
            ///4.26进入游戏直播房间
            [self accrssGameLiveRoom];

    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // 通过kind类型判断 设置相应内容
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, headView.frame.size.height);
}


#pragma mark - UIScrollViewDelegate 滑动改变view大小
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y  ;
    CGFloat y = SCREEN_HEIGHT;
//    backTopView.frame = CGRectMake(0,-y -yOffset, SCREEN_WIDTH, backTopView.frame.size.height);
}

//将要结束拖动
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"velocity:%@",NSStringFromCGPoint(velocity));
    //    NSLog(@"targetContentOffset:%@",NSStringFromCGPoint(*targetContentOffset));
    //强制设置scrollView的偏移量
    //*targetContentOffset = CGPointMake(0, 200);
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //18.7.9 在使用SDWebImage加载较多图片造成内存警告时，定期调用 可降低内存
    [[SDImageCache sharedImageCache] clearMemory];
}
@end

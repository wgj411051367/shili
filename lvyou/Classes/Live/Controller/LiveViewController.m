// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  LiveViewController.m
//  beibei
//
//  Created by dev on 16/6/27.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "LiveViewController.h"
#import "LiveHotListViewController.h"

#import "InviteView.h"

#import "shili-Swift.h"

#import "JXCategoryView.h"
#import "ZipArchive.h"
#import <CoreLocation/CoreLocation.h>



/**
 *  直播主页面
 **/
@interface LiveViewController ()<UIScrollViewDelegate,JXCategoryViewDelegate>
{
    UIView *segmentView;

    //定位省份
    NSString *userProvince;
    //定位城市
    NSString *userCity;
    //定位区县
    NSString *userDistrict;
    //城市编码
    NSString *cityCode;
    NSMutableArray *systemArr;
    
    NSMutableArray <TagsAnchorModel *>*tagsAnchors;
    NSMutableArray *tagsTitles;
    TagsAnchorModel *tagsAnchorModel;
}
@property (nonatomic,strong)HomeTanKuang *tanView;

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@end

@implementation LiveViewController
/// 2.17
@synthesize liveScroll,viewControllers;
- (void)requestData
{
    [[RootHttpHelper httpHelper] achieveCommonGetURL:users_info andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        UserInfoModel *userInfoModel = [[UserInfoModel alloc] initWithDictionary:successData error:nil];
        ///6.25
        SharedAppDelegate.userModel.user=userInfoModel;
        //2018.11.8 添加 信息获取不到直接退出到登录界面
        if (![userInfoModel.id isKindOfClass:[NSNull class]]) {
         if ([self isBlankString:userInfoModel.id]){  //无值
             //清除本地用户信息
             [SharedAppDelegate removeAllDefaultData];
             LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
             BaseNavigationController * navigationView = [[BaseNavigationController alloc]initWithRootViewController:loginView];
             SharedAppDelegate.window.rootViewController = navigationView;
              return;
           }
        }
        //6.20 推荐人提示标识 1有0无
        if ([userInfoModel.tuijianrentip integerValue]==1)
        {
            if (![userInfoModel.tuijianren isEqualToString:@""])
            {
                return;
            }
            else
            {
                [self addWindowAction];
            }
        }
        //8.16 被禁用之后直接退出
        if ([userInfoModel.isblock integerValue]==1)
        {
            [[RootHttpHelper httpHelper] achieveCommonPostURL:users_logout andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
                
                //清除本地用户信息
                [SharedAppDelegate removeAllDefaultData];
                
                LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
                UINavigationController * navigationView = [[UINavigationController alloc]initWithRootViewController:loginView];
                SharedAppDelegate.window.rootViewController = navigationView;
                
            }];
            return;
        }
        
        
        
    }];
}



- (void)showAdolescentView {
    


}

- (void)addWindowAction
{
    InviteView *theview=[[InviteView alloc] initWithFrame:CGRectMake(36*ScreenBiLi, -375*ScreenBiLi, 303*ScreenBiLi, 375*ScreenBiLi)];
    [[UIApplication sharedApplication].windows[0] addSubview:theview];
    [[UIApplication sharedApplication].windows[0] bringSubviewToFront:theview];
    //春天动画
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        theview.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    } completion:nil];
    
}
- (void)requestSystemData
{

    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    liveScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:liveScroll];
    [self requestData];
    //初始化界面
    [self initView];
    
    //初始化ScrollView
    [self initscrollView];
    
    //初始化分页
    [self segmentedControl];

    

    //获取本地等级
    [self getRankList];
    // 缓存关注列表
    [self getAttention];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHot:) name:@"goHot" object:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //10.8 首页弹框提示
//        [self showTheAlert];
//    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToWebVC:) name:@"pushtoad" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTheAlert) name:@"AdvertiseViewEnd" object:nil];
    
    if (@available(iOS 13.0, *)) {
        // 手动放一张白色底图遮住系统tabbar的顶部线条
        // blankView颜色必须设置
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, UIScreen.mainScreen.bounds.size.width, 0.5)];
        blankView.backgroundColor = UIColor.whiteColor;
        UITabBarController *tabVC = [[UITabBarController alloc] init];
    }
}
- (void)pushToWebVC:(NSNotification *)notification
{
    NSDictionary * infoDic = [notification object];
    // 这样就得到了我们在发送通知时候传入的字典了
    [self pushToBannerWebWithLoadUrl:infoDic[@"adurl"] withTitle:nil andShareUrl:nil];
}

- (void)showTheAlert
{

}
- (void)showViewWithUrl:(NSString *)updateUrl
{
    self.tanView=[[HomeTanKuang alloc] initWithUrl:updateUrl];
    self.tanView.delegate=self;
    [[UIApplication sharedApplication].windows[0] addSubview:self.tanView];
    [[UIApplication sharedApplication].windows[0] bringSubviewToFront:self.tanView];
}
- (void)pushToWebWith:(NSString *)loadurl with:(NSString *)titlelab and:(NSString *)imgurl
{
    [self pushToBannerWebWithLoadUrl:loadurl withTitle:titlelab andShareUrl:imgurl];
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

//8.14
- (void)getmsg:(NSNotification *)obj{//有新消息
    // 私信入口下线：不再显示未读私信角标
}

- (void)goHot:(NSNotification *)paramNotification
{
//    segmentControl.selectedSegmentIndex = 1;
    [self.liveScroll setContentOffset:CGPointMake(1 * SCREEN_WIDTH, 0) animated:YES];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //状态栏字体颜色
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getmsg:) name:@"GETMSG" object:nil];
    [self requestSystemData];
    [self requestTagsList];
    
    // 获取头像框
    [self getHeadPortraitData];
}

- (void)requestTagsList {
    
    if (!tagsTitles) {
        tagsTitles = [NSMutableArray array];
    }
    if (!tagsAnchors) {
        tagsAnchors = [NSMutableArray array];
    }
    [[RootHttpHelper httpHelper] achieveCommonGetURL:post_cate andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue]==200||[successData[@"code"] intValue]==200) {
            [tagsTitles removeAllObjects];
            [tagsAnchors removeAllObjects];
            NSArray *tempArr=successData[@"data"];
            for (int i = 0; i < tempArr.count; i++)
            {
                NSError *err = nil;
                tagsAnchorModel = [[TagsAnchorModel alloc] initWithDictionary:tempArr[i] error:&err];
                [tagsAnchors addObject:tagsAnchorModel];
                [tagsTitles addObject:tagsAnchorModel.name];
            }
            [AppDelegate appDelegate].tagsTitles = tagsTitles;
            [AppDelegate appDelegate].tagsAnchors = tagsAnchors;
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //状态栏字体颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xFFFFFF];
}

#pragma mark - 获取本地等级
- (void)getRankList
{
    NSMutableDictionary *rankList = [[NSUserDefaults standardUserDefaults] objectForKey:RankListKey];
    
    SharedAppDelegate.rankDic = rankList;
}

- (void)getAttention {

    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"num":@"10000",@"page":@"0"}];
    if (![self isBlankString:[AppDelegate appDelegate].userModel.user.id]) {
        //8.25
        [params setValue:[AppDelegate appDelegate].userModel.user.id forKey:@"user_id"];
    }
    [[RootHttpHelper httpHelper] achieveCommonGetURL:@"follows" andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in [successData objectForKey:@"data"]) {
            NSDictionary *tempDict = dict[@"target"];
            [tempArr addObject:tempDict[@"id"]];
        }
        // 保存的是房间号
        [[NSUserDefaults standardUserDefaults] setValue:tempArr forKey:@"FollowArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

#pragma mark - 初始化界面
- (void)initView
{
    if(viewControllers == nil)
    {
        viewControllers = [self viewControllers];
    }

    segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*ScreenBiLi)];
}

#pragma mark - 初始化数组
- (NSMutableArray *)viewControllers
{
    if (viewControllers == nil)
    {
        viewControllers = [NSMutableArray array];

        [viewControllers addObject:[[LiveHotListViewController alloc] init]];

    }
    return viewControllers;
}

#pragma mark - 初始化ScrollView
-(void)initscrollView
{
    liveScroll.contentSize = CGSizeMake(SCREEN_WIDTH * viewControllers.count, 0);
    liveScroll.backgroundColor = [UIColor whiteColor];
    liveScroll.pagingEnabled = YES;
    liveScroll.bounces = NO;
    liveScroll.showsHorizontalScrollIndicator = NO;
    liveScroll.delegate = self;

    for (int i = 0; i < viewControllers.count; i++)
    {

            LiveHotListViewController *childVC = [viewControllers objectAtIndex:i];
            childVC.rect = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, liveScroll.frame.size.height);
            [self addChildViewController:childVC];
            [childVC didMoveToParentViewController:self];
            __weak typeof(self) weakself = self;
            childVC.gotoRecommend = ^(NSInteger index) {
                [weakself.liveScroll setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
                [weakself.myCategoryView selectItemAtIndex:index];
            };
            [liveScroll addSubview:childVC.view];

    }
}

//最新直播
-(void)segmentedControl
{
    self.myCategoryView = [[JXCategoryTitleView alloc] init];
    self.myCategoryView.frame = CGRectMake(-10,6, segmentView.bounds.size.width, segmentView.bounds.size.height);
    self.myCategoryView.delegate = self;
    self.myCategoryView.titles = @[@"热门"];
    self.myCategoryView.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.myCategoryView.titleSelectedFont = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
    self.myCategoryView.titleColor = [UIColor colorWithHex:0x333333 alpha:1];
    self.myCategoryView.titleLabelVerticalOffset = -5;
    self.myCategoryView.titleSelectedColor = [UIColor colorWithHex:0x333333];
    self.myCategoryView.titleColorGradientEnabled = YES;
    self.myCategoryView.averageCellSpacingEnabled = NO;
    self.myCategoryView.titleLabelZoomEnabled = YES;
    self.myCategoryView.titleLabelZoomScale = 1.25;
    self.myCategoryView.contentScrollView = self.liveScroll;
    self.myCategoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;

    JXCategoryIndicatorLineView *indicatorLineView = [[JXCategoryIndicatorLineView alloc] init];
    indicatorLineView.indicatorWidth = 26;
    indicatorLineView.indicatorHeight = 8;
    indicatorLineView.indicatorColor = [UIColor gradientColorImageFromColors:@[[UIColor colorWithHexString:@"#FF28C5"],[UIColor colorWithHexString:@"#F6B707"]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(26, 8)];
    indicatorLineView.layer.cornerRadius = 3;
    indicatorLineView.layer.masksToBounds = YES;
    indicatorLineView.verticalMargin = 14;
    self.myCategoryView.indicators = @[indicatorLineView];

    [segmentView addSubview:self.myCategoryView];
    self.navigationItem.titleView = segmentView;
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.liveScroll setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}

//自定义contentScrollView点击选中切换效果
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickedItemContentScrollViewTransitionToIndex:(NSInteger)index {
    
}



///  加载新的页面
- (void)changeScrollViewControllerWithSelectedSegmentIntex:(NSInteger)number
{
    [self.liveScroll setContentOffset:CGPointMake(number * SCREEN_WIDTH, 0) animated:YES];
}
#pragma mark - UIScrollView滑动监听事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / SCREEN_WIDTH;
    
//    segmentControl.selectedSegmentIndex = page;
//    /// 2.17 ........
//    [self changeScrollViewControllerWithSelectedSegmentIntex:segmentControl.selectedSegmentIndex];
//    [segmentControl setSelectedSegmentIndex:page animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"我要开始动了");
//    self.liveScroll.scrollEnabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotRecommendStopAnimation" object:nil];
}



- (void)dealloc
{
    NSLog(@"liveviewcontroller  dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"goHot" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GETMSG" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushtoad" object:nil];
}

- (void)getHeadPortraitData {
//    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:horseModel.id,@"giftid",[NSString stringWithFormat:@"%@/static_data/gift/%@.zip?%@",IMAGEAPI,horseModel.id,horseModel.uptime],@"url",horseModel.uptime,@"version",horseModel.newpwd,@"newpwd",@"-100",@"filename", nil];
//    [self downloadAssetsWith:params];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[AppDelegate appDelegate].userModel.token forKey:@"token"];
    
    [[RootHttpHelper httpHelper] achieveCommonGetURL2:[NSString stringWithFormat:@"%@%@/%@",DATAAPI,@"v4",@"avatar/frameList"] andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
        if ([successData[@"api_code"] intValue] == 200) {
            NSDictionary *tempDict = successData[@"data"][0];
            NSArray *tempArr = tempDict[@"frame"];
            
            dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^ {
                for (NSDictionary *dict in tempArr) {
                    HorseModel *model = [[HorseModel alloc] initWithDictionary:dict error:nil];
                    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:model.id,@"giftid",[NSString stringWithFormat:@"%@/%@",IMAGEAPI,model.json_address],@"url", nil];
                    [self downloadAssetsWith:params];
                }
            });
        }
    }];
}


- (void)downloadAssetsWith:(NSDictionary *)info{
    
//    NSLog(@" 下载线程  %@",[NSThread currentThread]);
    NSString *url=[info objectForKey:@"url"];
    NSString *giftid=[info objectForKey:@"giftid"];
    //文件目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    //礼物ID目录
    NSString *filePath;
    NSString *zipPath;
    filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",giftid]];
    zipPath=[documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",giftid]];
    //配置文件地址
//    NSString *configFile=[filePath stringByAppendingPathComponent:@"config.ini"];
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {//礼物目录存在
        return;
    }
    //下载zip
    NSData *zip_data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (zip_data.length!=0) {//下载成功
        [fileManager removeItemAtPath:zipPath error:nil];
        [zip_data writeToFile:zipPath atomically:YES];
        
    }
    else{//下载不成功，显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"我点了HotView");
}

@end

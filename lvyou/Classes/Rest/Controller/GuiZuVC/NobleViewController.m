// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://company.zaoing.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  ShouHuViewController.m
//  beibei
//
//  Created by dev on 16/7/16.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "NobleViewController.h"
#import "MessageHelper.h"
#import "BuyGuiBinModel.h"
#import "shili-Swift.h"
#import "JXCategoryView.h"
#import "YYText.h"

@interface NobleViewController ()<UIScrollViewDelegate,JXCategoryViewDelegate>
{
    UIView *segmentView;
    UIScrollView *imgScroll,*backScroll,*backgroundScroll;
    UILabel *kaitongLab,*money,*xufeiLab,*intr;
    //购买按钮
    UIButton *buyBtn;
    //特权相关
    UIImageView *tequanImg;
    UILabel*desLab;
    UIView *tequanView;
    UIView *lineview;
    MBProgressHUD *HUD;
    NSString *guizuID,*wtype,*atype;
    CGFloat totalHeight;
    
    NSString *dihuang_recommend;
    NSInteger selectindex;
}

@property (strong, nonatomic) UIButton *xieyiBtn;
@property (strong, nonatomic) UIImageView *xieyiImg;
@property (nonatomic, strong) YYLabel *xieyiLab;

@property(nonatomic,strong)NSMutableDictionary *params;
@property (strong,nonatomic)HMSegmentedControl *segmentControl;
@property (strong,nonatomic)UIImageView *firstImg;
@property (strong, nonatomic)UILabel *firstLable;
@property (strong,nonatomic)NSMutableArray *dataArr;
@property (strong,nonatomic)NSMutableArray *tequanArr;
@property (strong,nonatomic)NSMutableArray *guiZuNameArr;
@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;

@end

@implementation NobleViewController
@synthesize segmentControl,firstImg,firstLable;

- (void)viewDidLoad
{
    self.title=@"贵族";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -NavigationBar_HEIGHT, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    topView.backgroundColor = [UIColor colorWithHex:0x1A1B22];
    [self.view addSubview:topView];
    segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  Segment_HEIGHT)];
    segmentView.backgroundColor=[UIColor colorWithHex:0x1A1B22];
    [UIView animateWithDuration:0.2 animations:^{
        self.PayView.transform = CGAffineTransformMakeTranslation(0, 180);
    }];
    totalHeight=self.payHeight.constant;
    [self requestData];
    
    
}

#pragma mark - 控制器的view将要布局子控件
- (void)viewWillLayoutSubviews
{
    if (self.searchpush==YES) {
        return;
    }
    if (self.tabPush==YES)
    {
        self.view.frame = _rect;
    }
}

- (void)requestData
{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    if (_guiZuNameArr==nil) {
        _guiZuNameArr=[NSMutableArray array];
    }
    [[RootHttpHelper httpHelper] achieveCommonGetURL:[NSString stringWithFormat:@"guizhulist?orderby=asc&platform=ios&version=%@",MyAppBuilder] andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        NSArray *tempArray = [successData objectForKey:@"data"];
        if ([successData[@"api_code"] intValue]==200)
         {
            for (int i = 0; i < tempArray.count; i++) {
                NSError *err = nil;
                BuyGuiBinModel*guibin = [[BuyGuiBinModel alloc] initWithDictionary:tempArray[i] error:&err];
                wtype=successData[@"iosw"];
                atype=successData[@"iosa"];
                [_dataArr addObject:guibin];
                [_guiZuNameArr addObject:guibin.giftname];
                dihuang_recommend = guibin.dihuang_recommend;
         }
             //初始化分页
           [self segmentedControl];
      }
   }];
}
#pragma mark - 初始化分页
-(void)segmentedControl
{
//    segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, segmentView.bounds.size.width, segmentView.bounds.size.height)];
//    segmentControl.backgroundColor = [UIColor clearColor];
//    segmentControl.sectionTitles=self.guiZuNameArr;
//    //下划线的高度
//    segmentControl.selectionIndicatorHeight = 1.0f;
//    [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xDFB4A9 alpha:0.7],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
//    [segmentControl setSelectedTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xDFB4A9],NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]}];
//    segmentControl.borderType = HMSegmentedControlBorderTypeBottom;
//    segmentControl.borderColor = [UIColor clearColor];
//    segmentControl.borderWidth = 0.5;
//    segmentControl.selectionIndicatorColor = RGBACOLOR(225, 176, 121, 1);
//    segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
//    segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    // 页面加载完成后显示热门的界面
//    segmentControl.selectedSegmentIndex = 0;
//    __weak typeof(self) weakSelf = self;
//    //点击事件
//    segmentControl.indexChangeBlock = ^(NSInteger index){
//        /// 2.17 加载新的页面
//        [weakSelf changeScrollViewControllerWithSelectedSegmentIntex:index];
//    };
//    [segmentView addSubview:segmentControl];
    
    [self initscrollView];
    self.myCategoryView = [[JXCategoryTitleView alloc] init];
    self.myCategoryView.frame = CGRectMake(0, 0, segmentView.bounds.size.width, segmentView.bounds.size.height);
    self.myCategoryView.delegate = self;
    self.myCategoryView.titles = self.guiZuNameArr;
    self.myCategoryView.titleFont = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.myCategoryView.titleSelectedFont = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    self.myCategoryView.titleColor = [UIColor colorWithHex:0xDFB4A9 alpha:0.7];
    self.myCategoryView.titleSelectedColor = [UIColor colorWithHex:0xDFB4A9];
    self.myCategoryView.titleLabelVerticalOffset = -5;
    self.myCategoryView.titleColorGradientEnabled = YES;
    self.myCategoryView.averageCellSpacingEnabled = YES;
    self.myCategoryView.titleLabelZoomEnabled = YES;
    self.myCategoryView.titleLabelZoomScale = 1.1;
    self.myCategoryView.contentScrollView = imgScroll;
    self.myCategoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
    
    JXCategoryIndicatorLineView *indicatorLineView = [[JXCategoryIndicatorLineView alloc] init];
    indicatorLineView.indicatorWidth = 13;
    indicatorLineView.indicatorHeight = 2;
    indicatorLineView.indicatorColor = [UIColor colorWithHex:0xDFB4A9];
    indicatorLineView.layer.cornerRadius = 1;
    indicatorLineView.layer.masksToBounds = YES;
    indicatorLineView.verticalMargin = 10;
    
    self.myCategoryView.indicators = @[indicatorLineView];
    
    [segmentView addSubview:self.myCategoryView];
    [self.view addSubview:segmentView];
    
}


//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self changeScrollViewControllerWithSelectedSegmentIntex:index];
    selectindex = index;
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    [imgScroll setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    
}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {

//    [self changeScrollViewControllerWithSelectedSegmentIntex:index];
    //消除键盘笨蛋方法
//    [self searchBarCancel];
}

//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {

}

//自定义contentScrollView点击选中切换效果
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickedItemContentScrollViewTransitionToIndex:(NSInteger)index {
    
}
- (void)initscrollView
{
    backgroundScroll=[[UIScrollView alloc] init];
    if (!self.userPush) {
        backgroundScroll.frame=CGRectMake(0, Segment_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT-TabBar_HEIGHT);
    } else {
        backgroundScroll.frame=CGRectMake(0, Segment_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT);
    }
    
    backgroundScroll.backgroundColor = [UIColor colorWithHex:0x1A1B22];
    backgroundScroll.pagingEnabled = YES;
    backgroundScroll.clipsToBounds = NO;
    //是否反弹
    backgroundScroll.bounces = NO;
    backgroundScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:backgroundScroll];
    [self.view sendSubviewToBack:backgroundScroll];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -NavigationBar_HEIGHT - Segment_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundView.image = [UIImage imageNamed:@"guizuBgView1"];
    [backgroundScroll addSubview:backgroundView];
    
    imgScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 186*ScreenBiLi)];
    imgScroll.contentSize = CGSizeMake(SCREEN_WIDTH *(self.guiZuNameArr.count), 0);
    imgScroll.backgroundColor = [UIColor clearColor];
    imgScroll.pagingEnabled = YES;
    //是否反弹
    imgScroll.bounces = NO;
    imgScroll.showsHorizontalScrollIndicator = NO;
    imgScroll.delegate = self;
    [backgroundScroll addSubview:imgScroll];
    [self initBackImage];
}
- (void)initBackImage
{
    for (int i=0; i<self.guiZuNameArr.count; i++)
    {
        firstImg = [[UIImageView alloc] init];
        firstImg.frame = CGRectMake(SCREEN_WIDTH * (i + 0.5) - 30 * ScreenBiLi, 30 * ScreenBiLi, 60 * ScreenBiLi, 60 * ScreenBiLi);
        firstImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_gui%d",i+1]];
        [imgScroll addSubview:firstImg];
        firstLable = [[UILabel alloc] init];
        firstLable.textColor = RGBACOLOR(225, 176, 121, 1);
        firstLable.textAlignment = NSTextAlignmentCenter;
        firstLable.font = [UIFont systemFontOfSize:18];
        firstLable.frame = CGRectMake(SCREEN_WIDTH * (i + 0.5) - 40 * ScreenBiLi, 118 * ScreenBiLi, 80 * ScreenBiLi, 30 * ScreenBiLi);
        firstLable.text = segmentControl.sectionTitles[i];
        [imgScroll addSubview:firstLable];
    }
    [self initBackScroll];
}
- (void)initBackScroll
{
    lineview=[[UIView alloc] initWithFrame:CGRectMake(0, imgScroll.frame.origin.y+imgScroll.frame.size.height+1*ScreenBiLi, SCREEN_WIDTH, 1*ScreenBiLi)];
    lineview.backgroundColor=[UIColor clearColor];
    [backgroundScroll addSubview:lineview];
    
    
    NSArray *nameArr=@[@"开通通知",@"贵族勋章",@"欢迎进场",@"专属座驾",@"加速升级",@"贵族弹幕",@"专属礼物",@"隐身进场",@"防禁言",@"传送门",@"帝皇推荐"];
    NSArray *describeArr;
    describeArr=@[@"开通时\n全站广播",@"贵族\n专属身份勋章",@"进场显示\n贵族炫酷特效",@"专属座驾\n专属身份座驾",@"消费币额外\n增加20%的经验值",@"与众不同的贵族\n头像弹幕",@"贵族专属\n豪华特效礼物",@"隐身进房\n低调看直播",@"贵族用户将无法\n被房管禁言",@"公爵每月2次\n帝皇每月4次",@"每日可推荐主播\n上推荐三次"];
    if (_tequanArr==nil) {
        _tequanArr=[NSMutableArray array];
    }
    NSInteger viewW = (SCREEN_WIDTH-30)/3;
    NSInteger viewH = 120*ScreenBiLi;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15*ScreenBiLi, lineview.frame.origin.y+lineview.frame.size.height, viewW*3, viewH*9)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 14;
    bgView.layer.masksToBounds = YES;
    [backgroundScroll addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(backgroundScroll).offset(lineview.frame.origin.y+lineview.frame.size.height);
//        make.left.equalTo(backgroundScroll).offset(15*ScreenBiLi);
//        make.centerY.equalTo(backgroundScroll);
//        make.bottom.equalTo(backgroundScroll);
//    }];
    
    UIImageView *zhuanshu = [[UIImageView alloc] init];
    zhuanshu.image = [UIImage imageNamed:@"icon_guizu_zhuanshu"];
    zhuanshu.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:zhuanshu];
    [zhuanshu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(11);
        make.centerX.equalTo(bgView);
    }];
    
    for (int i=0; i<11; i++)
    {
        NSUInteger col = i%3;
        CGFloat viewX = col * (viewW) + 15*ScreenBiLi;
        NSInteger row = i/3;
        CGFloat viewY = lineview.frame.origin.y+lineview.frame.size.height+row * (viewH) +37;
         // 每个格子的大小
        tequanView=[[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        tequanView.backgroundColor=[UIColor clearColor];
        //图片
        tequanImg=[[UIImageView alloc] initWithFrame:CGRectMake((viewW-56*ScreenBiLi)/2, 27*ScreenBiLi, 56*ScreenBiLi, 50*ScreenBiLi)];
        tequanImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"tequannormal_%d",i]];
        tequanImg.highlightedImage=[UIImage imageNamed:[NSString stringWithFormat:@"tequanselect_%d",i]];
        if (i <= 2) {
            tequanImg.highlighted = YES;
        } else {
            tequanImg.highlighted = NO;
        }
        tequanImg.tag=1000+i;
        [tequanView addSubview:tequanImg];
        [_tequanArr addObject:tequanImg];
        //功能名称
        UILabel*nameLab=[[UILabel alloc] init];
        nameLab.frame=CGRectMake(0, tequanImg.frame.origin.y+tequanImg.frame.size.height+5*ScreenBiLi, tequanView.frame.size.width, 12*ScreenBiLi);
        nameLab.text=nameArr[i];
        nameLab.textColor=RGBACOLOR(32, 32, 32, 1);
        nameLab.textAlignment=NSTextAlignmentCenter;
        nameLab.font=[UIFont systemFontOfSize:13.0f];
        [tequanView addSubview:nameLab];
        
        //功能描述
        desLab=[[UILabel alloc] init];
        desLab.frame=CGRectMake(0, nameLab.frame.origin.y+nameLab.frame.size.height+3*ScreenBiLi, tequanView.frame.size.width, 40*ScreenBiLi);
        if (i == 10) {
            desLab.text = [NSString stringWithFormat:@"每日可推荐主播\n上推荐%@次",dihuang_recommend];
        } else {
            desLab.text=describeArr[i];
        }
        
        desLab.numberOfLines=0;
        desLab.textColor=RGBACOLOR(151, 151, 151, 1);
        desLab.textAlignment=NSTextAlignmentCenter;
        desLab.font=[UIFont systemFontOfSize:11.0f];
        [tequanView addSubview:desLab];
        [backgroundScroll addSubview:tequanView];
    }
    [self initChargeView];
}
- (void)initChargeView
{
    UIView *view=[[UIView alloc] init];
//    if (self.tabBarController.tabBar.isHidden==YES) {//tabbar是否是隐藏状态
//        if (self.tabPush==YES) {
//            view.frame=CGRectMake(0, SCREEN_HEIGHT-83*ScreenBiLi-NavigationBar_HEIGHT, SCREEN_WIDTH, 83*ScreenBiLi);
//        }
//        else{
//            view.frame=CGRectMake(0, SCREEN_HEIGHT-83*ScreenBiLi-NavigationBar_HEIGHT, SCREEN_WIDTH, 83*ScreenBiLi);
//        }
//    }
//    else{
//        view.frame=CGRectMake(0, SCREEN_HEIGHT-83*ScreenBiLi-NavigationBar_HEIGHT-TabBar_HEIGHT, SCREEN_WIDTH, 83*ScreenBiLi);
//    }
    
    if (!self.userPush) {
        view.frame=CGRectMake(0, SCREEN_HEIGHT-65*ScreenBiLi-30-NavigationBar_HEIGHT-TabBar_HEIGHT, SCREEN_WIDTH, 65*ScreenBiLi+30);
    } else {
        CGFloat height = 50*ScreenBiLi + (iphoneX?34:0) + 30;
        view.frame=CGRectMake(0, SCREEN_HEIGHT-height-NavigationBar_HEIGHT, SCREEN_WIDTH, height);
    }
    view.backgroundColor=[UIColor colorWithHex:0x000000 alpha:0.8];
    
    BuyGuiBinModel *model;
    if (_dataArr.count>0)
    {
        model=_dataArr[0];
    }
    //  贵族的id
    guizuID=model.id;
    NSString *textStr=[NSString stringWithFormat:@"开通%@首月:",model.giftname];
    CGSize textSize = [textStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0)
                                            options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    kaitongLab=[[UILabel alloc] initWithFrame:CGRectMake(27*ScreenBiLi, 8*ScreenBiLi, textSize.width, 20*ScreenBiLi)];
    kaitongLab.text=textStr;
    kaitongLab.textColor=[UIColor whiteColor];
    kaitongLab.textAlignment=NSTextAlignmentLeft;
    kaitongLab.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:kaitongLab];
  
    money=[[UILabel alloc] initWithFrame:CGRectMake(kaitongLab.frame.origin.x+kaitongLab.frame.size.width+2*ScreenBiLi, 8*ScreenBiLi, 90*ScreenBiLi, 16*ScreenBiLi)];
    if (![self isBlankString:model.shouyue])
    {
        money.text=[NSString stringWithFormat:@"%@元",model.shouyue];
    }
    else
    {
      money.text=[NSString stringWithFormat:@"%@元",@"0"];
    }
    money.textColor=[UIColor colorWithHex:0xE1B079];
    money.textAlignment=NSTextAlignmentLeft;
    money.font= [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    [view addSubview:money];
    
    xufeiLab=[[UILabel alloc] initWithFrame:CGRectMake(27*ScreenBiLi, kaitongLab.frame.origin.y+kaitongLab.frame.size.height+2*ScreenBiLi, SCREEN_WIDTH/2, 16*ScreenBiLi)];
    if (![self isBlankString:model.xufei])
    {
        xufeiLab.text=[NSString stringWithFormat:@"往后续费只需%@元",model.xufei];
    }
    else
    {
       xufeiLab.text=[NSString stringWithFormat:@"往后续费只需%@元",@"0"];
    }
    xufeiLab.textColor=[UIColor whiteColor];
    xufeiLab.textAlignment=NSTextAlignmentLeft;
    xufeiLab.font= [UIFont fontWithName:@"DINAlternate-Bold" size:11];
    [view addSubview:xufeiLab];
    
    intr=[[UILabel alloc] initWithFrame:CGRectMake(27*ScreenBiLi, xufeiLab.frame.origin.y+xufeiLab.frame.size.height+3*ScreenBiLi, SCREEN_WIDTH/2+60*ScreenBiLi, 10*ScreenBiLi)];
    if (![self isBlankString:model.intr])
    {
        intr.text=[NSString stringWithFormat:@"%@",model.intr];
    }
    intr.textColor=[UIColor whiteColor];
    intr.textAlignment=NSTextAlignmentLeft;
    intr.font= [UIFont fontWithName:@"DINAlternate-Bold" size:11];
    [view addSubview:intr];
    
    NSString *xufeiString=@"立即开通";
    buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor=[UIColor gradientColorImageFromColors:@[[UIColor colorWithHex:0xF5DAD5],[UIColor colorWithHex:0xDFB4A9]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(119*ScreenBiLi, 35*ScreenBiLi)];
    buyBtn.layer.cornerRadius=17.5*ScreenBiLi;
    buyBtn.layer.masksToBounds=YES;
    if (![self isBlankString:model.isusing])
    {
        if ([model.isusing isEqualToString:@"1"])
        {
            NSString *xufei=@"立即续费";
            [self buttonTypeWithText:xufei];
            [buyBtn setTitle:xufei forState:0];
        }
        else
        {
            [self buttonTypeWithText:xufeiString];
           [buyBtn setTitle:xufeiString forState:0];
        }
    }
    else
    {
          [self buttonTypeWithText:xufeiString];
          [buyBtn setTitle:xufeiString forState:0];
    }
    [buyBtn setTitleColor:[UIColor whiteColor] forState:0];
    [buyBtn addTarget:self action:@selector(buyBtn:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.hidden = YES;   // 购买贵族入口下线（App Store 3.1.1：数字商品须走 IAP，非 IAP 购买已废）
    [view addSubview:buyBtn];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    if (!self.userPush) {
        backgroundScroll.contentSize = CGSizeMake(SCREEN_WIDTH,segmentView.frame.origin.y+imgScroll.frame.size.height+(SCREEN_WIDTH/3)*4+NavigationBar_HEIGHT+TabBar_HEIGHT+30);
    } else {
        backgroundScroll.contentSize = CGSizeMake(SCREEN_WIDTH,segmentView.frame.origin.y+segmentView.frame.size.height+imgScroll.frame.size.height+(SCREEN_WIDTH/3)*4+NavigationBar_HEIGHT+30);
    }
    
    self.xieyiLab = [[YYLabel alloc] init];
    self.xieyiLab.numberOfLines = 0;
    self.xieyiLab.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.xieyiLab.preferredMaxLayoutWidth = SCREEN_WIDTH-46-27*ScreenBiLi;//设置最大宽度
    [view addSubview:self.xieyiLab];
    [self.xieyiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.userPush) {
            make.bottom.equalTo(@-10);
        } else {
            make.bottom.equalTo(@(-10-24));
        }
        
        
        make.right.equalTo(@-46);
    }];
    
    self.xieyiImg = [[UIImageView alloc] init];
    
    
    [view addSubview:self.xieyiImg];
    
    self.xieyiBtn = [[UIButton alloc] init];
    [self.xieyiBtn addTarget:self action:@selector(loginXieYIBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.xieyiBtn];
    
    _xieyiBtn.selected = [[[NSUserDefaults standardUserDefaults] objectForKey:@"guizu_xieyi_se"] boolValue];
    if (_xieyiBtn.selected) {
        self.xieyiImg.image = [UIImage imageNamed:@"icon_login_se"];
    } else {
        self.xieyiImg.image = [UIImage imageNamed:@"icon_login_un"];
    }
    
    [self.xieyiImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xieyiLab);
        make.left.equalTo(@(27*ScreenBiLi));
        make.right.equalTo(self.xieyiLab.mas_left).offset(-10);
        make.width.height.equalTo(@13);
    }];
    
    [self.xieyiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.xieyiImg);
        
        make.top.equalTo(self.xieyiImg).offset(-10);
        make.right.equalTo(self.xieyiImg).offset(10);
    }];
    

    NSString *str = @"请阅读并同意";
    NSString *contentStr = [NSString stringWithFormat:@"%@%@",str,NSLocalizedString(@"充值协议", @"")];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:contentStr];

    [attr yy_setAttribute:NSForegroundColorAttributeName value:colorHead range:NSMakeRange(0, contentStr.length)];
    
    [attr yy_setAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFFFFFF alpha:1] range:NSMakeRange(0, str.length)];
//    // 下划线
//    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@(1) color:[UIColor whiteColor]];
//    [attr yy_setTextUnderline:decoration range:NSMakeRange(2, contentStr.length-2)];
    [attr yy_setAlignment:NSTextAlignmentCenter range:NSMakeRange(0, contentStr.length)];
    
    [attr yy_setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightMedium] range:NSMakeRange(0, contentStr.length)];
    [attr yy_setFont:[UIFont systemFontOfSize:11] range:NSMakeRange(0, str.length)];
    //这里设置useinfo，是为了点击的时候区分出点击的是哪段文字
    YYTextHighlight *lawHightLight = [YYTextHighlight new];
    lawHightLight.userInfo = @{@"title":NSLocalizedString(@"充值协议", @"")};
    [attr yy_setTextHighlight:lawHightLight range:[contentStr rangeOfString:NSLocalizedString(@"充值协议", @"")]];
    self.xieyiLab.attributedText = attr;
    self.xieyiLab.textAlignment = NSTextAlignmentLeft;
    //点击的方法
    /**点击富文本，服务协议和法律声明的跳转*/
    __weak typeof(self) weakself = self;
    [self.xieyiLab setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:range.location];
        NSString *title = highlight.userInfo[@"title"];

        if ([title isEqualToString:NSLocalizedString(@"充值协议", @"")]) {//点击的法律声明
            [weakself TiaoKuanActionWithID:@"3137"];
        }
    }];
     
}


- (void)loginXieYIBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.xieyiImg.image = [UIImage imageNamed:@"icon_login_se"];
    } else {
        self.xieyiImg.image = [UIImage imageNamed:@"icon_login_un"];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:@"guizu_xieyi_se"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)TiaoKuanActionWithID:(NSString *)str {
}
- (void)buyBtn:(UIButton *)btn
{
    if (!self.xieyiBtn.selected) {
        [self.view makeToast:@"请阅读并同意充值服务协议" duration:1.5 position:ToastDefaultPosition];

        return;
    }
    if (_dataArr.count>0) {
        BuyGuiBinModel *model=_dataArr[segmentControl.selectedSegmentIndex];
        [self payWithTypeWithModel:model];
    }
}
//购买贵族
- (void)payWithTypeWithModel:(BuyGuiBinModel *)model
{
    if ([wtype isEqualToString:@""]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.weView.hidden=YES;
            totalHeight=self.payHeight.constant-self.wechatHeight.constant;
            self.wechatHeight.constant=0;
        }];
    }
    if ([atype isEqualToString:@""]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.aliView.hidden=YES;
            totalHeight=self.payHeight.constant-self.aliHeight.constant;
            self.aliHeight.constant=0;
        }];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.PayView.hidden=NO;
        self.payHeight.constant=totalHeight;
        [self.PayView bringToFront];
         self.PayView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    [self payAction:nil];
}
// 购买贵族入口已下线(buyBtn.hidden=YES)。原第三方支付整条链
// (payWithModel/pushToH5PayWith/pushToNativePayWith/wechatPayWithDictionary/aliPayWithDictionary)
// 已整段删除(App Store 3.1.1 / 5.6：贵族属数字商品，非 IAP 购买违规)。
// payAction:/cancelAction: 为 XIB 连线的 IBAction，保留空壳避免加载崩溃。
- (IBAction)payAction:(UIButton *)sender{
}
- (IBAction)cancelAction:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.PayView.hidden=YES;
        self.PayView.transform = CGAffineTransformMakeTranslation(0, 180);
    }];
}
#pragma mark - UIScrollView滑动监听事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    int page = scrollView.contentOffset.x / SCREEN_WIDTH;
//    segmentControl.selectedSegmentIndex = page;
//    /// 2.17 ........
//    [self changeScrollViewControllerWithSelectedSegmentIntex:segmentControl.selectedSegmentIndex];
//    [segmentControl setSelectedSegmentIndex:page animated:YES];
}
/// 2.17 切换
- (void)changeScrollViewControllerWithSelectedSegmentIntex:(NSInteger)number
{

    [imgScroll setContentOffset:CGPointMake(number* SCREEN_WIDTH, 0) animated:YES];
    kaitongLab.text=[NSString stringWithFormat:@"开通%@首月:",self.guiZuNameArr[number]];
    BuyGuiBinModel *model;
    if (_dataArr.count>0)
    {
        model=_dataArr[number];
    }
    //2.28 添加贵族的id
    guizuID=model.id;
    if (![self isBlankString:model.shouyue])
    {
        money.text=[NSString stringWithFormat:@"%@元",model.shouyue];
    }
    else
    {
        money.text=[NSString stringWithFormat:@"%@元",@"0"];
    }
    if (![self isBlankString:model.xufei])
    {
        xufeiLab.text=[NSString stringWithFormat:@"往后续费只需%@元",model.xufei];
    }
    else
    {
        xufeiLab.text=[NSString stringWithFormat:@"往后续费只需%@元",@"0"];
    }
    if (![self isBlankString:model.intr])
    {
        intr.text=[NSString stringWithFormat:@"%@",model.intr];
    }
//    else
//    {
//        intr.text=[NSString stringWithFormat:@"送%@%@",@"0",[self moneyname]];
//    }
    if ([model.isusing isEqualToString:@"1"])
    {
        NSString *xufeiString=@"立即续费";
        [self buttonTypeWithText:xufeiString];
        [buyBtn setTitle:xufeiString forState:0];
    }
    else
    {
        NSString *xufeiString=@"立即开通";
        [self buttonTypeWithText:xufeiString];
        [buyBtn setTitle:xufeiString forState:0];
    }
    //改变图片的状态
    if (number==0)
    {
        for (UIImageView *img in _tequanArr)
        {
            img.highlighted=YES;
            if (img.tag>=1003) {
                [self changeImgState:img];
            }
        }
    }
    if (number==1)
    {
        
        for (UIImageView *img in _tequanArr)
        {
            img.highlighted=YES;
            if (img.tag>=1005) {
                [self changeImgState:img];
            }
        }
    }
    if (number==2)
    {
        for (UIImageView *img in _tequanArr)
        {
            img.highlighted=YES;
            if (img.tag>=1007) {
                [self changeImgState:img];
            }
        }
    }
    if (number==3)
    {
        for (UIImageView *img in _tequanArr)
        {
            img.highlighted=YES;
            if (img.tag>=1008) {
                [self changeImgState:img];
            }
        }
    }
    if (number==4)
    {
        for (UIImageView *img in _tequanArr)
        {
            img.highlighted=YES;
            if (img.tag>=1010) {
                [self changeImgState:img];
            }
        }
    }
    if (number==5)
    {
        for (UIImageView *img in _tequanArr) {
            img.highlighted=YES;
        }
    }
}
- (void)buttonTypeWithText:(NSString *)string
{
    buyBtn.frame=CGRectMake(SCREEN_WIDTH-35*ScreenBiLi-119*ScreenBiLi, 10*ScreenBiLi, 119*ScreenBiLi, 35*ScreenBiLi);
    buyBtn.titleLabel.font=[UIFont systemFontOfSize:16.0f];
}
//修改图片的状态
- (void)changeImgState:(UIImageView *)image
{
    switch (image.tag) {
        case 1003:
            [image viewWithTag:1003];
            image.highlighted=NO;
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"tequannormal_3"]];
            break;
        case 1004:
            [image viewWithTag:1004];
            image.highlighted=NO;
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"tequannormal_4"]];
            break;
        case 1005:
            [image viewWithTag:1005];
            image.highlighted=NO;
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"tequannormal_5"]];
            break;
        case 1006:
            [image viewWithTag:1006];
            image.highlighted=NO;
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"tequannormal_6"]];
            break;
        case 1007:
            [image viewWithTag:1007];
            image.highlighted=NO;
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"tequannormal_7"]];
            break;
        case 1008:
            [image viewWithTag:1008];
            image.highlighted=NO;
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"tequannormal_8"]];
            break;
        case 1009:
            [image viewWithTag:1009];
            image.highlighted=NO;
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"tequannormal_9"]];
            break;
        case 1010:
            [image viewWithTag:1010];
            image.highlighted=NO;
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"tequannormal_10"]];
            break;
        default:
            break;
    }
}

@end

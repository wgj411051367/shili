// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  XYNavigationController.m
//  beibei
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseNavigationController.h"
#import "Constants.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 更改nBar的颜色， 默认带有一定透明效果，可以使用以下方法去除系统效果
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];//导航栏的背景颜色
    [[UINavigationBar appearance] setTranslucent:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 设置顶部导航标题的大小和颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightSemibold],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    if (IOS11_OR_LATER)
    {
        UIImage *backButtonImage=[[UIImage imageNamed:@"back_personal_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationBar.backIndicatorImage=backButtonImage;
        self.navigationBar.backIndicatorTransitionMaskImage=backButtonImage;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0)forBarMetrics:UIBarMetricsDefault];//2.9 隐藏导航栏左侧返回按钮的标题title
        [UINavigationBar appearance].tintColor = [UIColor colorWithHex:0x4797FF];
    }
    else
    {
        // 返回按钮样式
        [[UIBarButtonItem appearance]setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_personal_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,21,0,0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        // 2017.6.8  警告！！！<不要设置无穷大的负偏移(NSIntegerMin)，否则app从后台返回前台时将会闪屏>
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-SCREEN_WIDTH, -SCREEN_HEIGHT) forBarMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].tintColor = [UIColor blackColor];
    }
    //放开此处注释的代码可以让nativetion不显示一条黑线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - 状态栏黑色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


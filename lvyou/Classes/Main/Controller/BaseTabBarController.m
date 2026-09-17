// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  TabBarController.m
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "LiveViewController.h"
#import "shili-Swift.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h>
@interface BaseTabBarController ()<UITabBarControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    AVAudioPlayer *player;
    NSMutableArray *systemArr;
}

@end

@implementation BaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    BaseNavigationController *liveRootVC = [[BaseNavigationController alloc] initWithRootViewController:[[LiveViewController alloc] init]];
    BaseNavigationController *userRootVC1 =[[BaseNavigationController alloc] initWithRootViewController:[[ProfileTabViewController alloc] init]];
    self.viewControllers= @[liveRootVC, userRootVC1];
    if(IOS10_OR_LATER)
    {
        [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
        [[UITabBar appearance] setBackgroundImage:[UIImage new]];
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [[UINavigationBar appearance] setTranslucent:NO];
        
        if (@available(iOS 13.0, *)) {
            UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
            appearance.backgroundImage = [UIImage new];
            appearance.backgroundColor = [UIColor whiteColor];
            appearance.shadowImage = [UIImage new];
            appearance.shadowColor = [UIColor clearColor];
            self.tabBar.standardAppearance = appearance;
        } else {
            // Fallback on earlier versions
        }
    }
    else{
        [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setBackgroundImage:[UIImage new]];
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        // 设置底部导航
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    }
    self.selectedIndex = 0;
    // iOS 26 SDK：viewDidLoad 时 tabBar 子视图尚未建齐，直接取 subviews[2] 会越界崩溃。加边界保护。
    if (self.tabBar.subviews.count > 2) {
        [self.view bringSubviewToFront:self.tabBar.subviews[2]];
    }
    // 进入主 App（已同意协议+登录）后再请求定位，而非启动时（App Store 5.1.1）
    [SharedAppDelegate initializeLocationService];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getmsg:) name:@"GETMSG" object:nil];
    [self requestSystemData];
    // 控制底部按钮
    [self setTabBarItems];
    [self getmsg:nil];
}

- (void)getmsg:(NSNotification *)obj{//有新消息
    //设置角标未读消息
//    NSString *unreadnum=[[UserDBHelper userDBHelper] msgUnreadNum];
//    if (![unreadnum isEqualToString:@"0"]) {
//        UIViewController *VC = self.viewControllers[3];
//        VC.tabBarItem.badgeValue = unreadnum;
//        VC.tabBarItem.badgeColor = [UIColor redColor];
//    }
}

- (void)requestSystemData
{
}

/**
 获取设备名称
 */
- (NSString *)iphoneName
{
    struct utsname systemInfo;
    uname(&systemInfo); // 获取系统设备信息
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    NSDictionary *dict = @{
                           // iPhone
                           @"iPhone5,3" : @"iPhone 5c",
                           @"iPhone5,4" : @"iPhone 5c",
                           @"iPhone6,1" : @"iPhone 5s",
                           @"iPhone6,2" : @"iPhone 5s",
                           @"iPhone7,1" : @"iPhone 6 Plus",
                           @"iPhone7,2" : @"iPhone 6",
                           @"iPhone8,1" : @"iPhone 6s",
                           @"iPhone8,2" : @"iPhone 6s Plus",
                           @"iPhone8,4" : @"iPhone SE",
                           @"iPhone9,1" : @"iPhone 7",
                           @"iPhone9,2" : @"iPhone 7 Plus",
                           @"iPhone10,1" : @"iPhone 8",
                           @"iPhone10,4" : @"iPhone 8",
                           @"iPhone10,2" : @"iPhone 8 Plus",
                           @"iPhone10,5" : @"iPhone 8 Plus",
                           @"iPhone10,3" : @"iPhone X",
                           @"iPhone10,6" : @"iPhone X",
                           @"iPhone11,2" : @"iPhone XS",
                           @"iPhone11,4" : @"iPhone XS Max",
                           @"iPhone11,6" : @"iPhone XS Max",
                           @"iPhone11,8" : @"iPhone XR",
                           @"i386" : @"iPhone Simulator",
                           @"x86_64" : @"iPhone Simulator",
                           // iPad
                           @"iPad4,1" : @"iPad Air",
                           @"iPad4,2" : @"iPad Air",
                           @"iPad4,3" : @"iPad Air",
                           @"iPad5,3" : @"iPad Air 2",
                           @"iPad5,4" : @"iPad Air 2",
                           @"iPad6,7" : @"iPad Pro 12.9",
                           @"iPad6,8" : @"iPad Pro 12.9",
                           @"iPad6,3" : @"iPad Pro 9.7",
                           @"iPad6,4" : @"iPad Pro 9.7",
                           @"iPad6,11" : @"iPad 5",
                           @"iPad6,12" : @"iPad 5",
                           @"iPad7,1" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,2" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,3" : @"iPad Pro 10.5",
                           @"iPad7,4" : @"iPad Pro 10.5",
                           @"iPad7,5" : @"iPad 6",
                           @"iPad7,6" : @"iPad 6",
                           // iPad mini
                           @"iPad2,5" : @"iPad mini",
                           @"iPad2,6" : @"iPad mini",
                           @"iPad2,7" : @"iPad mini",
                           @"iPad4,4" : @"iPad mini 2",
                           @"iPad4,5" : @"iPad mini 2",
                           @"iPad4,6" : @"iPad mini 2",
                           @"iPad4,7" : @"iPad mini 3",
                           @"iPad4,8" : @"iPad mini 3",
                           @"iPad4,9" : @"iPad mini 3",
                           @"iPad5,1" : @"iPad mini 4",
                           @"iPad5,2" : @"iPad mini 4",
                           // Apple Watch
                           @"Watch1,1" : @"Apple Watch",
                           @"Watch1,2" : @"Apple Watch",
                           @"Watch2,6" : @"Apple Watch Series 1",
                           @"Watch2,7" : @"Apple Watch Series 1",
                           @"Watch2,3" : @"Apple Watch Series 2",
                           @"Watch2,4" : @"Apple Watch Series 2",
                           @"Watch3,1" : @"Apple Watch Series 3",
                           @"Watch3,2" : @"Apple Watch Series 3",
                           @"Watch3,3" : @"Apple Watch Series 3",
                           @"Watch3,4" : @"Apple Watch Series 3",
                           @"Watch4,1" : @"Apple Watch Series 4",
                           @"Watch4,2" : @"Apple Watch Series 4",
                           @"Watch4,3" : @"Apple Watch Series 4",
                           @"Watch4,4" : @"Apple Watch Series 4"
                           };
    NSString *name = dict[platform];
    
    return name ? name : platform;
}

#pragma mark - 控制底部按钮
- (void)setTabBarItems
{
    NSArray *imageIndexes = @[@1, @2];
    for (NSInteger i = 0; i < self.viewControllers.count; i++)
    {
        UIViewController *VC = self.viewControllers[i];
        NSInteger imgIdx = (i < (NSInteger)imageIndexes.count) ? [imageIndexes[i] integerValue] : (i + 1);
        
        UITabBarItem * item = [[UITabBarItem alloc] init];
        UIImage *image = [[UIImage imageNamed:[NSString stringWithFormat:@"TabBar%ld",(long)imgIdx]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selImage = [[UIImage imageNamed:[NSString stringWithFormat:@"TabBarSel%ld",(long)imgIdx]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

            [item setImage:image];
            [item setSelectedImage:selImage];

        // 设置tabBar字体的偏移量
//        [item setTitlePositionAdjustment:UIOffsetMake(0, 2.0)];
//        if (IOS13_OR_LATER) {
//            if (@available(iOS 13.0, *)) {
//                [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :colorHead,NSFontAttributeName : [UIFont systemFontOfSize:13.0]} forState:UIControlStateSelected];
//                [UITabBarItem appearance].standardAppearance.selectionIndicatorTintColor = colorHead;
//                
//            } else {
//                // Fallback on earlier versions
//            }
//        } else {
//            [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :colorHead,NSFontAttributeName : [UIFont systemFontOfSize:13.0]} forState:UIControlStateSelected];//TabBarItem选中时的字体颜色和大小
//        }
//        
        
//        if (@available(iOS 13.0, *)) {
//            // iOS 13以上
//            self.tabBar.tintColor = colorHead;
//            self.tabBar.unselectedItemTintColor = [UIColor grayColor];
//            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
//            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:colorHead} forState:UIControlStateSelected];
//        } else {
//            // iOS 13以下
//            UITabBarItem *item = [UITabBarItem appearance];
//            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:colorHead} forState:UIControlStateSelected];
//        }
        
        // 设置 tabBar 阴影 
        self.tabBar.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.tabBar.layer.shadowOffset = CGSizeMake(0, -1);
        self.tabBar.layer.shadowOpacity =0.3;
        
        item.tag = imgIdx;
        item.title = @"";
        VC.tabBarItem = item;
    }
}
/** 获取当前控制器 */
+ (UIViewController *)currentVC
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    //当前windows的根控制器
    UIViewController *controller = window.rootViewController;
    
    //通过循环一层一层往下查找
    while (YES) {
        //先判断是否有present的控制器
        if (controller.presentedViewController) {
            //有的话直接拿到弹出控制器，省去多余的判断
            controller = controller.presentedViewController;
        } else {
            if ([controller isKindOfClass:[UINavigationController class]]) {
                //如果是NavigationController，取最后一个控制器（当前）
                controller = [controller.childViewControllers lastObject];
            } else if ([controller isKindOfClass:[UITabBarController class]]) {
                //如果TabBarController，取当前控制器
                UITabBarController *tabBarController = (UITabBarController *)controller;
                controller = tabBarController.selectedViewController;
            } else {
                if (controller.childViewControllers.count > 0) {
                    //如果是普通控制器，找childViewControllers最后一个
                    controller = [controller.childViewControllers lastObject];
                } else {
                    //没有present，没有childViewController，则表示当前控制器
                    return controller;
                }
            }
        }
    }
}
#pragma mark - 确定所点击的按钮(并跳到相应页面)，点击中间tabbarItem，不切换，让当前页面跳转
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{

    return YES;
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger index = tabBarController.selectedIndex;
    //7.26 调用方法使tabbar实现抖动效果
    [self animationWithIndex:index];
//    NSString *title;
    switch (index)
    {
        case 0:
//            title = @"Message";
            [self playMusicWithName:@"first" andType:@"wav"];
            break;
        case 1:
//            title = @"User List";
            [self playMusicWithName:@"second" andType:@"mp3"];
            break;
        case 3:
            {
//                此处不再需要设置图片 因为用来显示消息用的是系统tabbar的角标
//            UIImage *image = [[UIImage imageNamed:[NSString stringWithFormat:@"TabBar%ld",(long)4]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            UIViewController *VC = self.viewControllers[3];
//            [VC.tabBarItem setImage:image];
//                此处就是设置系统角标的地方 看过消息之后置为空
//            [VC.tabBarItem setBadgeValue:nil];
            [self playMusicWithName:@"forth" andType:@"wav"];
            }
            break;
        case 4:
            [self playMusicWithName:@"fifth" andType:@"mp3"];
           break;
    }
}
//7.26 新增tabBarItem的抖动效果
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    // iOS 26：tabBar 按钮类名/层级变了，筛出的数组可能为空或不足，直接取 [index] 会越界崩溃。加保护。
    if (index >= 0 && index < tabbarbuttonArray.count) {
        UIView *view = tabbarbuttonArray[index];
        [view.layer addAnimation:pulse forKey:nil];
    }
//    [[tabbarbuttonArray[index] layer]
//     addAnimation:pulse forKey:nil];
}

- (void)playMusicWithName:(NSString *)resource andType:(NSString *)type
{
    NSString *playerUrl = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    if (playerUrl==nil) {
        return;
    }
    return;//播放音效
    NSURL *url = [NSURL fileURLWithPath:playerUrl];
    // 2.创建播放器
    if (player) {
        [player stop];
        player=nil;
    }
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];// AVAudioPlayer对象要设置成全局的
    player.numberOfLoops = 0;//播放次数 0代表1次
    player.volume = 1;//音量
    [player prepareToPlay];
    [player play];
}

@end

// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  AppSettingsViewController.m
//  beibei
//
//  Created by dev on 16/7/7.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "AppSettingsViewController.h"
#import "shili-Swift.h"
/**
 *  设置页面
 **/
@interface AppSettingsViewController ()
{
    //缓存文件个数
    NSInteger fileFactCount;
    //缓存问价大小
    double totalFactSize;
    //缓存显示
    NSString *cacheFactSize;
    //清除缓存
    UIAlertView *clearAlertView;
    //退出登录
    UIAlertView *exitAlertView;
    //开关
    BOOL isButtonOn;
    NSString *thetype,*weNickName,*forceClick;
}
@property (strong, nonatomic) IBOutlet UISwitch *switchPrivate;

@end

@implementation AppSettingsViewController
@synthesize
cache,
switchPrivate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化界面
    [self initView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWeChatInfo:) name:@"wechatInfo" object:nil];
}

#pragma mark - 初始化界面
- (void)initView
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    //注销账号入口（App Store 指南 5.1.1(v)：可注册即必须可注销）
    [self setupDeleteAccountEntry];
}

#pragma mark - 注销账号入口
- (void)setupDeleteAccountEntry
{
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    CGRect lf = self.logoutBtn.frame;
    deleteBtn.frame = CGRectMake(lf.origin.x, CGRectGetMaxY(lf) + 12, lf.size.width, 40);
    [deleteBtn setTitle:@"注销账号" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn addTarget:self action:@selector(deleteAccountAction) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutBtn.superview addSubview:deleteBtn];
}

#pragma mark - 注销账号
- (void)deleteAccountAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注销账号"
        message:@"注销后你的账号及相关数据将被永久删除且无法恢复。确定要提交注销申请吗？"
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self performAccountDeletion];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)performAccountDeletion
{
    //best-effort 通知后端删号（不依赖返回；后端未就绪时也不阻塞注销流程）
    [[RootHttpHelper httpHelper] achieveCommonPostURL:@"users/logoff" andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {}];
    //当场登出：清 token + 清缓存，账号视为已进入注销流程
    [[RootHttpHelper httpHelper] setUserToken:@""];
    SharedAppDelegate.userModel.token = nil;
    [SharedAppDelegate removeAllDefaultData];
    UIAlertController *done = [UIAlertController alertControllerWithTitle:@"已提交注销申请"
        message:@"我们将在15个工作日内完成账号注销与数据删除。" preferredStyle:UIAlertControllerStyleAlert];
    [done addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginView];
        SharedAppDelegate.window.rootViewController = nav;
    }]];
    [self presentViewController:done animated:YES completion:nil];
}



#pragma mark - 退出登录
- (IBAction)logoutAction:(UIButton *)sender
{
    //NSLog(@"+++++++++++++++退出登录");
    //退出登录
    exitAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [exitAlertView show];
}

#pragma mark - UIAlertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(alertView == exitAlertView)       //退出登录
    {
        //判断用户点击了那个按钮, 根据索引来判断, 可在此添加不同索引下的响应事件,
        NSLog(@"++++++++++退出登录%@",[[NSString alloc] initWithFormat:@"第%ld个按钮", (long)buttonIndex]);
        if(buttonIndex == 1)
        {
            [[RootHttpHelper httpHelper] achieveCommonPostURL:users_logout andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {   
                [[RootHttpHelper httpHelper] setUserToken:@""];
                SharedAppDelegate.userModel.token = nil;
                ///清除存在userDefault中的缓存值
                [SharedAppDelegate removeAllDefaultData];
                
//                //1.10 退出账号的时候需要断开私信xmpp的连接
//                [SharedAppDelegate disconnectFromXMPP];
                
                //1.18 退出账号的时候删除当前账号发送的message私信的信息   !!!!!!!!!!!!
//                [[UserDBHelper userDBHelper] deleteMsg:SharedAppDelegate.userModel.user.id];
                
                LoginEntryViewController *loginView = [[LoginEntryViewController alloc] init];
                UINavigationController * navigationView = [[UINavigationController alloc]initWithRootViewController:loginView];
                SharedAppDelegate.window.rootViewController = navigationView;
            }];
        }
        else
        {
            
        }
    }
}

#pragma mark - Switch按钮点击事件
- (void)switchAction:(UISwitch *)sender
{
    isButtonOn = [sender isOn];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (!isButtonOn)
    {
        //NSLog(@"++++++++++++取消推送");
        [params setValue:@"0" forKey:@"on_off"];
    }
    else
    {
        //NSLog(@"++++++++++++打开推送");
        [params setValue:@"1" forKey:@"on_off"];
        
    }
    //1010
    [[RootHttpHelper httpHelper] achieveCommonPostURL:UserSwitchPushLive andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
        
       // NSLog(@"+++++++++++++请求到的数据: %@",successData);
        if (!isButtonOn)
        {
            //NSLog(@"++++++++++++取消推送");
            [[MessageHelper messageHelper] showSuccessMessage:self title:nil sub:@"推送已关闭"];
        }
        else
        {
           // NSLog(@"++++++++++++打开推送");
            [[MessageHelper messageHelper] showSuccessMessage:self title:nil sub:@"推送已打开"];
        }
    }];
    //调用开关接口
}
- (IBAction)weixinBangDing:(id)sender
{
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"AppSettingsViewController dealloc");
}

- (void)setAdolescentState {
    if ([self.appDelegate.userModel.user.young_pwd isEqualToString:@""]) {
        self.adolescentStateLab.text = @"未开启";
    } else {
        self.adolescentStateLab.text = @"已开启";
    }
}


// 进去设置青少年模式页面
- (IBAction)setAdolescentModelBtnAction:(id)sender {
}

@end

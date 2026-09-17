//
//  InviteView.m
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "InviteView.h"
#import "Constants.h"
#import "HudHelper.h"
#import "RootHttpHelper.h"
@implementation InviteView
@synthesize backImg,title,closeBtn,tfImg,TF,placeHolder,sureBtn;

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
     //背景图片
        if(backImg==nil)
        {
            backImg=[[UIImageView alloc] init];
            backImg.bounds=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            backImg.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            backImg.image=[UIImage imageNamed:@"cardBack"];
            backImg.userInteractionEnabled=YES;
        }

    //标题
        if (title==nil) {
            
            title=[[UILabel alloc] init];
            title.font = [UIFont fontWithName:@"STYuanti-SC-Regular" size:18];
            title.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
            title.textAlignment=NSTextAlignmentCenter;
            title.frame=CGRectMake(0, 47*ScreenBiLi, self.frame.size.width, 25*ScreenBiLi);
            title.text = [NSString stringWithFormat:@"欢迎来到%@",AppName];
            [self.backImg addSubview:self.title];
        }
        
    //输入框
        if (tfImg==nil) {
            tfImg=[[UIImageView alloc] init];
            tfImg.userInteractionEnabled=YES;
            tfImg.frame=CGRectMake(44*ScreenBiLi, 160*ScreenBiLi, 215*ScreenBiLi, 40*ScreenBiLi);
            tfImg.image=[UIImage imageNamed:@"cardTF"];
            [self.backImg addSubview:self.tfImg];
        }
        
        if (TF==nil) {
            TF=[[UITextField alloc] init];
            TF.backgroundColor=[UIColor clearColor];
            TF.delegate=self;
            TF.clearButtonMode = UITextFieldViewModeAlways;         //清零
            TF.keyboardType = UIKeyboardTypeNumberPad;
            TF.returnKeyType =UIReturnKeyDone;
            TF.frame=CGRectMake(44*ScreenBiLi, 160*ScreenBiLi, 215*ScreenBiLi, 40*ScreenBiLi);
            TF.textAlignment=NSTextAlignmentCenter;
            TF.textColor=[UIColor colorWithRed:245/255.0 green:106/255.0 blue:173/255.0 alpha:1/1.0];
            TF.font=[UIFont fontWithName:@".PingFang-SC-Regular" size:20];
            [self.backImg addSubview:self.TF];
        }
       
    //输入框文字
        if (placeHolder==nil) {
            placeHolder=[[UILabel alloc] init];
            placeHolder.text = @"请输入邀请码";
            placeHolder.font = [UIFont fontWithName:@".PingFang-SC-Regular" size:16];
            placeHolder.textColor = [UIColor colorWithHex:0x5939FE];
            placeHolder.textAlignment=NSTextAlignmentCenter;
            placeHolder.frame=CGRectMake(0, 169*ScreenBiLi, self.frame.size.width, 22*ScreenBiLi);
            [self.backImg addSubview:self.placeHolder];
        }

        
    //按钮
        if (sureBtn==nil) {
            sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [sureBtn setBackgroundImage:[UIImage imageNamed:@"cardSureBtn"] forState:0];
            [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
            sureBtn.frame=CGRectMake(60*ScreenBiLi, 295*ScreenBiLi, 184*ScreenBiLi, 44*ScreenBiLi);
            [self.backImg addSubview:self.sureBtn];
        }

    //关闭按钮

        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6];
        [self addSubview:self.backImg];
        
    }
    return self;
}
#pragma mark - 输入结束时代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    placeHolder.text=@"";
    if (textField==TF) {
        [TF becomeFirstResponder];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [TF resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [TF endEditing:YES];
}

- (void)sureBtnClick
{
    if ([TF.text isEqualToString:@""]) {
         [[HudHelper hudHepler]showShortTips:self tips:@"邀请码不能为空哦😝"];
    }
    else
    {
        NSString *tuijian = self.TF.text;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:tuijian forKey:@"tuijianren"];
        //更新用户信息
        [[RootHttpHelper httpHelper] achieveCommonPostURL:revamp_users andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
            
            if ([successData[@"api_code"] intValue]==500)
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = successData[@"api_msg"];
                hud.margin = 20.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
            }
            else
            {
                [self closeBtnClick];
            }
        }];
    
    }
    
}
- (void)closeBtnClick
{
    [self endEditing:YES];
    [self removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"yaoqingma"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

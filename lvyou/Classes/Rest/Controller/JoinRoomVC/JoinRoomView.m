//
//  JoinRoomViewController.m
//  jushi
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "JoinRoomView.h"
#import "WLUnitField.h"

@interface JoinRoomView()<WLUnitFieldDelegate>
{
    UITextField *numTF;
}

@property (strong, nonatomic) WLUnitField *unitField;

@end

@implementation JoinRoomView
@synthesize delegate;


- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    //高斯模糊背景图片
    UIImageView *backgroundImg=[[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundImg.userInteractionEnabled=YES;
    backgroundImg.image=[UIImage imageNamed:@"icon_user_begin_live"];
    [self addSubview:backgroundImg];
    
    // 背景卡片
    UIImageView *cardBackImg=[[UIImageView alloc] initWithFrame:CGRectMake(12*ScreenBiLi, 127*ScreenBiLi, 351*ScreenBiLi, 248*ScreenBiLi)];
    cardBackImg.userInteractionEnabled=YES;
    [backgroundImg addSubview:cardBackImg];
    ///使用第三方
                cardBackImg.image=[UIImage imageNamed:@"mimaCardFour"];
             _unitField=[[WLUnitField alloc] initWithFrame:CGRectMake(78*ScreenBiLi, 63*ScreenBiLi, 200*ScreenBiLi, 50*ScreenBiLi)];//4位密码
            for (int i=0; i<4; i++)
            {
                UILabel *textLab=[[UILabel alloc] initWithFrame:CGRectMake(65*ScreenBiLi+i*(50*ScreenBiLi+7), 63*ScreenBiLi, 50*ScreenBiLi, 50*ScreenBiLi)];//4位
                textLab.text=_unitField.text;
                textLab.textAlignment=NSTextAlignmentCenter;
                textLab.font=[UIFont systemFontOfSize:20.0f];
                [_unitField becomeFirstResponder];
                [cardBackImg addSubview:textLab];
            }

    _unitField.delegate = self;
    [cardBackImg addSubview:_unitField];
    
    //    确定
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(61*ScreenBiLi, 183*ScreenBiLi, 230*ScreenBiLi, 37*ScreenBiLi);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"sureBtn"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cardBackImg addSubview:sureBtn];
    
    // 关闭按钮
    UIButton *closeRoomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeRoomBtn.frame=CGRectMake(335*ScreenBiLi, 120*ScreenBiLi, 40*ScreenBiLi, 40*ScreenBiLi);
    [closeRoomBtn setBackgroundImage:[UIImage imageNamed:@"closeVC"] forState:UIControlStateNormal];
    [closeRoomBtn addTarget:self action:@selector(closeRoomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeRoomBtn];
}

//返回上一页
- (void)closeRoomBtnClick
{
    [(BaseLiveViewController *)delegate dismiss];
}

- (void)sureBtnClick
{
    //进入房间
    if(delegate &&[delegate respondsToSelector:@selector(onPwdInput:)])
    {
        //进入房间
        [(BaseLiveViewController *)delegate onPwdInput:_unitField.text];
    }
}

- (BOOL)unitField:(WLUnitField *)uniField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [uniField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"text==******>%@", text);
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

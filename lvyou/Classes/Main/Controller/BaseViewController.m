// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  BaseViewController.m
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "BaseViewController.h"
#import "RankPeopleModel.h"
#import "shili-Swift.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = SharedAppDelegate;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [AppDelegate appDelegate].navCtr = self.navigationController;
    }
}

- (NSURL *)placeImg:(NSString*)addr
{
    //判断是不是全路径
    if([[ToolHelper toolHelper] ReplacingCharActer:addr]){
       //全路径
        return [NSURL URLWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
    }else{
       //拼接路径
       return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",IMAGEAPI,addr]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}

+ (NSURL *)placeImg2:(NSString*)addr
{
    //判断是不是全路径
    if([[ToolHelper toolHelper] ReplacingCharActer:addr]){
        //全路径
        return [NSURL URLWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
    }else{
        //拼接路径
        return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",IMAGEAPI,addr]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (NSURL *)placeCorpsImg:(NSString*)addr
{
    //判断是不是全路径
    if([[ToolHelper toolHelper] ReplacingCharActer:addr]){
        //全路径
        return [NSURL URLWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
    }else{
        //        拼接路径
        return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",IMAGEAPI,addr]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

}

- (UIImage *)placeDefaultImg
{
    return [UIImage imageNamed:@"icon_login_head"];
}

- (NSString *)stringTheme:(NSString*)title
{
    return [NSString stringWithFormat:@"#%@#",title];
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Handle URL Scheme
- (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"] ?: [bundleInfo valueForKey:@"CFBundleName"];
}

- (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes) {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier]) {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    return scheme;
}

- (BOOL)isBlankString:(NSString *)string
{
    if (!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
//copy from im baseviewcontroller
- (void)addTapBlankToHideKeyboardGesture;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBlankToHideKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}
- (void)onTapBlankToHideKeyboard:(UITapGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    }
}
//显示贵族
- (void)showTheGuiZu:(UIImageView *)imgView With:(NSString *)guizu
{
    if (![self isBlankString:guizu]) {
        int i = [guizu intValue];
        if (i > 0 && i < 7) {
            imgView.hidden = NO;
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_gui%d",i]];
        } else {
            imgView.hidden = YES;
        }
    } else {
        imgView.hidden = YES;
    }
}

//显示vip
- (void)showTheVip:(UIImageView *)imgView With:(NSString *)vip_util With:(NSString *)viplevel
{
    double vipTime = [vip_util doubleValue];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970] / 1000;
    if (now > vipTime) {
        //vip已过期
        imgView.hidden = YES;
    }
    else{
        imgView.hidden =NO;
        //vip未过期  显示vip
        if ([viplevel intValue]==1)
        {
            imgView.image=[UIImage imageNamed:@"icon_yellowvip"];
        }
        else if ([viplevel intValue]==2)
        {
            imgView.image=[UIImage imageNamed:@"icon_purplevip"];
        }
        else if ([viplevel intValue]==3)
        {
            imgView.image=[UIImage imageNamed:@"icon_blackvip"];
        }
    }
}


//主播获得
- (void)showThePiao:(UILabel *)madouLab With:(NSString *)totalPoint//主播得到
{
    NSString *numbers =totalPoint;
    //    if ([numbers intValue]>10000)
    //    {
    //        NSString *ticket=[NSString stringWithFormat:@"%.2f万",[numbers floatValue]/10000];
    //        madouLab.text=ticket;
    //        if ([numbers intValue]>100000000)
    //        {
    //            NSString *ticket=[NSString stringWithFormat:@"%.2f亿",[numbers floatValue]/100000000];
    //            madouLab.text=ticket;
    //
    //        }
    //    }
    //    else
    //    {
    madouLab.text =[NSString stringWithFormat:@"%@:%@",[self jiFenNum],numbers];
    //    }
}
- (NSString *)livingname
{
    NSString *liveName;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"usernumber_name"] isEqualToString:@""]||[[NSUserDefaults standardUserDefaults]objectForKey:@"usernumber_name"]==nil)
    {
        liveName=[NSString stringWithFormat:@"%@",@"直播号"];
    }
    else
    {
        liveName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"usernumber_name"]];
    }
    return liveName;
}

- (NSString *)moneyname
{
    NSString *moneyName;
    if ([self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"money_name"]])
    {
        moneyName=[NSString stringWithFormat:@"%@",@"金币"];
    }
    else
    {
        moneyName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"money_name"]];
    }
    return moneyName;
}

- (NSString *)jiFenNum
{
    NSString *string=@"";
    if ([self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"money_name2"]])
    {
        string=[NSString stringWithFormat:@"积分"];
        
    }
    else
    {
        string=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"money_name2"]];
    }
    return string;
}

//带下划线显示不同颜色的等级
- (void)showThelevel:(NSString *)randid and:(UIImageView *)levelimg and:(UILabel *)levelLab isZhuBo:(BOOL)isZhuBo
{
    NSString *realLevel=randid;
    if ([randid containsString:@"_"]) {
        NSArray *tempArr=[randid componentsSeparatedByString:@"_"];
        if (tempArr.count>0) {
            realLevel=tempArr[0];
        }
    }
    
    RankPeopleModel *rankModel = [[RankPeopleModel alloc] initWithDictionary:[isZhuBo?SharedAppDelegate.zhuboRankDic:SharedAppDelegate.rankDic objectForKey:realLevel] error:nil];
                [levelimg sd_setImageWithURL:[self placeImg:rankModel.img] placeholderImage:nil];
            levelLab.text = realLevel;

    levelLab.hidden=YES;
}

- (void)pushToBannerWebWithLoadUrl:(NSString *)loadurl withTitle:(NSString *)titlelab andShareUrl:(NSString *)imgurl
{
}


// 根据所定义的id获取渐变颜色数组
- (NSArray *)gradientColorImageFromColorsWith:(NSInteger)index {
    NSArray *colors;
    switch (index) {
        case 1:colors = @[[UIColor colorWithHex:0xFAD961],[UIColor colorWithHex:0xF76B1C]];break;
        case 2:colors = @[[UIColor colorWithHex:0xFCCB90],[UIColor colorWithHex:0xFF6AB7]];break;
        case 3:colors = @[[UIColor colorWithHex:0xC86DD7],[UIColor colorWithHex:0x3023AE]];break;
        case 4:colors = @[[UIColor colorWithHex:0x42F7D6],[UIColor colorWithHex:0x1880F1]];break;
        case 5:colors = @[[UIColor colorWithHex:0xFF8997],[UIColor colorWithHex:0xFF1761]];break;
        case 6:colors = @[[UIColor colorWithHex:0xFE8C57],[UIColor colorWithHex:0xFE4F4F]];break;
        case 7:colors = @[[UIColor colorWithHex:0x33FFE1],[UIColor colorWithHex:0x002DCB]];break;
        case 8:colors = @[[UIColor colorWithHex:0xE1FF33],[UIColor colorWithHex:0x00CBB9]];break;
        case 9:colors = @[[UIColor colorWithHex:0xFFE5A9],[UIColor colorWithHex:0xE6AA7C]];break;
        case 10:colors = @[[UIColor colorWithHex:0xA9B4FF],[UIColor colorWithHex:0xCA4998]];break;
        default:colors = @[[UIColor colorWithHex:0xFAD961],[UIColor colorWithHex:0xF76B1C]];break;
    }
    return colors;
}

-(CGFloat)getWidthWithString:(NSString*)str font:(UIFont*)font{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize detailSize = [str sizeWithAttributes:dict];
    return detailSize.width;
}

//获取字符串的宽度

-(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{

    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;

}

-(float)widthForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{

    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;

}

// 更新缓存关注列表
- (void)setFollowListIsRemove:(BOOL)isRemove andUserid:(NSString *)userid {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *followArr = [[userdefault objectForKey:@"FollowArray"] mutableCopy];
    if (!followArr) {
        followArr = [NSMutableArray array];
    }
    if (isRemove) {
        if ([followArr containsObject:userid]) {
            [followArr removeObject:userid];
        }
    } else {
        if (![followArr containsObject:userid]) {
            [followArr addObject:userid];
        }
    }
    [userdefault setValue:followArr forKey:@"FollowArray"];
    [userdefault synchronize];
}


#pragma mark - Data Source Implementation
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"icon_list_empotydata"];
}



- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0f;
}

#pragma mark  Delegate Implementation
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

-(NSString *)notRounding:(double)price afterPoint:(int)position{

    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];

    NSDecimalNumber *ouncesDecimal;

    NSDecimalNumber *roundedOunces;

    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];

    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];

//    [ouncesDecimal release];

    return [NSString stringWithFormat:@"%@",roundedOunces];

}
@end

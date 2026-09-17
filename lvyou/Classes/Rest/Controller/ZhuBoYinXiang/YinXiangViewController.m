// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2017 Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com.cn
//
// ///////////////////////////////////////////////////////////////////////////
//
//  NicknameEditViewController.m
//  beibei
//
//  Created by apple on 16/7/9.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "YinXiangViewController.h"
#import "Constants.h"

#define random(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface YinXiangViewController ()
{
    XiangModel *yinxiangModel;
}
@property (strong, nonatomic)UIButton * saveButton;

@end

@implementation YinXiangViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}
- (void)requestTagTitle
{
    NSString *url=[NSString stringWithFormat:@"zhuboyingxiang?&roomnumber=%@&token=%@",self.roomNumber,SharedAppDelegate.userModel.token];
    if (_titles==nil) {
        _titles=[NSMutableArray array];
    }
    //更新用户信息
    [[RootHttpHelper httpHelper] achieveCommonPostURL:url andController:self andView:self.view andParams:nil andSuccess:^(NSDictionary *successData) {
        [_titles removeAllObjects];
        if ([successData[@"api_code"] intValue]==200)
        {
            for (NSMutableDictionary *dic in successData[@"data"])
            {
                yinxiangModel=[[XiangModel alloc] initWithDictionary:dic error:nil];
                [_titles addObject:yinxiangModel];
            }
            [self setUpTitles];
        }
    }];
}
#pragma mark - View从superView中移除时
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (void)initView
{
    //保存按钮
    NSString *title=@"保存";
    CGSize btnSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0)
                                         options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.saveButton.frame = CGRectMake(0, 0, btnSize.width, 30);
    [self.saveButton addTarget: self action: @selector(saveBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.saveButton setTitle:title forState:UIControlStateNormal];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 10*ScreenBiLi, SCREEN_WIDTH, 30*ScreenBiLi)];
    titleLab.font=[UIFont systemFontOfSize:22.0f];
    titleLab.text=@"选择你对主播的印象";
    titleLab.textColor=[UIColor colorWithRed:105/255.0 green:117/255.0 blue:122/255.0 alpha:1];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    UILabel *contentLab=[[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40*ScreenBiLi-NavigationBar_HEIGHT, SCREEN_WIDTH, 20*ScreenBiLi)];
    contentLab.font=[UIFont systemFontOfSize:14.0f];
    contentLab.text=@"选择你对主播的印象,可以帮助主播上热门哦";
    contentLab.textColor=[UIColor colorWithRed:105/255.0 green:117/255.0 blue:122/255.0 alpha:1];
    contentLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:contentLab];
    
    self.scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, titleLab.frame.origin.y+titleLab.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-titleLab.frame.size.height-contentLab.frame.size.height-NavigationBar_HEIGHT-40*ScreenBiLi)];
    self.scroll.backgroundColor=[UIColor whiteColor];
    self.scroll.showsVerticalScrollIndicator=NO;
    self.scroll.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.scroll];
    [self requestTagTitle];
    
}
- (void)setUpTitles{
    
    CGFloat w = 108*ScreenBiLi;//[UIScreen mainScreen].bounds.size.width / 4
    CGFloat h = 40*ScreenBiLi;
    CGFloat margin = 10*ScreenBiLi;
    
    NSMutableArray *jArr = [NSMutableArray array];
    NSMutableArray *oArr = [NSMutableArray array];
    
    //创建所有的按钮
    for (NSInteger i = 0; i < self.titles.count; i++) {
        XiangModel* yinxiang=self.titles[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scroll addSubview:button];
        button.tag = i + 100;
        //判断按钮所处的是偶数排还是奇数排
        if (i / 4 % 2 == 0) {
            [oArr addObject:button];
        }else{
            [jArr addObject:button];
        }
        
        [button setTitle:yinxiang.name forState:UIControlStateNormal];
        [button setTitleColor:randomColor forState:UIControlStateNormal];
        //[button setTitleColor:randomColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 20*ScreenBiLi;
        button.layer.masksToBounds = YES;
        //边框颜色
        button.layer.borderColor = [randomColor CGColor];
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    //设置偶数排的frame
    for (UIButton *button in oArr) {
        CGFloat x = ((button.tag - 100) % 4) * (w + margin) - w/3;
        CGFloat y = ((button.tag - 100) / 4) * (h + margin) + margin;
        
        button.frame = CGRectMake(x, y, w, h);
        
    }
    //设置奇数排的frame
    for (UIButton *button in jArr) {
        CGFloat x = ((button.tag - 100) % 4) * (w + margin) + margin;
        
        CGFloat y = ((button.tag - 100) / 4) * (h + margin) + margin;
        
        button.frame = CGRectMake(x, y, w, h);
    }
    self.scroll.contentSize = CGSizeMake(4 * w + 5 * margin + 0.5 * w, (h+margin)*(self.titles.count/4+1));//按钮高度+间距*行数
}

- (void)selectTitle:(UIButton *)button{
    
    //8.25 修改
    yinxiangModel=_titles[button.tag-100];
    //多选
    if (!button.selected) {////选中状态
        [button setBackgroundColor:randomColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.selectArr addObject:yinxiangModel.id];
        NSLog(@"==我被选中了==");
    }else{ ////取消选中状态
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:randomColor forState:UIControlStateNormal];
        if ([self.selectArr containsObject:yinxiangModel.id]) {
            [self.selectArr removeObject:yinxiangModel.id];
            NSLog(@"==我被取消了==");
        }
    }
    
    button.selected = !button.selected;
    //    if (!button.selected) {
    //
    //        if (self.selectArr.count < 3) {
    //            [button setBackgroundColor:_rgbColor[button.tag-100]];
    //            [self.selectArr addObject:[NSString stringWithFormat:@"%ld",button.tag]];
    //        }else{
    //            NSString *indexStr = self.selectArr[0];
    //            NSInteger index = [indexStr integerValue];
    //            UIButton *btn = self.scroll.subviews[index - 100];
    //            [btn setBackgroundColor:[UIColor whiteColor]];
    //            btn.selected = NO;
    //            [self.selectArr removeObject:[NSString stringWithFormat:@"%ld",btn.tag]];
    //            [button setBackgroundColor:_rgbColor[btn.tag-100]];
    //            [self.selectArr addObject:[NSString stringWithFormat:@"%ld",button.tag]];
    //            XiangModel *yinxiang=_titles[index-100];
    //            [self.selectArr addObject:yinxiang.id];
    //        }
    //    }else{
    //
    //        if ([self.selectArr containsObject:[NSString stringWithFormat:@"%ld",button.tag]]) {
    //
    //            [self.selectArr removeObject:[NSString stringWithFormat:@"%ld",button.tag]];
    //        }
    //    }
    //
    //    button.selected = !button.selected;
}

- (void)saveBtnClick:(UIButton *)sender
{
    if (self.selectArr.count==0)
    {
        [[MessageHelper messageHelper]showMessage:self title:@"" sub:@"没有选择印象标签不能保存哦"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //以逗号分隔数组
    [params setValue:[self.selectArr componentsJoinedByString:@","] forKey:@"yinxiang"];
    
    //更新用户信息
    NSString *url=[NSString stringWithFormat:@"zhuboyingxiang_set?&roomnumber=%@&token=%@",self.roomNumber,SharedAppDelegate.userModel.token];
    [[RootHttpHelper httpHelper] achieveCommonPostURL:url andController:self andView:self.view andParams:params andSuccess:^(NSDictionary *successData) {
        
        ///            后台返回500表示昵称修改错误 不做任何操作
        if ([successData[@"api_code"] intValue]==200)
        {
            [[MessageHelper messageHelper]showSuccessMessage:self title:@"" sub:successData[@"api_msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }       
    }];
}
- (void)dealloc
{
    NSLog(@"YinXiangViewController dealloc");
}
@end

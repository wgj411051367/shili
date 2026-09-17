//
//  InviteView.m
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "BuyGuiZu.h"
#import "Constants.h"
#import "BaseLiveViewController.h"
#import "GuiBinModel.h"
#import "NobleCell.h"
#import "RankPeopleModel.h"
#import "NobleModel.h"

@implementation BuyGuiZu
@synthesize backView,titleLab,guibinView,renqiLab,guibinLab,guibinImg,textLab,buyBtn,guibinTable,delegate;

- (instancetype)initWithFrame:(CGRect)frame andGuiZuNum:(NSString *)guizu_num andRenQi:(int)renqiNum andRoomnumber:(NSString *)roomNumber andArr:(NSMutableArray *)dataArr
{
    
    if (self = [super initWithFrame:frame]) {
        //背景view
        if(backView==nil)
        {
            backView=[[UIView alloc] init];
            backView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            backView.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            backView.backgroundColor=[UIColor whiteColor];
            backView.userInteractionEnabled=YES;
            backView.layer.cornerRadius=5;
            backView.layer.masksToBounds=YES;
        }
        //标题
        if (titleLab==nil) {
            titleLab=[[UILabel alloc] init];
            titleLab.frame=CGRectMake(0, 11*ScreenBiLi, self.backView.frame.size.width, 20*ScreenBiLi);
            titleLab.text=@"贵宾席";
            titleLab.textColor=RGBACOLOR(77, 77, 77, 1);
            titleLab.textAlignment=NSTextAlignmentCenter;
            titleLab.font=[UIFont systemFontOfSize:15.0f];
            [self.backView addSubview:self.titleLab];
        }
        //贵宾
        if (guibinLab==nil) {
            NSString *guibinNum=[NSString stringWithFormat:@"贵宾:%@",guizu_num];
            CGSize guibinSize = [guibinNum boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:nil context:nil].size; //boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0)options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size
            guibinLab=[[UILabel alloc] init];
            guibinLab.frame=CGRectMake(self.backView.frame.size.width-15*ScreenBiLi-guibinSize.width, 18*ScreenBiLi, guibinSize.width, 10*ScreenBiLi);
            guibinLab.text=guibinNum;
            guibinLab.textColor=RGBACOLOR(77, 77, 77, 1);
            guibinLab.textAlignment=NSTextAlignmentLeft;
            guibinLab.font=[UIFont systemFontOfSize:10.0f];
            [self.backView addSubview:self.guibinLab];
        }
        //人气
        if (renqiLab==nil) {
            NSString *renqi=[NSString stringWithFormat:@"人气:%d",renqiNum];
            CGSize renqiNumSize = [renqi boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:nil context:nil].size;//[renqi boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0)options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
            renqiLab=[[UILabel alloc] init];
           renqiLab.frame=CGRectMake(self.backView.frame.size.width-15*ScreenBiLi-guibinLab.frame.size.width-renqiNumSize.width-10*ScreenBiLi, 18*ScreenBiLi, renqiNumSize.width, 10*ScreenBiLi);
            renqiLab.text=renqi;
            renqiLab.textColor=RGBACOLOR(77, 77, 77, 1);
            renqiLab.textAlignment=NSTextAlignmentLeft;
            renqiLab.font=[UIFont systemFontOfSize:10.0f];
            [self.backView addSubview:self.renqiLab];
        }
        //贵宾view
        if (guibinView==nil) {
            guibinView=[[UIView alloc] init];
            guibinView.frame=CGRectMake(0, 42*ScreenBiLi, self.backView.frame.size.width, 35*ScreenBiLi);
            guibinView.backgroundColor=RGBACOLOR(190, 63, 237, 0.2);
            guibinView.userInteractionEnabled=YES;
            [self.backView addSubview:guibinView];
        }
        if (guibinImg==nil) {
            guibinImg=[[UIImageView alloc] init];
            guibinImg.frame=CGRectMake(6*ScreenBiLi, 10*ScreenBiLi, 16*ScreenBiLi, 12*ScreenBiLi);
            guibinImg.image=[UIImage imageNamed:@"huangguan"];
            [self.guibinView addSubview:guibinImg];
        }
        //贵宾/粉丝团可上座
        if (textLab==nil) {
            NSString *textStr=@"贵宾/粉丝团可上座";
            CGSize textSize = [textStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            textLab=[[UILabel alloc] init];
         textLab.frame=CGRectMake(guibinImg.frame.size.width+guibinImg.frame.origin.x+4*ScreenBiLi, 10*ScreenBiLi, textSize.width, 15*ScreenBiLi);
            textLab.text=textStr;
            textLab.textColor=RGBACOLOR(190, 63, 237, 1);
            textLab.textAlignment=NSTextAlignmentLeft;
            textLab.font=[UIFont systemFontOfSize:12.0f];
            [self.guibinView addSubview:self.textLab];
        }
        //开通按钮
        if (buyBtn==nil) {
            buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            buyBtn.frame=CGRectMake(self.backView.frame.size.width-self.backView.frame.size.width/4-8*ScreenBiLi,10*ScreenBiLi, self.backView.frame.size.width/4, 15*ScreenBiLi);
            [buyBtn setTitle:@"开通贵族 >" forState:0];
            [buyBtn setTitleColor:RGBACOLOR(190, 63, 237, 1) forState:0];
            buyBtn.titleLabel.font=[UIFont systemFontOfSize:12.0f];
            buyBtn.titleLabel.textAlignment=NSTextAlignmentRight;
            [buyBtn addTarget:self action:@selector(kaiTongGuiBinBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.guibinView addSubview:self.buyBtn];
        }
        if (_buyBtnTwo==nil) {
            buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            buyBtn.frame=CGRectMake(0, 10*ScreenBiLi, self.guibinView.frame.size.width, 15*ScreenBiLi);
            [buyBtn addTarget:self action:@selector(kaiTongGuiBinBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.guibinView addSubview:self.buyBtn];
        }
        if (_DataArray==nil) {
            _DataArray=[NSMutableArray array];
            _DataArray=dataArr;
        }
        if (guibinTable==nil) {
            guibinTable =[[UITableView alloc] initWithFrame:CGRectMake(0, 77*ScreenBiLi, self.backView.frame.size.width, self.backView.frame.size.height-77*ScreenBiLi) style:UITableViewStylePlain];
            guibinTable.delegate   = self;
            guibinTable.dataSource = self;
            guibinTable.separatorStyle = UITableViewScrollPositionNone;
            guibinTable.backgroundColor=[UIColor whiteColor];
            guibinTable.rowHeight=50;
            [self.backView addSubview:guibinTable];
        }
        //房间号
        roomnumber=roomNumber;
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.userInteractionEnabled=YES;
        [self addSubview:self.backView];
    }
    return self;
}
#pragma mark - TableView的代理方法
#pragma mark - 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NobleCell * rCell = [NobleCell cellWithTableView:tableView];
    [self configHotCell:rCell atIndexPath:indexPath];
    return rCell;
}

#pragma mark - 设置Cell内容
-(void)configHotCell:(NobleCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //9.27 添加判断防止崩溃
    if (indexPath.row>_DataArray.count) {
        return;
    }
    NobleModel*guibin = _DataArray[indexPath.row];
    cell.headView.contentMode = UIViewContentModeScaleAspectFill;
    cell.headView.clipsToBounds = YES;
    [cell.headView sd_setImageWithURL:[self placeImg:[[ToolHelper toolHelper] realAvatarUrl:guibin.userid andUpdate:guibin.update_avatar_time]] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
    //2018.10.31显示等级
    [self showThelevel:guibin.richlevel and:cell.levelImg and:cell.levelNum];
    cell.name.text = guibin.nickname;
    if (![guibin.guizhu isKindOfClass:[NSNull class]]) {
        cell.guibinImg.hidden = NO;
        cell.guibinImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"icon_gui%d",[guibin.guizhu intValue]]];
    }
}
//显示等级部分
- (void)showThelevel:(NSString *)randid and:(UIImageView *)levelimg and:(UILabel *)levelLab
{
    NSString *realLevel=randid;
    if ([randid containsString:@"_"]) {
        NSArray *tempArr=[randid componentsSeparatedByString:@"_"];
        if (tempArr.count>0) {
            realLevel=tempArr[0];
        }
    }
    RankPeopleModel *rankModel = [[RankPeopleModel alloc] initWithDictionary:[SharedAppDelegate.rankDic objectForKey:realLevel] error:nil];
                [levelimg sd_setImageWithURL:[self placeImg:rankModel.img] placeholderImage:nil];
            levelLab.text = realLevel;

    levelLab.hidden=YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -------跳转开通贵族页面
- (void)kaiTongGuiBinBtnClick
{
    if(delegate &&[delegate respondsToSelector:@selector(kaiTongGuiBinBtn)])
    {
        [(BaseLiveViewController *)delegate kaiTongGuiBinBtn];
    }
   [self closeView];
}
#pragma mark -------移除页面
- (void)closeView
{
    [UIView animateWithDuration:0.2 animations:^{
        [self removeFromSuperview];
    }];
}

- (NSURL *)placeImg:(NSString*)addr
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
- (void)dealloc
{
    
}

@end

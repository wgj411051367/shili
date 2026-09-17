//
//  nbPackView.m
//  RedPacketDemo
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TheMoreView.h"
#import "UserInfoModel.h"
#import "SDWebImage.h"
#import "ToolHelper.h"
#import "BaseLiveViewController.h"
#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface TheMoreView ()<UIScrollViewDelegate>
{
    UIScrollView *scroll;
    UIPageControl *pageShow;
}
@end
@implementation TheMoreView
@synthesize backImg,delegate,isGame;

-(instancetype)initWith
{
    self=[super init];
    if (self) {
        
        self.frame=CGRectMake(0, HEIGHT-248*ScreenBiLi, WIDTH, 248*ScreenBiLi);
//        self.backImg.frame=CGRectMake(0, self.frame.size.height ,WIDTH,248*ScreenBiLi);
//        self.backImg=[[UIImageView alloc]init];
//        if (isGame==YES)
//        {
//
//            self.backImg.image=[UIImage imageNamed:@"gameBackground"];
//        }
//        if (self.isLiveGame==YES)
//        {
//            self.backImg.image=[UIImage imageNamed:@"gameBackground"];
//        }
//        else
//        {
//            self.backImg.image=[UIImage imageNamed:@"beijingtupian"];
//        }
//        self.backImg.userInteractionEnabled=YES;
//        //8.7
////        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTheMoreView)];
////        [self addGestureRecognizer:singleTap];
//        [self addSubview:self.backImg];
        
    }
    return self;
}

- (void)initWithMoreArray:(NSArray *)imageArr andTitle:(NSArray *)titleArr
{
    if (self)
    {
        if (scroll) {
            [scroll removeFromSuperview];
        }
        CGFloat height = 100*(imageArr.count/4 + (((imageArr.count%4)>0)?1:0));
        self.frame=CGRectMake(0, HEIGHT-height-50*ScreenBiLi, SCREEN_WIDTH, height+50*ScreenBiLi);
        scroll = [[UIScrollView alloc]init];
        
//        CGFloat height = 100*(imageArr.count/4 + imageArr.count%4);
        scroll.frame=CGRectMake(15, 0, WIDTH-30, height+20*ScreenBiLi);
//        scroll.contentSize = CGSizeMake(ceil((imageArr.count)/8.0f)*WIDTH, 0);
        scroll.bounces = NO;
        scroll.pagingEnabled = YES;
        scroll.delegate = self;
        scroll.backgroundColor=[UIColor colorWithHex:0xFFFFFF];
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.layer.cornerRadius = 20;
        scroll.layer.masksToBounds = YES;
        [self addSubview:scroll];
        if (pageShow) {
            [pageShow removeFromSuperview];
        }
//        pageShow = [[UIPageControl alloc]init];//h=20
//        pageShow.bounds=CGRectMake(0, 0, 60, 10);
//        pageShow.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-20);
//        pageShow.currentPage=0;
//        pageShow.currentPageIndicatorTintColor =[UIColor colorWithRed:255.0/255 green:215.0/255 blue:100.0/255 alpha:1];
//        pageShow.pageIndicatorTintColor =[UIColor whiteColor];
//        pageShow.numberOfPages = ceil((imageArr.count)/8.0f);
//        [self addSubview:pageShow];
        
        for (int i = 0; i < imageArr.count; i ++)
        {
            NSString *img=imageArr[i];
            NSString *title=titleArr[i];
            //总共多少页
            int page =0;
            //多少行
            int row = i/(imageArr.count) + i/4 ;
//            if ((i%8)<=4) {
//                //               1--4的时候设置为0行
//                row=0;
//            }
//            else{
//                //               5--8的时候设置为1行
//                row=1;
//            }
            //            多少列
            int col =(i%4);
            //礼物列表的排列
            MoreDetailView *detailview =[[MoreDetailView alloc] initWithFrame:CGRectMake(((WIDTH-30)/4)*col+page*WIDTH, row*100, (WIDTH-30)/4, 100)];
            detailview.backgroundColor=[UIColor clearColor];
            detailview.headImg.tag=i;
            if (isGame==YES)
            {
                detailview.nickname.textColor=[UIColor colorWithRed:252/255.0 green:194/255.0 blue:0/255.0 alpha:1/1.0];
                [detailview.headImg sd_setImageWithURL:[self placeCorpsImg:[NSString stringWithFormat:@"%@",img]] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
            }
            else if (self.isLiveGame==YES)
            {
                detailview.nickname.textColor=[UIColor colorWithRed:252/255.0 green:194/255.0 blue:0/255.0 alpha:1/1.0];
                [detailview.headImg sd_setImageWithURL:[self placeCorpsImg:[NSString stringWithFormat:@"%@",img]] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
            }
            else
            {
                detailview.headImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",img]];
            }
             detailview.btn.tag=i;
            [detailview.btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            detailview.nickname.tag=i;
            detailview.nickname.text=title;
            detailview.tag=999+i;
            [scroll addSubview:detailview];
        }
    }
}

//根据tag值 来设置图片、文字
-(void)setImg:(NSString *)img andTitle:(NSString *)title byTag:(NSInteger)tagid{
    MoreDetailView *detailview=[self viewWithTag:(999+tagid)];
    detailview.headImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",img]];
    detailview.nickname.text=title;
}
- (void)btnClickAction:(UIButton *)btn
{
    [(BaseLiveViewController *)delegate ButtonClickAction:btn];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageShow.currentPage = scrollView.contentOffset.x/WIDTH;
    pageShow.currentPageIndicatorTintColor =[UIColor colorWithRed:255.0/255 green:215.0/255 blue:100.0/255 alpha:1];
    pageShow.pageIndicatorTintColor =[UIColor whiteColor];
}
- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    //8.7
    self.backImg.frame=CGRectMake(0, self.frame.size.height-248*ScreenBiLi, WIDTH, 248*ScreenBiLi);
    
}
///8.7 修改
#pragma mark  hide the moreview
- (void)hideTheMoreView
{
    [self hide];
}

- (void)hide
{
    [self dismiss];
}
- (void)dismiss {
    [UIView animateWithDuration:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.backImg.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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


@end

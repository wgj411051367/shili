//
//  InviteView.m
//
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 gaogao. All rights reserved.
//

#import "HomeTanKuang.h"
#import "Constants.h"
#import "shili-Swift.h"
@implementation HomeTanKuang

- (instancetype)initWithUrl:(NSString *)updateUrl
{
    if (self = [super init]) {
     //背景view
        if(self.backView==nil)
        {
            self.backView=[[UIView alloc] init];
            self.backView.frame=CGRectMake(50*ScreenBiLi, 100*ScreenBiLi, SCREEN_WIDTH-100*ScreenBiLi,(SCREEN_WIDTH-100*ScreenBiLi)/3*4);
            self.backView.backgroundColor=[UIColor clearColor];
            [self addSubview:self.backView];
        }
        if (self.contentImg==nil) {
            self.contentImg=[[UIImageView alloc] init];
            self.contentImg.frame=CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
            [self.contentImg sd_setImageWithURL:[NSURL URLWithString:updateUrl]];
//            self.contentImg.backgroundColor = [UIColor whiteColor];
//            self.contentImg.image=[UIImage imageNamed:@"homeback"];
            [self.backView addSubview:self.contentImg];
        }
//        if(self.backweb==nil)
//        {
//            self.backweb=[[UIView alloc] init];
//            self.backweb.frame=CGRectMake(0*ScreenBiLi, 120*ScreenBiLi, 280*ScreenBiLi,300*ScreenBiLi);
//            self.backweb.layer.cornerRadius=10*ScreenBiLi;
//            self.backweb.layer.masksToBounds=YES;
//            self.backweb.backgroundColor=[UIColor clearColor];
//            [self.backView addSubview:self.backweb];
//        }
//        if (self.bannerWeb==nil) {
//            self.bannerWeb = [[WKWebView alloc]initWithFrame:CGRectMake(0*ScreenBiLi, 0*ScreenBiLi, self.backweb.frame.size.width, self.backweb.frame.size.height)];
//            if (updateUrl!=nil) {
//                [self.bannerWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:updateUrl]]];
//            }
//            self.bannerWeb.navigationDelegate = self;
//            self.bannerWeb.UIDelegate = self;
//            [self.backweb addSubview:self.bannerWeb];
//            [self.bannerWeb bringToFront];
//        }
        //关闭按钮
        if (self.closeBtn==nil) {
            self.closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"whiteCloseBtn"] forState:0];
            [self.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            self.closeBtn.bounds=CGRectMake(0, 0, 40*ScreenBiLi, 40*ScreenBiLi);
            self.closeBtn.center=CGPointMake((SCREEN_WIDTH)/2, self.backView.frame.size.height+self.backView.frame.origin.y+50*ScreenBiLi);
            [self addSubview:self.closeBtn];
        }
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    }
    return self;
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //    此处的url是web页中获取到的 需要对它进行判断
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([url containsString:@"#inner"]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(pushToWebWith:with:and:)]) {
            [(LiveViewController *)_delegate pushToWebWith:url with:@"" and:@""];
            [self closeBtnClick];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([url containsString:@"#outer"]) {
        [self pushToBrowserWithString:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)pushToBrowserWithString:(NSString *)url
{
    if ([url containsString:@"?"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@&platform=ios",url,SharedAppDelegate.userModel.token]]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@&platform=ios",url,SharedAppDelegate.userModel.token]]];
    }
}
- (void)closeBtnClick
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

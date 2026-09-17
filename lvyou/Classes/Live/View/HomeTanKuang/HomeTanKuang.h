//
//  InviteView.h
//  
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 gaogao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveViewController.h"
#import <WebKit/WebKit.h>
@interface HomeTanKuang : UIView <WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *backweb;
@property(nonatomic,strong)UIImageView *contentImg;
@property(strong, nonatomic)WKWebView *bannerWeb;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,weak)id delegate;

- (instancetype)initWithUrl:(NSString *)updateUrl;

@end

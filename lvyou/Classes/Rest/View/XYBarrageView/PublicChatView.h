// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2017 Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com.cn
//
// ///////////////////////////////////////////////////////////////////////////
//
//  PublicChatView.h
//  beibei
//
//  Created by dev on 16/7/13.
//  Copyright © 2016年 Shili. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#import <UIKit/UIKit.h>
#import "GrounderModel.h"
#import "Constants.h"
#import "SDWebImage.h"
@interface PublicChatView : UIView

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isSecret;//神秘人
@property (nonatomic, assign) BOOL previousIsShow;
@property (nonatomic, assign) NSInteger selfYposition;
@property (nonatomic, assign) NSInteger index;
//添加delegate
@property (nonatomic,weak)id delegate;

- (id)init;
- (void)setContent:(id)model;
//过场动画，根据长度计算时间
- (void)grounderAnimation;

//固定高度求文字长度
+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)height;

@end

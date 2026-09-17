//
//  nbPackView.h
//  RedPacketDemo
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreDetailView.h"

@interface TheMoreView : UIView
@property(nonatomic,strong)UIImageView *backImg;
@property (nonatomic,weak)id delegate;

//8.11
@property(assign)BOOL isGame;
@property(assign)BOOL isLiveGame;

-(instancetype)initWith;
- (void)initWithMoreArray:(NSArray *)imageArr andTitle:(NSArray *)titleArr;
- (void)showInView:(UIView *)view;
- (void)hide;
-(void)setImg:(NSString *)img andTitle:(NSString *)title byTag:(NSInteger)tagid;
@end


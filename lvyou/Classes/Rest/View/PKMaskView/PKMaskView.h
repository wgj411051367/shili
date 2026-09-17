//
//  InviteView.h
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKMaskView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,strong)UIImageView *topImg;
@property(nonatomic,strong)UIImageView *bottomImg;
@property (nonatomic,weak)id delegate;
- (void)removeView;

@end

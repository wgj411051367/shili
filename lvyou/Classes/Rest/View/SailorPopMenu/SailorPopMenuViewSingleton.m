//
//  SailorPopMenuViewSingleton.m
//  zhenpin
//
//  Created by dev on 16/6/8.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "SailorPopMenuViewSingleton.h"
#import "SailorPopMenuView.h"

@interface SailorPopMenuViewSingleton ()



@end

@implementation SailorPopMenuViewSingleton

+ (SailorPopMenuViewSingleton *)shareManager
{
    static SailorPopMenuViewSingleton *_popMenuViewSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _popMenuViewSingleton = [[SailorPopMenuViewSingleton alloc] init];
    });
    
    return _popMenuViewSingleton;
}

- (void)creatPopMenuWithFrame:(CGPoint)startPoint
                 popMenuWidth:(CGFloat)width
                 popMenuItems:(NSArray *)items
                       action:(void(^)(NSInteger index))action
{
    __weak __typeof(&*self)weakSelf = self;
    if (self.popmenuView != nil)
    {
        [weakSelf menuHide];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    
    self.popmenuView = [[SailorPopMenuView alloc] initWithFrame:window.bounds
                                             menuStartPoint:startPoint
                                                  menuWidth:width
                                                  menuItems:items
                                                     action:^(NSInteger index) {
                                                         action(index);
                                                         [weakSelf menuHide];
                                                     }];
    self.popmenuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    
    [window addSubview:self.popmenuView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.popmenuView.popMenuTableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)menuHide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.popmenuView.popMenuTableView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.popmenuView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.popmenuView.popMenuTableView removeFromSuperview];
        [self.popmenuView removeFromSuperview];
        self.popmenuView.popMenuTableView = nil;
        self.popmenuView = nil;
    }];
}

@end

//
//  SailorPopMenuViewSingleton.h
//  zhenpin
//
//  Created by dev on 16/6/8.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SailorPopMenuView.h"
@interface SailorPopMenuViewSingleton : NSObject

@property (nonatomic, strong) SailorPopMenuView *popmenuView;
/**
 *  创建单例
 *
 *
 */
+ (SailorPopMenuViewSingleton *)shareManager;

/**
 *  创建一个弹出框菜单
 *
 *  @param startPoint 弹出框左上角起点位置
 *  @param width      弹出框的宽度
 *  @param items      模型数组
 *  @param action     点击回调方法
 */
- (void)creatPopMenuWithFrame:(CGPoint)startPoint
                 popMenuWidth:(CGFloat)width
                 popMenuItems:(NSArray *)items
                       action:(void(^)(NSInteger index))action;

/**
 *  隐藏菜单
 */
- (void)menuHide;

@end

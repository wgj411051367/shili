//
//  SailorPopMenuView.h
//  zhenpin
//
//  Created by dev on 16/6/8.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SailorPopMenuView : UIView

@property (nonatomic, strong) UITableView *popMenuTableView;

/**
 *  创建tableView
 *
 *  @param frame
 *  @param satrtPoint  整个弹框左上角坐标
 *  @param menuWidth  弹出框的宽度
 *  @param items     模型数组
 *  @param action    cell选中标识
 *
 *  @return 返回所点击的cell
 */
- (instancetype)initWithFrame:(CGRect)frame
               menuStartPoint:(CGPoint)startPoint
                    menuWidth:(CGFloat)menuWidth
                    menuItems:(NSArray *)items
                       action:(void (^)(NSInteger index))action;

/*

 if(titles == nil)
 {
 titles = [NSMutableArray array];
 }
 if(images == nil)
 {
 images = [NSMutableArray array];
 }
 [titles addObject:@"文件夹"];
 [titles addObject:@"照片"];
 [images addObject:@"icon_add_file"];
 [images addObject:@"icon_add_image"];

 
 NSMutableArray *arr = [[NSMutableArray alloc] init];
 for (int i = 0; i < titles.count; i++)
 {
 SailorPopMenuViewModel *model = [[SailorPopMenuViewModel alloc] init];
 model.image = images[i];
 model.title = titles[i];
 [arr addObject:model];
 }
 
 //弹出框的宽度
 CGFloat menuViewWidth = 150;
 //弹出框的左上角起点坐标
 CGPoint startPoint = CGPointMake(SCREEN_WIDTH - menuViewWidth - 20, 64 + 12);
 
 [[SailorPopMenuViewSingleton shareManager] creatPopMenuWithFrame:startPoint popMenuWidth:menuViewWidth popMenuItems:arr action:^(NSInteger index) {
 
 //NSLog(@"+++++++++++++++点击的index=%ld",(long)index);
 switch (index)
 {
 case 0:
 //添加到文件夹
 [self addFile];
 break;
 case 1:
 //添加到照片
 [self addImage];
 break;
 default:
 break;
 }
 }];

 */


@end

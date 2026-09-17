//
//  SailorPopMenuView.m
//  zhenpin
//
//  Created by dev on 16/6/8.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "SailorPopMenuView.h"
#import "SailorMenuViewCell.h"
#import "SailorPopMenuViewModel.h"
#import "SailorPopMenuViewSingleton.h"

#define CELLHEIGHT 30;

static NSString * SailorMenuCellName = @"SailorMenuViewCell";

@interface SailorPopMenuView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) CGFloat menuWidth;
@property (nonatomic,copy) NSArray *menuItems;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,copy) void (^action)(NSInteger index);

@end

@implementation SailorPopMenuView

- (instancetype)initWithFrame:(CGRect)frame
               menuStartPoint:(CGPoint)startPoint
                    menuWidth:(CGFloat)menuWidth
                    menuItems:(NSArray *)items
                       action:(void (^)(NSInteger index))action
{
    if (self = [super initWithFrame:frame])
    {
        self.menuWidth = menuWidth;
        self.menuItems = items;
        self.startPoint = startPoint;
        self.action = [action copy];
        self.popMenuTableView = [[UITableView alloc] initWithFrame:[self popMenuViewFrame] style:UITableViewStylePlain];
        self.popMenuTableView.delegate = self;
        self.popMenuTableView.dataSource = self;
        self.popMenuTableView.layer.cornerRadius = 5;
        self.popMenuTableView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        self.popMenuTableView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.popMenuTableView.rowHeight = CELLHEIGHT;
        self.popMenuTableView.backgroundColor = [UIColor colorWithHex:0x273140 alpha:0.99];
//        self.popMenuTableView.alpha = 0.8;
        self.popMenuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.popMenuTableView.layer.cornerRadius = 8;
        self.popMenuTableView.layer.masksToBounds = YES;
        [self addSubview:self.popMenuTableView];
        
        [self.popMenuTableView registerClass:[SailorMenuViewCell class] forCellReuseIdentifier:SailorMenuCellName];
        
        if ([self.popMenuTableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self.popMenuTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.popMenuTableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [self.popMenuTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SailorMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SailorMenuCellName];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (self.menuItems > 0)
    {
        SailorPopMenuViewModel *model = self.menuItems[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.title];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        if (model.image) {
          cell.imageView.image = [UIImage imageNamed:model.image];
        }else{
          cell.textLabel.textAlignment = NSTextAlignmentCenter;
          tableView.separatorColor = [UIColor whiteColor];
          tableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);
          tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.action)
    {
        self.action(indexPath.row);
    }
}

- (CGRect)popMenuViewFrame
{
    CGFloat menuViewX = 75 + self.startPoint.x;
    CGFloat menuViewY = self.startPoint.y - 4 * 20;
    CGFloat menuWidth = self.menuWidth;
    ///9.22  高度修改
    CGFloat menuHeight = 4 * CELLHEIGHT;//3 * CELLHEIGHT;
    
    return CGRectMake(menuViewX, menuViewY, menuWidth, menuHeight);
    
}

//#pragma mark - 绘制三角形
//- (void)drawRect:(CGRect)rect
//{
//    // 背景色
//    [[UIColor whiteColor] set];
//
//    // 获取视图
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//
//    // 开始绘制
//    CGContextBeginPath(contextRef);
//
//    CGContextMoveToPoint(contextRef, self.startPoint.x + self.menuWidth - 20, self.startPoint.y);
//
//    CGContextAddLineToPoint(contextRef, self.startPoint.x + self.menuWidth - 20 * 1.5, self.startPoint.y - 10);
//    CGContextAddLineToPoint(contextRef, self.startPoint.x + self.menuWidth - 20 * 2, self.startPoint.y);
//
//    // 结束绘制
//    CGContextClosePath(contextRef);
//    // 填充色
//    [[UIColor whiteColor] setFill];
//    // 边框颜色
//    [[UIColor whiteColor] setStroke];
//    // 绘制路径
//    CGContextDrawPath(contextRef, kCGPathFillStroke);
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[SailorPopMenuViewSingleton shareManager] menuHide];
}

@end

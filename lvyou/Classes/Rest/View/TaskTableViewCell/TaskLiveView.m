//
//  TaskLiveView.m
//  liveios
//
//  Created by dev on 2019/7/5.
//  Copyright © 2019 Shili. All rights reserved.
//

#import "TaskLiveView.h"
#import "TaskTableViewCell.h"
#import "BaseViewController.h"
#import "TaskLiveModel.h"

@interface TaskLiveView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation TaskLiveView


- (void)showView:(UIButton *)sender {
    
    self.hidden = NO;

}


- (void)setTaskArr:(NSMutableArray *)taskArr {
    if (!_taskArr) {
        _taskArr = [[NSMutableArray alloc] init];
    }
    self.hidden = NO;
    _taskArr = [taskArr copy];
    [self.taskTableView reloadData];
}

#pragma mark - TableView的代理方法
#pragma mark - 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.taskArr.count;
    
}

#pragma mark - 每个Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 26;
}

#pragma mark - 初始化Cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskTableViewCell * rCell = [TaskTableViewCell cellWithTableView:tableView];
    
    [self configThemeCell:rCell atIndexPath:indexPath];
    
    return rCell;
}


#pragma mark - Cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
}

#pragma mark - 设置Cell内容
-(void)configThemeCell:(TaskTableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    
    TaskLiveModel *model = self.taskArr[indexPath.row];
    
    CGAffineTransform transform1 = CGAffineTransformMakeScale(1.0f, 2.5f);
    cell.taskProgressView.transform = transform1;//设定宽高
    for (UIImageView * imageview in cell.taskProgressView.subviews) {
        imageview.layer.cornerRadius = 2.5;
        imageview.clipsToBounds = YES;
    }
    cell.taskProgressView.progressImage = [UIImage imageNamed:@"icon_live_progress"];
    
    if ([model.num integerValue] >= [model.max integerValue]) {
        cell.taskProgressView.progress = 1.0f;
    } else {
        cell.taskProgressView.progress = [model.num floatValue] / [model.max floatValue];
    }
    if ([model.type isEqualToString:@"gift"]) {
        cell.taskTitle.text = [NSString stringWithFormat:@"收到%@/%@个%@",[model.num integerValue] >= [model.max integerValue]?model.max:model.num,model.max,model.name];
        if (model.icon) {
            [cell.taskImg sd_setImageWithURL:[NSURL URLWithString:model.icon]];
        } else {
            cell.taskImg.image = [UIImage imageNamed:@"icon_live_task_gift"];
        }
        
    } else if ([model.type isEqualToString:@"fan"]) {
        cell.taskTitle.text = [NSString stringWithFormat:@"新增粉丝%@/%@位",[model.num integerValue] >= [model.max integerValue]?model.max:model.num,model.max];
        cell.taskImg.image = [UIImage imageNamed:@"icon_live_task_fan"];
    } else {
        cell.taskTitle.text = [NSString stringWithFormat:@"pk胜利%@/%@场",[model.num integerValue] >= [model.max integerValue]?model.max:model.num,model.max];
        cell.taskImg.image = [UIImage imageNamed:@"icon_live_task_pk"];
    }
    
    
}

@end

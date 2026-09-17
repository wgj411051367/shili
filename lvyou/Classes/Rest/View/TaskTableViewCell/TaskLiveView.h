//
//  TaskLiveView.h
//  liveios
//
//  Created by dev on 2019/7/5.
//  Copyright © 2019 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskLiveView : UIView
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;

@property (nonatomic, copy) NSMutableArray *taskArr;

@end

NS_ASSUME_NONNULL_END

//
//  RedPackRecordCell.h
//  liveios
//
//  Created by imac on 2022/9/21.
//  Copyright © 2022 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RedPackRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *bestTip;
@property (weak, nonatomic) IBOutlet UILabel *money;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

//
//  PersonalCell.h
//  binfen
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *IconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end

//
//  UITextView+Master.h
//  HiGoMaster
//
//  Created by dev on 15/4/13.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UITextView (Master)

@property (nonatomic, readonly) UILabel *placeholderLabel;
@property (nonatomic, copy) NSString *placeholderStr;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

- (void)checkAttachment;
@end

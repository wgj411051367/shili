//
//  InviteView.h
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteView : UIView<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *backImg;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIImageView *tfImg;
@property(nonatomic,strong)UITextField *TF;
@property(nonatomic,strong)UILabel *placeHolder;
@property(nonatomic,strong)UIButton *sureBtn;

- (instancetype)initWithFrame:(CGRect)frame;
@end

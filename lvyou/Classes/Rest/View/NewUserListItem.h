//
//  NewUserListItem.h
//  iumobile
//
//  Created by 金颖 on 16/3/16.
//  Copyright © 2016年 halley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@interface NewUserListItem : UIView{
    UserInfoModel *userinfo;
    //id delegate;
    UITapGestureRecognizer *singleTap;
    LOTAnimationView *animation;
}
@property (nonatomic,weak)id delegate;
- (id)initWithFrame:(CGRect)frame andInfo:(UserInfoModel *)info andController:(id)parentid;
- (void)singleTapAction;
- (void)removeAnimationView;
@end

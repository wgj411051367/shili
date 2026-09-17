//
//  CustomUIView.m
//  Beautifuller
//
//  Created by mac on 17/7/12.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "CustomUIView.h"

@implementation CustomUIView
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

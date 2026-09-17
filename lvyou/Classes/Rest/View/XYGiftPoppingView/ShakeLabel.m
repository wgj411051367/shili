//
//  ShakeLabel.m
//  presentAnimation
//
//  Created by 许博 on 16/7/14.
//  Copyright © 2016年 许博. All rights reserved.
//

#import "ShakeLabel.h"

@implementation ShakeLabel

-(void)initLabel{

    if (label1!=nil) {
        return;
    }
    label1 =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    label1.font = [UIFont systemFontOfSize:22 weight:2.0f];
    UIColor *textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textbg"]];
    label1.textColor = textColor;
    label1.textAlignment = NSTextAlignmentLeft;
    label1.backgroundColor=[UIColor clearColor];
    [label1 setText:@""];
    label2 =  [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    label2.font = [UIFont systemFontOfSize:22 weight:2.0f];
    label2.textColor = textColor;
    label2.textAlignment = NSTextAlignmentLeft;
    label2.backgroundColor=[UIColor clearColor];
    [label2 setText:@""];
    [self addSubview:label1];
    [self addSubview:label2];
}
-(void)label2totop{
    labPos1=NO;
    [UIView animateWithDuration:0.3 animations:^{
        [label2 setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [label1 setFrame:CGRectMake(0, 0-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished) {
        [label1 setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        [label2 setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }];
}
-(void)label1totop{
    labPos1=YES;
    [UIView animateWithDuration:0.3 animations:^{
        [label1 setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [label2 setFrame:CGRectMake(0, 0-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished) {
        [label2 setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        [label1 setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }];
}
-(void)setText:(NSString *)text{
    //第一次
    if ([label1.text isEqualToString:@""] && [label2.text isEqualToString:@""]) {
        [label1 setText:text];
        [label2 setText:text];
    }
    //第二次
    else if(![label1.text isEqualToString:@""] && [label2.text isEqualToString:@""])
    {
        [label2 setText:text];
        [self label2totop];
    }
    //第三次以后
    else{
        if (labPos1) {
            [label2 setText:text];
            [self label2totop];
        }
        else{
            [label1 setText:text];
            [self label1totop];
        }
    }
}
- (void)dealloc
{
    
}
@end

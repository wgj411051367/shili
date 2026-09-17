//
//  ShakeLabel.h
//  presentAnimation
//
//  Created by 许博 on 16/7/14.
//  Copyright © 2016年 许博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeLabel : UIView{
    UILabel *label1;
    UILabel *label2;
    BOOL labPos1;
}
-(void)initLabel;
-(void) setText:(NSString *)text;
@end

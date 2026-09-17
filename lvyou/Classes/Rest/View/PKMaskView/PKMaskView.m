//
//  LeQuanAlertView
//  aihu
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "PKMaskView.h"
#import "Constants.h"
@implementation PKMaskView
@synthesize delegate,topImg,bottomImg;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (topImg==nil) {
            topImg=[[UIImageView alloc] init];
            topImg.frame=CGRectMake(0, 0, frame.size.width, (SCREEN_HEIGHT-frame.size.width*4/6)/2);
            topImg.image=[UIImage imageNamed:@"stopBgImage"];
            [self addSubview:topImg];
        }
        
        if (bottomImg==nil) {
            bottomImg=[[UIImageView alloc] init];
            bottomImg.frame=CGRectMake(0,((SCREEN_HEIGHT-frame.size.width*4/6)/2)+frame.size.width*4/6, frame.size.width, SCREEN_HEIGHT);
            bottomImg.image=[UIImage imageNamed:@"stopBgImage"];
            bottomImg.backgroundColor=[UIColor yellowColor];
            [self addSubview:bottomImg];
        }
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)removeView
{
    [UIView animateWithDuration:0.2 animations:^{
        [self removeFromSuperview];
    }];
}
- (void)dealloc
{
    
}

@end

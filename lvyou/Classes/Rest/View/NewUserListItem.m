//
//  NewUserListItem.m
//  iumobile
//
//  Created by 金颖 on 16/3/16.
//  Copyright © 2016年 halley. All rights reserved.
//

#import "NewUserListItem.h"
#import "AppDelegate.h"
#import "BaseLiveViewController.h"
@implementation NewUserListItem
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame andInfo:(UserInfoModel *)info andController:(id)parentid
{
    self = [super initWithFrame:frame];
    if (self) {
        //头像
        UIImageView *avatar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
       //2.14 修改头像
        if (info.avatar!=nil) {
            [avatar sd_setImageWithURL:[self placeCorpsImg:info.avatar] placeholderImage:[UIImage imageNamed:@"icon_login_head"]];
        }
        avatar.contentMode = UIViewContentModeScaleAspectFill;
        avatar.clipsToBounds = YES;
        //圆角
        avatar.layer.masksToBounds = YES;
        avatar.layer.cornerRadius=frame.size.height/2;
        [self addSubview:avatar];
        
        if (![info.avatar_frame isKindOfClass:[NSNull class]]) {
            if (info.avatar_frame) {
                if (![info.avatar_frame isEqualToString:@""]) {
                    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
                    NSString *filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",info.avatar_frame]];
                    CGFloat width = (avatar.width * 42) / 30;
                    animation = [LOTAnimationView animationWithFilePath:filePath];
                    animation.loopAnimation = YES;
                    [self addSubview:animation];
                    [animation mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.equalTo(avatar);
                        make.width.height.equalTo(@(width));
                    }];
                    [animation playWithCompletion:^(BOOL animationFinished) {
                    }];
                }
            }
        }
        
        //vip图片
        UIImageView *vipImg=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-10, frame.size.width-12, 12, 12)];
        [self showTheGuiZu:vipImg With:info.guizhu];//11.6贵族

        [self addSubview:vipImg];
        
        userinfo=info;
        delegate=parentid;
        self.userInteractionEnabled=YES;
        singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self                 action:@selector(singleTapAction)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}
//显示贵族
- (void)showTheGuiZu:(UIImageView *)imgView With:(NSString *)guizu
{
    if (![self isBlankString:guizu]) {
        int i = [guizu intValue];
        if (i > 0 && i < 7) {
            imgView.hidden = NO;
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_gui%d",i]];
        } else {
            imgView.hidden = YES;
        }
    } else {
        imgView.hidden = YES;
    }
}
//显示vip
- (void)showTheVip:(UIImageView *)imgView With:(NSString *)vip_util With:(NSString *)viplevel
{
    double vipTime = [vip_util doubleValue];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970] / 1000;
    if (now > vipTime) {
        //vip已过期
        imgView.hidden = YES;
    }
    else{
        imgView.hidden =NO;
        //vip未过期  显示vip
        if ([viplevel intValue]==1)
        {
            imgView.image=[UIImage imageNamed:@"icon_yellowvip"];
        }
        else if ([viplevel intValue]==2)
        {
            imgView.image=[UIImage imageNamed:@"icon_purplevip"];
        }
        else if ([viplevel intValue]==3)
        {
            imgView.image=[UIImage imageNamed:@"icon_blackvip"];
        }
    }
}
- (BOOL)isBlankString:(NSString *)string
{
    if (!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
- (void)dealloc // 6.11修改 移除手势
{
    if (singleTap) {
        [self removeGestureRecognizer:singleTap];
    }
    
}
- (void)removeAnimationView {
    [animation stop];
    [animation removeFromSuperview];
    animation = nil;
}
/// 2.14
- (NSURL *)placeCorpsImg:(NSString*)addr
{
    //判断是不是全路径
    if([[ToolHelper toolHelper] ReplacingCharActer:addr]){
        //全路径
        return [NSURL URLWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
    }else{
        //        拼接路径
        return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",IMAGEAPI,addr]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
}

-(void)singleTapAction
{
    if (delegate &&[delegate respondsToSelector:@selector(onViewerAvatarTapped:)]) {
        // 这里添加点击后要做的事情
        [(BaseLiveViewController *)delegate onViewerAvatarTapped:userinfo];
    }
}
@end

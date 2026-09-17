// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2017 Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com.cn
//
// ///////////////////////////////////////////////////////////////////////////
//
//  PublicChatView.m
//  beibei
//
//  Created by dev on 16/7/13.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "PublicChatView.h"
#import "UIImage+Resample.h"
#import "BaseLiveViewController.h"
#import "YYText.h"
@interface PublicChatView()
{
    UILabel * titleLabel;
    UIImageView * headImage;
    //飘屏背景
    UIImageView *flyBgImage;
    UIButton * headBtn;
    float viewWidth;
    //showthelove
    float stayTime;
    NSString *type;
    UIView *synView;// 混排View
    NSString *hor_ini_pos;
}
@end

@implementation PublicChatView

- (id)init
{
    self = [super init];
    if (self)
    {
        //背景图
        flyBgImage = [[UIImageView alloc] init];
        [self addSubview:flyBgImage];
        self.userInteractionEnabled =YES;
        titleLabel = [[UILabel alloc] init];
        [flyBgImage addSubview:titleLabel];
        
        
    }
    return self;
}

- (void)setNewContent:(GrounderModel *)grounderModel {
    synView = [[UIView alloc] init];
//    synView.hidden = NO;
    [flyBgImage addSubview:synView];
    stayTime=[grounderModel.staytime floatValue]/1000;
    
    viewWidth = [grounderModel.content_left floatValue]/2*ScreenBiLi;
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:grounderModel.bg] options:NSDataReadingMappedAlways error:nil]; //18.7.10修改 源代码是dataWithContentsOfURL
    UIImage *defaultImg=[UIImage imageWithData:data];
    if (!grounderModel.imgscale) {
        grounderModel.imgscale = @"1";
    }
    UIImage *scaleImg=[defaultImg imageCompressWithSimpleScale:(0.5*ScreenBiLi/[grounderModel.imgscale floatValue])];
    // 设置端盖的值
    CGFloat top = [grounderModel.scale9_top floatValue]/2*ScreenBiLi;
    CGFloat left = [grounderModel.scale9_left floatValue]/2*ScreenBiLi;
    CGFloat bottom = [grounderModel.scale9_bottom floatValue]/2*ScreenBiLi;
    CGFloat right = [grounderModel.scale9_right floatValue]/2*ScreenBiLi;
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    // 拉伸图片
    UIImage *newImage;
    if (scaleImg)
    {
        newImage = [scaleImg resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    }
    else
    {  //1.7 默认背景
        flyBgImage.backgroundColor=RGBACOLOR(0, 0, 0, 0.55);
    }
    
    [self setUIModel:grounderModel andHeight:scaleImg.size.height];
    
    flyBgImage.frame=CGRectMake(0, 0, viewWidth+ [grounderModel.content_right floatValue]/2*ScreenBiLi, scaleImg.size.height);
    synView.frame = CGRectMake(0, 0, viewWidth+ [grounderModel.content_right floatValue]/2*ScreenBiLi, scaleImg.size.height);
    [flyBgImage setImage:newImage];
    self.frame = CGRectMake([hor_ini_pos floatValue], (([grounderModel.screen_height floatValue])*[grounderModel.pos floatValue]/100)+[grounderModel.screen_top floatValue], viewWidth, scaleImg.size.height);
    //添加点击手势
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClickAction)];
    flyBgImage.tag=[grounderModel.userid integerValue];
    [self addGestureRecognizer:singleTap];
    [self grounderAnimation];
    type=grounderModel.type;
}

- (void)setUIModel:(GrounderModel *)grounderModel andHeight:(float)viewHeight {
    
    for (SFMContentModel *model in grounderModel.content) {
        if (model.img_url != nil && ![model.img_url isEqualToString:@""]) {
            float imageW = [model.img_size floatValue]/2*ScreenBiLi;
            UIImageView *image = [[UIImageView alloc] init];
            image.frame = CGRectMake(viewWidth, (viewHeight - imageW)/2, imageW, imageW);
            [image sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.layer.cornerRadius = [model.img_corner floatValue]/180 * (imageW);
            image.layer.masksToBounds = YES;
            [synView addSubview:image];
            viewWidth += imageW;
        }
        
        float labelWidth = [[BaseViewController alloc] widthForString:model.text fontSize:([model.text_size floatValue]/2*ScreenBiLi) andHeight:viewHeight];
        UILabel *lab = [[UILabel alloc] init];
        if ([model isEqual:grounderModel.content.lastObject]) {
            lab.frame = CGRectMake(viewWidth, 0, labelWidth+10*ScreenBiLi, viewHeight);
        } else {
            lab.frame = CGRectMake(viewWidth, 0, labelWidth, viewHeight);
        }
        
        lab.text = model.text;
        lab.textColor = [UIColor colorWithHexString:model.text_color];
        lab.font = [UIFont systemFontOfSize:([model.text_size floatValue]/2*ScreenBiLi) weight:UIFontWeightSemibold];
        [synView addSubview:lab];
        viewWidth += labelWidth;
    }
    
}

- (void)setContent:(id)model
{
    GrounderModel *grounderModel = (GrounderModel *)model;
    if ([grounderModel.hor_ini_pos isKindOfClass:[NSString class]]) {
        if (![grounderModel.hor_ini_pos isEqualToString:@""]) {
            hor_ini_pos = grounderModel.hor_ini_pos;
        }
    }
    if ([grounderModel.version integerValue] == 2) {
        [self setNewContent:grounderModel];
        return;
    }
    stayTime=[grounderModel.staytime floatValue]/1000;
    NSString *c=[NSString stringWithFormat:@"0x%@",[grounderModel.color substringFromIndex:1]];
    long colorInt=strtoul([c UTF8String],0,16);
    [titleLabel setTextColor:UIColorFromHex(colorInt)];
    if (grounderModel.fontColors.count>0) {//分段颜色
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[grounderModel.title mutableCopy]];//1.2 添加mutableCopy
        for (NSDictionary *color in grounderModel.fontColors) {
            NSString *start=[color objectForKey:@"start"];
            NSString *end=[color objectForKey:@"end"];
            if (start) {
                long color_range=strtoul([[NSString stringWithFormat:@"0x%@",[[color objectForKey:@"color"] substringFromIndex:1]] UTF8String],0,16);
                NSRange range=NSMakeRange([start intValue], [end intValue]-[start intValue]);
                //1.2 添加判断
                if ([start intValue]<=[end intValue]-[start intValue]) {
                    if ((range.length+range.location)<hintString.length) {
                        [hintString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(color_range) range:range];
                    }
                }
            }
        }
        titleLabel.attributedText=hintString;
    }
    else{
        [titleLabel setText:grounderModel.title];//统一颜色
    }
    
    [titleLabel setFont:[UIFont systemFontOfSize:[grounderModel.fontSize floatValue]/2*ScreenBiLi]];
    titleLabel.frame = CGRectMake([grounderModel.pl floatValue]/2*ScreenBiLi, [grounderModel.sizetop floatValue]/2*ScreenBiLi, [PublicChatView calculateMsgWidth:titleLabel.text andWithLabelFont:[UIFont boldSystemFontOfSize:[grounderModel.fontSize floatValue]/2*ScreenBiLi] andWithHeight:[grounderModel.fontSize floatValue]/2*ScreenBiLi], [grounderModel.fontSize floatValue]/2*ScreenBiLi);
    
    if([grounderModel.userid intValue]>0){//userid 小于0没有头像
        headImage = [[UIImageView alloc] init];
        headImage.clipsToBounds = YES;
        headImage.frame = CGRectMake([grounderModel.avatar_x floatValue]/2*ScreenBiLi, [grounderModel.avatar_y floatValue]/2*ScreenBiLi, [grounderModel.avatar_size floatValue]/2*ScreenBiLi, [grounderModel.avatar_size floatValue]/2*ScreenBiLi);
        headImage.layer.cornerRadius = [grounderModel.avatar_size floatValue]/2*ScreenBiLi/2;
        headImage.layer.borderWidth = 0.5;
        headImage.contentMode = UIViewContentModeScaleAspectFill;
        headImage.clipsToBounds = YES;
        [flyBgImage addSubview:headImage];
        if (self.isSecret==YES) {//神秘人
            headImage.image=[UIImage imageNamed:placeHolderImageName];
        }
        else{
            [headImage sd_setImageWithURL:[NSURL URLWithString:grounderModel.headImage] placeholderImage:[UIImage imageNamed:@"icon_login_head"] options:SDWebImageRetryFailed];
        }
    }
    viewWidth = titleLabel.frame.size.width + [grounderModel.pr floatValue]/2*ScreenBiLi+ [grounderModel.pl floatValue]/2*ScreenBiLi;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:grounderModel.bg]];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            // 请求失败，进行错误处理
            NSLog(@"请求失败：%@", error.localizedDescription);
            if (synView) {
                [synView removeFromSuperview];
                synView = nil;
            }
            [self removeFromSuperview];
            return;
        }
        
        // 请求成功，处理返回的数据
        if (data) {
            // 在这里可以对返回的数据进行处理
            // 例如，将数据转换为图片并更新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                // 在主线程更新界面
                // 更新 UI 控件，显示图片
                UIImage *defaultImg=[UIImage imageWithData:data];
                if (!grounderModel.imgscale) {
                    grounderModel.imgscale = @"1";
                }
                UIImage *scaleImg=[defaultImg imageCompressWithSimpleScale:(0.5*ScreenBiLi/[grounderModel.imgscale floatValue])];
                // 设置端盖的值
                CGFloat top = [grounderModel.scale9_top floatValue]/2*ScreenBiLi;
                CGFloat left = [grounderModel.scale9_left floatValue]/2*ScreenBiLi;
                CGFloat bottom = [grounderModel.scale9_bottom floatValue]/2*ScreenBiLi;
                CGFloat right = [grounderModel.scale9_right floatValue]/2*ScreenBiLi;
                // 设置端盖的值
                UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
                // 设置拉伸的模式
                UIImageResizingMode mode = UIImageResizingModeStretch;
                // 拉伸图片
                UIImage *newImage;
                if (scaleImg)
                {
                    newImage = [scaleImg resizableImageWithCapInsets:edgeInsets resizingMode:mode];
                }
                else
                {  //1.7 默认背景
                    flyBgImage.backgroundColor=RGBACOLOR(0, 0, 0, 0.55);
                }
                flyBgImage.frame=CGRectMake(0, 0, viewWidth, scaleImg.size.height);
                [flyBgImage setImage:newImage];
                self.frame = CGRectMake([hor_ini_pos floatValue]/100*SCREEN_WIDTH, (([grounderModel.screen_height floatValue])*[grounderModel.pos floatValue]/100)+[grounderModel.screen_top floatValue], viewWidth, scaleImg.size.height);
                //添加点击手势
                UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClickAction)];
                flyBgImage.tag=[grounderModel.userid integerValue];
                [self addGestureRecognizer:singleTap];
                [self grounderAnimation];
                type=grounderModel.type;
            });
        }
    }];

    [task resume];
    
    
    
}

- (void)headClickAction
{
    for(UIView *view in self.subviews)
    {
        
        [(BaseLiveViewController *)_delegate flyMsgClicked:view.tag];
        
    }
    
}
- (void)grounderAnimation
{
    CGRect frame=self.frame;
    CGFloat stopX=0;
//    if (frame.size.width>SCREEN_WIDTH) {
//        stopX=SCREEN_WIDTH-frame.size.width;
//    }
    [UIView animateKeyframesWithDuration:2.0f delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.frame=CGRectMake(stopX, frame.origin.y, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(hideView) withObject:nil afterDelay:stayTime];
    }];
    
}
- (void)hideView
{
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.frame = CGRectMake( - viewWidth - 20, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)height
{
    CGFloat messageLableWidth;
    if ([msg isEqualToString:@""])
    {
        return 0;
    }
    messageLableWidth = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, height)options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}context:nil].size.width;// 1.26 添加NSStringDrawingUsesLineFragmentOrigin
    return messageLableWidth + 1;
}

- (void)dealloc
{
    NSLog(@"PublicChatView  dealloc");
    if (synView) {
        [synView removeFromSuperview];
        synView = nil;
    }
}

@end

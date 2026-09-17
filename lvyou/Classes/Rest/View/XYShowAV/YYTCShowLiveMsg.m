//
//  TCShowLiveMsg.m
//  TCShow
//
//  Created by AlexiChen on 16/4/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "YYTCShowLiveMsg.h"
#import "GiftModel.h"
#import "HorseModel.h"
#import "Global.h"
#import "AppDelegate.h"
#import "YYText.h"
#import "SDWebImage.h"
@implementation YYTCShowLiveMsg
{
    NSMutableArray *giftLists;
    GiftModel *giftModel;
    GiftModel *gift;
}
- (instancetype)init
{
    if (self = [super init])
    {
        _nameColor = [UIColor whiteColor];//jinying maybe wrong
    }
    return self;
}
- (instancetype)initWithMessage:(NSString *)message
{
    if (self = [self init])
    {
     
        _msgText = message;
        _customElemModel = [[CustomElemModel alloc] initWithString:message error:nil];
        
    }
    return self;
}
- (instancetype)initWith:(UserInfoModel *)user message:(NSString *)message
{
    if (self = [self init])
    {
        _sender = user;
        _msgText = message;
        [self getGiftList];
        _customElemModel = [[CustomElemModel alloc] initWithString:message error:nil];

    }
    return self;
}

- (instancetype)initWithCustom:(UserInfoModel *)user message:(CustomElemModel *)message
{
    if (self = [self init])
    {
        _sender = user;
        _customElemModel = message;
        
        
        //_msgText = message;
        //[self getGiftList];
    }
    return self;
}


#pragma mark - 获取本地礼物列表
- (void)getGiftList
{
    //NSLog(@"++++++++++++获取本地礼物列表");
    giftLists = [[NSMutableArray alloc]init];
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:RequestGiftListKey];
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *giftList = [[NSMutableArray alloc]initWithArray:array];
    for (NSDictionary *dic in giftList)
    {
        giftModel = [[GiftModel alloc]initWithDictionary:dic error:nil];
        [giftLists addObject:giftModel];
    }
}

// 普通文样样式
- (NSString *)avimMsgText
{
    //_customElemModel = [[CustomElemModel alloc] initWithString:_msgText error:nil];
//    ExtraModel *horseModel = [[ExtraModel alloc]initWithString:_customElemModel.extra error:nil];
    //1014
    if (!_customElemModel) {
      return [NSString stringWithFormat:@"%@", _msgText];
        
    }else{
        switch (_customElemModel.type)
        {
            case IM_TYPE_GIFT:
            {
//                for (GiftModel *model in giftLists)
//                {
//                    if([model.id isEqualToString:_customElemModel.r_id]){
//                        giftModel = model;
//                    }
//
//                }
                gift = [[GiftModel alloc]initWithDictionary:[[AppDelegate appDelegate].giftDic objectForKey:_customElemModel.r_id] error:nil];
                //1101
                return [NSString stringWithFormat:@"%@ 送给 %@ %@",_customElemModel.s_nick,_customElemModel.t_nick,gift.name];
            }
                break;
                
            case IM_TYPE_ENTER:
            {
                if (_customElemModel.extra)
                {
                    if (self.ishide==YES) {
                        return [NSString stringWithFormat:@"%@",@"咻的一下,有人窜进了房间"];
                    }
                    else{
                    return [NSString stringWithFormat:@"%@坐着%@进入了直播间", _customElemModel.s_nick,_customElemModel.extra];
                  }
                }else {
                    if (self.ishide==YES) {
                        return [NSString stringWithFormat:@"%@",@"咻的一下,有人窜进了房间"];
                    }
                    else{
//                        return @"꧁꫞꯭冷不过心꯭꫞꧂    进入了直播间";
                    return [NSString stringWithFormat:@"%@进入了直播间", _customElemModel.s_nick];
                  }
               }
            }
                break;
            case IM_TYPE_EXIT:
            {
                if ([_customElemModel.s_vip integerValue]==1)
                {
                    return [NSString stringWithFormat:@"%@ 退出了直播间", _customElemModel.s_nick];
                }else if([_customElemModel.s_vip integerValue]==0){
                    return [NSString stringWithFormat:@"%@ 退出了直播间", _customElemModel.s_nick];
                }

            }
                break;
            case IM_TYPE_CHAT_MSG:
            {
               
//                if ([_customElemModel.ishost integerValue]==1) {
//                   return [NSString stringWithFormat:@"%@:%@", _customElemModel.s_nick, _customElemModel.extra];
//                }else{
                if ([_customElemModel.extra containsString:@"sz_svga_"]) {
                    if ([_customElemModel.extra containsString:@"sz_svga_1"]) self.svgaName = @"sz_svga_1";
                    if ([_customElemModel.extra containsString:@"sz_svga_2"]) self.svgaName = @"sz_svga_2";
                    if ([_customElemModel.extra containsString:@"sz_svga_3"]) self.svgaName = @"sz_svga_3";
                    if ([_customElemModel.extra containsString:@"sz_svga_4"]) self.svgaName = @"sz_svga_4";
                    if ([_customElemModel.extra containsString:@"sz_svga_5"]) self.svgaName = @"sz_svga_5";
                    if ([_customElemModel.extra containsString:@"sz_svga_6"]) self.svgaName = @"sz_svga_6";
                    return [NSString stringWithFormat:@"%@:", _customElemModel.s_nick];
                } else if ([_customElemModel.extra containsString:@"em_svga_"]) {
                    if ([_customElemModel.extra containsString:@"em_svga_baodeng"])  self.svgaName = @"爆灯";
                    if ([_customElemModel.extra containsString:@"em_svga_dazh"])     self.svgaName = @"打招呼";
                    if ([_customElemModel.extra containsString:@"em_svga_daxiao"])   self.svgaName = @"大笑";
                    if ([_customElemModel.extra containsString:@"em_svga_diantou"])  self.svgaName = @"点头";
                    if ([_customElemModel.extra containsString:@"em_svga_fahuo"])    self.svgaName = @"发火";
                    if ([_customElemModel.extra containsString:@"em_svga_guzhang"])  self.svgaName = @"鼓掌";
                    if ([_customElemModel.extra containsString:@"em_svga_huaixiao"]) self.svgaName = @"坏笑";
                    if ([_customElemModel.extra containsString:@"em_svga_keai"])     self.svgaName = @"可爱";
                    if ([_customElemModel.extra containsString:@"em_svga_koubs"])    self.svgaName = @"抠鼻屎";
                    if ([_customElemModel.extra containsString:@"em_svga_kuku"])     self.svgaName = @"哭哭";
                    if ([_customElemModel.extra containsString:@"em_svga_leihh"])    self.svgaName = @"泪哗哗";
                    if ([_customElemModel.extra containsString:@"em_svga_milian"])   self.svgaName = @"迷恋";
                    if ([_customElemModel.extra containsString:@"em_svga_wuyu1"])    self.svgaName = @"无语";
                    if ([_customElemModel.extra containsString:@"em_svga_xihuan"])   self.svgaName = @"喜欢";
                    if ([_customElemModel.extra containsString:@"em_svga_zuoqq"])    self.svgaName = @"左亲亲";
                    if ([_customElemModel.extra containsString:@"em_svga_youqq"])    self.svgaName = @"右亲亲";
                    return [NSString stringWithFormat:@"%@:", _customElemModel.s_nick];
                } else {
                    return [NSString stringWithFormat:@"%@:%@", _customElemModel.s_nick, _customElemModel.extra];
                }
                
//                }
            }
                break;
            case IM_TYPE_PROHIBIT:
            {
                return [NSString stringWithFormat:@"%@禁言了 %@",_customElemModel.s_nick,_customElemModel.t_nick];
            }
                break;
            case IM_TYPE_UNPROHIBIT:
            {
                return [NSString stringWithFormat:@"%@取消了 %@ 的禁言  ",_customElemModel.s_nick,_customElemModel.t_nick];
            }
                break;
            case IM_TYPE_FOLLOW:
            {
                return [NSString stringWithFormat:@"%@关注了主播",_customElemModel.s_nick];
            }
                break;
            case IM_TYPE_LEVEL_UP:
            {
                return [NSString stringWithFormat:@"%@在直播间中升级了",_customElemModel.s_nick];
            }
                break;
            case IM_TYPE_STAR:
            {
                //12.6 修改 点亮心形图标
                return [NSString stringWithFormat:@"%@点亮了❤️",_customElemModel.s_nick];
            }
                break;
            case IM_TYPE_LIVE_ADMIN_SET_GUARD:
            {
                return [NSString stringWithFormat:@"%@设置%@成场控",_customElemModel.s_nick,_customElemModel.t_nick];
            }
            case IM_TYPE_LIVE_ADMIN_UNSET_GUARD:
            {
                return [NSString stringWithFormat:@"%@取消%@的场控",_customElemModel.s_nick,_customElemModel.t_nick];
            }
                break;
            case IM_TYPE_KICKOUT:
            {
                return [NSString stringWithFormat:@"%@将%@踢出了房间",_customElemModel.s_nick,_customElemModel.t_nick];
            }
                break;
           
            default:
                break;
        }
    }
    return [NSString stringWithFormat:@"%@  %@", [self.sender nickname], _msgText];
}
// 在界面中显示富文本样式
- (NSAttributedString *)avimMsgRichText
{

    if (!_avimMsgRichText || _customElemModel.type==IM_TYPE_GIFT)
    {
        self.svgaName = @"";
        NSString *userName;
        NSString *info;
        UIFont *font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        //有_customElemModel的情况下
        if (_customElemModel) {
            if (_customElemModel.type == IM_TYPE_CHOU_MSG) {
                NSMutableAttributedString *text = [NSMutableAttributedString new];
                for (NSDictionary *dict in _customElemModel.content) {
                    if ([dict.allKeys containsObject:@"img_url"]) {
                        if (![dict[@"img_url"] isEqualToString:@""]) {
                            UIImageView *image = [[UIImageView alloc] init];
                            [image sd_setImageWithURL:[NSURL URLWithString:dict[@"img_url"]]];
                            image.contentMode = UIViewContentModeScaleAspectFill;
                            image.frame = CGRectMake(0, 0, 30, 30);
                            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                            [text appendAttributedString:attachText];
                        }
                    }
                    if ([dict.allKeys containsObject:@"text"]) {
                        if (![dict[@"text"] isEqualToString:@""]) {
                            [text appendAttributedString:[[NSAttributedString alloc] initWithString:dict[@"text"] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithHexString:dict[@"text_color"]]}]];
                        }
                    }
                    
                }
                NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
                paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
                paraStyle01.headIndent = 0.0f;//行首缩进
                //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
                paraStyle01.tailIndent = 0.0f;//行尾缩进
                paraStyle01.lineSpacing = 2.0f;//行间距
                [paraStyle01 setLineBreakMode:NSLineBreakByCharWrapping];
                NSDictionary *dict = @{NSParagraphStyleAttributeName:paraStyle01,NSKernAttributeName:@(1.2)};
                [text addAttributes:dict range:NSMakeRange(0, text.length)];

                 _avimMsgRichText = text;
                return _avimMsgRichText;
                
            }
            if (_customElemModel.type==IM_TYPE_CHAT_MSG) {
                userName = _customElemModel.s_nick;
                info = [self avimMsgText];
            }
            //2018.1.23 添加
            if (_customElemModel.type==IM_TYPE_ENTER) {
                userName = _customElemModel.s_nick;
                info = [self avimMsgText];
            }
            if (_customElemModel.type==IM_TYPE_GIFT) {
                userName = _customElemModel.s_nick;
                info = [self avimMsgText];
            }
            else{
                userName = _customElemModel.s_nick;
                info = [self avimMsgText];
            }
            NSInteger spaceNum=0;
            if ([userName isEqualToString:@"神秘人"] || userName == nil) {
                
            } else {
                
                if (_customElemModel.uimg != nil && ![_customElemModel.uimg isEqualToString:@""] && ![_customElemModel.uimg isEqualToString:@"0.png"]&&![_customElemModel.uimg isKindOfClass:[NSNull class]]) {
                    spaceNum = (2+33+13*[_customElemModel.uimgh floatValue])/4;

                    NSMutableString *str = [[NSMutableString alloc] initWithString:info];
                    for (int i = 0; i<spaceNum; i++) {
                        [str insertString:@" " atIndex:0];
                    }
                    info = str;
                } else {
                    spaceNum = (2+33)/4;

                    NSMutableString *str = [[NSMutableString alloc] initWithString:info];
                    for (int i = 0; i<spaceNum; i++) {
                        [str insertString:@" " atIndex:0];
                    }
                    info = str;
                }
            }
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:info];
            

            [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, userName.length)];
            if ([_customElemModel.s_vip integerValue]==1) {
                [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(spaceNum, userName.length+1)];
            }
            else
            {
                [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF5A623] range:NSMakeRange(spaceNum, userName.length+1)];
            }
            UIColor *nameColor = [UIColor colorWithHex:0xFFEF00];
            switch ([_customElemModel.guizu integerValue]) {
                case 1:
                    nameColor = [UIColor colorWithHex:0xFFBEA1];
                    break;
                case 2:
                    nameColor = [UIColor colorWithHex:0xA1FFDA];
                    break;
                case 3:
                    nameColor = [UIColor colorWithHex:0xD0A1FF];
                    break;
                case 4:
                    nameColor = [UIColor colorWithHex:0x4BB2FF];
                    break;
                case 5:
                    nameColor = [UIColor colorWithHex:0xE695FF];
                    break;
                case 6:
                    nameColor = [UIColor colorWithHex:0xFFBF39];
                    break;
                    
                default:
                    break;
            }
            [attriString addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(spaceNum, userName.length+1)];
            if (_customElemModel.type==IM_TYPE_CHAT_MSG) {
                [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(userName.length+spaceNum+1, info.length - userName.length-spaceNum-1)];
                
            } else {
                [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(userName.length+spaceNum, info.length - userName.length-spaceNum)];
            }
            [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(userName.length, info.length - userName.length)];
            
           // [NSString stringWithFormat:@"%@ 送给 %@ %@个 %@",_customElemModel.s_nick,_customElemModel.t_nick,_customElemModel.r_num,gift.name];
            if (_customElemModel.type==IM_TYPE_GIFT) { //送礼
                if (gift.name)
                {
                    UIImageView *image = [[UIImageView alloc] init];
                    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEAPI,gift.icon]]];
                    image.contentMode = UIViewContentModeScaleAspectFill;
                    image.frame = CGRectMake(0, 0, 20, 20);
                    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                    [attriString appendAttributedString:attachText];
                    
                    NSString *title = [NSString stringWithFormat:@" X%@     ",_customElemModel.r_num];
                    
                    
                    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xff7a91] range:[info rangeOfString:info]];
                            [attriString appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithHex:0xff7a91]}]];
                }
            }
            if (_customElemModel.type==IM_TYPE_ENTER) {
                if (_customElemModel.extra) { //乘坐座驾进入房间
                    [attriString addAttribute:NSForegroundColorAttributeName value:nameColor range:[info rangeOfString:_customElemModel.extra]];
                    [attriString addAttribute:NSForegroundColorAttributeName value:nameColor range:[info rangeOfString:_customElemModel.s_nick]];
                }
                else //普通人进入房间
                {
                    if ([userName isEqualToString:@"神秘人"] || userName == nil) {
                        
                    } else {
                        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xDCD9D9] range:NSMakeRange(0, info.length)];
                        [attriString addAttribute:NSForegroundColorAttributeName value:nameColor range:[info rangeOfString:_customElemModel.s_nick]];
                    }
                }
            }
            NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
            paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
            paraStyle01.headIndent = 0.0f;//行首缩进
            //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
            CGFloat emptylen = font.pointSize * 2;


            paraStyle01.tailIndent = 0.0f;//行尾缩进
            paraStyle01.lineSpacing = 2.0f;//行间距
            [paraStyle01 setLineBreakMode:NSLineBreakByCharWrapping];
            
            NSDictionary *dict = @{NSParagraphStyleAttributeName:paraStyle01,NSKernAttributeName:@(1.2),};
            [attriString addAttributes:dict range:NSMakeRange(0, info.length)];
            

             _avimMsgRichText = attriString;
            
        }else {
            userName = [self.sender nickname];
            info = [self avimMsgText];
            UIFont *fifthFont=[UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            NSString *sysMessage=@"";
            NSString *jumpName = @"";
            if (self.jump_name) {
                jumpName = self.jump_name;
            }
            NSString *msg=[NSString stringWithFormat:@"%@%@",sysMessage,info];
            if (![info isEqualToString:@""])
            {
                NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:msg];
                //8.15 公告的字体颜色紫色
//                switch (SystemColor) {
//                    case NSDataRequestSystemColorPurple:
//                        [attriString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(177, 145, 255, 1) range:NSMakeRange(0, msg.length)];
//                        break;
//                    case NSDataRequestSystemColorYellow:
//                        [attriString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(255, 216, 3, 1) range:NSMakeRange(0, msg.length)];
//                        break;
//                }
                NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
                paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
                paraStyle01.headIndent = 0.0f;//行首缩进
                paraStyle01.tailIndent = 0.0f;//行尾缩进
                paraStyle01.lineSpacing = 2.0f;//行间距
                [paraStyle01 setLineBreakMode:NSLineBreakByCharWrapping];
                NSDictionary *dict = @{NSParagraphStyleAttributeName:paraStyle01,NSKernAttributeName:@(1.2)};
                [attriString addAttributes:dict range:NSMakeRange(0, msg.length)];
                [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x00E5FC] range:NSMakeRange(0, msg.length)];
                [attriString addAttribute:NSFontAttributeName value:fifthFont range:NSMakeRange(0, msg.length)];
//                [attriString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[msg rangeOfString:jumpName]];
                
                
//                NSDictionary *attDic = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:15.0],NSFontAttributeName,[UIColor redColor],NSForegroundColorAttributeName,NSUnderlineStyleAttributeName,NSUnderlineStyleSingle, nil];
                
                [attriString setAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor colorWithHex:0x00E5FC],NSFontAttributeName:fifthFont,NSForegroundColorAttributeName:[UIColor colorWithHex:0x00E5FC]} range:[msg rangeOfString:jumpName]];
//                NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                    [UIFont systemFontOfSize:15.0],NSFontAttributeName,
//                                                    [UIColor redColor],NSForegroundColorAttributeName,
//                                                   NSUnderlineStyleAttributeName,NSUnderlineStyleSingle,nil];
//                [attriString addAttributes:attDic range:[info rangeOfString:jumpName]];
                _avimMsgRichText = attriString;
            }
        }
    }
    return _avimMsgRichText;
}

// 在渲染前，先计算渲染的内容
- (void)prepareForRender
{
    // do nothing
    [YYTCShowLiveMsg defaultShowHeightOf:self inSize:CGSizeMake(kMainScreenWidth * 0.7, HUGE_VALF)];// 0.7
}

+ (UIFont *)defaultFont
{
    return kAppMiddleTextFont;
}
+(float)widthForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

/// 获取富文本文字高度
+ (CGFloat)getAttributedStringHeight:(NSAttributedString *)attributedString width:(CGFloat)width {
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = 0;
    messageLabel.attributedText = attributedString;
    return [messageLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}

+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)width
{
    CGFloat messageLableWidth;
    messageLableWidth = [msg boundingRectWithSize:CGSizeMake(width,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}context:nil].size.height;// 1.26 添加NSStringDrawingUsesLineFragmentOrigin
    return messageLableWidth;
}

+ (CGSize)defaultShowSizeOf:(YYTCShowLiveMsg *)item inSize:(CGSize)size
{
    //如果是礼物消息，要重新计算宽度
    if (item.avimMsgShowSize.width != 0 && item.customElemModel.type!=IM_TYPE_GIFT)
    {

        return item.avimMsgShowSize;
    }
    size.width -= 10;// 4*20 //2017.12.30 此处是修改显示字体的宽度的地方
    //    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    CGSize contentSize;
//    if (item.customElemModel.type == IM_TYPE_GIFT) {
//        contentSize= [item.avimMsgRichText boundingRectWithSize:CGSizeMake(size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;//NSStringDrawingUsesFontLeading
//    } else {
//
//    }

    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(size.width, CGFLOAT_MAX) text:item.avimMsgRichText];
           CGFloat _commentHeight = layout.textBoundingSize.height;
            NSLog(@"YY计算-%f",_commentHeight);
    
    contentSize= [item.avimMsgRichText boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;//NSStringDrawingUsesFontLeading
    
//    contentSize.width = size.width;
    item.avimMsgShowSize = CGSizeMake(size.width, _commentHeight);
    
    return item.avimMsgShowSize;
}

+ (CGFloat)defaultShowHeightOf:(YYTCShowLiveMsg *)item inSize:(CGSize)size
{
    CGSize contentSize = [YYTCShowLiveMsg defaultShowSizeOf:item inSize:size];
    //9.6 修改
    if ([item.svgaName isEqualToString:@""]) {
//        if (item.customElemModel.type == IM_TYPE_GIFT) {
//            return (contentSize.height < 20 ? 20 : contentSize.height + 6) + 10+3;
//        } else
        if (item.customElemModel.type == IM_TYPE_CHOU_MSG) {
            return (contentSize.height < 20 ? 20 : contentSize.height + 6) + 10;
        }
        return (contentSize.height < 24 ? 24 : contentSize.height + 6) + 4;
    } else {
        return ((contentSize.height < 24 ? 24 : contentSize.height + 6) + 3) * 2 - 4;
    }
    
    //return 3 + (contentSize.height < 24 ? 24 : contentSize.height + 8) + 3;
}

@end

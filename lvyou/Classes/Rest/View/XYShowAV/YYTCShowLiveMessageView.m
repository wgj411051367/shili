//
//  TCShowLiveMessageView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "YYTCShowLiveMessageView.h"
#import "RankPeopleModel.h"
#import "AppDelegate.h"
#import "SDWebImage.h"
#import "UIView+CustomAutoLayout.h"
#import "SDWebImage.h"
#import "YYText.h"

#define SYS_ANNOUNCE 8888
#define NORMAL_MSG 7777
#define kDefaultMargin  22
@interface TCShowLiveMsgTableViewCell : UITableViewCell<SVGAPlayerDelegate>
{
//    UIButton                *_msgImageView,*shouhuImg;//7.17
//    UILabel                 *_msgLabel;
    RankPeopleModel         *rankPeopleModel;
    __weak YYTCShowLiveMsg    *_msgItem;
    
}
@property (nonatomic, assign) BOOL hided;//是否隐身  10.12添加
@property(nonatomic,strong)YYLabel                 *msgLabel;
//@property(nonatomic,strong)UILabel                 *msgLabel;
@property(nonatomic,strong)UIButton                 *msgImageView;
@property(nonatomic,strong)UIButton                 *msgStarImageView;
@property(nonatomic,strong)UIButton                 *shouhuImg;
@property(nonatomic,strong)SVGAParser *parser;
@property(nonatomic,strong)SVGAPlayer *player;
@property(nonatomic,strong)UIView    *msgBack;
@property(nonatomic,copy)  NSArray   *svgaArr;

@property(nonatomic,assign)  NSInteger   lastIndex;// 上一次替换的是哪一个

- (void)config:(YYTCShowLiveMsg *)item;
@property(nonatomic,copy)void (^cellClick)(YYTCShowLiveMsg *item);

@end

//====================================

@implementation TCShowLiveMsgTableViewCell

- (void)grounderChatNextView:(NSNotification *)notification
{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.transform = CGAffineTransformMakeScale(1, -1);
        self.backgroundColor = [UIColor clearColor];
        if (self.msgBack==nil) {
            self.msgBack = [[UIView alloc] init];
            //        背景颜色去掉
            self.msgBack.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
            self.msgBack.layer.cornerRadius=6;
//            self.msgBack.layer.masksToBounds=YES;
            [self.contentView addSubview:self.msgBack];
        }
        if (_msgStarImageView==nil) {
            _msgStarImageView=[[UIButton alloc] init];
            [self.msgBack addSubview:_msgStarImageView];
        }
        if (_msgImageView==nil) {
            _msgImageView =[[UIButton alloc]init];
            [self.msgBack addSubview:_msgImageView];
        }
        
        if (_shouhuImg==nil) {
            _shouhuImg =[[UIButton alloc]init];
            [self.msgBack addSubview:_shouhuImg];
        }
        if (_msgLabel==nil) {
            _msgLabel = [[YYLabel alloc] init];
            _msgLabel.backgroundColor = [UIColor clearColor];
            _msgLabel.numberOfLines = 0;
            _msgLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _msgLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
//            _msgLabel.shadowColor = colorLetterGray3;
//            _msgLabel.shadowOffset = CGSizeMake(1.0,1.0);
//            _msgLabel.font=[UIFont fontWithName:@"PingFangTC-Light" size:14];
            _msgLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
            [_msgLabel addGestureRecognizer:tap];
            [self.msgBack addSubview:_msgLabel];
        }
        if (!_player) {
            _player = [[SVGAPlayer alloc] init];
            self.parser = [[SVGAParser alloc] init];
            _player.userInteractionEnabled=NO;
            _player.backgroundColor=[UIColor clearColor];
            _player.delegate=self;
            _player.contentMode=UIViewContentModeScaleAspectFill; //填充整个页面
            _player.loops =1;//播放3次
            _player.clearsAfterStop = NO;
            [self.msgBack addSubview:_player];
            _player.hidden = YES;
        }
        
    }
    return self;
}

//播放svga
- (void)showSVGAParserWithUrl:(NSString *)name
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:name ofType:@"svga"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];

    
    __weak typeof(self)weakself =self;
    [self.parser parseWithData:data cacheKey:name completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            weakself.player.videoItem = videoItem;
            [weakself.player startAnimation];
        }
    } failureBlock:^(NSError * _Nonnull error) {
                [weakself stop];
//        [weakself.player clear];
    }];
    
    //    [self.marrySvgView sendSubviewToBack:weakself.player];
}

// 播放完成的回调 进行下一次的播放
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player;
{
    [self stop];
//    [self.player clear];
    
}

- (void)stop {
    if (self.player) {
        [self.player stopAnimation];
//        [self.player removeFromSuperview];
//        self.player=nil;
    }
//    if (self.parser) {
//        self.parser=nil;
//    }
}

-(void)tapClick{
    if (self.cellClick) {
        self.cellClick(_msgItem);
    }
}

- (void)config:(YYTCShowLiveMsg *)item
{
    _msgItem = item;
    if (_msgItem.customElemModel.chat_bg_color) {
        if (![_msgItem.customElemModel.chat_bg_color isEqualToString:@""]) {
            self.msgBack.backgroundColor = [UIColor colorWithHexString:_msgItem.customElemModel.chat_bg_color];
        } else {
            self.msgBack.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
        }
    } else {
        self.msgBack.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
    }
    
    if ([AppDelegate appDelegate].rankDic!=nil) { //4.19添加不为空的判断
       rankPeopleModel = [[RankPeopleModel alloc] initWithDictionary:[[AppDelegate appDelegate].rankDic objectForKey:_msgItem.customElemModel.s_level] error:nil];
    }
    [_msgStarImageView setImage:nil forState:UIControlStateNormal];
    [_msgStarImageView setBackgroundImage:nil forState:UIControlStateNormal];
    [_msgStarImageView setTitle:@"" forState:UIControlStateNormal];
    
    [_msgImageView setImage:nil forState:UIControlStateNormal];
    [_msgImageView setBackgroundImage:nil forState:UIControlStateNormal];
    [_msgImageView setTitle:@"" forState:UIControlStateNormal];
    
    
    
    [_shouhuImg setImage:nil forState:0];
    [_shouhuImg setBackgroundImage:nil forState:0];
    [_shouhuImg setTitle:@"" forState:0];
    
    if (_msgItem.ishost) {
        [_msgImageView setImage:[UIImage imageNamed:@"host"] forState:UIControlStateNormal];
        item.ishost = YES;
        
    }else{
        item.ishost = NO;
        
//        if (_msgItem.isGuard) {
//            item.isGuard = YES;
//            [_msgStarImageView setImage:[UIImage imageNamed:@"manage"] forState:UIControlStateNormal];
//            _msgStarImageView.titleLabel.font=[UIFont systemFontOfSize:10.f];
//            _msgStarImageView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//            _msgStarImageView.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
//        } else {
            item.isGuard = NO;
//        }
        if (rankPeopleModel.img!=nil) { //4.19添加不为空的判断
            [_msgImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEAPI,rankPeopleModel.img]] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRetryFailed];//1.5下载失败的时候继续下载
        }
//        [_msgImageView setTitle:_msgItem.customElemModel.s_level  forState:UIControlStateNormal];
        _msgImageView.titleLabel.font=[UIFont systemFontOfSize:10.f];
        _msgImageView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _msgImageView.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        
        
        
    }
    self.hided=item.ishide;
    ///6.21 增加新的图标
    if (_msgItem.customElemModel.uimg!=nil&&![_msgItem.customElemModel.uimg isEqualToString:@""]&&![_msgItem.customElemModel.uimg isEqualToString:@"0.png"]) {
        [_shouhuImg sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@img/lvv2/userico/%@",DATAAPI,_msgItem.customElemModel.uimg]] forState:UIControlStateNormal placeholderImage:nil];
    }
    _msgLabel.attributedText = [item avimMsgRichText];
    if (!item.customElemModel) {
        _msgLabel.tag=SYS_ANNOUNCE;
        self.player.hidden = YES;
    }
    else{
        _msgLabel.tag=NORMAL_MSG;
        NSRange range = [_msgLabel.text rangeOfString:@":"];
        NSInteger length = _msgLabel.text.length;
        if (range.location + range.length == length) {
            self.player.hidden = NO;
            [self showSVGAParserWithUrl:item.svgaName];
        } else {
            self.player.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect frame = self.contentView.frame;
    //frame.size.width *= 0.7;
    CGSize size = _msgItem.avimMsgShowSize;
    CGFloat leftX=5;
    
    CGFloat top,labTop,imgWidth;
    imgWidth = 0;
    if ([_msgItem.svgaName isEqualToString:@""]) {
        top = 4;
        labTop = 3*ScreenBiLi;
    } else {
        top = 4;
        labTop = 3*ScreenBiLi;
    }
    
    _msgImageView.frame=CGRectMake(5, top, 38, 15);// 之前的x=0 y=8
    _msgStarImageView.frame = CGRectMake(_msgImageView.frame.origin.x+_msgImageView.frame.size.width+2, top, 38, 15);
    _shouhuImg.hidden = NO;
    if (_msgItem.ishide) {
        _shouhuImg.hidden = YES;
        _shouhuImg.frame = CGRectMake(0, 0, 0, 0);
        _msgImageView.frame = CGRectMake(0, 0, 0, 0);
        _msgStarImageView.frame = CGRectMake(0, 0, 0, 0);
    }
    if (_msgItem.customElemModel.uimg!=nil&&![_msgItem.customElemModel.uimg isEqualToString:@""] &&![_msgItem.customElemModel.uimg isEqualToString:@"0.png"]) {
        if (_msgItem.ishost) {
            _shouhuImg.frame=CGRectMake(_msgImageView.frame.origin.x+_msgImageView.frame.size.width+5,top, 15*[_msgItem.customElemModel.uimgh floatValue], 15);
            leftX+=_shouhuImg.frame.size.width;
        } else if (_msgItem.isGuard) {
            _msgImageView.frame=CGRectMake(_msgImageView.frame.origin.x+_msgImageView.frame.size.width+2, top, 38, 15);
            _msgStarImageView.frame = CGRectMake(5, top, 38, 15);// 之前的x=0 y=8
            _shouhuImg.frame=CGRectMake(_msgStarImageView.frame.origin.x+_msgImageView.frame.size.width + _msgStarImageView.frame.size.width + 5,top, 15*[_msgItem.customElemModel.uimgh floatValue], 15);
            leftX+=8+15*[_msgItem.customElemModel.uimgh floatValue];
        } else {
            _shouhuImg.frame=CGRectMake(_msgImageView.frame.origin.x+_msgImageView.frame.size.width+5,top, 15*[_msgItem.customElemModel.uimgh floatValue], 15);
            leftX+=8+15*[_msgItem.customElemModel.uimgh floatValue];
        }
        
    }
    imgWidth = _shouhuImg.frame.size.width+_msgImageView.frame.size.width+_msgStarImageView.frame.size.width;
    CGSize size1 = [self widthForAttributed:_msgLabel.attributedText inSize:CGSizeMake(MAXFLOAT, 30*ScreenBiLi)];
    if (size1.width > frame.size.width *0.7) {
        size1 = [self widthForAttributed:_msgLabel.attributedText inSize:CGSizeMake(frame.size.width *0.7, MAXFLOAT)];
    }
    if(_msgLabel.tag==NORMAL_MSG){
        
        
//        float width = ([self widthForString:_msgLabel.text fontSize:14.0 andHeight:_msgLabel.frame.size.height]+20*ScreenBiLi) > (frame.size.width *0.7) ? frame.size.width *0.7 : [self widthForString:_msgLabel.text fontSize:14.0 andHeight:_msgLabel.frame.size.height]+20*ScreenBiLi;
//        float height;
//        if (frame.size.height < 30*ScreenBiLi) {
//            width = width + 15*ScreenBiLi;
//        }
        _msgLabel.frame =CGRectMake(5, labTop, size1.width, frame.size.height);//y=6
        self.msgBack.frame=CGRectMake(5, 0, size1.width+10, frame.size.height-4*ScreenBiLi);//12.28修改leftX*3/2

        NSRange range = [_msgLabel.text rangeOfString:@":"];
        NSInteger length = _msgLabel.text.length;
        if (range.location + range.length == length) {

            [_player setFrame:CGRectMake([self widthForString:_msgLabel.text fontSize:16.0 andHeight:_msgLabel.frame.size.height]+30, 0, size.height*2, size.height*2)];
        
            if ([_msgItem.svgaName isEqualToString:@""]) {
                self.msgBack.frame=CGRectMake(2, 0, frame.size.width *0.7+5*ScreenBiLi, frame.size.height-4*ScreenBiLi);//12.28修改leftX*3/2
            } else {
                self.msgBack.frame=CGRectMake(2, 0, frame.size.width *0.7+5*ScreenBiLi, frame.size.height-4*ScreenBiLi);//12.28修改leftX*3/2
            }
        }
    }
    else if(_msgLabel.tag==SYS_ANNOUNCE){
        _msgLabel.frame =CGRectMake(5, labTop, size1.width, frame.size.height);//y=6
        self.msgBack.frame=CGRectMake(5, labTop,size1.width+10, frame.size.height-8*ScreenBiLi);
        

    }
    
    
//    NSLog(@"公屏消息 宽 = %@  宽高 = %@",NSStringFromCGSize(size1),NSStringFromCGSize(size1));
}

#pragma -mark -functions

//获取字符串的宽度

-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{

    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置

    return sizeToFit.width;
}


- (CGSize)widthForAttributed:(NSAttributedString *)attributedText inSize:(CGSize)size {
    CGSize contentSize;
    contentSize= [attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return contentSize;
}



@end
//===========================================

@interface YYTCShowLiveMessageView ()
{
    BOOL _isScrolling;
}

@end

@implementation YYTCShowLiveMessageView


#define kMaxMsgCount 100
- (void)initTableView{
    self.clipsToBounds = YES;
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = YES;
//    _tableView.clipsToBounds = NO;
    [_tableView setBackgroundView:nil];
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _liveMessages = [[NSMutableArray alloc] init];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
    {
        [self initTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initTableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.scrollsToTop=NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = YES;
    [_tableView setBackgroundView:nil];
    _tableView.backgroundColor = [UIColor clearColor];

    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width-5, self.bounds.size.height);//2017.12.30 self.bounds.size.width-self.frame.origin.x-5
//    _tableView.contentOffset = CGPointMake(0, _tableView.contentSize.height - _tableView.bounds.size.height);
    _tableView.transform = CGAffineTransformMakeScale(1, -1);
    
}

// 主要是上线消息
- (void)insertOnlineFrom:(UserInfoModel *)user
{
    [self insertText:@"进来了" from:user isMsg:NO];
}
- (void)insertText:(NSString *)message from:(UserInfoModel *)user
{
    _msgCount++;
    [self insertText:message from:user isMsg:YES];
}


#define kTableViewMaxHeigh 260

- (void)updateTableViewFrame:(CGFloat)heigt offsert:(CGFloat)scrolloff
{
    
    CGRect rect = _tableView.frame;
    rect.origin.y -= heigt;
    // 显示从(0,0.2, 0.7,1)的位置
    if (rect.size.height + heigt >= kTableViewMaxHeigh)
    {
        _tableView.frame = CGRectMake(0, self.bounds.size.height - kTableViewMaxHeigh, self.bounds.size.width, kTableViewMaxHeigh);
        
//        CGPoint off = _tableView.contentOffset;
//        off.y += scrolloff;
//        _tableView.contentOffset = off;
    }
    else
    {
        rect.size.height += heigt;
        _tableView.frame = rect;
    }
    //#endif
}

- (void)insertMsg:(YYTCShowLiveMsg *)item//(id<NSObject>)item 5.16修改
{
    _msgCount++;
    
    if (_isPureMode)
    {
        @synchronized(_liveMessages)
        {
            if (_liveMessages.count >= kMaxMsgCount)
            {
                [_liveMessages removeLastObject];
            }
            [_liveMessages insertObject:item atIndex:0];
        }
    }
    else
    {
        @synchronized(_liveMessages)
        {
            CGFloat scrolloff = 0;
            [_tableView beginUpdates];
            
            if (_liveMessages.count >= kMaxMsgCount)
            {
                YYTCShowLiveMsg *msg = [_liveMessages objectAtIndex:0];
                
                CGFloat text_width=[self getWidthFromItem:msg];
                scrolloff -= [YYTCShowLiveMsg defaultShowHeightOf:msg inSize:CGSizeMake(text_width, HUGE_VALF)];
                NSIndexPath *index = [NSIndexPath indexPathForRow:_liveMessages.count-1 inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
                [_liveMessages removeLastObject];
            }
            [_liveMessages insertObject:item atIndex:0];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
            
            
            [_tableView endUpdates];
            
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            CGFloat text_width=[self getWidthFromItem:item];
            CGFloat heigt = [YYTCShowLiveMsg defaultShowHeightOf:item inSize:CGSizeMake(text_width, HUGE_VALF)];
            scrolloff += heigt;
            
            [self updateTableViewFrame:heigt offsert:scrolloff];
        }
    }
    
}

- (void)insertTCShowMsg:(YYTCShowLiveMsg *)item andLeft:(BOOL)isLeft andisMsg:(BOOL)isMsg
{
//    if (!isLeft) {
        _msgCount++;
//    }
    item.isMsg = isMsg;
    if (_isPureMode)
    {
        @synchronized(_liveMessages)
        {
            if (_liveMessages.count >= kMaxMsgCount)
            {
                [_liveMessages removeLastObject];
            }
//            if (!isLeft) {
                [_liveMessages insertObject:item atIndex:0];
//            }
        }
    }
    else
    {
        @synchronized(_liveMessages)
        {
            ///2017.6.8 此处往下注释的代码指的是送礼的话 时间不超过3秒会只显示一条 而不是一条一条的显示
//            [_liveMessages removeObjectAtIndex:0];
            if (_liveMessages.count > 0) {

                

                YYTCShowLiveMsg *item1 = _liveMessages[0];
                YYTCShowLiveMsg *item2;
                if (_liveMessages.count > 1) {
                    item2 = _liveMessages[1];
                    if (!item1.isMsg && !item2.isMsg) {
                        // 最近两条都是欢迎
                        if (item.isMsg) {
                            [_liveMessages removeObjectAtIndex:1];
                            [_liveMessages insertObject:item atIndex:1];
                            [_tableView reloadData];
                        } else {
                            [_liveMessages removeObjectAtIndex:1];
                            [_liveMessages insertObject:item atIndex:0];
                            [_tableView reloadData];
                        }
                        return;
                    } else if (!item1.isMsg && item.isMsg) {
                        [_liveMessages removeObjectAtIndex:0];
                        [_liveMessages insertObject:item atIndex:0];
                        [_tableView reloadData];
                        return;
                    }
                }
                
//                if (!item1.isMsg) {
//                    [_liveMessages removeObjectAtIndex:0];
//                    [_liveMessages insertObject:item atIndex:0];
//                    [_tableView reloadData];
//                    return;
//                }
            }
            
            CGFloat scrolloff = 0;
            [_tableView beginUpdates];
            BOOL haveExist=NO;
            int row=0;
            //显示时间是3000ms
            float showtime=3*1000;
            // 获取当前时间 如果消息显示时间小于3s 就刷新送礼个数 刷新之后让时间等于当前时间 下次显示的消息数据时间还从当前时间来计算
            NSNumber *currentTime=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]*1000];
            for (YYTCShowLiveMsg *msgItem in _liveMessages) {
                if  (msgItem.customElemModel.r_id==item.customElemModel.r_id && msgItem.customElemModel.s_uid==item.customElemModel.s_uid && msgItem.customElemModel.t_uid==item.customElemModel.t_uid&&item.customElemModel.type==IM_TYPE_GIFT&&([currentTime doubleValue]-[msgItem.customElemModel.time doubleValue])<showtime) {
                    haveExist=YES;
                    if (isLeft) {
                        NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 更新界面 4.25
                            [UIView performWithoutAnimation:^{
                               [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    //                                         [_tableView reloadData];//18.5.23修改
                            }];
                         });
                        msgItem.customElemModel.time=currentTime;
                        continue;
                    } else {
                        NSInteger currentNum=[msgItem.customElemModel.r_num intValue];
                        NSInteger addNum=[item.customElemModel.r_num intValue];
                        msgItem.customElemModel.r_num=[NSString stringWithFormat:@"%ld",currentNum+addNum];
                        NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 更新界面 4.25
                            [UIView performWithoutAnimation:^{
                               [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    //                                         [_tableView reloadData];//18.5.23修改
                            }];
                         });
                        msgItem.customElemModel.time=currentTime;
                    }
                    
                     break;
                }
                row++;
            }
            if (!haveExist) {
                if (_liveMessages.count >= kMaxMsgCount)
                {
                    YYTCShowLiveMsg *msg = [_liveMessages lastObject];
                    scrolloff -= [YYTCShowLiveMsg defaultShowHeightOf:msg inSize:CGSizeMake(self.bounds.size.width, HUGE_VALF)];
                    NSIndexPath *index = [NSIndexPath indexPathForRow:_liveMessages.count-1 inSection:0];
                    [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
                    [_liveMessages removeLastObject];
                }
                [_liveMessages insertObject:item atIndex:0];

                
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];


            }

            [_tableView endUpdates];
            if (!haveExist) {
//                CGFloat heigt = [TCShowLiveMsg defaultShowHeightOf:item inSize:CGSizeMake(self.bounds.size.width, HUGE_VALF)];
//                scrolloff += heigt;
//                [self updateTableViewFrame:heigt offsert:scrolloff];
            }
            //此处往下的代码是msgview一条一条的显示
//            CGFloat scrolloff = 0;
//            [_tableView beginUpdates];
//
//            if (_liveMessages.count >= kMaxMsgCount)
//            {
//                TCShowLiveMsg *msg = [_liveMessages objectAtIndex:0];
//
//                CGFloat text_width=[self getWidthFromItem:msg];
//                scrolloff -= [TCShowLiveMsg defaultShowHeightOf:msg inSize:CGSizeMake(text_width, HUGE_VALF)];
//                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
//                [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
//                [_liveMessages removeObjectAtIndex:0];
//            }
//
//            NSIndexPath *index = [NSIndexPath indexPathForRow:_liveMessages.count inSection:0];
//            [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
//            [_liveMessages addObject:item];
//
//            [_tableView endUpdates];
//            CGFloat text_width=[self getWidthFromItem:item];
//            CGFloat heigt = [TCShowLiveMsg defaultShowHeightOf:item inSize:CGSizeMake(text_width, HUGE_VALF)];
//            scrolloff += heigt;
//
//            [self updateTableViewFrame:heigt offsert:scrolloff];
        }
    }
}
- (void)insertText:(NSString *)message from:(UserInfoModel *)user isMsg:(BOOL)isMsg
{
    if (!message.length)
    {
        // 空消息不发送
        return;
    }
    YYTCShowLiveMsg *item = [[YYTCShowLiveMsg alloc] initWith:user message:message];
    item.isMsg = isMsg;
    
    if (_isPureMode)
    {
        @synchronized(_liveMessages)
        {
            if (_liveMessages.count >= kMaxMsgCount)
            {
                [_liveMessages removeObjectAtIndex:0];
            }
            [_liveMessages addObject:item];
        }
        
    }
    else
    {
        @synchronized(_liveMessages)
        {
            CGFloat scrolloff = 0;
            [_tableView beginUpdates];
            
            if (_liveMessages.count >= kMaxMsgCount)
            {
                YYTCShowLiveMsg *msg = [_liveMessages objectAtIndex:0];
                
                scrolloff -= [YYTCShowLiveMsg defaultShowHeightOf:msg inSize:CGSizeMake([self getWidthFromItem:msg], HUGE_VALF)];
                NSIndexPath *index = [NSIndexPath indexPathForRow:_liveMessages.count inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
                [_liveMessages removeLastObject];
            }
            [_liveMessages insertObject:item atIndex:0];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
            
            
            
            [_tableView endUpdates];
//            [_tableView setScrollsToTop:YES];
            
            CGFloat heigt = [YYTCShowLiveMsg defaultShowHeightOf:item inSize:CGSizeMake([self getWidthFromItem:item], HUGE_VALF)];
            scrolloff += heigt;
            
            [self updateTableViewFrame:heigt offsert:scrolloff];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _liveMessages.count;
}
-(CGFloat)getWidthFromItem:(YYTCShowLiveMsg *)item{
    
    CGFloat text_width=_tableView.frame.size.width;
    if (item.customElemModel) {
//        if (item.customElemModel.uimg != nil && ![item.customElemModel.uimg isEqualToString:@""] && ![item.customElemModel.uimg isEqualToString:@"0.png"]) {
//            text_width=text_width-5-33-8-15*[item.customElemModel.uimgh floatValue]-5;
//        }
//        else{
            text_width=text_width;
//        }
    }
    return text_width*0.7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYTCShowLiveMsg *item = [_liveMessages objectAtIndex:indexPath.row];
    CGFloat text_width=[self getWidthFromItem:item];
//    NSLog(@"contentSize5%f",text_width);
    CGFloat f=[YYTCShowLiveMsg defaultShowHeightOf:item inSize:CGSizeMake(text_width, HUGE_VALF)];
    return f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakself=self;
    TCShowLiveMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCShowLiveMsgTableViewCell"];
    if (!cell)
    {
        cell = [[TCShowLiveMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TCShowLiveMsgTableViewCell"];
        cell.cellClick = ^(YYTCShowLiveMsg *item){
            if (weakself.block) {
                weakself.block(item);
            }
        };
    }
    cell.layer.shouldRasterize = YES; //2018.8.30
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    if (indexPath.row<_liveMessages.count) {
        YYTCShowLiveMsg *item = [_liveMessages objectAtIndex:indexPath.row];
        [cell config:item];
        [cell setNeedsLayout];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYTCShowLiveMsg *item = [_liveMessages objectAtIndex:indexPath.row];
    
    if (self.blockdissmiss) {
        self.blockdissmiss();
    }
}

- (void)changeToMode:(BOOL)pure
{
    _isPureMode = pure;
    if (!_isPureMode)
    {
        [_tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"offsect = %f",scrollView.contentOffset.y);
    _lastContentOffset = scrollView.contentOffset.y;
}
- (void)dealloc
{
    NSLog(@"TCShowLiveMessageView dealloc");
}
@end


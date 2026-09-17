//
//  TCShowLiveMsg.h
//  TCShow
//
//  Created by AlexiChen on 16/4/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "CustomElemModel.h"
#import "AVIMMsg.h"
@interface YYTCShowLiveMsg : AVIMMsg
@property (nonatomic, strong) NSString *svgaName;
@property (nonatomic, assign) BOOL isMsg;               // NO：进入消息，YES：聊天消息
@property (nonatomic, strong) UIColor *nameColor;       // 显示名字的颜色
@property (nonatomic, assign) BOOL ishost;
@property (nonatomic, assign) BOOL ishide;//是否隐身
@property (nonatomic, assign) BOOL isGuard;// 是否是管理员
@property (nonatomic, copy) NSString *jump_url;
@property (nonatomic, copy) NSString *jump_name;
@property (nonatomic, strong) NSAttributedString *avimMsgRichText;
@property (nonatomic, strong) NSAttributedString *avimMsgRichTextNew;
@property (nonatomic, assign) CGSize avimMsgShowSize;
@property (nonatomic, strong) CustomElemModel *customElemModel;
+ (CGFloat)defaultShowHeightOf:(YYTCShowLiveMsg *)item inSize:(CGSize)size;

- (instancetype)initWithMessage:(NSString *)message;
- (instancetype)initWith:(UserInfoModel *)user message:(NSString *)message;
- (instancetype)initWithCustom:(UserInfoModel *)user message:(CustomElemModel *)message;

@end

// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  ToolHelper.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ToolHelper : NSObject

/**
 *  初始化方法
 */
+ (ToolHelper*)toolHelper;

/**
 *  是否已升级数据库
 */
- (BOOL)dbMigrate;

/**
 *  生成随机字符串
 */
- (NSString*)randomString;

/**
 *  分析字符串
 */
- (int)charactersInString:(NSString*)string;

/**
 *  裁剪图片
 */
- (UIImage*)cropImage:(UIImage*)image;
- (UIImage*)scaleToScreenWidth:(UIImage*)origin;

/**
 *  分割字符串
 */
- (NSMutableArray*)stringToArr:(NSString*)string seprate:(NSString*)sep;

/**
 *  分割数组，生成字符串
 */
- (NSString *)stringToString:(NSMutableArray*)array seprate:(NSString*)sep;

/**
 *  检验本地沙盒中是否有该key的值
 */
- (BOOL)basicUserDefaults:(NSString *)key;
- (void)oppsiteUserDefaults:(NSString*)key;

/**
 *  标记是否为第一次打开App
 */
-(BOOL)firstLaunch;

/**
 *  时间转化串成时间戳
 */
- (NSString *)formatStringDate:(NSUInteger)time style:(NSString*)style;

/**
 *  时间转化成时间戳
 */
- (NSString *)formatDate:(NSDate *)date style:(NSString*)style;

- (NSString *)getNowTimeTimestamp3;

/**
 *  当前时间
 */
- (NSString*)nonceTime:(NSString *)style;

/**
 *  计算某个时间距离今天的时间
 */
- (NSString*)rangeDate:(NSInteger)timeInt;

/**
 *  计算两个日期之间相差几天
 */
- (NSString*)tooOverdue:(NSString *)endDateStr;

/**
 *  过滤html
 */
- (NSString *)flattenHTML:(NSString *)html;

/**
 *  友好化距离显示
 */
- (NSString *)formatDistance:(float)distance;

/**
 *  验证邮箱
 */
- (BOOL)validateEmail:(NSString *)email;

/**
 *  验证手机号  
 */
- (BOOL)validatePhone:(NSString *)phone;

/**
 *  验证身份证号
 */
- (BOOL)validateIdentityCard:(NSString *)identityCard;
//4.19
/**
 *  验证银行卡
 */
- (BOOL) IsBankCard:(NSString *)cardNumber;
/*
 * MD5加密
 */
- (NSString *)encryptMD5:(NSString *)string;

/*
 * 计算文字长度
 */
- (CGSize)sizeWithString:(NSString *)string andSize:(NSInteger)size;

/*
 * 替换某个范围的子串
 */
- (NSString *)byReplacingCharActer:(NSString *)phone;

/*
 * 截取一定长度的串
 */
- (NSString *)interceptReplacingString:(NSString *)time;

/*
 * 判断是否有http://子串
 */
- (BOOL)ReplacingCharActer:(NSString *)portrait;

/*
 * 判断是否无值
 */
- (BOOL)isBlankString:(NSString *)string;

/*
 * 根据月份和日期计算星座
 */
- (NSString *)getAstroWithMonth:(NSInteger)month day:(NSInteger)day;

/*
 * 根据编号获取星座名称
 */
- (NSString *)getconstellationTag:(NSUInteger)integer;

/*
 * 根据编号获取会员金额
 */
- (NSUInteger)memberShellTag:(NSUInteger)integer;

/*
 * 根据编号获取会员时间
 */
- (NSUInteger)membeTimeTag:(NSUInteger)integer;

/*
 * 根据编号获取赠送会员礼包类型
 */
- (NSString *)membeBagag:(NSUInteger)integer;
- (NSString *)lianghaoNum:(NSUInteger)integer;
/*
 * 将GIF图分解成数组
 */
- (NSMutableArray *)decomposeGIFToImageData:(NSData *)data andStart:(size_t)start andOver:(size_t)over;
/*
 * 当前是否有网络
 */
- (BOOL)connectedToNetwork;
//6.15
-(NSString *)realAvatarUrl:(NSString *)uid andUpdate:(NSString*)update;

// 字符串转时间戳
- (NSDate *)dateWitchString:(NSString *)time andWithFormat:(NSString *)formatStr;
@end

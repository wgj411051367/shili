// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  ToolHelper.m
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "ToolHelper.h"
#import <ImageIO/ImageIO.h>
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

NSDate *date;
NSDateFormatter *dateFormatter;

@implementation ToolHelper

/**
 *  初始化方法
 */
+ (ToolHelper*)toolHelper
{
    static ToolHelper *toolHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        toolHelper = [[ToolHelper alloc] init];
        dateFormatter=[[NSDateFormatter alloc]init];
    });
    return toolHelper;
}

/**
 *  是否已升级数据库
 */
- (BOOL)dbMigrate
{
    return [self basicUserDefaults:[NSString stringWithFormat:@"dbMigrate%@",MyAppBuilder]];
}

/**
 *  生成随机字符串
 */
- (NSString*)randomString
{
    char data[15];
    for (int x=0;x<10;data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:10 encoding:NSUTF8StringEncoding];
}

/**
 *  分析字符串
 */
- (int)charactersInString:(NSString*)string
{
    int strlength = 0;
    char* p = (char*)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
    }
    return (strlength+1)/2;
}
/**
 *  裁剪图片
 */
- (UIImage*)cropImage:(UIImage*)image
{
    // Create rectangle from middle of current image
    CGRect croprect = CGRectMake(image.size.width -200, 0 ,
                                 (200), (image.size.height));
    // Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
    // Create new cropped UIImage
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    return croppedImage;
}

- (UIImage *)scaleToScreenWidth:(UIImage *)origin
{
    CGSize originSize = origin.size;
    CGSize newSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*originSize.height/originSize.width);
    
    UIGraphicsBeginImageContext(originSize);
    [origin drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  分割字符串
 */
- (NSMutableArray*)stringToArr:(NSString*)string seprate:(NSString*)sep
{
    return [NSMutableArray arrayWithArray:[string componentsSeparatedByString:sep]];
}

/**
 *  分割数组，生成字符串
 */
- (NSString *)stringToString:(NSMutableArray*)array seprate:(NSString*)sep
{
    return [array componentsJoinedByString:sep];
}

/**
 *  检验本地沙盒中是否有该key的值
 */
- (BOOL)basicUserDefaults:(NSString *)key
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:key])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)oppsiteUserDefaults:(NSString*)key
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:key])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    }
}

/**
 *  标记是否为第一次打开ApptooOverdue
 */
-(BOOL)firstLaunch
{
    return [self basicUserDefaults:[NSString stringWithFormat:@"firstLaunch%@",APIVersion]];
}

/**
 *  时间转化串成时间戳
 */
- (NSString *)formatStringDate:(NSUInteger)time style:(NSString*)style
{
    date = [NSDate dateWithTimeIntervalSince1970:time];
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:style];
    return [dateFormatter stringFromDate:date];
}

/**
 *  时间转化成时间戳
 */
- (NSString *)formatDate:(NSDate *)time style:(NSString*)style
{
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:style];
    return [dateFormatter stringFromDate:time];
}

- (NSString *)getNowTimeTimestamp3{

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];

    return timeSp;
}

/**
 *  当前时间
 */
- (NSString*)nonceTime:(NSString *)style
{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:style];
    NSString * na = [df stringFromDate:currentDate];
    
    return na;
}


/**
 *  计算某个时间距离今天的时间
 */
- (NSString*)rangeDate:(NSInteger)timeInt
{
    //计算时间
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * newDateFormatter = [dateFormatter dateFromString:[self formatStringDate:timeInt style:@"yyyy-MM-dd HH:mm:ss"]];       //取出的时间
    
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate * current_date = [[NSDate alloc] init];
    
    NSTimeInterval time = [current_date timeIntervalSinceDate:newDateFormatter];
    
    int month = ((int)time)/(3600*24*30);
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/60;
    int second = ((int)time)%(3600*24*60*60);
    if(month!=0)
    {
        return [NSString stringWithFormat:@"%i%@",month,@"个月前"];
    }
    else if(days!=0)
    {
        return [NSString stringWithFormat:@"%i%@",days,@"天前"];
    }
    else if(hours!=0)
    {
        return [NSString stringWithFormat:@"%i%@",hours,@"小时前"];
    }
    else if(minute!=0)
    {
        return [NSString stringWithFormat:@"%i%@",minute,@"分钟前"];
    }
    else
    {
        return [NSString stringWithFormat:@"%i%@",second,@"秒前"];
    }
}

/**
 *  计算两个日期之间相差几天
 */
- (NSString*)tooOverdue:(NSString *)endDateStr
{
    // 创建日期格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = TimeDetailedStyle;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *nowDate = [NSDate date];
    NSDate *endDate = [dateFormatter dateFromString:endDateStr];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:nowDate toDate:endDate options:0];
    //NSLog(@"time-----%@",[NSString stringWithFormat:@"距离靓号过期时间还有:%ld年%ld月%ld天%ld时%ld分%ld秒",(long)comps.year,(long)comps.month,(long)comps.day,(long)comps.hour,(long)comps.minute,(long)comps.second]);
    return [NSString stringWithFormat:@"%ld天",(long)comps.year*365+(long)comps.month*30+(long)comps.day];
}

/**
 *  过滤html
 */
- (NSString *)flattenHTML:(NSString *)html
{
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO)
    {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    NSCharacterSet *nbsp = [NSCharacterSet characterSetWithCharactersInString:@"&nbsp;"];
    html = [html stringByTrimmingCharactersInSet:nbsp];
    return [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  友好化距离显示
 */
- (NSString *)formatDistance:(float)distance
{
    return [NSString stringWithFormat:distance>1000?@"%dkm":@"%dm",(int)roundf(distance>1000?distance/1000:distance)];
}

/**
 *  验证邮箱
 */
- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  验证手机号
 */
- (BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"^1+[3578]+\\d{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

/**
 *  验证身份证号
 */
- (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
/// 4.19新增银行卡号验证
- (BOOL) IsBankCard:(NSString *)cardNumber
{
    BOOL flag;
    if(cardNumber.length==0)
    {
        flag= NO;
        return flag;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

/*
 * MD5加密
 */
- (NSString *)encryptMD5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02X", digest[i]];
    }
    return output;
}

/*
 * 计算文字长度
 */
- (CGSize)sizeWithString:(NSString *)string andSize:(NSInteger)size
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 10000) //限制最大的宽度和高度
                                       options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin  //采用换行模式
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}      //传人的字体字典
                                       context:nil];
    return rect.size;
}

/*
 * 替换某个范围的子串
 */
- (NSString *)byReplacingCharActer:(NSString *)phone
{
    if([self validatePhone:phone])
    {
        return [phone stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"XXXXX"];
    }
    else
    {
        return phone;
    }
}

/*
 * 截取一定长度的串
 */
- (NSString *)interceptReplacingString:(NSString *)time
{
    return [time substringToIndex:16];
}

/*
 * 判断是否有http://子串
 */
- (BOOL)ReplacingCharActer:(NSString *)portrait
{
    if ([portrait isKindOfClass:[NSNull class]]) { //2018.3.27添加判断
         return NO;
    }
    if([portrait hasPrefix:@"http://"] || [portrait hasPrefix:@"https://"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
 * 判断是否无值
 */
- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
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

/*
 * 根据月份和日期计算星座
 */
- (NSString *)getAstroWithMonth:(NSInteger)month day:(NSInteger)day
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (month<1||month>12||day<1||day>31)
    {
        return @"错误日期格式!";
    }
    
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }
    else if(month==4 || month==6 || month==9 || month==11)
    {
        if (day>30)
        {
            return @"错误日期格式!!!";
        }
    }
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}

/*
 * 根据编号获取星座名称
 */
- (NSString *)getconstellationTag:(NSUInteger)integer
{
    NSString *result;
    switch (integer)
    {
        case 1:
            result = @"白羊";
            break;
        case 2:
            result = @"金牛";
            break;
        case 3:
            result = @"双子";
            break;
        case 4:
            result = @"巨蟹";
            break;
        case 5:
            result = @"狮子";
            break;
        case 6:
            result = @"处女";
            break;
        case 7:
            result = @"天秤";
            break;
        case 8:
            result = @"天蝎";
            break;
        case 9:
            result = @"射手";
            break;
        case 10:
            result = @"魔羯";
            break;
        case 11:
            result = @"水瓶";
            break;
        case 12:
            result = @"双鱼";
            break;
        default:
            result = @"编号已经超出范围!";
            break;
    }
    return [NSString stringWithFormat:@"%@座",result];
}

/*
 * 根据编号获取会员金额
 */
- (NSUInteger)memberShellTag:(NSUInteger)integer
{
    NSString *result;
    switch (integer)
    {
        case 1:
            result = @"150";
            break;
        case 2:
            result = @"450";
            break;
        case 3:
            result = @"900";
            break;
        case 4:
            result = @"1800";
            break;
        case 5:
            result = @"5400";
            break;
        default:
            result = @"0";
            break;
    }
    return [result integerValue];
}

/*
 * 根据编号获取会员时间
 */
- (NSUInteger)membeTimeTag:(NSUInteger)integer
{
    NSString *result;
    switch (integer)
    {
        case 1:
            result = @"1";
            break;
        case 2:
            result = @"3";
            break;
        case 3:
            result = @"6";
            break;
        case 4:
            result = @"12";
            break;
        case 5:
            result = @"36";
            break;
        default:
            result = @"0";
            break;
    }
    return [result integerValue];
}

/*
 * 根据编号获取赠送会员礼包类型
 */
- (NSString *)membeBagag:(NSUInteger)integer
{
    NSString *result;
    switch (integer)
    {
        case 1:
            result = @"0";
            break;
        case 2:
            result = @"普通礼包";
            break;
        case 3:
            result = @"精美礼包";
            break;
        case 4:
            result = @"豪华礼包";
            break;
        case 5:
            result = @"至尊礼包";
            break;
        default:
            result = @"0";
            break;
    }
    return result;
}
/*
 * 根据编号获取靓号尾数
 */
- (NSString *)lianghaoNum:(NSUInteger)integer
{
    NSString *result;
    switch (integer)
    {
        case 0:
            result = @"";
            break;
        case 1:
            result = @"";
            break;
        case 2:
            result = @"5";
            break;
        case 3:
            result = @"6";
            break;
        case 4:
            result = @"7";
            break;
        case 5:
            result = @"8";
            break;
        default:
            //            result = @"0";
            break;
    }
    return result;
}


/*
 * 将GIF图分解成数组
 */
- (NSMutableArray *)decomposeGIFToImageData:(NSData *)data andStart:(size_t)start andOver:(size_t)over
{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src)
    {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = start; i < over; i++)
        {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                UIImage *image = [UIImage imageWithCGImage:img scale:3.5f orientation:UIImageOrientationUp];
                [frames addObject:image];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
}

/*
 * 当前是否有网络
 */
- (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}
//6.15
-(NSString *)realAvatarUrl:(NSString *)uid andUpdate:(NSString*)update{
    if(![uid isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@/apis/avatar.php?uid=%@&update=%@",IMAGEAPI,uid,update];//[NSString stringWithFormat:@"%@/static_data/uploaddata/avatar/%@/%@.gif?update=%@",IMAGEAPI,[uid substringToIndex:1],uid,update];
    }
    return [NSString stringWithFormat:@"%@/images/2456_120x120.jpg",IMAGEAPI];
}

- (NSDate *)dateWitchString:(NSString *)time andWithFormat:(NSString *)formatStr {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatStr];
    NSDate *date1 = [format dateFromString:time];
    return date1;
}
@end

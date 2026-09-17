
//
//  ReplaceEmoji.m
//  testemoji
//
//  Created by 金颖 on 17/1/6.
//  Copyright © 2017年 test. All rights reserved.
//

#import "ReplaceEmoji.h"
@implementation ReplaceEmoji
+(BOOL)isEmojiCharacter:(UInt64)codePoint {
    int result=0;
    if ((codePoint >= 0x2600 && codePoint <= 0x27BF)) {
        result=1;
    }
    else if(codePoint == 0x303D){
        result=2;
    }
    else if(codePoint == 0x2049){
        result=3;
    }
    else if(codePoint == 0x203C){
        result=4;
    }
    else if(codePoint >= 0x2000 && codePoint <= 0x200F){
        result=5;
    }
    else if(codePoint >= 0x2028 && codePoint <= 0x202F){
        result=6;
    }
    else if(codePoint == 0x205F){
        result=7;
    }
    else if(codePoint >= 0x2065 && codePoint <= 0x206F){
        result=8;
    }
    else if(codePoint >= 0x2100 && codePoint <= 0x214F){
        result=9;
    }
    else if(codePoint >= 0x2300 && codePoint <= 0x23FF){
        result=10;
    }
    else if(codePoint >= 0x2B00 && codePoint <= 0x2BFF){
        result=11;
    }
    else if(codePoint >= 0x2900 && codePoint <= 0x297F){
        result=12;
    }
    else if(codePoint >= 0x3200 && codePoint <= 0x32FF){
        result=13;
    }
    else if(codePoint >= 0xD800 && codePoint <= 0xDFFF){
        result=14;
    }
    else if(codePoint >= 0xE000 && codePoint <= 0xF8FF){
        result=15;
    }
    else if(codePoint >= 0xFE00 && codePoint <= 0xFE0F){
        result=16;
    }
    else if(codePoint >= 0x10000){
        result=17;
    }
    return result;
}
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    //match: 所有匹配到的字符,根据() 包含级
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            if (i%2==0) {
                continue;
            }
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            [array addObject:component];
        }
    }
    return array;
}
+(NSString *)decode:(NSString *)src{
    return src;
    NSArray *array = [ReplaceEmoji matchString:src toRegexString:@"\\<\\{u(.+?)\\}\\>"];
    for(NSString *str in array){
        NSString *findStr=[NSString stringWithFormat:@"<{u%@}>",str];
        unsigned int codePoint = strtoul([str UTF8String],0,16);
        unichar characters[2];
        NSUInteger numCharacters = 0;
        NSString *replaceStr;
        if (CFStringGetSurrogatePairForLongCharacter(codePoint, characters)) {
            numCharacters = 2;
        } else {
            characters[0] = codePoint;
            numCharacters = 1;
        }
        replaceStr=[NSString stringWithCharacters:characters length:numCharacters];
        src=[src stringByReplacingOccurrencesOfString: findStr withString:replaceStr];
    }
    return src;
}
+(NSString *)escape:(NSString *)src {
    return src;
    if (src == nil) {
        return nil;
    }
    if ([src isEqualToString:@""]) {
        return src;
    }
    
    NSMutableString *sb=[NSMutableString string];
    NSRange range;
    NSLog(@"src length %ld",src.length);
    for(NSInteger i = 0; i < src.length; i += range.length) {
        range = [src rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *codeString = [src substringWithRange:range];
        NSData* data = [codeString dataUsingEncoding:NSUTF16BigEndianStringEncoding];
        NSLog(@"code string length=%ld",codeString.length);
        NSMutableString* hexString = [NSMutableString string];
        for (int y = 0; y < codeString.length; ++y) {
            [hexString appendFormat:@"%02x", [codeString characterAtIndex:y]];
        }
        NSScanner* scanner = [NSScanner scannerWithString:hexString];
        UInt64 codepoint = 0x00;
        [scanner scanHexLongLong: &codepoint];
        int isEmoji=[ReplaceEmoji isEmojiCharacter:codepoint];
        if (isEmoji) {
            while ([[hexString substringWithRange:NSMakeRange(hexString.length-4, 4)] isEqualToString:@"fe0f"]) {
                hexString=[hexString substringWithRange:NSMakeRange(0, hexString.length-4)];
            }
            int single=0;
            if (hexString.length%8!=0) {//不整除
                NSString *newhex=[hexString substringWithRange:NSMakeRange(0, 4)];
                NSScanner* scanner = [NSScanner scannerWithString:newhex];
                UInt64 tmp_codepoint = 0x00;
                [scanner scanHexLongLong: &tmp_codepoint];
                NSString *hash = [NSString stringWithFormat:@"<{u%04llx}>",tmp_codepoint];
                [sb insertString:hash atIndex:0];
                single=4;
             }
             //cointpoint 每8位一个unicode字符串
             for (long x=0; x<(hexString.length/8); x++) {
                 NSString *newhex=[hexString substringWithRange:NSMakeRange(x*8+single, 8)];
                 NSScanner* scanner = [NSScanner scannerWithString:newhex];
                 UInt64 tmp_codepoint = 0x00;
                 [scanner scanHexLongLong: &tmp_codepoint];
                 UInt64 before=(tmp_codepoint & 0xFFFF0000)>>4*4;
                 UInt64 end=tmp_codepoint & 0xFFFF;
                 NSLog(@"before=%llx",before);
                 NSLog(@"end=%llx",end);
                 //转utf16
                 UInt64 charResult=0x10000 + (before-0xD800) * 0x400 + (end-0xDC00);
                 if (charResult<0x10000 || charResult>0x1FFFF) {//好像个别有问题，取高四就行
                     charResult=before;
                 }
                 NSString *hash = [NSString stringWithFormat:@"<{u%04llx}>",charResult];
                 [sb appendString:hash];
             }
        } else {
            [sb appendFormat:@"%@",codeString];
        }
    }
    return sb;
}
@end

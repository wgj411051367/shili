//
//  NSArray+SafeObjectAt.m
//  qunxing
//
//  Created by mac on 16/9/30.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "NSArray+SafeObjectAt.h"

@implementation NSDictionary (SafeObject)
-(id)SafeObject:(NSString *)keyname{
    id r=[self objectForKey:keyname];
    if (r==nil) {
        return @"";
    }
    if ([r isKindOfClass:[NSNull class]])
    {
        return @""; //3.22容错
    }
    if (r==NULL) {//1.16 添加
        return @"";
    }
    return r;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end

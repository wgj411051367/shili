//
//  NSArray+SafeObjectAt.h
//  qunxing
//
//  Created by mac on 16/9/30.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeObject)
//判断字符串
-(id)SafeObject:(NSString *)keyname;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

//
//  NSArray+SafeObjectAt.m
//  beibei
//
//  Created by mac on 16/9/30.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "NSArray+SafeObjectAt.h"

@implementation NSArray (SafeObjectAt)
-(id)SafeObjectAt:(NSInteger)index{
    if (self.count>index) {
        return [self objectAtIndex:index];
    }
    return @"";
}
@end

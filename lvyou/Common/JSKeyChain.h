//
//  GSKeyChain.h
//  keychaintest
//
//  Created by dev on 2019/4/26.
//  Copyright © 2019 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;
@end

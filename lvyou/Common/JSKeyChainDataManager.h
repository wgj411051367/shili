//
//  GSKeyChainDataManager.h
//  keychaintest
//
//  Created by dev on 2019/4/26.
//  Copyright © 2019 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSKeyChainDataManager : NSObject

/**
 *   存储 UUID
 *
 *     */
+(void)saveUUID:(NSString *)UUID;

/**
 *  读取UUID *
 *
 */
+(NSString *)readUUID;

/**
 *    删除数据
 */
+(void)deleteUUID;


@end

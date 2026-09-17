//
//  GSKeyChainDataManager.m
//  keychaintest
//
//  Created by dev on 2019/4/26.
//  Copyright © 2019 Shili. All rights reserved.
//

#import "JSKeyChainDataManager.h"
#import "JSKeyChain.h"
@implementation JSKeyChainDataManager

static NSString * const KEY_IN_KEYCHAIN_UUID = @"JS_KEY_UUID";
static NSString * const KEY_UUID = @"js_key_uuid";

+(void)saveUUID:(NSString *)UUID{
    
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:UUID forKey:KEY_UUID];
    
    [JSKeyChain save:KEY_IN_KEYCHAIN_UUID data:usernamepasswordKVPairs];
}

+(NSString *)readUUID{
    
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[JSKeyChain load:KEY_IN_KEYCHAIN_UUID];
    
    return [usernamepasswordKVPair objectForKey:KEY_UUID];
    
}

+(void)deleteUUID{
    
    [JSKeyChain delete:KEY_IN_KEYCHAIN_UUID];
    
}

@end

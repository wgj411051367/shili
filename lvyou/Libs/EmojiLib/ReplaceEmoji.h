//
//  ReplaceEmoji.h
//  testemoji
//
//  Created by 金颖 on 17/1/6.
//  Copyright © 2017年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplaceEmoji : NSObject{
    
}
+(BOOL)isEmojiCharacter:(UInt64)codePoint;
+(NSString *)escape:(NSString *)src;
+(NSString *)decode:(NSString *)src;
@end

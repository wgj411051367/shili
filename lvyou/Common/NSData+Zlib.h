//
//  NSData+Zlib.h
//  ChatTest
//
//  Created by 金颖 on 2019/4/2.
//  Copyright © 2019 JuSi. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSData (Zlib)
- (id)deflate:(int)compressionLevel;
- (id)inflate;
@end

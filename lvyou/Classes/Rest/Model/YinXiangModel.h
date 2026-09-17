//
//  LiveGameModel.h
//  aibei
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol YinXiangModel
@end

@interface YinXiangModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *name;
@end

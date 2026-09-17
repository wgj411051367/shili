// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  UserHorseModel.h
//  beibei
//
//  Created by dev on 16/8/22.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HorseModel.h"

@protocol UserHorseModel
@end

@interface UserHorseModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *active;
@property (strong, nonatomic) NSString<Optional> *expiration;
@property (strong, nonatomic) HorseModel<Optional> *horse;

@end

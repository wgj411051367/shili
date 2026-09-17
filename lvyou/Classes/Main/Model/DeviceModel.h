// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  DeviceModel.h
//  beibei
//
//  Created by dev on 16/7/7.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DeviceModel
@end

@interface DeviceModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *device;
@property (strong, nonatomic) NSString<Optional> *last_active;

@end

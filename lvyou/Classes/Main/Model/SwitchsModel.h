// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  SwitchsModel.h
//  beibei
//
//  Created by dev on 16/8/26.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SwitchsModel
@end

@interface SwitchsModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *push_on;
@property (strong, nonatomic) NSString<Optional> *push_live_on;
@property (strong, nonatomic) NSString<Optional> *im_private_letter_on;

@end

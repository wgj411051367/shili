// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  OauthModel.h
//  beibei
//
//  Created by dev on 16/7/7.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol OauthModel
@end

@interface OauthModel : JSONModel

@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString<Optional> *external_name;
@property (strong, nonatomic) NSString<Optional> *external_uid;
@property (strong, nonatomic) NSString<Optional> *force;//是否能点击去绑定
@end

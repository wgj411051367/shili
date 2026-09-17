// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  TagsAnchorModel.h
//  beibei
//
//  Created by dev on 16/7/16.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GiftCateModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *giftcateid;
@property (strong, nonatomic) NSString<Optional> *catename;

@property (strong, nonatomic) NSString<Optional> *send_num;

@end

// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  PushModel.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PushModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString<Optional> *summary;
@property (strong, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSString<Optional> *user_id;
@property (strong, nonatomic) NSString<Optional> *post_id;
@property (strong, nonatomic) NSString<Optional> *follow_id;
@property (strong, nonatomic) NSString<Optional> *comment_id;
@property (strong, nonatomic) NSString<Optional> *like_id;
@property (strong, nonatomic) NSString<Optional> *live_id;

@end

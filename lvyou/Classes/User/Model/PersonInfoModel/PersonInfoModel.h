//
//  TaskItemModel.h
//  doudou
//
//  Created by Mac on 2017/10/31.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PersonInfoModel : JSONModel

@property(nonatomic,copy)  NSString<Optional>* name;
@property(nonatomic,copy)  NSString<Optional>* icon;
@property(nonatomic,copy)  NSString<Optional>* tag;
@property(nonatomic,copy)  NSString<Optional>* url;
@property(nonatomic,copy)  NSString<Optional>* linespace;
@end

//
//  TaskLiveModel.h
//  liveios
//
//  Created by dev on 2019/7/5.
//  Copyright © 2019 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskLiveModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *type;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *max;
@property (strong, nonatomic) NSString<Optional> *num;
@property (strong, nonatomic) NSString<Optional> *giftid;
@property (strong, nonatomic) NSString<Optional> *icon;
@end

NS_ASSUME_NONNULL_END

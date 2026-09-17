//
//  SFMContentModel.h
//  liveios
//
//  Created by dev on 2020/3/10.
//  Copyright © 2020 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol SFMContentModel
@end
NS_ASSUME_NONNULL_BEGIN

@interface SFMContentModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *img_size;
@property (strong, nonatomic) NSString<Optional> *img_corner;
@property (strong, nonatomic) NSString<Optional> *img_url;
@property (strong, nonatomic) NSString<Optional> *text;
@property (strong, nonatomic) NSString<Optional> *text_size;
@property (strong, nonatomic) NSString<Optional> *text_color;
@end

NS_ASSUME_NONNULL_END

//
//  LiveGameModel.h
//  aibei
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TiePianBanner : JSONModel

@property (strong, nonatomic) NSString<Optional> *img;
@property (strong, nonatomic) NSString<Optional> *address;
@property (strong, nonatomic) NSString<Optional> *x;
@property (strong, nonatomic) NSString<Optional> *y;
@property (strong, nonatomic) NSString<Optional> *uimgh;
@property (strong, nonatomic) NSString<Optional> *img_w_scale;
@property (strong, nonatomic) NSString<Optional> *app_open;

@property (strong, nonatomic) NSString<Optional> *web_h_w;
@property (strong, nonatomic) NSString<Optional> *in_h;
@property (strong, nonatomic) NSString<Optional> *in_t_size;
@property (strong, nonatomic) NSString<Optional> *in_txt;
@property (strong, nonatomic) NSString<Optional> *in_w;
@property (strong, nonatomic) NSString<Optional> *in_x;
@property (strong, nonatomic) NSString<Optional> *in_y;
@property (strong, nonatomic) NSString<Optional> *or_w;
@property (strong, nonatomic) NSString<Optional> *in_t_color;
@property (strong, nonatomic) NSString<Optional> *giftid;
@property (strong, nonatomic) NSString<Optional> *img_bg;
@property (strong, nonatomic) NSString<Optional> *max_num;
@property (strong, nonatomic) NSString<Optional> *getnum;
@end

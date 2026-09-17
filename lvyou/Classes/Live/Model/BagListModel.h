//
//  BagListModel.h
//  beibei
//
//  Created by mac on 16/8/11.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BagListModel : JSONModel
//"id": "09lk1",
//"item_num": 1,
//"user": {
//    "id": "glk53",
//    "unique_id": "15000871",
//    "im_uid": "glk53",
//    "nickname": "用户1470194439570",
//    "avatar": "",
//    "gender": "1",
//    "birthday": null,
//    "constellation": null,
//    "summary": null,
//    "is_follow": 0,
//    "follow_num": "0",
//    "fans_num": "0",
//    "emotion": null,
//    "hometown_province": null,
//    "hometown_city": null,
//    "job": null,
//    "reg_time": "1470194439",
//    "rank_id": null,
//    "anchor_rank_id": null,
//    "vip_util": "1867202617",
//    "total_ticket": "0",
//    "total_send_gift": "0",
//    "haoma": false,
//    "oauths": [
//               {
//                   "type": 1,
//                   "external_uid": "13857173334",
//                   "external_name": "13857173334"
//               }
//               ],
//    "devices": [
//                {
//                    "device": "jmj-pc",
//                    "last_active": "1470797545"
//                }
//                ],
//    "balance": "4289546420",
//    "ticket": "20",
//    "exp": "9925",
//    "person_verify": 1,
//    "beibei_verify": 1,
//    "im_sig": "eJxNjV1vgjAARf8Lry6jBQqyZA*ToRMR3QAzCAlBqbR82UGR6bL-PkJctsd7zs29X4Jnu-fJ4XDqah7zC8PCgwCEuxHTFNecHiluBpiVBZJvImGMpnHCY7lJ--XbtIhHNTCoAAAgnCL9JvEnow2OkyMf5yBCSBoqN3vGTUtP9SAkABGUZAD*JKcVHic1oOkaUtDvH80GnGeFvg1e8v7VsI3U77yczhI78MzGns0hK4FjqqulS3G1LCLxqVw7JBJtOWedZKwnpzZ7GzIrL4ScK7XezM2cPhuwd7GH5lt34YfO6sOYWqBlk71rKgpYnIkhTRni4UGVK7JPfRaJkgdJ4FqXQt3Afrcr2vcktHX9ahHszHozaIMJI7S7Bo-C9w9Z8HJB"
//},
//"item": {
//    "id": "1",
//    "type": 1,
//    "name": "VIP充值送礼包测试",
//    "icon": "/6/14703661694831.jpg",
//    "animation": "",
//    "price": 0,
//    "exp": 0,
//    "source": 0,
//    "continuous": 1,
//    "desc": "",
//    "use_count": 0,
//    "status": 1,
//    "need_vip": 0,
//    "need_exp": 0,
//    "created_at": 1470366230,
//    "updated_at": 1470366473
//}
//},
@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *item_num;
@property (strong, nonatomic) NSMutableDictionary<Optional> *user;
@property (strong, nonatomic) NSMutableDictionary<Optional> *item;

@end

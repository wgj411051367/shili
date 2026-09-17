//
//  HttpMacro.h
//  beibei
//
//  Created by dev on 16/7/7.
//  Copyright © 2016年 Shili. All rights reserved.
//

#ifndef HttpMacro_h
#define HttpMacro_h

#pragma mark - 直播推送
#define UserSwitchPushLive @"user/switch/push"

#pragma mark - 直播海报
#define GiftNumberList @"gift/number/list"

#pragma mark - 直播海报
#define UsersLive_banner @"users/live-banner"

#pragma mark - 获取未读消息的个数
#define PostVod @"post/vod/"

#pragma mark - 获取未读消息的个数
#define VRINFO @"vr/info/"

#pragma mark - 获取未读消息的个数
#define NoticeCount @"notice/count"

#pragma mark - 红包被抢记录
#define RedpackRobForepart @"redpack/"
#define RedpackRobHeel @"/rob/list"

#pragma mark - 直播间内抢红包
#define LiveRedpackRob @"live/redpack/rob/"

#pragma mark - 礼物之星榜单
#define GiftStarRank @"rankinglist/giftstarrank"

#pragma mark - 礼物之星下拉选择列表
#define GiftStarList @"rankinglist/giftstarlist"
//换登录密码
#define users_changePwd @"users/set-pwd"
//12.20 新增榜单
#pragma mark - 主播榜单
#define rankinglist_zhubo @"rankinglist/plateformreceive"
#pragma mark - 土豪榜单
#define rankinglist_tuhao @"rankinglist/platform"
#pragma mark - 英雄榜单
#define rankinglist_hero @"rankinglist/yingxiong"
#pragma mark - 礼物
#define rankinglist_huodong @"rankinglist/gift"

#pragma mark - 礼物榜单
#define ActivityGiftRank @"rankinglist/activitygiftrank"

#pragma mark - 下拉选择列表
#define ActivityGiftList @"rankinglist/activitygiftlist"

#pragma mark - 获得游戏列表
#define GameList @"game/list"

#pragma mark - 获得正在玩开宝箱游戏的人数
#define BoxGetnum @"box/getnum"

#pragma mark - 正在玩深海拾贝游戏人数
#define SeaPlayerNum @"game/playernum"

#pragma mark - 动态消息列表
#define s_livenNotice @"notice/list"

#pragma mark - 直播间发送红包
#define s_liveRedPack @"live/redpack/"

#pragma mark - 直播间购买礼物送礼给普通用户
#define LiveSendGiftToUser @"live/send/gift/to/user"

#pragma mark - 直播间购买礼物并送礼给主播
#define LiveSendGiftToAnchor @"live/send/gift/to/anchor"

#pragma mark - 直播间使用背包礼物送礼给普通用户
#define LiveUseGiftToUser @"live/use/gift/to/user"

#pragma mark - 直播间使用背包礼物送礼给主播
#define LiveUseGiftToAnchor @"live/use/gift/to/anchor"

#pragma mark - 直播间内点赞
#define s_liveStar @"live/star/"

#pragma mark - 取消关注某人
#define s_liveUnfollow @"unfollow/"

#pragma mark - 关注某人
#define s_liveFollow @"follow/"

#pragma mark - 发送喇叭
#define liveLaba @"live/laba/"

#pragma mark - 发送弹幕
#define liveBullet @"live/bullet/"

#pragma mark - 取消禁言
#define liveUnprohibit @"live/unprohibit/"

#pragma mark - 取消踢人
#define liveUnkickout @"live/unkickout/"

#pragma mark - 直播间禁言列表
#define liveBanKickForepart @"live/"
#define liveBanKickHeel @"/ban/kick/list"

#pragma mark - 直播间场控列表
#define liveGuardForepart @"live/"
#define liveGuardHeel @"/guard/list"

#pragma mark - 热门直播标签列表
#define liveTagLive @"live/tag/list"

#pragma mark - 踢人
#define liveKickout @"live/kickout/"

#pragma mark - 设置禁言
#define liveProhibit @"live/prohibit/"

#pragma mark - 设置场控
#define liveGuard @"live/guard/"

#pragma mark - 获取直播间内成员列表
#define liveViewers @"live/viewers/"

#pragma mark - 退出直播房间
#define liveExit @"live/exit/"

#pragma mark - 进入直播房间
#define AccrssLiveRoom @"live/enter/"

#pragma mark - 结束直播
#define liveEnd @"live/end/"

#pragma mark - 获取省份列表
#define regionProvince @"region/province"

#pragma mark - 获取市列表
#define regionCity @"region/city/"

#pragma mark - 获取区列表
#define regionRegion @"region/region/"

//#pragma mark - 等级数据列表
//#define RankList @"rank-list"

#pragma mark - 等级数据列表
#define Config @"config"

#pragma mark - 心跳
#define heartbeat @"live/heartbeat/"

#pragma mark - 我关注的人列表
#define followsRequest @"follows"

#pragma mark - 我的粉丝列表
#define fansRequest @"fans"

#pragma mark - 主播标签（tag）列表
#define tags_anchor @"tags/anchor"

#pragma mark -火箭位
#define toutiao @"live/list/toutiao"

#pragma mark - 获取中国所有城市
#define region_cities @"region/cities"

#pragma mark - 开始直播
#define live_start @"live/start"

#pragma mark - 靓号列表
#define haoma_list @"haoma/list"

#pragma mark - 购买靓号
#define haoma_buy @"haoma/buy/"

#pragma mark - 分类座驾列表
#define horse_list @"horse/list"

#pragma mark - 购买座驾
#define horse_buy @"horse/buy/"

#pragma mark - 获取顽兔全局唯一上传名称
#define wantu_name @"wantu/name/"

#pragma mark - 获取轻量化顽兔多媒体上传token
#define wantu_token @"wantu/token"

#pragma mark - 更新当前登录用户资料
#define revamp_users @"users/save"

#pragma mark - 检查手机号是否已注册
#define check_mobile @"users/check-mobile"

#pragma mark - 绑定（换绑）手机号、微信
#define users_bind @"users/bind"

#pragma mark - 取当前登录用户信息
#define users_info @"users"

#pragma mark - 退出登录
#define users_logout @"users/logout"

#pragma mark - 修改或重置密码
#define users_reset_pwd @"users/reset-pwd"

#pragma mark - 手机号密码登录
#define users_login @"users/login"

#pragma mark - 临时jusi登录
#define users_jusilogin @"users/jusilogin"

#pragma mark - 临时jusi获取userid
#define users_jusiget @"users/jusigetuser"

#pragma mark - 第三方(含手机)注册或登录
#define users_oauth @"users/oauth"

#pragma mark - 更新APNStoken
#define update_apnstoken @"update_apnstoken"

#pragma mark - 获取验证码
#define users_code @"users/code"


#pragma mark - 分享直播
#define live_share @"live/share/"

#pragma mark - 分享直播成功
#define live_share_success @"share/success"

#pragma mark - 获取动态（帖子）列表
#define post_list @"post/list/0"

#pragma mark - 发布动态（帖子）
#define post_info @"post"

#pragma mark - 发表评论
#define comment_add @"comment/add/"

#pragma mark - 评论列表
#define comment_list @"comment/list"

#pragma mark - 动态点赞
#define post_star @"post/star/"

#pragma mark - 点赞列表
#define post_likelist @"post/likelist/"

#pragma mark - 用户举报
#define post_report_person @"report/person/"

#pragma mark - 动态举报
#define post_report_trends @"report/post/"

#pragma mark - 用户拉黑
#define post_blacklist_add @"blacklist/add/"


#pragma mark - vip购买
#define vip_buy @"vip/buy/"

#pragma mark - vip列表
#define vip_list @"vip/list"

#pragma mark - 靓号搜索
#define search_list @"search"

#pragma mark - 黑名单列表
#define blacklist_list @"blacklist/list"

#pragma mark - 删除黑名单
#define delete_blacklist_list @"blacklist/delete/"

#pragma mark - 身份认证
#define userVerify @"userVerify"

//#pragma mark - 主播标签
//#define tags_anchor @"tags/anchor"

#pragma mark - 动态分类
#define post_cate @"post/cate"

#pragma mark - 直播认证
#define beibeiVerify @"beibeiVerify"

#pragma mark - 获取我发布的动态（帖子）列表
#define my_post_delete @"post/delete/"
#define my_post_list @"post/mylist"

#pragma mark - 获取我发布的动态（帖子）列表
#define post_list_other @"post/list/"

#pragma mark - 检测是否完善资料
#define perfect_data @"task/list"

#define task_ling @"task/ling"
#define task_list @"task/list"
#pragma mark - 检测是否喜欢动态
#define post_isstar @"post/isstar/"

#pragma mark - 取消动态点赞
#define cancal_post_like @"post/unstar/"

#pragma mark - 个人送礼榜单
#define rankinglist_person @"rankinglist/person"
#pragma mark - 房间送礼榜单
#define rankinglist_roomperson @"rankinglist/roomperson"
#pragma mark - 房间魅力榜单
#define rankinglist_meili @"rankinglist/charm"

#pragma mark - 帮助与反馈
#define help @"help/list"

#pragma mark - 礼物列表
#define gift_list @"gift/list"

#pragma mark - 背包列表
#define user_backpack_list @"user/backpack/list"

#pragma mark - 私信送礼
#define person_sendgift   @"person/sendgift"

#pragma mark - 蓝V认证
#define applysign_blue   @"applysign/blue"

#pragma mark - 购买头像框
#define frame_buy @"avatar/buyFrame"

#pragma mark - 购买称谓
#define tietiao_buy @"tietiao/buy"

#pragma mark - 购买表情包
#define emoticon_buy @"emoticon/buy"


#pragma mark - webrtc创建房间
#define webrtc_do @"webrtc/do"

#pragma mark - 商品发布
#define mall_addproduct   @"mall/addproduct"
#pragma mark - 商品编辑
#define mall_editproduct   @"mall/editproduct"
#endif /* HttpMacro_h */

# 实力直播（lvyou）ViewController 清单

> 生成日期：2026-06-23  
> 扫描范围：`lvyou/Classes/` 下所有 `*ViewController*`、`*Controller*`、`*VC*` 头文件（不含 `View/` 目录）  
> 统计：共 **95** 个控制器类（含基类与导航封装）

## 模块统计汇总

| 模块 | 控制器数量 |
|------|-----------:|
| Main | 4 |
| Login | 5 |
| Live | 14 |
| Rest | 14 |
| Find | 6 |
| Message | 6 |
| User | 46 |
| **合计** | **95** |

## 控制器明细

### Main 模块（4）

| # | 类名 | 父类 | 相对路径 | 功能说明 |
|---:|------|------|----------|----------|
| 1 | `BaseNavigationController` | `UINavigationController` | `BaseNavigationController.h` | 导航控制器封装，统一处理导航栏样式、横竖屏和页面栈行为。 |
| 2 | `BaseTabBarController` | `UITabBarController` | `BaseTabBarController.h` | App 底部 Tab 根容器，负责首页、充值、开播入口、商城、我的等主入口组织。 |
| 3 | `BaseViewController` | `UIViewController` | `BaseViewController.h` | 业务页面基类，提供通用导航、占位图、图片 URL、提示等公共能力。 |
| 4 | `IndexViewController` | `BaseViewController` | `IndexViewController.h` | 列表/首页类页面公共父类，被首页、消息、我的等模块继承复用。 |

### Login 模块（5）

| # | 类名 | 父类 | 相对路径 | 功能说明 |
|---:|------|------|----------|----------|
| 1 | `AddLoginInfoVC` | `BaseViewController` | `AddLoginInfoVC.h` | 第三方登录后补充昵称、头像等必要资料。 |
| 2 | `PolicyViewController` | `BaseViewController` | `PolicyViewController.h` | 用户协议、隐私政策等登录前协议页面。 |
| 3 | `UserGuideLoginViewController` | `BaseViewController` | `UserGuideLoginViewController.h` | 登录引导页，未登录状态下的入口页面。 |
| 4 | `UserRegisterViewController` | `BaseViewController` | `UserRegisterViewController.h` | 手机号/账号注册页面。 |
| 5 | `UserResetViewController` | `BaseViewController` | `UserResetViewController.h` | 找回密码、重置密码页面。 |

### Live 模块（14）

| # | 类名 | 父类 | 相对路径 | 功能说明 |
|---:|------|------|----------|----------|
| 1 | `HomeSearchViewController` | `BaseViewController` | `HomeSearchViewController.h` | 首页综合搜索/搜索结果页，承载主播、直播等搜索结果展示。 |
| 2 | `LSAttentionViewController` | `BaseViewController` | `LSAttentionViewController.h` | 关注主播直播列表，也被个人中心“我的关注”复用。 |
| 3 | `LSHotViewController` | `BaseViewController` | `LSHotViewController.h` | 首页热门直播列表，包含推荐、Banner、直播房间入口等。 |
| 4 | `LSLatestViewController` | `BaseViewController` | `LSLatestViewController.h` | 首页最新直播列表。 |
| 5 | `LiveViewController` | `IndexViewController` | `LiveViewController.h` | 首页 Tab 根页面，组织热门、最新、关注、小视频等子页面。 |
| 6 | `SPLivePlayVC` | `BaseLiveViewController` | `SmallVideoVC/SPLivePlayVC.h` | 单条小视频/回放播放页，复用直播间播放、礼物等基础能力。 |
| 7 | `SVideoHotVC` | `BaseViewController` | `SmallVideoVC/SVideoHotVC.h` | 小视频热门列表页。 |
| 8 | `VideoScrollPlayVC` | `BaseLiveViewController` | `SmallVideoVC/VideoScrollPlayVC.h` | 上下滑刷小视频播放页。 |
| 9 | `AdolescentMiMaViewController` | `BaseViewController` | `SubVC/AdolescentMiMaViewController.h` | 青少年模式密码输入/校验页面。 |
| 10 | `AdolescentModelViewController` | `BaseViewController` | `SubVC/AdolescentModelViewController.h` | 青少年模式说明与开启入口。 |
| 11 | `BannerWebViewController` | `UIViewController` | `SubVC/BannerWebViewController.h` | 通用 H5/WebView 页面，用于 Banner、协议、内部网页等跳转。 |
| 12 | `FliterUserViewController` | `BaseViewController` | `SubVC/FliterUserViewController.h` | 用户筛选列表页，按条件展示用户/主播结果。 |
| 13 | `TM_AdolesscentSetViewController` | `BaseViewController` | `SubVC/TM_AdolesscentSetViewController.h` | 青少年模式设置页。 |
| 14 | `XYListViewController` | `IndexViewController` | `SubVC/XYListViewController.h` | 排行榜根页面，组织主播榜、土豪榜等榜单内容。 |

### Rest 模块（14）

| # | 类名 | 父类 | 相对路径 | 功能说明 |
|---:|------|------|----------|----------|
| 1 | `BaseLiveViewController` | `BaseViewController` | `BaseLiveViewController.h` | 直播间基类，封装聊天、礼物、观众列表、WebSocket、PK/连麦等公共能力。 |
| 2 | `CameraViewController` | `BaseLiveViewController` | `CameraViewController.h` | 主播端直播间/推流页面，使用腾讯直播相关能力开播。 |
| 3 | `GuiZuViewController` | `BaseViewController` | `GuiZuVC/GuiZuViewController.h` | 贵族购买/开通页面。 |
| 4 | `FaBuMovieViewController` | `UIViewController` | `MovieVC/FaBuMovieViewController.h` | 小视频发布编辑页，处理视频文件、封面、发布提交。 |
| 5 | `MovieViewController` | `UIViewController` | `MovieVC/MovieViewController.h` | 小视频录制页面，封装相机录制流程。 |
| 6 | `RestViewController` | `BaseViewController` | `RestViewController.h` | 中间 Tab 占位控制器，实际开播/发布入口由 TabBar 控制。 |
| 7 | `XYLiveDevoteViewController` | `BaseViewController` | `SubVC/XYLiveDevoteViewController.h` | 直播间贡献榜页面。 |
| 8 | `XYLiveGuardViewController` | `BaseViewController` | `SubVC/XYLiveGuardViewController.h` | 直播间守护/管理相关列表页。 |
| 9 | `XYLiveMansgeViewController` | `BaseViewController` | `SubVC/XYLiveMansgeViewController.h` | 直播间管理页，主要处理黑名单/被拉黑用户等管理功能。 |
| 10 | `XYLivePurseViewController` | `BaseViewController` | `SubVC/XYLivePurseViewController.h` | 直播间发红包/红包相关页面。 |
| 11 | `XYBeginLiveViewController` | `BaseViewController` | `XYBeginLiveViewController.h` | 开播准备页，处理封面、分类、定位、美颜、房间配置后进入主播直播间。 |
| 12 | `XYGameViewerUserLiveViewController` | `BaseLiveViewController` | `XYGameViewerUserLiveViewController.h` | 观众端直播间页面，包含拉流、聊天、礼物、游戏 WebView 等看播能力。 |
| 13 | `XYResignLiveViewController` | `BaseViewController` | `XYResignLiveViewController.h` | 主播下播结算/直播结束页面。 |
| 14 | `YinXiangViewController` | `BaseViewController` | `ZhuBoYinXiang/YinXiangViewController.h` | 主播印象标签页面。 |

### Find 模块（6）

| # | 类名 | 父类 | 相对路径 | 功能说明 |
|---:|------|------|----------|----------|
| 1 | `HeadPortraitViewController` | `BaseViewController` | `SubVC/HeadPortraitViewController.h` | 头像框商城/头像装饰购买页。 |
| 2 | `TieTiaoViewController` | `BaseViewController` | `SubVC/TieTiaoViewController.h` | 贴纸/贴条商城购买页。 |
| 3 | `XYFindStoreHorseViewController` | `BaseViewController` | `SubVC/XYFindStoreHorseViewController.h` | 座驾商城列表页。 |
| 4 | `XYFindStoreMemberViewController` | `BaseViewController` | `SubVC/XYFindStoreMemberViewController.h` | 会员商城/会员权益购买页。 |
| 5 | `XYFindStorePrettyViewController` | `BaseViewController` | `SubVC/XYFindStorePrettyViewController.h` | 靓号商城列表页。 |
| 6 | `XYFindStoreViewController` | `BaseViewController` | `XYFindStoreViewController.h` | 商城 Tab 根页面，组织座驾、靓号、会员、贵族等商城子页。 |

### Message 模块（6）

| # | 类名 | 父类 | 相对路径 | 功能说明 |
|---:|------|------|----------|----------|
| 1 | `ChatDetailViewController` | `UIViewController` | `ChatDetailViewController.h` | 私信聊天详情页，处理文字、图片、语音等 IM 会话内容。 |
| 2 | `ConversationViewController` | `IndexViewController` | `ConversationViewController.h` | 消息/会话列表页，展示私信会话和消息入口。 |
| 3 | `DeleteMessageViewController` | `BaseViewController` | `DeleteMessageViewController.h` | 清除指定用户聊天记录的确认/操作页面。 |
| 4 | `MessageViewController` | `BaseViewController` | `MessageViewController.h` | 消息中心入口页。 |
| 5 | `MyFriendsViewController` | `IndexViewController` | `MyFriendsViewController.h` | 好友/联系人列表页，供私信或直播间聊天选择用户。 |
| 6 | `SystemNewsViewController` | `BaseViewController` | `SystemNewsViewController.h` | 系统通知/公告列表页。 |

### User 模块（46）

| # | 类名 | 父类 | 相对路径 | 功能说明 |
|---:|------|------|----------|----------|
| 1 | `XYCashRecordController` | `BaseViewController` | `CashRecordVC/XYCashRecordController.h` | 提现记录页面。 |
| 2 | `CustomChargeViewController` | `BaseViewController` | `CustomChargeViewController.h` | 自定义充值金额页面。 |
| 3 | `XYApproveController` | `BaseViewController` | `EditVC/Approve/XYApproveController.h` | 实名认证/身份信息认证页面。 |
| 4 | `GongHuiViewController` | `BaseViewController` | `EditVC/GongHuiViewController.h` | 公会选择/公会信息列表页，供认证资料选择公会。 |
| 5 | `XYBBApproveController` | `BaseViewController` | `EditVC/XYBBApproveController.h` | 主播/宝宝认证资料提交页面。 |
| 6 | `XYNickNameController` | `BaseViewController` | `EditVC/XYNickNameController.h` | 修改昵称页面。 |
| 7 | `XYSignatureController` | `BaseViewController` | `EditVC/XYSignatureController.h` | 修改个性签名页面。 |
| 8 | `XYStatusApproveController` | `BaseViewController` | `EditVC/XYStatusApproveController.h` | 身份/主播认证状态与认证资料入口页面。 |
| 9 | `XYVocationController` | `BaseViewController` | `EditVC/XYVocationController.h` | 修改职业资料页面。 |
| 10 | `XYUserHistoryLiveTimeViewController` | `BaseViewController` | `LiveTimeVC/XYUserHistoryLiveTimeViewController.h` | 历史直播时长明细页面。 |
| 11 | `XYUserLiveTimesController` | `BaseViewController` | `LiveTimeVC/XYUserLiveTimesController.h` | 直播时长统计页面。 |
| 12 | `ModifyPhoneViewController` | `BaseViewController` | `ModifyPhoneViewController.h` | 修改登录密码/手机号相关验证页面。 |
| 13 | `MyFrameViewController` | `BaseViewController` | `MyFrameViewController.h` | 我的头像框/头像装饰资产页面。 |
| 14 | `MyGuiZuViewController` | `BaseViewController` | `MyGuiZuViewController.h` | 我的贵族权益/贵族状态页面。 |
| 15 | `MyHorseViewController` | `BaseViewController` | `MyHorseViewController.h` | 我的座驾资产页面。 |
| 16 | `MyMakeUoViewController` | `BaseViewController` | `MyMakeUoViewController.h` | 我的靓号资产页面。 |
| 17 | `MyPropsNewViewController` | `BaseViewController` | `MyPropsNewViewController.h` | 我的道具聚合页，展示座驾、贵族、头像框、贴纸等资产入口。 |
| 18 | `MySelfViewController` | `BaseViewController` | `MySelfViewController.h` | 个人主页/他人主页统一页面，展示用户资料、关注、作品、聊天等入口。 |
| 19 | `MyTieTiaoViewController` | `BaseViewController` | `MyTieTiaoViewController.h` | 我的贴纸/贴条资产页面。 |
| 20 | `XYGetGiftController` | `BaseViewController` | `RecordVC/SubVC/XYGetGiftController.h` | 收礼记录列表页。 |
| 21 | `XYGiveGiftController` | `BaseViewController` | `RecordVC/SubVC/XYGiveGiftController.h` | 送礼记录列表页。 |
| 22 | `XYRecordController` | `BaseViewController` | `RecordVC/SubVC/XYRecordController.h` | 充值记录列表页。 |
| 23 | `XYCheckController` | `BaseViewController` | `RecordVC/XYCheckController.h` | 记录聚合页，组织充值、送礼、收礼等记录子页。 |
| 24 | `AttentionListViewController` | `BaseViewController` | `SubVC/AttentionListViewController.h` | 关注列表页面。 |
| 25 | `BandPhoneViewController` | `BaseViewController` | `SubVC/BandPhoneViewController.h` | 绑定手机号页面。 |
| 26 | `ChangeBandPhoneViewController` | `BaseViewController` | `SubVC/Change/ChangeBandPhoneViewController.h` | 换绑手机号流程页面。 |
| 27 | `XYChangeController` | `BaseViewController` | `SubVC/Change/XYChangeController.h` | 收益兑换/余额转换页面。 |
| 28 | `FollowsListViewController` | `BaseViewController` | `SubVC/FollowsListViewController.h` | 粉丝列表页面。 |
| 29 | `PhoneBandViewController` | `BaseViewController` | `SubVC/PhoneBandViewController.h` | 已绑定手机号后的管理/换绑入口页面。 |
| 30 | `WithdrawViewController` | `BaseViewController` | `SubVC/WithdrawViewController.h` | 提现申请页面。 |
| 31 | `XYEditLivePosterViewController` | `BaseViewController` | `SubVC/XYEditLivePosterViewController.h` | 编辑直播封面/直播海报页面。 |
| 32 | `XYUserBalanceApperPayController` | `BaseViewController` | `SubVC/XYUserBalanceApperPayController.h` | 充值/余额/支付页面，同时作为底部 Tab 的充值入口。 |
| 33 | `XYUserGradeViewController` | `BaseViewController` | `SubVC/XYUserGradeViewController.h` | 用户等级/等级规则页面。 |
| 34 | `XYUserIncomeViewController` | `BaseViewController` | `SubVC/XYUserIncomeViewController.h` | 我的收益页面，展示收益、提现等入口。 |
| 35 | `XYUserIssueViewController` | `BaseViewController` | `SubVC/XYUserIssueViewController.h` | 我的发布页面，展示个人发布内容/小视频记录。 |
| 36 | `XYUserMissionViewController` | `BaseViewController` | `SubVC/XYUserMissionViewController.h` | 任务中心页面。 |
| 37 | `XYUserSignInViewController` | `BaseViewController` | `SubVC/XYUserSignInViewController.h` | 每日签到页面。 |
| 38 | `UserViewController` | `IndexViewController` | `UserViewController.h` | 我的 Tab 根页面，组织个人资料、资产、设置、收益等入口。 |
| 39 | `XYEditUserInfoViewController` | `BaseViewController` | `XYEditUserInfoViewController.h` | 编辑个人资料页面，处理头像、昵称、签名、职业、认证等资料编辑。 |
| 40 | `AboutViewController` | `UIViewController` | `XYUserSetVC/AboutViewController.h` | 关于我们页面。 |
| 41 | `ConnectWeViewController` | `BaseViewController` | `XYUserSetVC/ConnectWeViewController.h` | 联系我们/客服说明页面，部分内容跳转 Web。 |
| 42 | `DetailViewController` | `UIViewController` | `XYUserSetVC/DetailViewController.h` | 设置模块通用详情说明页。 |
| 43 | `FeedbackViewController` | `BaseViewController` | `XYUserSetVC/FeedbackViewController.h` | 意见反馈页面。 |
| 44 | `TiaoKuanViewController` | `UIViewController` | `XYUserSetVC/TiaoKuanViewController.h` | 条款/协议说明页面。 |
| 45 | `XYBlackListViewController` | `BaseViewController` | `XYUserSetVC/XYBlackListViewController.h` | 黑名单列表与解除拉黑页面。 |
| 46 | `XYUserSetViewController` | `BaseViewController` | `XYUserSetViewController.h` | 设置主页，包含账号绑定、黑名单、反馈、关于等入口。 |

## 本次同步说明

- 已根据当前项目文件重新扫描生成，移除了已删除的废弃 VC。
- 动态广场、旧搜索/同城/星座筛选、旧他人主页、推广/佣金等候选删除链路已不再出现在清单中。
- `IndexViewController`、`BaseLiveViewController`、`BaseViewController` 仍为继承链基础类，不建议删除。

## 重新扫描命令

```bash
find lvyou/Classes \( -name '*ViewController*.h' -o -name '*Controller.h' -o -name '*VC.h' \) ! -path '*/View/*' | sort
```

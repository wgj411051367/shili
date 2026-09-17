# 实力直播（lvyou）View 组件清单（保留项）

> 更新日期：2026-06-23  
> 关联文档：[ViewController清单.md](./ViewController清单.md)（**95** 个保留 VC） · [View可删除清单.md](./View可删除清单.md)（**30** 个候选删除）  
> 扫描范围：`lvyou/Classes/**/View/`、`Message/UUChat/`、`Rest/Controller/` 下独立 View/Cell  
> 统计：磁盘共扫描 **152** 个头文件；剔除纯数据模型后，**保留 UI 组件 110 个**（本清单），**可删除 30 个**（见独立文档）

## 与旧版差异

| 项目 | 旧版（2026-06-22） | 本次 |
|------|-------------------|------|
| 清单性质 | 全量罗列（含已废弃） | **仅保留、仍在用的 View** |
| 组件数量 | 146 | **110** |
| 可删除分析 | 无 | 独立 [View可删除清单.md](./View可删除清单.md) |
| 对齐 VC | 126 VC | **95 VC** |

## 模块统计

| 模块 | 保留数量 | 路径前缀 |
|------|---------:|----------|
| Main | 3 | `Classes/Main/View/` |
| Live | 19 | `Classes/Live/View/` |
| Rest | 52 | `Classes/Rest/View/` + Controller 内 2 个 |
| Find | 7 | `Classes/Find/View/` |
| Message | 10 | `Classes/Message/View/` + `UUChat/` |
| User | 19 | `Classes/User/View/` |
| **合计** | **110** | — |

> Login 模块无独立 `View/` 目录。  
> 未列入本清单但在 View 目录下的 **消息/礼物数据模型**（如 `UUMessage`、`AVIMMsg`、`GiftChooseModel` 等）仍被保留代码引用，删除 View 时勿误删。

## 分析方法说明

1. 在 `.m` / `.h` / `.xib` 中检索 `#import`、`alloc/init`、`loadNibNamed`、`cellWith`、`IBOutlet`、`customClass`。  
2. 向上追溯至入口 ViewController，对照 [ViewController清单](./ViewController清单.md) 判断所属功能是否仍保留。  
3. 若上层 VC 已下架、或仅有注释掉的 `registerNib` / 无实例化，则归入 [View可删除清单](./View可删除清单.md)（A/B/C 分级）。

---


## Main 模块（3）

> 公共弹窗与输入，路径：`Classes/Main/View/`

| # | 类名 | 父类 | 相对路径 | 主要使用方 | 说明 |
|---:|------|------|----------|------------|------|
| 1 | `InviteView` | `UIView` | `Main/View/InviteView.h` | LiveViewController | 邀请好友弹窗 |
| 2 | `JSBaseAlertView` | `UIView` | `Main/View/JSBaseAlertView.h` | UserGuideLoginViewController | 通用自定义 Alert 弹窗 |
| 3 | `UISailorTextView` | `UITextView` | `Main/View/UISailorTextView.h` | — | 带占位符文本输入（XIB IBOutlet） |

## Live 模块（19）

> 首页热门、搜索、签到、小视频，路径：`Classes/Live/View/`

| # | 类名 | 父类 | 相对路径 | 主要使用方 | 说明 |
|---:|------|------|----------|------------|------|
| 1 | `AdolescentView` | `UICollectionReusableView` | `Live/View/AdolescentView.h` | LiveViewController | 自定义面板 |
| 2 | `HomeTanKuang` | `UIView` | `Live/View/HomeTanKuang/HomeTanKuang.h` | LiveViewController | 弹窗 / 浮层 |
| 3 | `JSPickerView` | `UIView` | `Live/View/PickerView/JSPickerView.h` | XYEditUserInfoViewController | 自定义面板 |
| 4 | `QDCollectionView` | `UICollectionViewCell` | `Live/View/QDCollectionView/QDCollectionView.h` | — | 自定义面板 |
| 5 | `LingQuView` | `UIView` | `Live/View/QianDaoView/LingQuView.h` | AppDelegate、QQHelper | 自定义面板 |
| 6 | `QianDaoView` | `UIView` | `Live/View/QianDaoView/QianDaoView.h` | LSHotViewController | 自定义面板 |
| 7 | `ShareAlertView` | `UIView` | `Live/View/QianDaoView/ShareAlertView.h` | LSHotViewController | 弹窗 / 浮层 |
| 8 | `ShareSecondAlertView` | `UIView` | `Live/View/QianDaoView/ShareSecondAlertView.h` | LSHotViewController | 弹窗 / 浮层 |
| 9 | `ShareWXView` | `UIView` | `Live/View/QianDaoView/ShareWXView.h` | LSHotViewController | 自定义面板 |
| 10 | `SPLivePlayCommentCell` | `UITableViewCell` | `Live/View/SPLivePlayCommentView/SPLivePlayCommentCell.h` | SPLivePlayVC、VideoScrollPlayVC | UI 组件 |
| 11 | `SearchPageCell` | `UICollectionViewCell` | `Live/View/SearchPageCell/SearchPageCell.h` | — | UI 组件 |
| 12 | `SVideoReleaseCCell` | `UICollectionViewCell` | `Live/View/VideoView/SVideoReleaseCCell.h` | SVideoHotVC、AdolescentModelViewController | UI 组件 |
| 13 | `HotRocketView` | `UICollectionReusableView` | `Live/View/XYHotView/HotRocketView.h` | LSHotViewController | 自定义面板 |
| 14 | `HotTitleView` | `UICollectionReusableView` | `Live/View/XYHotView/HotTitleView.h` | LSHotViewController | 自定义面板 |
| 15 | `RecommendView` | `UICollectionReusableView` | `Live/View/XYHotView/RecommendView.h` | LSHotViewController | 自定义面板 |
| 16 | `RecommendViewCell` | `UICollectionViewCell` | `Live/View/XYHotView/RecommendViewCell.h` | — | 列表行 Cell |
| 17 | `XYLiveHotViewCell` | `UITableViewCell` | `Live/View/XYHotView/XYLiveHotViewCell.h` | LSHotViewController、LSAttentionViewController | 列表行 Cell |
| 18 | `UISailorAwesomeButton` | `UIControl` | `Live/View/XYSearchView/Category/UISailorAwesomeButton.h` | SailorSegmentedControl | UI 组件 |
| 19 | `XYLiveSearchViewCell` | `UITableViewCell` | `Live/View/XYSearchView/XYLiveSearchViewCell.h` | HomeSearchViewController、FliterUserViewController | 列表行 Cell |

## Rest 模块（Controller 内）（2）

> JoinRoom / 贵族，路径：`Classes/Rest/Controller/`

| # | 类名 | 父类 | 相对路径 | 主要使用方 | 说明 |
|---:|------|------|----------|------------|------|
| 1 | `GuiZuViewCell` | `UITableViewCell` | `Rest/Controller/GuiZuVC/GuiZuViewCell.h` | BuyGuiZu | 贵族购买 Cell |
| 2 | `JoinRoomView` | `UIView` | `Rest/Controller/JoinRoomVC/JoinRoomView.h` | XYGameViewerUserLiveViewController | 密码进房弹窗 |

## Rest 模块（50）

> 直播间礼物、PK、红包、弹幕等，路径：`Classes/Rest/View/`

| # | 类名 | 父类 | 相对路径 | 主要使用方 | 说明 |
|---:|------|------|----------|------------|------|
| 1 | `BangDanViewCell` | `UITableViewCell` | `Rest/View/BangDanViewCell/BangDanViewCell.h` | XYTuHaoViewController1、XYZhuBoViewController1、XYLiveDevoteViewController | 列表行 Cell |
| 2 | `BuyGuiZu` | `UIView` | `Rest/View/BuyGuiZuView/BuyGuiZu.h` | BaseLiveViewController | UI 组件 |
| 3 | `ChatRecordView` | `UICollectionReusableView` | `Rest/View/ChatRecordView/ChatRecordView.h` | BaseLiveViewController | 自定义面板 |
| 4 | `DaShangView` | `UIView` | `Rest/View/DaShangView/DaShangView.h` | BaseLiveViewController | 自定义面板 |
| 5 | `GuanZhongCell` | `UITableViewCell` | `Rest/View/GuanZhongCell/GuanZhongCell.h` | HaoYouView | UI 组件 |
| 6 | `HaoYouView` | `UIView` | `Rest/View/HaoYouView/HaoYouView.h` | CameraViewController | 自定义面板 |
| 7 | `HyPopMenuView` | `UIView` | `Rest/View/HyPopMenuView/HyPopMenuView.h` | BaseTabBarController | 弹窗 / 浮层 |
| 8 | `LiveWishScrollView` | `UICollectionReusableView` | `Rest/View/LiveWishView/LiveWishScrollView.h` | BaseLiveViewController | Collection 区头 / 区尾 |
| 9 | `LiveWishViewCell` | `UICollectionViewCell` | `Rest/View/LiveWishView/LiveWishViewCell.h` | — | 列表行 Cell |
| 10 | `MoreDetailView` | `UIView` | `Rest/View/MoreBtnView/MoreDetailView.h` | TheMoreView | 自定义面板 |
| 11 | `TheMoreView` | `UIView` | `Rest/View/MoreBtnView/TheMoreView.h` | CameraViewController、XYGameViewerUserLiveViewController、BaseLiveViewController | 自定义面板 |
| 12 | `SLInviteAvatarView` | `UIView` | `Rest/View/MultiPK/SLInviteAvatarView.h` | SLMultiPKInviteView、SLMultiPKTanKuan | 自定义面板 |
| 13 | `SLMultiPKInviteView` | `UICollectionReusableView` | `Rest/View/MultiPK/SLMultiPKInviteView.h` | CameraViewController | PK 相关 UI |
| 14 | `SLMultiPKStartView` | `UICollectionReusableView` | `Rest/View/MultiPK/SLMultiPKStartView.h` | BaseLiveViewController | PK 相关 UI |
| 15 | `SLMultiPKTanKuan` | `UICollectionReusableView` | `Rest/View/MultiPK/SLMultiPKTanKuan.h` | CameraViewController | PK 相关 UI |
| 16 | `SLMultiPkChooseView` | `UICollectionReusableView` | `Rest/View/MultiPK/SLMultiPkChooseView.h` | CameraViewController | 自定义面板 |
| 17 | `NewUserListItem` | `UIView` | `Rest/View/NewUserListItem.h` | BaseLiveViewController | UI 组件 |
| 18 | `PKAlertView` | `UIView` | `Rest/View/PKAlertView/PKAlertView.h` | CameraViewController | 弹窗 / 浮层 |
| 19 | `PKMaskView` | `UIView` | `Rest/View/PKMaskView/PKMaskView.h` | CameraViewController、XYGameViewerUserLiveViewController、BaseLiveViewController | PK 相关 UI |
| 20 | `PKRandomView` | `UICollectionReusableView` | `Rest/View/PKTanKuangOne/PKRandomView.h` | CameraViewController | PK 相关 UI |
| 21 | `PKTanKuangTwo` | `UIView` | `Rest/View/PKTanKuangOne/PKTanKuangTwo.h` | CameraViewController | 弹窗 / 浮层 |
| 22 | `PKView` | `UIView` | `Rest/View/PKView/PKView.h` | BaseLiveViewController | PK 相关 UI |
| 23 | `nbPackView` | `UIView` | `Rest/View/QuanFuHongBao/nbPackView.h` | BaseLiveViewController | 自定义面板 |
| 24 | `RedPackBigView` | `UICollectionReusableView` | `Rest/View/RedBigView/RedPackBigView.h` | BaseLiveViewController | 自定义面板 |
| 25 | `RedPackRecordCell` | `UITableViewCell` | `Rest/View/RedBigView/RedPackRecordCell.h` | RedPackBigView | UI 组件 |
| 26 | `RedPackSmallView` | `UICollectionReusableView` | `Rest/View/RedBigView/RedPackSmallView.h` | BaseLiveViewController | 自定义面板 |
| 27 | `RoomAvatarView` | `UIView` | `Rest/View/RoomAvatarView/RoomAvatarView.h` | CameraViewController、XYGameViewerUserLiveViewController、BaseLiveViewController、SLMultiPKStartView | 自定义面板 |
| 28 | `SailorMenuViewCell` | `UITableViewCell` | `Rest/View/SailorPopMenu/SailorMenuViewCell.h` | — | 列表行 Cell |
| 29 | `SailorPopMenuView` | `UIView` | `Rest/View/SailorPopMenu/SailorPopMenuView.h` | — | 弹窗 / 浮层 |
| 30 | `SailorPopMenuViewSingleton` | `NSObject` | `Rest/View/SailorPopMenu/SailorPopMenuViewSingleton.h` | — | 弹出菜单单例（直播间/聊天） |
| 31 | `SendToGiftCell` | `UITableViewCell` | `Rest/View/SendToGiftCell/SendToGiftCell.h` | XYCLAnimationView | 礼物 / 弹幕 / 动画 |
| 32 | `SharePasswordView` | `UIView` | `Rest/View/SharePasswordView/SharePasswordView.h` | CameraViewController | 自定义面板 |
| 33 | `OpenShouHuView` | `UIView` | `Rest/View/ShouHuView/OpenShouHuView.h` | XYGameViewerUserLiveViewController | 自定义面板 |
| 34 | `TaskLiveView` | `UIView` | `Rest/View/TaskTableViewCell/TaskLiveView.h` | BaseLiveViewController | 自定义面板 |
| 35 | `TaskTableViewCell` | `UITableViewCell` | `Rest/View/TaskTableViewCell/TaskTableViewCell.h` | TaskLiveView | 列表行 Cell |
| 36 | `TotalPeopleTableViewCell` | `UITableViewCell` | `Rest/View/TotalView/TotalPeopleTableViewCell.h` | BaseLiveViewController、TotalPeopleView | 列表行 Cell |
| 37 | `TotalPeopleView` | `UIView` | `Rest/View/TotalView/TotalPeopleView.h` | BaseLiveViewController | 自定义面板 |
| 38 | `TuYaView` | `UIView` | `Rest/View/TuYaView/TuYaView.h` | CameraViewController、XYGameViewerUserLiveViewController | 自定义面板 |
| 39 | `UserListView` | `UICollectionReusableView` | `Rest/View/UserListView/UserListView.h` | XYTuHaoViewController1、XYZhuBoViewController1、XYLiveDevoteViewController | 自定义面板 |
| 40 | `XYAssistHeartFlyView` | `UIView` | `Rest/View/XYBarrageView/XYAssistHeartFlyView.h` | BaseLiveViewController | 礼物 / 弹幕 / 动画 |
| 41 | `XYGrounderChatView` | `UIView` | `Rest/View/XYBarrageView/XYGrounderChatView.h` | BaseLiveViewController | 自定义面板 |
| 42 | `PresentView` | `UIView` | `Rest/View/XYGiftPoppingView/PresentView.h` | BaseLiveViewController | 礼物 / 弹幕 / 动画 |
| 43 | `ShakeLabel` | `UIView` | `Rest/View/XYGiftPoppingView/ShakeLabel.h` | PresentView | UI 组件 |
| 44 | `ChatAnimationView` | `UIView` | `Rest/View/XYGiftView/ChatAnimationView.h` | UUInputFunctionView | 礼物 / 弹幕 / 动画 |
| 45 | `ChatMickeyView` | `UIView` | `Rest/View/XYGiftView/ChatMickeyView.h` | ChatAnimationView | 礼物 / 弹幕 / 动画 |
| 46 | `MickeyView` | `UIView` | `Rest/View/XYGiftView/MickeyView.h` | CLAnimationView、XYCLAnimationView | 礼物 / 弹幕 / 动画 |
| 47 | `XYCLAnimationView` | `UIView` | `Rest/View/XYGiftView/XYCLAnimationView.h` | BaseLiveViewController | 礼物 / 弹幕 / 动画 |
| 48 | `XYLiveGuardViewCell` | `UITableViewCell` | `Rest/View/XYLiveGuard/XYLiveGuardViewCell.h` | XYLiveGuardViewController | 列表行 Cell |
| 49 | `YYTCShowLiveMessageView` | `UIView` | `Rest/View/XYShowAV/YYTCShowLiveMessageView.h` | — | 直播间公屏消息 |
| 50 | `GuanZhuHostView` | `UIView` | `Rest/View/ZhuBoAttentionView/GuanZhuHostView.h` | XYGameViewerUserLiveViewController | 自定义面板 |

## Find 模块（7）

> 商城座驾、靓号、会员，路径：`Classes/Find/View/`

| # | 类名 | 父类 | 相对路径 | 主要使用方 | 说明 |
|---:|------|------|----------|------------|------|
| 1 | `BuyStoreView` | `UIView` | `Find/View/BuyStoreView/BuyStoreView.h` | XYFindStorePrettyViewController、HeadPortraitViewController、XYFindStoreHorseViewController、TieTiaoViewController | 自定义面板 |
| 2 | `LianghaoScreenView` | `UIView` | `Find/View/BuyStoreView/LianghaoScreenView.h` | XYFindStoreViewController | 自定义面板 |
| 3 | `XYFindStoreHorseCollectionCell` | `UICollectionViewCell` | `Find/View/XYFindStoreHorse/XYFindStoreHorseCollectionCell.h` | — | 网格 / 卡片 Cell |
| 4 | `XYFindStorePrettyCollectionCell` | `UICollectionViewCell` | `Find/View/XYFindStorePretty/XYFindStorePrettyCollectionCell.h` | — | 网格 / 卡片 Cell |
| 5 | `MickeyAlbum` | `UIViewController` | `Find/View/XYFindTrends/MickeyAlbum.h` | MySelfViewController、XYUserIssueViewController | 相册选择页 |
| 6 | `XYFindRecordedViewCell` | `UITableViewCell` | `Find/View/XYFindTrends/XYFindRecordedViewCell.h` | MySelfViewController、XYUserIssueViewController | 列表行 Cell |
| 7 | `XYFindTrendsViewCell` | `UITableViewCell` | `Find/View/XYFindTrends/XYFindTrendsViewCell.h` | MySelfViewController、XYUserIssueViewController | 列表行 Cell |

## Message 模块（2）

> 好友列表 Cell，路径：`Classes/Message/View/`

| # | 类名 | 父类 | 相对路径 | 主要使用方 | 说明 |
|---:|------|------|----------|------------|------|
| 1 | `MyFriendsViewCell` | `UITableViewCell` | `Message/View/MyFriends/MyFriendsViewCell.h` | MyFriendsViewController | 列表行 Cell |
| 2 | `XYNicetyFriendsViewCell` | `UITableViewCell` | `Message/View/XYNicetyFriends/XYNicetyFriendsViewCell.h` | AttentionListViewController、FollowsListViewController | 列表行 Cell |

## Message / UUChat（8）

> 私信聊天 UI 与语音/图片工具，路径：`Classes/Message/UUChat/`

| # | 类名 | 父类 | 相对路径 | 主要使用方 | 说明 |
|---:|------|------|----------|------------|------|
| 1 | `DXFaceView` | `UIView` | `Message/UUChat/FaceView/DXFaceView.h` | UUInputFunctionView | 自定义面板 |
| 2 | `FacialView` | `UIView` | `Message/UUChat/FaceView/FacialView.h` | DXFaceView | 自定义面板 |
| 3 | `UUAVAudioPlayer` | `NSObject` | `Message/UUChat/UUAVAudioPlayer.h` | UUMessageCell | 聊天语音播放单例 |
| 4 | `UUImageAvatarBrowser` | `NSObject` | `Message/UUChat/UUImageAvatarBrowser.h` | UUMessageCell | 聊天图片大图浏览 |
| 5 | `UUInputFunctionView` | `UIView` | `Message/UUChat/UUInputFunctionView.h` | — | 自定义面板 |
| 6 | `UUMessageCell` | `UITableViewCell` | `Message/UUChat/UUMessageCell.h` | — | UI 组件 |
| 7 | `UUMessageContentButton` | `UIButton` | `Message/UUChat/UUMessageContentButton.h` | — | UI 组件 |
| 8 | `UUProgressHUD` | `UIView` | `Message/UUChat/UUProgressHUD.h` | UUInputFunctionView | UI 组件 |

## User 模块（19）

> 个人中心、充值、记录、任务，路径：`Classes/User/View/`

| # | 类名 | 父类 | 相对路径 | 主要使用方 | 说明 |
|---:|------|------|----------|------------|------|
| 1 | `ChargeViewCollectionCell` | `UICollectionViewCell` | `User/View/ChargeViewCell/ChargeViewCollectionCell.h` | — | 网格 / 卡片 Cell |
| 2 | `ChargeViewTwoCell` | `UITableViewCell` | `User/View/ChargeViewCell/ChargeViewTwoCell.h` | XYUserBalanceApperPayController | UI 组件 |
| 3 | `DetailCollectionCell` | `UICollectionViewCell` | `User/View/DetailCollectionCell/DetailCollectionCell.h` | — | 网格 / 卡片 Cell |
| 4 | `GongHuiCell` | `UITableViewCell` | `User/View/GongHuiCell/GongHuiCell.h` | GongHuiViewController | UI 组件 |
| 5 | `GuiZuInfoCollectionViewCell` | `UICollectionViewCell` | `User/View/GuiZuInfoCollectionViewCell.h` | — | 列表行 Cell |
| 6 | `XYUserMissionCell` | `UITableViewCell` | `User/View/MissionViewCell/XYUserMissionCell.h` | XYUserMissionViewController | UI 组件 |
| 7 | `MyPropsCollectionViewCell` | `UICollectionViewCell` | `User/View/MyPropsCollectionViewCell.h` | — | 列表行 Cell |
| 8 | `MyPropsHeadView` | `UICollectionReusableView` | `User/View/MyPropsHeadView.h` | MyFrameViewController、MyHorseViewController、MyGuiZuViewController、MyMakeUoViewController、MyTieTiaoViewController | Collection 区头 / 区尾 |
| 9 | `MySelfHeadView` | `UIView` | `User/View/MySelfHeadView/MySelfHeadView.h` | MySelfViewController | Collection 区头 / 区尾 |
| 10 | `MySelfInfoView` | `UIView` | `User/View/MySelfInfoView/MySelfInfoView.h` | MySelfViewController | 自定义面板 |
| 11 | `OtherUserCollectionViewCell` | `UICollectionViewCell` | `User/View/OtherUserCollectionViewCell.h` | XYUserIssueViewController | 列表行 Cell |
| 12 | `PersonalCell` | `UICollectionViewCell` | `User/View/PersonalCell/PersonalCell.h` | — | UI 组件 |
| 13 | `PersonalTableCell` | `UITableViewCell` | `User/View/PersonalTableCell/PersonalTableCell.h` | UserViewController | UI 组件 |
| 14 | `PersonalView` | `UICollectionReusableView` | `User/View/PersonalView/PersonalView.h` | UserViewController | 自定义面板 |
| 15 | `XYBlackListViewCell` | `UITableViewCell` | `User/View/XYBlackListViewCell.h` | XYBlackListViewController、XYLiveMansgeViewController | 列表行 Cell |
| 16 | `XYCashRecordCell` | `UITableViewCell` | `User/View/XYCashRecordCell.h` | XYCashRecordController | UI 组件 |
| 17 | `XYGetGiftCell` | `UITableViewCell` | `User/View/XYGetGiftCell.h` | XYGetGiftController | 礼物 / 弹幕 / 动画 |
| 18 | `XYGiftCell` | `UITableViewCell` | `User/View/XYGiftCell.h` | XYGiveGiftController | 礼物 / 弹幕 / 动画 |
| 19 | `XYRecordCell` | `UITableViewCell` | `User/View/XYRecordCell.h` | XYRecordController | UI 组件 |

<!--TOTAL 110-->

---

## 未列入本清单的说明

以下类型文件位于 View 目录但属于 **数据模型 / 工具类**，不计入 UI 组件统计：

- `Message/UUChat/`：`UUMessage`、`UUMessageFrame`、`Emoji`、`FaceUtil` 等  
- `Rest/View/XYShowAV/`：`AVIMMsg`、`YYTCShowLiveMsg`（直播间 IM 消息模型）  
- `Rest/View/XYGiftView/`：`GiftChooseModel`  
- `Rest/View/SailorPopMenu/`：`SailorPopMenuViewModel`  

## 重新扫描命令

```bash
find lvyou/Classes \( -path '*/View/*.h' -o -path '*/UUChat/*.h' \) | sort
grep -rl '@interface' lvyou/Classes/Message/UUChat --include='*.h'
```

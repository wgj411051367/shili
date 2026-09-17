# 实力直播 View 可删除清单

> 分析日期：2026-06-23  
> 依据：[ViewController清单.md](./ViewController清单.md)（当前 **95** 个保留 VC）  
> 方法：对 `lvyou/Classes/**/View/`、`Message/UUChat/` 扫描 `.m/.h/.xib`，检查 `#import`、`alloc/init`、`loadNibNamed`、`cellWith`、`IBOutlet`、`customClass`；并向上追溯至入口 VC 是否仍在清单内、调用是否被注释。

## 结论摘要

| 分级 | 数量 | 说明 |
|------|------|------|
| **A 级** | **21** | 无有效引用，或上层 VC 已从清单移除，可优先删 |
| **B 级** | **7** | 活跃 VC 中仅残留 `import`/属性，实例化已不存在 |
| **C 级** | **2** | 随推广模块 VC 一并删除（文件仍在磁盘） |
| **保留** | **110** | 仍有实例化或 IBOutlet 绑定，勿删（见 [View清单.md](./View清单.md)） |

**建议执行顺序**：先删 A 级整目录 → 清理 B 级对应 `.h` 残留属性 → 与推广 VC 同批删 C 级 → 同步改 `project.pbxproj` 与 `BeiBeiLive-Prefix.pch`（如适用）。

---

## 一、A 级：可立即删除（21 项）

> 判定：工程内无其它 `.m/.h/.xib` 的有效引用，或仅对应 VC 已从 [ViewController清单](./ViewController清单.md) 移除。

### 1.1 Find — 动态广场 / 发布（随 VC 删除，6 项）

| 类名 | 路径 | 删除依据 |
|------|------|----------|
| `FindTrendDetailTableViewCell` | `Find/View/XYFindTrends/` | 原 `FindTrendDetailViewController` 已下架，仅自身 `.m` |
| `TrendLikeListCell` | `Find/View/XYFindTrends/` | 原 `TrendLikeListViewController` 已下架 |
| `XYFindTrendsViewCellOne` | `Find/View/XYFindTrends/` | 原 `XYFindTrendsViewController` 已下架 |
| `XYFindTrendsViewCellTwo` | `Find/View/XYFindTrends/` | 同上 |
| `XYFindTrendsViewCellFour` | `Find/View/XYFindTrends/` | 同上 |
| `XYSelectImageCollectionCell` | `Find/View/XYIssueFind/` | 原 `XYIssueFindViewController` 已下架；**可删整个 `XYIssueFind/` 目录** |

**保留勿删（同目录仍在用）**：

- `XYFindTrendsViewCell` — `MySelfViewController` 动态列表仍在用  
- `XYFindRecordedViewCell`、`MickeyAlbum` — `MySelfViewController`、`XYUserIssueViewController` 仍在用  

### 1.2 Live — 搜索 / 旧榜单 Cell（6 项）

| 类名 | 路径 | 删除依据 |
|------|------|----------|
| `SailorSegmentedControl` | `Live/View/XYSearchView/` | 原 `XYSearchViewController` 已下架；`FliterUserViewController` 未使用 |
| `SailorSegmentItem` | `Live/View/XYSearchView/` | 仅被 `SailorSegmentedControl` 引用，随分段控件一并删除 |
| `XYCommonListViewCell` | `Live/View/XYListView/` | 无外部引用；榜单子页已改为 `XYTuHaoViewController1` / `XYZhuBoViewController1` 自带 Cell |
| `XYCorpsListViewCell` | `Live/View/XYListView/` | 同上 |
| `XYLiveLatestCollectionCell` | `Live/View/XYLatestView/` | 无引用；`LSLatestViewController` 使用 `QDCollectionView` |
| `NewCollectionView` | `Live/View/QDCollectionView/` | 仅 `LSLatestViewController` 有 `import`/常量，实际注册的是 `QDCollectionView` |

### 1.3 Message — 动态消息（1 项）

| 类名 | 路径 | 删除依据 |
|------|------|----------|
| `XYTrendsMessageViewCell` | `Message/View/XYTrendsMessage/` | 原 `XYTrendsMessageViewController` 已下架；**可删整个 `XYTrendsMessage/` 目录** |

### 1.4 Rest — 直播间主题（1 项）

| 类名 | 路径 | 删除依据 |
|------|------|----------|
| `XYLiveThemeViewCell` | `Rest/View/XYLiveTheme/` | 原 `XYLiveThemeViewController` 已下架；**可删整个 `XYLiveTheme/` 目录** |

### 1.5 Rest — 重复 / 未接线组件（3 项）

| 类名 | 路径 | 删除依据 |
|------|------|----------|
| `CLAnimationView` | `Rest/View/XYGiftView/` | 旧版礼物动画；现用 `XYCLAnimationView`（`BaseLiveViewController`） |
| `ReportHostView` | `Rest/View/XYShowAV/CustomUI/` | 仅 `CustomUIHeader.h` / PCH 引入，全工程无 `alloc` |
| `UIPlaceHolderTextView` | `Rest/View/XYShowAV/CustomUI/` | 同上（含 `UILimitTextView` 子类） |

删后需同步编辑：

- `Rest/View/XYShowAV/CustomUI/CustomUIHeader.h` — 去掉上述 `#import`  
- `BeiBeiLive-Prefix.pch` — 若不再需要通过 PCH 全局引入 `CustomUIHeader.h` 可评估精简  

### 1.6 User — 旧座驾 Cell（4 项）

| 类名 | 路径 | 删除依据 |
|------|------|----------|
| `UserHorseCollectionCell` | `User/View/` | 无引用；`MyHorseViewController` 已改用 `MyPropsCollectionViewCell` |
| `UserHorseHeadView` | `User/View/` | 无引用 |
| `UserNoHorseHeadView` | `User/View/` | 无引用 |
| `UserHeadDetailView` | `User/View/` | 无引用 |

---

## 二、B 级：活跃 VC 残留 import/属性（7 项）

> 判定：所属 VC 仍在清单内，但 **全工程检索不到 `alloc` / `loadNibNamed` / `cellWith`**，仅头文件或属性声明残留。删 View 前需 **先删对应 `.h` 属性与 `#import`**。

| 类名 | 路径 | 上层 VC | 追溯说明 |
|------|------|---------|----------|
| `UpdateAlertView` | `Live/View/QianDaoView/` | `LSHotViewController` | 仅有 `@property UpdateAlertView *updateAppView`，`.m` 中无创建/展示代码 |
| `XYFindStoreHorseHeadView` | `Find/View/XYFindStoreHorse/` | `XYFindStoreHorseViewController` 等 | `registerNib` 区头代码已注释，仅余 `import` 与常量 |
| `XYFindTrendsHeadView` | `Find/View/` | `SVideoHotVC` | 仅声明 `findHeadView` 成员，无 `loadNib` / `register` |
| `XYLiveHotHeadView` | `Live/View/XYHotView/` | `LSLatestViewController` | `registerNib` 区头已注释，仅 `import` 与 ivar |
| `PKTanKuangOne` | `Rest/View/PKTanKuangOne/` | `BaseLiveViewController` | `.h` 有 `pkTanKuangview` 属性；`.m` 无 `alloc`，仅 `CameraViewController` 中 `removeFromSuperview` |
| `RoomMicEditView` | `Rest/View/RoomMicEdit/` | `BaseLiveViewController` | `.h` 有 `roomUserEditView` 属性；`.m` 无实例化 |
| `PushToOtherRoom` | `Rest/View/PushToOtherRoom/` | `XYGameViewerUserLiveViewController` | `.h` 有 `pushView` 属性；全工程无 `pushView =` 赋值，仅有 `removeView` 防御代码 |

**推荐操作**：删除 View 文件的同时，清理 `BaseLiveViewController.h`、`LSHotViewController.m`、`XYGameViewerUserLiveViewController.h` 等处的残留声明。

---

## 三、C 级：随推广模块 VC 整包删除（2 项）

> VC 文件仍在 `TuiGuangVC/`，但已从产品清单移除；若无计划恢复推广，建议 **View + VC + XIB** 一起删。

| 类名 | 路径 | 关联 VC | 引用证据 |
|------|------|---------|----------|
| `MyTeamCell` | `User/View/MyTeamCell/` | `MyTeamController` | `MyTeamController.m:142` `[MyTeamCell cellWithTableView:]` |
| `XingTanShouYiCell` | `User/View/MyTeamCell/` | `ShouYiController` | `ShouYiController.m:214` 同上 |

**建议整包删除**：

```text
User/Controller/TuiGuangVC/MyTeamController.*
User/Controller/TuiGuangVC/ShouYiController.*
User/View/MyTeamCell/
```

并在 `UserViewController` 等入口去掉跳转（若仍有残留 push 代码）。

---

## 四、已删除 VC 与 View 对照（便于回溯）

| 已下架 VC | 可删 View（A/B 级） |
|-----------|-------------------|
| `XYFindTrendsViewController` | `XYFindTrendsViewCellOne/Two/Four`（保留 `XYFindTrendsViewCell`） |
| `XYIssueFindViewController` | `XYSelectImageCollectionCell`、`XYIssueFind/` |
| `FindTrendDetailViewController` | `FindTrendDetailTableViewCell` |
| `TrendLikeListViewController` | `TrendLikeListCell` |
| `XYTrendsMessageViewController` | `XYTrendsMessageViewCell` |
| `XYSearchViewController` | `SailorSegmentedControl` |
| `XYLiveThemeViewController` | `XYLiveThemeViewCell` |
| `MyTeamController` / `ShouYiController` | `MyTeamCell`、`XingTanShouYiCell` |

---

## 五、明确保留（易误判为可删）

| 类名 | 原因 |
|------|------|
| `YYTCShowLiveMessageView` | `BaseLiveViewController.h` IBOutlet `msgView`，直播间公屏核心 |
| `UISailorTextView` | `BaseViewController.h`、`FaBuMovieViewController` 等 XIB IBOutlet |
| `XYFindTrendsViewCell` | `MySelfViewController` 仍在用（**`MySelfViewController` 未列入 95 VC 清单，但多处活跃跳转**） |
| `XYNicetyFriendsViewCell` | `AttentionListViewController`、`FollowsListViewController`、`MyFriendsViewController`、`BaseLiveViewController.h` |
| `UUMessageCell` / `UUInputFunctionView` | `ChatDetailViewController` 聊天核心 |
| `UUMessageContentButton` | `UUMessageCell.m` 内 `buttonWithType` 创建 |
| `UUProgressHUD` | `UUInputFunctionView.m` 语音录制 HUD |
| `SailorPopMenuViewSingleton` | `SailorPopMenuView.m` 单例调用 |
| `JoinRoomView` | `XYGameViewerUserLiveViewController` 密码进房 |
| `OpenShouHuView` | 观众直播间 `loadNibNamed` 开通守护 |
| `JSBaseAlertView` | `UserGuideLoginViewController` `[JSBaseAlertView sharedAlertView]` |

---

## 六、删除单个 View 的检查清单

1. 删除 `.h` / `.m` / `.xib`（及 `Assets` 中仅该 View 使用的切图）  
2. 从 `lvyou.xcodeproj/project.pbxproj` 移除编译与资源引用  
3. 全局搜索类名，清理所有 `#import`、IBOutlet、`customClass`  
4. 若删的是 B 级，先改上层 VC 头文件再删 View  
5. 编译验证：`xcodebuild -workspace lvyou.xcworkspace -scheme lvyou`  

---

## 七、建议第一批删除命令（仅供参考）

```bash
# A 级 — Find 动态
rm -rf lvyou/Classes/Find/View/XYIssueFind
rm lvyou/Classes/Find/View/XYFindTrends/FindTrendDetailTableViewCell.*
rm lvyou/Classes/Find/View/XYFindTrends/TrendLikeListCell.*
rm lvyou/Classes/Find/View/XYFindTrends/XYFindTrendsViewCellOne.*
rm lvyou/Classes/Find/View/XYFindTrends/XYFindTrendsViewCellTwo.*
rm lvyou/Classes/Find/View/XYFindTrends/XYFindTrendsViewCellFour.*

# A 级 — Message / Rest 主题
rm -rf lvyou/Classes/Message/View/XYTrendsMessage
rm -rf lvyou/Classes/Rest/View/XYLiveTheme

# A 级 — Live 旧 Cell / 搜索
rm lvyou/Classes/Live/View/XYSearchView/SailorSegmentedControl.*
rm lvyou/Classes/Live/View/XYSearchView/SailorSegmentItem.*
rm lvyou/Classes/Live/View/XYListView/XYCommonListViewCell.*
rm lvyou/Classes/Live/View/XYListView/XYCorpsListViewCell.*
rm lvyou/Classes/Live/View/XYLatestView/XYLiveLatestCollectionCell.*
rm lvyou/Classes/Live/View/QDCollectionView/NewCollectionView.*

# A 级 — Rest 重复 / 未用
rm lvyou/Classes/Rest/View/XYGiftView/CLAnimationView.*
rm lvyou/Classes/Rest/View/XYShowAV/CustomUI/ReportHostView.*
rm lvyou/Classes/Rest/View/XYShowAV/CustomUI/UIPlaceHolderTextView.*

# A 级 — User 旧座驾
rm lvyou/Classes/User/View/UserHorseCollectionCell.*
rm lvyou/Classes/User/View/UserHorseHeadView.*
rm lvyou/Classes/User/View/UserNoHorseHeadView.*
rm lvyou/Classes/User/View/UserHeadDetailView.*
```

删完后在 Xcode 中清理红色缺失引用，并处理 B/C 级残留属性。

---

## 八、说明与局限

- 静态分析 **不能替代真机回归**；直播间、聊天、商城建议各走一遍主路径。  
- `MySelfViewController` 已列入 95 VC 清单（User 模块 #18），其依赖的 `XYFindTrendsViewCell` 等 **必须保留**。  
- `XYTuHaoViewController1`、`XYZhuBoViewController1` 未入 VC 清单，但由 `XYListViewController` 子页引用；`BangDanViewCell`、`UserListView` 等 **必须保留**。  
- `UUAVAudioPlayer`、`UUImageAvatarBrowser` 通过 `sharedInstance` / 类方法调用，静态扫描易漏判，**不可删**。  

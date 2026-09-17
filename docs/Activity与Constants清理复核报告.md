# 实力直播 Activity（ViewController）与 Constants 清理复核报告

> 复核日期：2026-06-22  
> 复核对象：`Activity与Constants清理分析.md`、`lvyou/Common/Constants.h/.m`、主要入口控制器、XIB 与 `project.pbxproj`  
> 说明：本报告只做静态分析和构建基线检查，未修改业务代码。

## 一、结论摘要

原分析的整体方向正确：项目确实存在未入工程的重复文件、只被固定配置分支引用的历史模块，以及数个零有效引用的 Constants。但是，原报告目前**不能直接作为整批删除清单执行**，至少有两项关键误判：

1. **`IndexViewController` 必须保留。** 它不是孤立页面，而是 7 个控制器的公共父类，其中包括当前 Tab 根页面 `LiveViewController`、`UserViewController`，以及当前消息入口使用的 `ConversationViewController`。删除会直接导致编译失败。
2. **WanFa 玩法链暂不能判定为死链。** 虽然两个子类的 `downTheBtn` 没有显示 `wanBtn`，但父类 `BaseLiveViewController` 的 `hideFullGame -> showBtn` 会在 `HaveWanBtn=1` 时重新显示按钮；全屏游戏又受服务端房间数据 `gameType` 驱动，不等同于 `BeginLiveType` 的“游戏开播”配置。

因此建议把清理拆为三批：

- 第一批：只删除已确认的磁盘孤儿和零有效引用项；风险低。
- 第二批：删除固定配置下不可达的整模块，但前提是产品明确放弃多站点/换皮配置能力；风险中等。
- 第三批：WanFa、服务端游戏、密码房、守护等运行时能力，先加埋点或做真机回归再判断；风险高。

## 二、对原报告的关键修正

### 2.1 `IndexViewController`：原结论错误，禁止删除

原报告以“没有 `[[IndexViewController alloc] init]`”判定零引用，这个判据不适用于基类。实际继承关系如下：

| 子类 | 当前重要性 |
|---|---|
| `LiveViewController` | 首页 Tab 根页面，活跃 |
| `UserViewController` | 我的 Tab 根页面，活跃 |
| `ConversationViewController` | `PushToList=3` 的消息入口，活跃 |
| `XYListViewController` | 排行榜仍有其他入口 |
| `MyFriendsViewController` | 消息体系 |
| `GMTagTotalVC` | 首页分类体系 |
| `FindViewController` | 1v1 配置分支 |

此外，`CameraViewController.m` 还用 `[temp isKindOfClass:[IndexViewController class]]` 做运行时类型判断。结论：**`IndexViewController.h/.m` 都应保留。**

### 2.2 WanFa：从“建议删除”下调为“待运行时验证”

已确认的调用链：

```text
直播间 gameType == fullscreen
  -> rightSwip
  -> hideFullGame
  -> showBtn
  -> HaveWanBtn == 1
  -> wanBtn.hidden = NO
  -> playAction / requestWanFaList / WanFaView
```

这说明“XIB 默认隐藏”和子类显示代码被注释，不足以证明入口永远不可达。`BaseLiveViewController` 仍会显示按钮，且 `gameType`、`game_url` 等来自房间/服务端数据。建议：

- 暂不删除 `WanFaVC/`、`WanFaModel`、FMS 的 `wan_toshow`/`wan_jujue` 处理。
- 先确认线上服务端是否还会下发 `fullscreen` 游戏及玩法列表。
- 若决定彻底下线服务端游戏，WanFa 应与直播间游戏 WebView/FMS 协议一起清，而不是单独按 UI 隐藏状态删除。

### 2.3 `HomeScreenViewController` 路径和边界需修正

实际文件位于 `lvyou/Classes/Live/Controller/HomeScreenViewController.*`，不在原报告所写的 `Find/Controller/`。它在 `XYFindAndMakingViewController` 中有有效创建，但 `LiveViewController` 也 import 了它并保留注释入口。若删除交友模块，可列为候选，但应先确认首页筛选功能是否准备恢复，不能按错误路径机械删除。

### 2.4 “配置关闭”不等于“代码无用”

`TabTwoType`、`TabThreeType`、`HomePageType`、`BeginLiveType` 本质上是编译进同一个包的产品形态开关。当前值固定只能证明该版本不可达，不能证明未来换皮、运营切换或其他构建配置不再需要。

若项目已经确定不再支持多站点配置，可以删分支；否则建议把这些配置收拢为明确的 Feature Flags 或不同 Target/xcconfig，而不是直接按当前值永久裁剪。

## 三、复核后的清理分级

### A 级：现在可以清理

| 项目 | 证据 | 操作 |
|---|---|---|
| `BannerWebViewControlleraa.m` | 磁盘存在，`project.pbxproj` 无记录；仅它自己引用 `ToyWebViewController` | 删除该重复文件 |
| `GuiZuViewControlleraa.h/.m/.xib` | 磁盘存在，`project.pbxproj` 无记录 | 删除 3 个重复文件 |
| `MyPropsViewControllerOld.h/.m/.xib` | 工程内除自身外仅有一个 import，没有实例化、继承、XIB 外部引用 | 先删 `UserViewController.m` 的 import，再从工程删除 3 个文件 |
| `BeginLiveShow` | 只有 `.h` 声明和 `.m` 定义 | 删除常量及枚举 |
| `RocketType` | 只有 `.h` 声明和 `.m` 定义 | 删除常量及枚举 |
| `HaveGameType` | 唯一业务出现位于整段注释代码 | 删除常量及枚举，并清注释 |
| `LastRowType` | 两个业务出现均在注释中 | 删除常量及枚举，并清注释 |

注意：A 级不包含 `IndexViewController`，也暂不包含 `HaveWanBtn`。

### B 级：产品确认“永久放弃配置能力”后可清理

| 模块 | 当前不可达依据 | 复核意见 |
|---|---|---|
| 1v1：`FindViewController` 及下游 | `TabTwoType=6`，1v1 case 为 2；`OneToOneType=2` | 可以整链清，但需同步删 Tab case、个人中心/任务入口。注意其 XIB 还有一处 File's Owner 类名疑似错误，见第五节 |
| 交友/动态 Tab：`XYFindAndMakingViewController` 及专属下游 | `TabTwoType!=5` 且 `TabThreeType!=2` | 基本同意原报告；必须逐个区分共享的动态、发布、搜索、用户详情组件，不能按 Find 目录整删 |
| 游戏开播：`BeginGameLiveViewController`、`SelectGameViewController`、`SelectGameModel` | `BeginLiveType=3`，只走视频+直播 | 可清理“主播游戏开播”链，但不代表“观众直播间服务端游戏”也能删除 |
| 游戏首页：`GameLiveVC`、`GameLiveCCell` | `HomePageType=10`，游戏首页 case 为 6 | 可按固定产品形态清理 |
| 游戏账单：`GameRecordViewController` | `GameListType=2` | 可清理，需同步重写 `XYCheckController` 的数组索引和切页逻辑 |
| 粉丝团旧浮层：`ShouHuViewController`、`ShouHuView`、`ShouHuDetailView` | `initShouHuPeople` 无外部调用；`ShouHuType=2` | 倾向可删，但应先搜索服务端消息/performSelector；保留活跃的 `OpenShouHuView` |

### C 级：暂不删除

| 项目 | 原因 |
|---|---|
| `IndexViewController` | 活跃公共父类 |
| `WanFaVC/`、`WanFaModel`、`HaveWanBtn` | 父类 `showBtn` 可重新显示入口，服务端游戏状态可能触发 |
| `XYGameViewerUserLiveViewController` | 观众端主直播间，不是可选游戏首页 |
| `PWDRoomVC` 与密码/收费房相关链 | 类本身看似无外部静态引用，但房间密码数据仍在多条入房链路传递；需真机验证及服务端协议确认 |
| 原报告 3.10 的低引用控制器 | 静态零引用只能作为候选；仍需检查 XIB、服务端路由、通知、字符串类名和历史入口 |

## 四、Constants 的建议处理方式

### 4.1 可直接删除的零有效引用常量

本轮确认：`BeginLiveShow`、`RocketType`、`HaveGameType`、`LastRowType`。

### 4.2 不建议“保留并写死”大量常量

原报告提出“约 28 项保留并写死当前值”。从维护角度看，这会产生最差的中间状态：名字仍像配置，行为却已不可配置。更建议二选一：

- 仍有多产品/换皮需求：保留配置，但迁移到 `AppFeatures`/xcconfig，按业务域分组并加注释和测试。
- 已确定单一产品形态：删除配置变量和不可达分支，直接保留当前实现，不再保留伪开关。

### 4.3 建议暂时保留的配置

`HomePageType`、`TabTwoType`、`TabThreeType`、`BeginLiveType`、`HaveWanBtn`、`ShouHuType`、`OneToOneType`、`GameListType` 等，直到对应模块完成独立删除并通过回归。应遵循“先删调用分支和模块，最后删常量”，避免中间提交不可编译。

### 4.4 安全问题（不属于本次删除范围，但应尽快处理）

`Constants.m` 中存在硬编码的第三方 App Secret/解密配置等敏感值。客户端二进制无法安全保存真正的 secret；建议轮换已暴露凭据，并将不应下发到客户端的密钥迁到服务端。空字符串的 `DATAAPI`、`CHAT` 等看起来由运行时配置补齐，不能仅因初值为空删除。

## 五、额外发现

1. `OneToOneHotDetailViewController.xib` 的 File's Owner 写成了 `OneToOneHotViewController`，与文件名和实现类不一致。若保留 1v1，应先修复并回归；若删除整个 1v1 模块，则随模块一并移除。
2. `IndexViewController` 虽然代码很薄，但统一设置导航栏和状态栏行为，不能仅按实现行数判断价值。
3. `project.pbxproj` 中待删业务文件通常出现多次（文件引用、Build File、Sources/Resources、Group），不能只删磁盘文件；建议用 Xcode 或脚本同步删除所有引用。
4. 静态搜索未发现业务控制器使用 `NSClassFromString` 动态创建候选类，但仍无法排除服务端 URL/协议驱动的业务行为。

## 六、构建基线

执行命令：

```sh
xcodebuild -workspace lvyou.xcworkspace \
  -scheme lvyou \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

结果：**未通过，但失败发生在业务源码编译之前**。`libksygpulive` 的预编译静态库包含 iOS device 对象，被链接进 iOS Simulator arm64 目标，产生平台不匹配。另有多个 Pod 的最低部署版本低于当前 Xcode 26.4 支持范围的警告。

这意味着当前环境没有可用的 Simulator 编译基线，后续每批清理最好采用以下之一验证：

- 真机 generic device 构建（具备签名/依赖条件时）；
- 为 Simulator 排除不兼容架构或升级 `libksygpulive`；
- 先建立能稳定通过的 CI/归档基线，再开始批量删除。

## 七、推荐执行顺序

1. 建立可重复的构建基线；至少确保修改前、修改后使用同一命令。
2. 第一提交：删除 4 个未入工程的 `aa` 重复文件。
3. 第二提交：删除 `MyPropsViewControllerOld` 及唯一 import。
4. 第三提交：删除 4 个零有效引用 Constants，保持纯机械变更。
5. 产品确认是否永久放弃多站点配置。
6. 按模块单独提交：1v1、交友 Tab、游戏开播、游戏首页、游戏账单、旧守护浮层；每个模块独立编译和回归。
7. 单独评估服务端游戏与 WanFa，不能夹在普通 UI 清理提交中。
8. 最后收敛 Constants 和枚举，避免先删开关导致大量调用方同时失控。

## 八、最终建议

当前最稳妥的范围是：**先执行 A 级，但排除原报告错误列入的 `IndexViewController`，并把 WanFa 整体从 B 级移到 C 级。**

原报告估算的“第二批约 83 个文件”不建议一次性删除。应拆成 5～6 个可回滚模块提交；否则一旦出现直播间、消息、服务端房间协议或 XIB 索引问题，很难定位是哪一组删除造成的。

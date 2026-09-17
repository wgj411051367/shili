//
//  lvyou-Bridging-Header.h
//  Swift ↔ Objective-C 混编桥接头
//
//  只在这里 #import 「干净」的 OC 头（不依赖 pch、不拖入被 iOS 26 移除的旧 API）。
//  切忌 import BaseViewController.h / AppDelegate.h 这类「上帝头文件」——它们会把
//  半个 app 的传递依赖拖进来、还依赖 pch、还含 iOS26 已移除的 ALAsset，导致
//  bridging 预编译失败。凡是脏头背后的能力，一律用干净门面（如 LoginBridge）暴露。
//

#import "Constants.h"        // 颜色/枚举/extern 全局(DATAAPI/IMAGEAPI/Authorization…)
#import "HttpMacro.h"        // 接口路径字符串常量(users_oauth/users_code…)
#import "RootHttpHelper.h"   // 网络封装(已改为前向声明 AppDelegate，头文件干净)
#import "MessageHelper.h"    // 轻提示 toast
#import "HUDHelper2.h"       // 加载 HUD（syncLoading/syncStopLoading）
#import "HudHelper.h"        // 短提示（showShortTips）
#import "LoginBridge.h"      // 登录/注册脏活的干净门面
#import "UserInfoModel.h"    // 核心用户资料模型（JSONModel，干净），User 模块编辑页需要
#import "LevelBridge.h"      // 等级徽章展示的干净门面（脏活关在 .m）
#import "CurrentUserBridge.h"// 当前登录用户资料的干净门面（脏活关在 .m）
#import "RankPeopleModel.h"  // 等级模型（JSONModel，干净），等级页需要


#import "BannerModel.h"              // banner 模型（JSONModel，干净）
#import "SDCycleScrollView.h"        // 轮播图（vendored UIView）
#import <Lottie/LOTAnimationView.h>  // Lottie（头像框/座驾 cell 头文件引用 LOTAnimationView，需先可见）
#import "HorseModel.h"               // 头像框/座驾模型（JSONModel，干净）
#import "UserMenuBridge.h"           // 我的页菜单跳转的统一门面
#import "PersonInfoModel.h"          // 我的页菜单项模型（JSONModel，干净）
#import "PersonalView.h"             // 我的页头部视图（OC nib View，干净）
#import "PersonalTableCell.h"        // 我的页菜单 cell（OC View，干净）
#import "ToolHelper.h"               // 工具单例（rangeDate 相对时间等），头文件干净
#import <SDWebImage/UIImageView+WebCache.h>  // 图片异步加载/缓存（Swift 列表页头像/礼物图）

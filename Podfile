source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

platform :ios, '14.0'
use_frameworks!

target 'lvyou' do

pod 'DACircularProgress'
pod 'JSONModel'
#pod 'AFNetworking'
pod 'SDWebImage', '~>5.21' #P0: 4.3.3 升级到 5.21（多个 4.x CVE）
pod 'MBProgressHUD'
pod 'MJRefresh'
#pod 'SDCycleScrollView','~>1.75' #版本
pod 'FMDB'
#pod 'WeiboSDK'
pod 'RMessage','~>2.1.5'#版本
pod 'HMSegmentedControl', '~> 1.5.5'
# pop 已移除：Facebook POP 2022 归档、纯 C++ 老库现代工具链链接失败，
# 唯一用途（HyPopMenuView 弹出动画）已换成 UIKit 原生弹簧动画
#pod 'AMap2DMap', '~>3.3.0'
#pod 'AMapLocation' , '~>1.2.2'
#pod 'AMapSearch', '~>3.3.0'
#pod 'XMPPFramework', :git => "https://github.com/robbiehanson/XMPPFramework.git", :branch => 'master'
pod 'SVGAPlayer'#yy的svga动画 2018.8.8
pod 'Bugly'
pod 'Masonry'
pod 'JXCategoryView'
pod 'YYText'
pod 'lottie-ios', '~> 2.5.3'
pod 'DZNEmptyDataSet', '~> 1.8.1'

pod 'TXLiteAVSDK_Professional', :podspec => 'https://liteav.sdk.qcloud.com/pod/liteavsdkspec/TXLiteAVSDK_Professional.podspec'
#pod 'TXLiteAVSDK_TRTC', :podspec => 'https://liteav.sdk.qcloud.com/pod/liteavsdkspec/TXLiteAVSDK_TRTC.podspec'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    # 强制所有 pod 的最低部署版本对齐主工程（14.0）。
    # 老 pod（如 lottie 2.5.3）默认 target 过低（iOS 8），Xcode 14.3+ 已移除
    # libarclite，链接会报 "SDK does not contain 'libarclite'"。抬高即可修复。
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'

      # YYText 1.0.7（已归档，升无可升）的 YYTextLayout.m 有祖传的链式比较
      # 写法 `A < B < C`（作者本意是三元表达式的笔误）。新版 clang 把链式比较
      # 从警告升级为默认错误。降回警告以保持线上既有运行时行为不变。
      if target.name == 'YYText'
        config.build_settings['GCC_WARN_ABOUT_MISSING_PROTOTYPES'] = 'NO'
        existing = config.build_settings['OTHER_CFLAGS'] || '$(inherited)'
        config.build_settings['OTHER_CFLAGS'] = "#{existing} -Wno-error=parentheses"
      end

      # SVGAPlayer 内置的老 protoc 生成代码（Svga.pbobjc.m）用了废弃的
      # OSAtomicCompareAndSwapPtrBarrier 却没 import 头文件。新版 clang 把隐式
      # 函数声明变成硬错误。强制 include OSAtomic 头，让真实声明可见。
      if target.name == 'SVGAPlayer'
        existing = config.build_settings['OTHER_CFLAGS'] || '$(inherited)'
        config.build_settings['OTHER_CFLAGS'] = "#{existing} -include libkern/OSAtomic.h -Wno-error=implicit-function-declaration"
      end
    end

    shell_script_path = "Pods/Target Support Files/#{target.name}/#{target.name}-frameworks.sh"
    if File.exist?(shell_script_path)
      shell_script_input_lines = File.readlines(shell_script_path)
      shell_script_output_lines = shell_script_input_lines.map { |line| line.sub("source=\"$(readlink \"${source}\")\"", "source=\"$(readlink -f \"${source}\")\"") }
      File.open(shell_script_path, 'w') do |f|
        shell_script_output_lines.each do |line|
          f.write line
        end
      end
    end
  end
end


end

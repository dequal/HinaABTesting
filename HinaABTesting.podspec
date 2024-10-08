Pod::Spec.new do |s|
  s.name         = 'HinaABTesting'
  s.version      = "0.0.5"
  s.summary      = 'The official iOS SDK of Hina A/B Testing.'
  s.homepage     = 'https://github.com/dequal/HinaABTesting'
  s.license      = "MIT"
  s.source       = { :git => 'https://github.com/dequal/HinaABTesting.git', :tag => "0.0.8" }
  s.author       = 'dequal'
  s.ios.deployment_target = '9.0'
  # s.osx.deployment_target = '10.13'
  s.module_name  = "HinaABTest"
  s.requires_arc = true
  s.cocoapods_version = '>= 1.5.0'
  s.ios.framework = 'UIKit', 'Foundation'

#  依赖 海纳埋点sdk 最低版本
 s.dependency 'HinaCloudSDK', '>=4.0.1'

#  s.source_files = 'HinaABTest/**/*.{h,m}'
#  s.public_header_files = 'HinaABTest/**/HinaABTestConfigOptions.h', 'HinaABTest/**/HinaABTest.h', 'HinaABTest/**/HinaABTestExperiment.h'
#  s.resource_bundle = { 'HinaABTesting' => 'HinaABTest/Resources/**/*'}

# ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
# 本库提供的framework静态库
s.vendored_frameworks = 'Sources/*.xcframework'

# ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.requires_arc = true
s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 x86_64' }


end

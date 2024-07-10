Pod::Spec.new do |s|
  s.name         = 'HinaABTesting'
  s.version      = "0.0.1"
  s.summary      = 'The official iOS/macOS SDK of Hina A/B Testing.'
  s.homepage     = 'https://github.com/dequal/HinaABTesting'
  s.license      = "MIT"
  s.source       = { :git => 'https://github.com/dequal/HinaABTesting.git', :tag => 'v' + s.version.to_s}
  s.author       = 'dequal'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.13'
  s.module_name  = "HinaABTest"
  s.requires_arc = true
  s.cocoapods_version = '>= 1.5.0'
  s.ios.framework = 'UIKit', 'Foundation'

#  依赖 海纳埋点sdk 最低版本
  s.dependency 'HinaCloudSDK', '>=4.0.0'

#  s.source_files = 'HinaABTest/**/*.{h,m}'
#  s.public_header_files = 'HinaABTest/**/HinaABTestConfigOptions.h', 'HinaABTest/**/HinaABTest.h', 'HinaABTest/**/HinaABTestExperiment.h'
#  s.resource_bundle = { 'HinaABTesting' => 'HinaABTest/Resources/**/*'}


# 本库提供的framework静态库
spec.vendored_frameworks = 'Sources/*.xcframework'

# ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
spec.requires_arc = true
spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 x86_64' }


end

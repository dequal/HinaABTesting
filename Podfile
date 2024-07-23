# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'

workspace 'HinaABTest'
project './Example/Example.xcodeproj'

target 'Example-iOS' do
  platform :ios, '9.0'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

#  pod 'SensorsAnalyticsSDK'
#  pod 'HinaABTesting'
  
  pod 'HinaABTesting', :path => './'
  pod 'HinaCloudSDK', '>= 4.0.1'


end


target 'Example-macOS' do
  platform :osx, '10.10'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  #  pod 'HinaABTesting'

#  pod 'HinaABTesting', :path => './'
#  pod 'SensorsAnalyticsSDK', '>= 4.5.6'

end

#
# Be sure to run `pod lib lint PoporUploadVC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PoporUploadVC'
  s.version          = '0.0.01'
  s.summary          = '简化上传图片视频等方法'

  s.homepage         = 'https://github.com/popor/PoporUploadVC'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'popor' => '908891024@qq.com' }
  s.source           = { :git => 'https://github.com/popor/PoporUploadVC.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PoporUploadVC/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PoporUploadVC' => ['PoporUploadVC/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'Masonry'
  s.dependency 'JSONModel'
  s.dependency 'PoporUI/IToast'
  s.dependency 'PoporFoundation/PrefixCore'
  s.dependency 'PoporFoundation/NSAssistant'
  s.dependency 'PoporFoundation/NSDate'
  s.dependency 'SDWebImage'
  s.dependency 'PoporAVPlayer'
  s.dependency 'PoporImageBrower'
  s.dependency 'PoporMedia'
  s.dependency 'AFNetworking'
  s.dependency 'DMProgressHUD'
  
  #s.dependency 'AliyunOSSiOS'
  
  
end

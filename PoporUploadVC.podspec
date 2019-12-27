#
# Be sure to run `pod lib lint PoporUploadVC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PoporUploadVC'
  s.version          = '1.12'
  s.summary          = '简化上传图片视频等方法'

  s.homepage         = 'https://github.com/popor/PoporUploadVC'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'popor' => '908891024@qq.com' }
  s.source           = { :git => 'https://github.com/popor/PoporUploadVC.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.subspec 'EntityTool' do |ss|
    ss.source_files = 'Example/Classes/PoporUploadEntity.{h,m}', 'Example/Classes/PoporUploadServiceProtocol.{h,m}', 'Example/Classes/PoporUploadTool.{h,m}', 'Example/Classes/PoporUploadVCPrefix.{h,m}', 'Example/Classes/PUShare.{h,m}', 'Example/Classes/PUVideoTool.{h,m}', 'Example/Classes/UIView+PoporUpload.{h,m}'
    
  end
  
  s.subspec 'Cell' do |ss|
    ss.ios.dependency 'PoporUploadVC/EntityTool'
    
    ss.source_files = 'Example/Classes/PoporUploadCC.{h,m}', 'Example/Classes/PoporUploadCCProtocol.{h,m}'
    
  end
  
  s.subspec 'VC' do |ss|
    ss.ios.dependency 'PoporUploadVC/EntityTool'
    ss.ios.dependency 'PoporUploadVC/Cell'
    
    ss.source_files = 'Example/Classes/PoporUploadVC.{h,m}', 'Example/Classes/PoporUploadVcCellPresent.{h,m}', 'Example/Classes/PoporUploadVCInteractor.{h,m}', 'Example/Classes/PoporUploadVCPresenter.{h,m}', 'Example/Classes/PoporUploadVCProtocol.{h,m}', 'Example/Classes/PoporUploadVcShowPresent.{h,m}'
    
  end
  
  s.resource = 'Example/Classes/PoporUploadVC.bundle'
  
  s.dependency 'Masonry'
  s.dependency 'JSONModel'
  s.dependency 'PoporUI/IToast'
  s.dependency 'PoporUI/UIImage'
  s.dependency 'PoporFoundation/Prefix'
  s.dependency 'PoporFoundation/NSAssistant'
  s.dependency 'PoporFoundation/NSDate'
  s.dependency 'SDWebImage'
  s.dependency 'PoporAVPlayer'
  s.dependency 'PoporImageBrower'
  s.dependency 'PoporMedia'
  s.dependency 'AFNetworking'
  s.dependency 'DMProgressHUD'
  
end

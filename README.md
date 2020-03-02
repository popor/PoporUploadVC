# PoporUploadVC

[![CI Status](https://img.shields.io/travis/popor/PoporUploadVC.svg?style=flat)](https://travis-ci.org/popor/PoporUploadVC)
[![Version](https://img.shields.io/cocoapods/v/PoporUploadVC.svg?style=flat)](https://cocoapods.org/pods/PoporUploadVC)
[![License](https://img.shields.io/cocoapods/l/PoporUploadVC.svg?style=flat)](https://cocoapods.org/pods/PoporUploadVC)
[![Platform](https://img.shields.io/cocoapods/p/PoporUploadVC.svg?style=flat)](https://cocoapods.org/pods/PoporUploadVC)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PoporUploadVC is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PoporUploadVC'
```

1.09
- 移除videoFromCamraUseCompress(单独的bool变量控制, 是否不压缩拍摄视频),改为PoporUploadVideoCompressTypeCamera
- 增加PoporUploadVideoCompressTypeMp4       = 1 << 3, // 如果不是MP4后缀,那么不显示'不压缩'选项
- 增加PoporUploadVideoCompressTypeCamera  = 1 << 4, // 拍摄的视频不需要压缩情形(个别情况使用)

1.11
允许设定图片容量block.
PoporUpload_imageAllowSelectBlock imageAllowSelectBlock;

1.12
修改图片image显示顺序
优先显示entity.image和imageUrl, 其次替换模式下面的图片, 最后显示页面或者entity默认图片

1.13
增加了PoporUpload_tvPlaceHolderBlock  tvPlaceHolderBlock, 可以设置TV的一些额外属性,比如默认空白页


## Author

popor, 908891024@qq.com

## License

PoporUploadVC is available under the MIT license. See the LICENSE file for more info.

<a href='https://github.com/popor/mybox'> MyBox </a>

# PoporAVPlayer

[![CI Status](https://img.shields.io/travis/popor/PoporAVPlayer.svg?style=flat)](https://travis-ci.org/popor/PoporAVPlayer)
[![Version](https://img.shields.io/cocoapods/v/PoporAVPlayer.svg?style=flat)](https://cocoapods.org/pods/PoporAVPlayer)
[![License](https://img.shields.io/cocoapods/l/PoporAVPlayer.svg?style=flat)](https://cocoapods.org/pods/PoporAVPlayer)
[![Platform](https://img.shields.io/cocoapods/p/PoporAVPlayer.svg?style=flat)](https://cocoapods.org/pods/PoporAVPlayer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### A simple video player, support orientation.

### 1.you need registe in AppDelegate
### 1.你需要在 AppDelegate中注册
```
- (BOOL)application:(UIApplication *)application did finishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[PoporOrientation swizzlingAppDelegate:self];
	return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
	// this will be replaced by PoporOrientation within runtime, do not remove!
	return UIInterfaceOrientationMaskPortrait;
}

```
### 2.demo
```
- (void)playVideoAction {
	NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"douyin" ofType:@"mp4"];
	NSURL * videoURL    = [NSURL fileURLWithPath:videoPath];

	[self.navigationController pushViewController:[PoporAVPlayerVCRouter vcWithDic:@{@"title":@"升降桌", @"videoURL":videoURL, @"showLockRotateBT":@(YES)}] animated:YES];
}
```

## Requirements

## Installation

PoporAVPlayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PoporAVPlayer'
```

## Author

popor, 908891024@qq.com

## License

PoporAVPlayer is available under the MIT license. See the LICENSE file for more info.

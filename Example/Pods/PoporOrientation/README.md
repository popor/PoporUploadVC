<a href='https://github.com/popor/mybox'> MyBox </a>

# PoporOrientation

[![CI Status](https://img.shields.io/travis/wangkq/PoporOrientation.svg?style=flat)](https://travis-ci.org/wangkq/PoporOrientation)
[![Version](https://img.shields.io/cocoapods/v/PoporOrientation.svg?style=flat)](https://cocoapods.org/pods/PoporOrientation)
[![License](https://img.shields.io/cocoapods/l/PoporOrientation.svg?style=flat)](https://cocoapods.org/pods/PoporOrientation)
[![Platform](https://img.shields.io/cocoapods/p/PoporOrientation.svg?style=flat)](https://cocoapods.org/pods/PoporOrientation)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

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

### 2. demo
```
- (void)autoRotationAction:(UIButton *)bt {
	bt.selected = !bt.isSelected;
	if (bt.isSelected) {
		[PoporOrientation enableAutoFinish:nil];
		[self closeLockEvent];
	}else{
		[PoporOrientation disable];
	}
}

- (void)lockAction:(UIButton *)bt {
	bt.selected = !bt.isSelected;
	[PoporOrientation share].lock = bt.isSelected;
}

- (void)autoFisrtLeftAction:(UIButton *)bt {
	bt.selected = !bt.isSelected;
	if (bt.isSelected) {
		[PoporOrientation enableRotateTo:UIInterfaceOrientationLandscapeLeft finish:nil];
		[self closeLockEvent];
	}else{
		[PoporOrientation disable];
	}
}

- (void)autoFisrtRightAction:(UIButton *)bt {
	bt.selected = !bt.isSelected;
	if (bt.isSelected) {
		[PoporOrientation enableRotateTo:UIInterfaceOrientationLandscapeRight finish:nil];
		[self closeLockEvent];
	}else{
		[PoporOrientation disable];
	}
}

- (void)autoPriorityLeftAction:(UIButton *)bt {
	bt.selected = !bt.isSelected;
	if (bt.isSelected) {
		[PoporOrientation enablePriorityLeftFinish:nil];
		[self closeLockEvent];
	}else{
		[PoporOrientation disable];
	}
}

- (void)autoPriorityRightAction:(UIButton *)bt {
	bt.selected = !bt.isSelected;
	if (bt.isSelected) {
		[PoporOrientation enablePriorityRightFinish:nil];
		[self closeLockEvent];
	}else{
		[PoporOrientation disable];
	}
}

- (void)closeLockEvent {
	if (self.lockBT.isSelected) {
		dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			self.lockBT.selected = YES;
			[self lockAction:self.lockBT];
		});
	}
}
```

## Requirements

## Installation

PoporOrientation is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PoporOrientation'
```

## Author

popor, 908891024@qq.com

## License

PoporOrientation is available under the MIT license. See the LICENSE file for more info.

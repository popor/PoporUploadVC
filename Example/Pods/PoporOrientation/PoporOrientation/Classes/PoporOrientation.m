//
//  PoporOrientation.m
//  Pods-PoporOrientation_Example
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporOrientation.h"
#import "PoporMotionManager.h"
#import "PoporAppDelegate.h"
#import "PoporInterfaceOrientation.h"

@interface PoporOrientation ()

@property (nonatomic, strong) PoporMotionManager * pmm;

@property (nonatomic, getter=isEnableNotificationCenter) BOOL enableNotificationCenter;

@end


@implementation PoporOrientation

+ (instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)swizzlingAppDelegate:(id)appDelegate {
    [PoporAppDelegate swizzlingAppDelegate:appDelegate];
}

//------------------------------------------------------------------------------
// 全自动方向
+ (void)enableAutoFinish:(BlockPUIDeviceOrientation)block {
    PoporOrientation * po = [PoporOrientation share];
    po.finishBlock = block;
    po.allowRotation = YES;

#if TARGET_IPHONE_SIMULATOR
    //模拟器 : 由于虚拟机没有陀螺仪,所以需要多执行下面的代码,这样的话,会触发系统紊乱,从而自动识别到对的方向.
    UIInterfaceOrientation io = [PoporInterfaceOrientation interfaceOrientation_deviceOrientation:po.lastDeviceOrientation];
    [PoporInterfaceOrientation rotateTo:io];
#elif TARGET_OS_IPHONE//真机
    //真机 : 存在陀螺仪的话,不需要多余的操作.
#endif
    
    if (!po.pmm) {
        po.pmm = [PoporMotionManager new];
    }
    [po.pmm startMonitor:^(BOOL success) {
        PoporOrientation * po_ = [PoporOrientation share];
        UIInterfaceOrientation io = [po_.pmm interfaceOrientation];
        [PoporInterfaceOrientation rotateTo:io];
        [po_.pmm stopMonitor];
    }];
}

// 自动旋转,假如当前为非左右方向,那么旋转为左方向,然后自动跟随设备方向旋转
+ (void)enablePriorityLeftFinish:(BlockPUIDeviceOrientation)block {
    [self enablePriorityTo:UIInterfaceOrientationLandscapeLeft finish:block];
}

// 自动旋转,假如当前为非左右方向,那么旋转为右方向,然后自动跟随设备方向旋转
+ (void)enablePriorityRightFinish:(BlockPUIDeviceOrientation)block {
    [self enablePriorityTo:UIInterfaceOrientationLandscapeRight finish:block];
}

// 内部接口,主要供enablePriorityLeftFinish:和enablePriorityRightFinish:使用
+ (void)enablePriorityTo:(UIInterfaceOrientation)interfaceOrientation finish:(BlockPUIDeviceOrientation)block {
    if (interfaceOrientation != UIInterfaceOrientationLandscapeLeft &&
        interfaceOrientation != UIInterfaceOrientationLandscapeRight) {
        interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
    }
    PoporOrientation * po = [PoporOrientation share];
    po.finishBlock = block;
    po.allowRotation = YES;
    
#if TARGET_IPHONE_SIMULATOR
    //模拟器 : 由于虚拟机没有陀螺仪,所以需要多执行下面的代码,这样的话,会触发系统紊乱,从而自动识别到对的方向.
    NSLog(@"PoporOrientation : 虚拟机优先旋转可能存在问题.");
    UIInterfaceOrientation io = [PoporInterfaceOrientation interfaceOrientation_deviceOrientation:po.lastDeviceOrientation];
    [PoporInterfaceOrientation rotateTo:io];
#elif TARGET_OS_IPHONE//真机
    //真机 : 存在陀螺仪的话,不需要多余的操作.
#endif
    
    if (!po.pmm) {
        po.pmm = [PoporMotionManager new];
    }
    [po.pmm startMonitor:^(BOOL success) {
        PoporOrientation * po_ = [PoporOrientation share];
        UIInterfaceOrientation io = [po_.pmm interfaceOrientation];
        if (io == UIInterfaceOrientationUnknown ||
            io == UIInterfaceOrientationPortrait ||
            io == UIInterfaceOrientationPortraitUpsideDown) {
            io = interfaceOrientation;
        }
        [PoporInterfaceOrientation rotateTo:io];
        [po_.pmm stopMonitor];
    }];
}

// 自动旋转为?,然后自动跟随设备方向旋转
+ (void)enableRotateTo:(UIInterfaceOrientation)interfaceOrientation finish:(BlockPUIDeviceOrientation)block {
    PoporOrientation * po = [PoporOrientation share];
    po.finishBlock = block;
    po.allowRotation = YES;
    [PoporInterfaceOrientation rotateTo:interfaceOrientation];
}


+ (void)disable {
    [PoporOrientation disableRotateTo:UIInterfaceOrientationPortrait];
}

+ (void)disableRotateTo:(UIInterfaceOrientation)interfaceOrientation {
    PoporOrientation * po = [PoporOrientation share];
    po.finishBlock = nil;
    po.allowRotation = NO;
    [PoporInterfaceOrientation rotateTo:interfaceOrientation];
}

//------------------------------------------------------------------------------
- (void)setAllowRotation:(BOOL)allowRotation{
    _allowRotation = allowRotation;
    if (allowRotation) {
        [self sysOritationMonitor_NotificationCenterEnabled:allowRotation];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sysOritationMonitor_NotificationCenterEnabled:allowRotation];
        });
    }
}

// 该函数enabled == NO,将关闭系统触发application:supportedInterfaceOrientationsForWindow:功能,需要的话可以重新打开.
- (void)sysOritationMonitor_NotificationCenterEnabled:(BOOL)enabled {
    [self sysOritationMonitorEnabled:enabled];
    [self notificationCenterEnabled:enabled];
}

- (void)sysOritationMonitorEnabled:(BOOL)enabled {
    if (enabled) {
        if (![UIDevice currentDevice].isGeneratingDeviceOrientationNotifications) {
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        }
    }else{
        if ([UIDevice currentDevice].isGeneratingDeviceOrientationNotifications) {
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        }
    }
}

#pragma mark - 通知部分
- (void)notificationCenterEnabled:(BOOL)enabled {
    if (enabled) {
        if (!self.isEnableNotificationCenter) {
            self.enableNotificationCenter = !self.enableNotificationCenter;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        }
    }else{
        if (self.isEnableNotificationCenter) {
            self.enableNotificationCenter = !self.enableNotificationCenter;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        }
    }
    
    // __weak typeof(self) weakSelf = self;
    // [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * _Nullable x) {
    //         NSLog(@"%@", x);
    //         [weakSelf onDeviceOrientationDidChange];
    // }];
}

// 设备方向改变
- (void)onDeviceOrientationDidChange {
    [self performSelector:@selector(onDeviceOrientationDidChangeDelay) withObject:nil afterDelay:0.05];
}

- (void)onDeviceOrientationDidChangeDelay {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (self.lastDeviceOrientation != orientation) {
        self.lastDeviceOrientation  = orientation;
        if (self.isLock) {
            
        }else if ([PoporOrientation share].isAllowRotation) {
            
            self.newInterfaceOrientationMask = [PoporInterfaceOrientation interfaceOrientationMask_deviceOrientation:orientation];
            self.newInterfaceOrientation = [PoporInterfaceOrientation interfaceOrientation_deviceOrientation:orientation];
            [PoporInterfaceOrientation rotateTo:self.newInterfaceOrientation];
            [self rotationOritationBlock:orientation];
            //NSLog(@"方向UI监测 %lu, 刷新", self.newInterfaceOrientation);
        }
    }else{
        //NSLog(@"方向UI监测 %lu, 忽略", self.newInterfaceOrientation);
    }
}

#pragma mark - 处理block
- (void)rotationOritationBlock:(UIDeviceOrientation)orientation {
    if (self.finishBlock) {
        self.finishBlock(orientation);
    }
}

@end

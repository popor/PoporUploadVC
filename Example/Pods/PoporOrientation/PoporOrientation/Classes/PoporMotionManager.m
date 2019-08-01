//
//  PoporMotionManager.m
//  Masonry
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporMotionManager.h"
#import "PoporInterfaceOrientation.h"

@import CoreMotion;

@interface PoporMotionManager ()
@property (nonatomic, strong) CMMotionManager * motionManager;

@end

@implementation PoporMotionManager

- (void)startMonitor:(void (^)(BOOL success)) finishBolck {
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    // 刷新数据频率
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    
    // 判断设备的传感器是否可用
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"PoporOrientation : Device Motion Available");
        //__weak typeof(self) weakSelf = self;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler: ^(CMDeviceMotion *motion, NSError*error){
            if ( finishBolck) {
                 finishBolck(YES);
            }
            //[weakSelf performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    } else {
        NSLog(@"PoporOrientation : No device motion on device.");
        _motionManager = nil;
        if ( finishBolck) {
             finishBolck(NO);
        }
    }
}

- (void)stopMonitor {
    [_motionManager stopDeviceMotionUpdates];
}

- (UIImageOrientation)imageOritation {
    return [PoporInterfaceOrientation imageOrientation_deviceOrientation:[self deviceOrientation]];
}

- (UIInterfaceOrientation)interfaceOrientation {
    return [PoporInterfaceOrientation interfaceOrientation_deviceOrientation:[self deviceOrientation]];
}

- (UIInterfaceOrientationMask)interfaceOrientationMask {
    return [PoporInterfaceOrientation interfaceOrientationMask_deviceOrientation:[self deviceOrientation]];
}

- (UIDeviceOrientation)deviceOrientation {
    return [self handleDeviceMotion:self.motionManager.deviceMotion];
}

- (UIDeviceOrientation)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    
    if (fabs(y) >= fabs(x)) {
        if (y >= 0){
            //NSLog(@"PoporOrientation PoporMotionManager: UIDeviceOrientationPortraitUpsideDown");
            return UIDeviceOrientationPortraitUpsideDown;
        } else{
            //NSLog(@"PoporOrientation PoporMotionManager:UIDeviceOrientationPortrait");
            return UIDeviceOrientationPortrait;
        }
    } else {
        if (x >= 0){
            //NSLog(@"PoporOrientation PoporMotionManager: UIDeviceOrientationLandscapeRight");
            return UIDeviceOrientationLandscapeRight;
        } else{
            //NSLog(@"PoporOrientation PoporMotionManager: UIDeviceOrientationLandscapeLeft");
            return UIDeviceOrientationLandscapeLeft;
        }
    }
}

@end

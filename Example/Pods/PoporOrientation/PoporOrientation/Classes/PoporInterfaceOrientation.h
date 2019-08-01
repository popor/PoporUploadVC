//
//  PoporInterfaceOrientation.h
//  Masonry
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoporInterfaceOrientation : NSObject

// 强制调整设备显示方向
+ (void)rotateTo:(UIInterfaceOrientation)interfaceOrientation;

+ (UIInterfaceOrientation)interfaceOrientation_deviceOrientation:(UIDeviceOrientation)deviceOrientation;
+ (UIInterfaceOrientationMask)interfaceOrientationMask_deviceOrientation:(UIDeviceOrientation)deviceOrientation;
+ (UIImageOrientation)imageOrientation_deviceOrientation:(UIDeviceOrientation)deviceOrientation;

@end

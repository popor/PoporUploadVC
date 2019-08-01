//
//  PoporInterfaceOrientation.m
//  Masonry
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporInterfaceOrientation.h"

@implementation PoporInterfaceOrientation

// 强制调整设备显示方向
+ (void)rotateTo:(UIInterfaceOrientation)interfaceOrientation {
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationUnknown) forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:@(interfaceOrientation) forKey:@"orientation"];
}

+ (UIInterfaceOrientation)interfaceOrientation_deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    UIInterfaceOrientation io;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:{
            io = UIInterfaceOrientationPortrait;
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:{
            if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
                io = UIInterfaceOrientationPortraitUpsideDown;
            }else{
                // iphone 不允许出现该模式,会崩溃.
                io = UIInterfaceOrientationUnknown;
            }
            break;
        }
        case UIDeviceOrientationLandscapeLeft:{
            io = UIInterfaceOrientationLandscapeRight;
            break;
        }
        case UIDeviceOrientationLandscapeRight:{
            
            io = UIInterfaceOrientationLandscapeLeft;
            break;
        }
        default:{
            io = UIInterfaceOrientationUnknown;
            break;
        }
    }
    return io;
}

+ (UIInterfaceOrientationMask)interfaceOrientationMask_deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    UIInterfaceOrientationMask iom;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:{
            iom = UIInterfaceOrientationMaskPortrait;
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:{
            if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
                iom = UIInterfaceOrientationMaskPortraitUpsideDown;
            }else{
                //iphone 不允许出现该模式,会崩溃.
                iom = UIInterfaceOrientationMaskAllButUpsideDown;
            }
            break;
        }
        case UIDeviceOrientationLandscapeLeft:{
            iom = UIInterfaceOrientationMaskLandscapeRight;
            break;
        }
        case UIDeviceOrientationLandscapeRight:{
            iom = UIInterfaceOrientationMaskLandscapeLeft;
            break;
        }
        default:{
            iom = UIInterfaceOrientationMaskPortrait;
            break;
        }
    }
    return iom;
}

+ (UIImageOrientation)imageOrientation_deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    UIImageOrientation imageOritation;
    switch (deviceOrientation) {
            
        case UIDeviceOrientationLandscapeLeft:
            imageOritation = UIImageOrientationUp;
            break;
        case UIDeviceOrientationLandscapeRight:
            imageOritation = UIImageOrientationDown;
            break;
            
            // 这几个都处理成默认
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            imageOritation = UIImageOrientationRight;
            break;
        default:
            imageOritation = UIImageOrientationRight;
            break;
    }
    return imageOritation;
}

@end

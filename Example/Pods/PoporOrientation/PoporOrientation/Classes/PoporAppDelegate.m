//
//  PoporAppDelegate.m
//  Masonry
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporAppDelegate.h"
#import "PoporOrientation.h"
#import "PoporInterfaceOrientation.h"

#import <PoporFoundation/NSObject+Swizzling.h>

@interface PoporAppDelegate ()

//@property (nonatomic        ) int tag;

@end

@implementation PoporAppDelegate

+ (void)swizzlingAppDelegate:(id)appDelegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSEL  = @selector(application:supportedInterfaceOrientationsForWindow:);
        SEL swizzleSEL = @selector(swizzlingApplication:supportedInterfaceOrientationsForWindow:);
        
        Class class = [appDelegate class];
        
        if (![appDelegate respondsToSelector:originSEL]) {
            //NSLog(@"appDelegate 不包含");
            //class_addMethod(class, originSEL, class_getMethodImplementation([PoporOrientation class], originSEL), "lu@:@:@");
            NSString * info = [NSString stringWithFormat:@"❌❌❌ PoporOrientation : Class [%@] should add code:\n\n- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {\n\t// this will be replaced by PoporOrientation within runtime, do not remove! \n\treturn UIInterfaceOrientationMaskPortrait;\n}\n\n❌❌❌\n", NSStringFromClass([appDelegate class])];
            fprintf(stderr,"\n%s\n", [info UTF8String]);
            return;
        }else{
            NSString * info = [NSString stringWithFormat:@"✅✅✅ PoporOrientation : Class [%@] will replace application:supportedInterfaceOrientationsForWindow:  by swizzlingApplication:supportedInterfaceOrientationsForWindow: \n", NSStringFromClass([appDelegate class])];
            fprintf(stderr,"\n%s\n", [info UTF8String]);
        }
        
        // 1. 先增加一个方法.
        // https://www.jianshu.com/p/6a3672b8be40
        //比如：”v@:”意思就是这已是一个void类型的方法，没有参数传入。
        //再比如 “i@:”就是说这是一个int类型的方法，没有参数传入。
        //再再比如”i@:@”就是说这是一个int类型的方法，又一个参数传入。
        class_addMethod(class, swizzleSEL, class_getMethodImplementation([self class], swizzleSEL), "lu@:@:@");
        
        // 2.再交换该方法
        [class methodSwizzlingWithOriginalSelector:originSEL bySwizzledSelector:swizzleSEL];
    });
}

- (UIInterfaceOrientationMask)swizzlingApplication:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    
    PoporOrientation * po = [PoporOrientation share];
    po.lastDeviceOrientation = [UIDevice currentDevice].orientation;
    
    if (po.isLock) {
        //NSLog(@"lock方向: %lu", po.lastInterfaceOrientationMask);
        return po.lastInterfaceOrientationMask;
    }else if (po.isAllowRotation) {
        po.lastInterfaceOrientationMask = [PoporInterfaceOrientation interfaceOrientationMask_deviceOrientation:po.lastDeviceOrientation];
        //NSLog(@"陀螺仪方向: %lu", po.lastInterfaceOrientationMask);
        return po.lastInterfaceOrientationMask;
    }else{
        //NSLog(@"固定方向");
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end

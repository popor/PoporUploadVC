//
//  PoporOrientation.h
//  Pods-PoporOrientation_Example
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

//作者：木语先生
//链接：https://www.jianshu.com/p/d6cb54d2eaa1
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
// 部分代码摘自:木语先生

#import <Foundation/Foundation.h>

typedef void(^BlockPUIDeviceOrientation) (UIDeviceOrientation orientation);

@interface PoporOrientation : NSObject

@property(nonatomic, getter=isAllowRotation)             BOOL allowRotation;
@property(nonatomic, getter=isLock)                      BOOL lock;

@property (nonatomic        ) UIDeviceOrientation        lastDeviceOrientation;// 自己使用
@property (nonatomic        ) UIInterfaceOrientationMask lastInterfaceOrientationMask;// AppDelegate使用

@property (nonatomic        ) UIInterfaceOrientation     newInterfaceOrientation;// AppDelegate使用
@property (nonatomic        ) UIInterfaceOrientationMask newInterfaceOrientationMask;// AppDelegate使用

@property (nonatomic, copy  ) BlockPUIDeviceOrientation  finishBlock; // 完成旋转后的回调

+ (instancetype)share;

+ (void)swizzlingAppDelegate:(id)appDelegate;

// 全自动方向
+ (void)enableAutoFinish:(BlockPUIDeviceOrientation)block;

// 自动旋转,假如当前为非左右方向,那么旋转为左方向,然后自动跟随设备方向旋转
+ (void)enablePriorityLeftFinish:(BlockPUIDeviceOrientation)block;
// 自动旋转,假如当前为非左右方向,那么旋转为右方向,然后自动跟随设备方向旋转
+ (void)enablePriorityRightFinish:(BlockPUIDeviceOrientation)block;
// 内部接口,主要供enablePriorityLeftFinish:和enablePriorityRightFinish:使用
+ (void)enablePriorityTo:(UIInterfaceOrientation)interfaceOrientation finish:(BlockPUIDeviceOrientation)block;

// 自动旋转为?,然后自动跟随设备方向旋转
+ (void)enableRotateTo:(UIInterfaceOrientation)interfaceOrientation finish:(BlockPUIDeviceOrientation)block;

// 关闭自动旋转功能
+ (void)disable;
// 关闭旋转功能,并且旋转到?
+ (void)disableRotateTo:(UIInterfaceOrientation)interfaceOrientation;

- (void)sysOritationMonitor_NotificationCenterEnabled:(BOOL)enabled;
// 该函数enabled == NO,将关闭系统触发application:supportedInterfaceOrientationsForWindow:功能,需要的话可以重新打开.
- (void)sysOritationMonitorEnabled:(BOOL)enabled;
- (void)notificationCenterEnabled:(BOOL)enabled;

@end



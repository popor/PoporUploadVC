//
//  PrefixSize.h
//  AppStore
//
//  Created by popor on 2017/7/6.
//  Copyright © 2017年 popor. All rights reserved.
//

#ifndef PrefixSize_h
#define PrefixSize_h

#pragma mark - iOS
#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
#import <UIKit/UIKit.h>

#define ScreenBounds   [[UIScreen mainScreen] bounds]
#define ScreenSize     [[UIScreen mainScreen] bounds].size

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height


#pragma mark - macOS
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>

#define ScreenBounds   [[NSScreen mainScreen] bounds]
#define ScreenSize     [[NSScreen mainScreen] bounds].size

#define SCREEN_WIDTH   [NSScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [NSScreen mainScreen].bounds.size.height

#endif

#endif /* PrefixSize_h */

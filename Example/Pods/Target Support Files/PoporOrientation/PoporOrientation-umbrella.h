#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "PoporAppDelegate.h"
#import "PoporInterfaceOrientation.h"
#import "PoporMotionManager.h"
#import "PoporOrientation.h"

FOUNDATION_EXPORT double PoporOrientationVersionNumber;
FOUNDATION_EXPORT const unsigned char PoporOrientationVersionString[];


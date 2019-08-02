//
//  PoporUploadShare.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import "PUShare.h"

@implementation PUShare

+ (instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
    });
    return instance;
}

+ (UIImage *)imageBundleNamed:(NSString *)imageName {
    UIImage * (^ imageBundleBlock)(NSString *) = ^(NSString *imageName){
        static NSBundle * bundle;
        if (!bundle) {
            bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"PoporUploadVC" ofType:@"bundle"]];
        }
        return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    };
    return imageBundleBlock(imageName);
}

@end

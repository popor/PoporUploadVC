//
//  PoporAVPlayerBundle.m
//  KVOController
//
//  Created by apple on 2018/7/17.
//

#import "PoporAVPlayerBundle.h"

@implementation PoporAVPlayerBundle

+ (UIImage *)imageBundleNamed:(NSString *)imageName {
    UIImage * (^ imageBundleBlock)(NSString *) = ^(NSString *imageName){
        static NSBundle * bundle;
        if (!bundle) {
            bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"PoporAVPlayer" ofType:@"bundle"]];
        }
        return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    };
    return imageBundleBlock(imageName);
}

@end

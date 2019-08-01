//
//  PoporMedia.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAsset+data.h"
#import "PoporImagePickerVC.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "PoporMediaPrefix.h"

@class PHAsset;

typedef void(^PoporImageFinishBlock)(NSArray *images, NSArray *assets, BOOL origin);
typedef void(^PoporVideoFinishBlock)(NSURL * videoURL, NSString * videoPath, NSData *imageData, UIImage *image, PHAsset * phAsset, CGFloat time, CGFloat videoSize);

@class PoporVideoProvider;

@interface PoporMedia : NSObject

@property (nonatomic, copy  ) PoporImageFinishBlock PoporImageFinishBlock;
@property (nonatomic, strong) PoporVideoProvider * imageProvider;

// 拍摄的时候增加一个浮层使用,只针对单拍使用.

#pragma mark - image
- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin finish:(PoporImageFinishBlock)finish;
// 可以增加自定义actions
- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin actions:(NSArray *)actions finish:(PoporImageFinishBlock)finish;

- (void)showImageACTitle:(NSString *)title
                 message:(NSString *)message
                      vc:(UIViewController *)vc
                maxCount:(int)maxCount
                  origin:(BOOL)origin
                 actions:(NSArray *)actions
                  finish:(PoporImageFinishBlock)finish
                  camera:(PoporImagePickerCameraBlock)cameraAppearBlock
                   album:(PoporImagePickerAlbumBlock)albumAppearBlock;

#pragma mark - video
- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size qualityType:(UIImagePickerControllerQualityType)qualityType finish:(PoporVideoFinishBlock)finish;
// 可以增加自定义actions
- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size qualityType:(UIImagePickerControllerQualityType)qualityType actions:(NSArray *)actions finish:(PoporVideoFinishBlock)finish;

@end

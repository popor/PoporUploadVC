//
//  ImageProvider.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PoporVideoProviderBlock)(NSURL * videoURL); // __BlockTypedef

@interface PoporVideoProvider : NSObject

@property (nonatomic, weak  ) UIImagePickerController * imagePC; // 图片采集器
@property (nonatomic, copy  ) PoporVideoProviderBlock   hasTakeVideo;

@property (nonatomic, weak  ) UIViewController * superVC;
@property (nonatomic        ) UIImagePickerControllerQualityType qualityType;

- (void)takeVideoFromCamera;

- (void)closeImagePC;

@end

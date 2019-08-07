//
//  PoporUploadTool.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoporUploadServiceProtocol.h"
#import "PoporUploadVCPrefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoporUploadTool : NSObject

@property (nonatomic, strong, nullable) id<PoporUploadServiceProtocol>  uploadService;
@property (nonatomic, copy  , nullable) PoporUpload_ProgressBlock puProgressBlock;
@property (nonatomic, copy  , nullable) PoporUpload_FinishBlock   puFinishBlock;
@property (nonatomic, strong) NSString          * uploadFileName; // 上传到服务器的名字.

// 图片部分
@property (nonatomic, copy  ) NSNumber          * compressionNumber;
@property (nonatomic, strong) NSString          * imageFileURL; // 假如传递图片url的话,可以使用这个参数.

@property (nonatomic, strong, nullable) UIImage * image;// 用于上传
@property (nonatomic, strong, nullable) NSData  * imageData;  // 假如传递视频的Data话,可以使用这个参数. 优选选择imageData
@property (nonatomic, strong) NSNumber          * originFile; // 是否使用原图

// 视频部分
@property (nonatomic, strong) NSString          * videoFileURL; // 假如传递视频的url话,可以使用这个参数.
@property (nonatomic, strong, nullable) NSData  * videoData;  // 假如传递视频的Data话,可以使用这个参数.

// 回调block
- (void)updateProgressBlock:(PoporUpload_ProgressBlock _Nullable)puProgressBlock;
- (void)updateFinishBlock:(PoporUpload_FinishBlock _Nullable)puFinishBlock;

// 开始上传
- (void)startUpload;

- (void)cancleUpload;

@end

NS_ASSUME_NONNULL_END


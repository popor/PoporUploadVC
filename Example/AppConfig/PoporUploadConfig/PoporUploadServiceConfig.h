//
//  PoporUploadServiceConfig.h
//  PoporUploadVC_Example
//
//  Created by apple on 2019/8/9.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporUploadEntity.h"
#import "PoporUploadVCProtocol.h"
#import "PoporUploadServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoporUploadServiceConfig : NSObject <PoporUploadServiceProtocol>

// 进行一些公共block设置
+ (void)setPushareCommonBlock;

#pragma mark - 视频文件
- (void)uploadVideoData:(NSData *)data fileName:(NSString *)fileName progress:(PoporUpload_ProgressBlock)progressBlock finish:(PoporUpload_FinishBlock)finishBlock;
- (void)uploadVideoPath:(NSString *)path fileName:(NSString *)fileName progress:(PoporUpload_ProgressBlock)progressBlock finish:(PoporUpload_FinishBlock)finishBlock;

#pragma mark - 普通文件
- (void)uploadImageData:(NSData *)data fileName:(NSString *)fileName   progress:(PoporUpload_ProgressBlock)progressBlock finish:(PoporUpload_FinishBlock)finishBlock;

- (void)cancleUpload;

@end

NS_ASSUME_NONNULL_END

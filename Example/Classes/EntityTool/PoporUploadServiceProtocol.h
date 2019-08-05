//
//  PoporUploadServiceProtocol.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PoporFoundation/PrefixBlock.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PoporUpload_ProgressBlock) (CGFloat progress);

// 当前PoporUpload_FinishBlock所传递的参数满足阿里
typedef void(^PoporUpload_FinishBlock)   (BOOL isSuccess, BOOL isCancle, NSString * _Nullable fileUrl, NSString * _Nullable requestId);

@protocol PoporUploadServiceProtocol <NSObject>

@property (nonatomic, copy  ) PoporUpload_ProgressBlock progressBlock;
@property (nonatomic, copy  ) PoporUpload_FinishBlock   finishBlock;

#pragma mark - 视频文件
- (void)uploadVideoData:(NSData *)data fileName:(NSString *)fileName progress:(PoporUpload_ProgressBlock)progressBlock finish:(PoporUpload_FinishBlock)finishBlock;
- (void)uploadVideoPath:(NSString *)path fileName:(NSString *)fileName progress:(PoporUpload_ProgressBlock)progressBlock finish:(PoporUpload_FinishBlock)finishBlock;

#pragma mark - 普通文件
- (void)uploadImageData:(NSData *)data fileName:(NSString *)fileName   progress:(PoporUpload_ProgressBlock)progressBlock finish:(PoporUpload_FinishBlock)finishBlock;

- (void)cancleUpload;

@end



NS_ASSUME_NONNULL_END

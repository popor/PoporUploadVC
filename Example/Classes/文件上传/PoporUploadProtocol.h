//
//  PoporUploadProtocol.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PoporFoundation/PrefixBlock.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * PoporUsRepeatRed = @"PoporUsRepeatRed";

typedef void(^PoporUploadProgressBlock) (CGFloat progress);
typedef void(^PoporUploadFinishBlock)   (BOOL isSuccess, BOOL isCancle, NSString * _Nullable fileUrl, NSString * _Nullable requestId);

@protocol PoporUploadProtocol <NSObject>

@property (nonatomic, copy  ) PoporUploadProgressBlock progressBlock;
@property (nonatomic, copy  ) PoporUploadFinishBlock   finishBlock;

#pragma mark - 视频文件
- (void)uploadVideoData:(NSData *)data fileName:(NSString *)fileName progress:(PoporUploadProgressBlock)progressBlock finish:(PoporUploadFinishBlock)finishBlock;
- (void)uploadVideoPath:(NSString *)path fileName:(NSString *)fileName progress:(PoporUploadProgressBlock)progressBlock finish:(PoporUploadFinishBlock)finishBlock;

#pragma mark - 普通文件
- (void)uploadJPGData:(NSData *)data fileName:(NSString *)fileName   progress:(PoporUploadProgressBlock)progressBlock finish:(PoporUploadFinishBlock)finishBlock;

- (void)cancleUpload;

@end



NS_ASSUME_NONNULL_END

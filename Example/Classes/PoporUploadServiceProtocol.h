//
//  PoporUploadServiceProtocol.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PoporFoundation/Block+pPrefix.h>

@class PoporUploadEntity;

NS_ASSUME_NONNULL_BEGIN

typedef void(^PoporUpload_ProgressBlock) (CGFloat progress);

// 当前PoporUpload_FinishBlock所传递的参数满足阿里
typedef void(^PoporUpload_FinishBlock)   (BOOL isSuccess, BOOL isCancle, NSString * _Nullable fileUrl, NSString * _Nullable requestId);

typedef void(^PoporUpload_FFmpegBlock)   (NSString * _Nonnull videoPath, NSString * _Nonnull toPath, BlockPBool _Nullable finish);

typedef void(^PoporUpload_tvPlaceHolderBlock) (UICollectionView * infoCV);

/**
 如果需要检查图片容量,请设置该block. 必要的设置有:
 entity.imageUploadTool.image = image;
 entity.imageUploadTool.imageData  = imageData;
 相关代码请复制block声明下面的代码块.
 
 @param image : 不为空
 @param imageData : 假如图片来自相机,该项为空.
 @param originFile: 用户是否选择了原图.
 @param entity : 请设置entity.imageUploadTool.imageData和entity.imageUploadTool.image, 假如.imageData 为空,则使用默认方式压缩 : imageData = UIImageJPEGRepresentation(image, 0.9);
 新增模式下,entity置为空则不上传该图片. 替换模式,主要不设置entity.image和data就可以不上传了.
 */
typedef void(^PoporUpload_imageAllowSelectBlock) (UIImage * image, NSData * imageData, BOOL originFile, PoporUploadEntity * puEntity);
// PoporUpload_imageAllowSelectBlock imageAllowSelectBlock = ^(UIImage * image, NSData * imageData, BOOL originFile, PoporUploadEntity * puEntity) {
//     if (!imageData) {
//         imageData = UIImageJPEGRepresentation(image, 0.9);
//     }
//     NSUInteger maxLength = 1.0*1024*1024;
//     if (imageData.length > maxLength) {
//         imageData = [image compressWithMaxLength:maxLength];
//
//         if (originFile) {
//             AlertToastTitle(@"原图片容量超过了1.0兆, 将进行压缩");
//         } else {
//             AlertToastTitle(@"原图片容量较大, 将进行压缩");
//         }
//     }
//
//     puEntity.imageUploadTool.image      = image;
//     puEntity.imageUploadTool.imageData  = imageData;
// };

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

//
//  PoporUploadVCPrefix.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <PoporFoundation/Block+pPrefix.h>
#import <PoporFoundation/Color+pPrefix.h>
#import "PoporUploadServiceProtocol.h"

@class PoporUploadEntity;

NS_ASSUME_NONNULL_BEGIN

#ifndef PoporUploadPrefix_h
#define PoporUploadPrefix_h

#define CvSectionDefaultEdgeInsets UIEdgeInsetsMake(5, 16, 5, 16)

typedef void(^PoporUpload_PEntityFinish) (PoporUploadEntity * puEntity, BlockPBool finishBlock);

typedef void(^PoporUpload_PNcVc) (UINavigationController * nc, UIViewController * vc);

typedef void(^PoporUpload_PNcVcEntityArray) (UINavigationController * nc, UIViewController * vc, PoporUploadEntity * puEntity, NSMutableArray * pueArray);

typedef BOOL(^PoporUpload_RBoolPVoid) (void);

typedef id<PoporUploadServiceProtocol>_Nullable(^PoporUpload_RUploadServicePVoid) (void);

typedef NSString * _Nullable(^PoporUpload_RStringPStringSize) (NSString * url, CGSize ccSize);


static NSString * PoporUploadImage_Add     = @"PoporUploadImage_Add";
static NSString * PoporUploadImage_Delete  = @"PoporUploadImage_Delete";
static NSString * PoporUploadImage_SelectN = @"PoporUploadImage_SelectN";
static NSString * PoporUploadImage_SelectS = @"PoporUploadImage_SelectS";
static NSString * PoporUploadImage_Resume  = @"PoporUploadImage_Resume";

static CGFloat    PoporUploadImageCompressionQuality = 0.9;

// 功能类型: 内部 CC 使用参数
typedef NS_ENUM(int, PoporUploadCCFunType) {
    PoporUploadCCFunTypeAdd    = 1,   // 新增按钮
    PoporUploadCCFunTypeNormal = 2,   // 上传、显示等
};

typedef NS_ENUM(int, PoporUploadType) {
    PoporUploadType_imageUpload,      // 图片上传
    PoporUploadType_videoUpload,      // 视频上传
    PoporUploadType_imageUploadBind,  // 图片上传绑定
    PoporUploadType_videoUploadBind,  // 视频上传绑定
    
    PoporUploadType_imageDisplay,     // 图片浏览
    PoporUploadType_videoDisplay,     // 视频浏览
    
    PoporUploadType_imageSelect,      // 图片浏览选择
    PoporUploadType_videoSelect,      // 视频浏览选择
    
    PoporUploadType_audioDisplay,     // 音频浏览
};

typedef NS_OPTIONS(NSUInteger, PoporUploadVideoCompressType) {
    PoporUploadVideoCompressTypeNone    = 1 << 0, // 不压缩
    PoporUploadVideoCompressTypeFFMpeg  = 1 << 1, // FFMpeg
    PoporUploadVideoCompressTypeSystem  = 1 << 2, // 系统压缩
    PoporUploadVideoCompressTypeMp4     = 1 << 3, // 如果不是MP4后缀,那么不显示'不压缩'选项
    PoporUploadVideoCompressTypeCamera  = 1 << 4, // 拍摄的视频不需要压缩情形(个别情况使用)
    // 3和4会存在冲突,因为拍摄的视频也是mov结尾的.
};

typedef NS_ENUM(int, PoporUploadAddType) {
    PoporUploadAddTypeNone,    // 没有新增图片的功能
    PoporUploadAddTypeOrder,   // 顺序增加
    PoporUploadAddTypeReplace, // 替换模式
};

typedef NS_ENUM(int, PoporUploadStatus) {
    PoporUploadStatusInit = 1,
    PoporUploadStatusUploading,
    PoporUploadStatusFinish,
    PoporUploadStatusFailed,
};

#endif /* PoporUploadPrefix_h */

NS_ASSUME_NONNULL_END

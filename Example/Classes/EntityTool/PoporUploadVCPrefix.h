//
//  PoporUploadVCPrefix.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#ifndef PoporUploadPrefix_h
#define PoporUploadPrefix_h

static NSString * PoporUploadImage_Add     = @"PoporImage_Add";
static NSString * PoporUploadImage_Delete  = @"PoporImage_Delete";
static NSString * PoporUploadImage_SelectN = @"PoporUploadImage_SelectN";
static NSString * PoporUploadImage_SelectS = @"PoporUploadImage_SelectS";
static NSString * PoporUploadImage_Resume  = @"PoporUploadImage_Resume";

static CGFloat    PoporUploadImageCompressionQuality = 0.9;

// 功能类型: 内部 CC 使用参数
typedef NS_ENUM(int, PoporUploadCCFunType) {
    PoporUploadCCFunTypeAdd    = 1,   // 新增按钮
    PoporUploadCCFunTypeNormal = 2,   // 上传、显示等
};

typedef NS_ENUM(int, PoporUploadCvType) {
    PoporUploadCvType_imageUpload,    // 图片上传
    PoporUploadCvType_videoUpload,    // 视频上传
    PoporUploadCvType_imageUploadBind,// 图片上传绑定
    PoporUploadCvType_videoUploadBind,// 视频上传绑定
    
    PoporUploadCvType_imageDisplay,   // 图片浏览
    PoporUploadCvType_videoDisplay,   // 视频浏览
    
    PoporUploadCvType_imageSelect,    // 图片浏览选择
    PoporUploadCvType_videoSelect,    // 视频浏览选择
};

typedef NS_OPTIONS(NSUInteger, PoporUploadVideoCompressType) {
    PoporUploadVideoCompressTypeNone   = 1 << 0, // 不压缩
    PoporUploadVideoCompressTypeFFMpeg = 1 << 1, // FFMpeg
    PoporUploadVideoCompressTypeSystem = 1 << 2, // 系统压缩
};

typedef NS_ENUM(int, PoporUploadAddType) {
    PoporUploadAddTypeNone,           // 没有新增图片的功能
    PoporUploadAddTypeOrder,          // 顺序增加
    PoporUploadAddTypeReplace,        // 替换模式
};

#endif /* PoporUploadPrefix_h */

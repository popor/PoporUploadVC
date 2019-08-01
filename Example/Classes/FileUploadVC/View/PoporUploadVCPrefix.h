//
//  FileUploadPrefix.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#ifndef FileUploadPrefix_h
#define FileUploadPrefix_h

static NSString * PoporFUImage_Add     = @"PoporFU_add";
static NSString * PoporFUImage_Delete  = @"PoporFU_deleteN";
static NSString * PoporFUImage_SelectN = @"PoporFU_selectN";
static NSString * PoporFUImage_SelectS = @"PoporFU_selectS";
static NSString * PoporFUImage_Resume  = @"PoporFU_resume";

// 功能类型: 内部 CC 使用参数
typedef NS_ENUM(int, FileUploadCCFunType) {
    FileUploadCCFunTypeAdd    = 1,   // 新增按钮
    FileUploadCCFunTypeNormal = 2,   // 上传、显示灯
};

typedef NS_ENUM(int, FileUploadCvType) {
    FileUploadCvType_imageUpload,    // 图片上传
    FileUploadCvType_videoUpload,    // 视频上传
    FileUploadCvType_imageUploadBind,// 图片上传绑定
    FileUploadCvType_videoUploadBind,// 视频上传绑定
    
    FileUploadCvType_imageDisplay,   // 图片浏览
    FileUploadCvType_videoDisplay,   // 视频浏览
    
    FileUploadCvType_imageSelect,    // 图片浏览选择
    FileUploadCvType_videoSelect,    // 视频浏览选择
};

typedef NS_OPTIONS(NSUInteger, FileUploadVideoCompressType) {
    FileUploadVideoCompressTypeNone   = 1 << 0, // 不压缩
    FileUploadVideoCompressTypeFFMpeg = 1 << 1, // FFMpeg
    FileUploadVideoCompressTypeSystem = 1 << 2, // 系统压缩
};

typedef NS_ENUM(int, FileUploadAddType) {
    FileUploadAddTypeNone,           // 没有新增图片的功能
    FileUploadAddTypeOrder,          // 顺序增加
    FileUploadAddTypeReplace,        // 替换模式
};

#endif /* FileUploadPrefix_h */

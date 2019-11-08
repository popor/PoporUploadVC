//
//  PUVideoTool.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

// 这个文件夹会生成大量的视频压缩临时文件,需要自定义页面清除!!!
static NSString * VideoCompressCacheFolder = @"VideoCompressCache";

@interface PUVideoTool : NSObject

// 系统方法压缩视频
// ios8+
+ (void)systemCompressVideoPHAsset:(PHAsset *)myAsset finishBlock:(void(^)(NSString * saveUrl))finishBlock;
// ios7 压缩视频
+ (void)systemCompressVideoURL:(NSURL *)path finishBlock:(void(^)(NSString * saveUrl))finishBlock;

/// 获取视频的首帧缩略图
+ (UIImage *)imageWithVideoURL:(NSURL *)url;

+ (CGFloat)fileSize:(NSURL *)path;

+ (NSString *)videoCompressCacheFolderPath;
+ (NSString *)videoCompressPath_time;


//作者：键盘上的演绎者
//链接：https://www.jianshu.com/p/f136c6d991ca
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

@end

NS_ASSUME_NONNULL_END


//
//  PoporUploadTool.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import "PoporUploadTool.h"
#import <PoporUI/IToastKeyboard.h>

@implementation PoporUploadTool

- (void)updateProgressBlock:(PoporUploadProgressBlock)puProgressBlock {
    // !!!: 以后禁止做自己销毁的动作,自己只做自己该做的东西,不然其他调用者会出现异常.
    self.puProgressBlock = puProgressBlock;
    if (self.uploadTool) {
        self.uploadTool.progressBlock = puProgressBlock;
    }
}

- (void)updateFinishBlock:(PoporUploadFinishBlock _Nullable)puFinishBlock {
    // !!!: 以后禁止做自己销毁的动作,自己只做自己该做的东西,不然其他调用者会出现异常.
    __weak typeof(self) weakSelf = self;
    self.puFinishBlock = ^(BOOL isSuccess, BOOL isCancle, NSString * _Nullable fileUrl, NSString * _Nullable requestId) {
        if (puFinishBlock) {
            puFinishBlock(isSuccess, isCancle, fileUrl, requestId);
        }
        if (isSuccess) {
            // !!!: 上传成功的回调增加额外功能,假如既有image又有imageData,那么清空imageData,减少内存压力.
            if (weakSelf.image && weakSelf.imageData) {
                weakSelf.imageData = nil;
            }
            
            // !!!: 以后禁止做自己销毁的动作,自己只做自己该做的东西,不然其他调用者会出现异常.
            // 错误的: 延迟0.1秒后销毁aliBCBlock,防止同一个UIImageView上传多次,生成的图片名字却是一样的.
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //    weakSelf.aliBCBlock = nil;
            //});
        }
    };
    if (self.uploadTool) {
        self.uploadTool.finishBlock = self.puFinishBlock;
    }
}

- (void)startUpload {
    if (!self.uploadTool) {
        NSLog(@"\n❗️❗️❗️未设置: createUploadBlock, 遵循 PoporUploadProtocol 的上传类❗️❗️❗️");
        if (self.puFinishBlock) {
            self.puFinishBlock(NO, NO, nil, nil);
        }
        return;
    }
    
    NSData * data;
    NSString * videoPath;
    CGFloat compress = self.compressionNumber ? self.compressionNumber.floatValue:PoporUploadImageCompressionQuality;
    BOOL isImage;
    if (self.imageData || self.imageFileURL) {
        // 1.2.优先使用,
        NSData * originData;
        if (self.imageData) {
            originData = self.imageData;
        }else{
            if ([self.imageFileURL hasPrefix:@"file://"]) {
                originData = [NSData dataWithContentsOfFile:[self.imageFileURL substringFromIndex:7]];
            }else{
                originData = [NSData dataWithContentsOfFile:self.imageFileURL];
            }
        }
        //NSData * originData = self.imageData ? self.imageData:[NSData dataWithContentsOfFile:self.imageFileURL];
        NSLog(@"原图: %lu", (unsigned long)originData.length);
        if (self.originFile.boolValue) {
            data = originData;
        }else{
            // 有image并且originData大于512KB,才考虑压缩
            if(self.image && originData.length/1024 > 512){
                data = UIImageJPEGRepresentation(self.image, compress);
                float scale = originData.length / (float)data.length;
                NSLog(@"压缩: %lu, 原图: %lu, 压缩率: %.02fKB", (unsigned long)data.length, (unsigned long)originData.length, scale);
                // 压缩率小于1.3的话,使用原图.
                if(scale < 1.3){
                    data = originData;
                }
            }else{
                data = originData;
            }
        }
        isImage = YES;
    }else if (self.image) {
        // 3.最后使用 self.image
        if (self.originFile.boolValue) {
            data = UIImageJPEGRepresentation(self.image, 1);
        }else{
            data = UIImageJPEGRepresentation(self.image, compress);
        }
        NSLog(@"压缩图片: %.02fKB", data.length/1024.0);

        isImage = YES;
    }else if (self.videoFileURL) {
        data      = nil;
        videoPath = self.videoFileURL;
        isImage   = NO;
    }else if (self.videoData) {
        data      = self.videoData;
        videoPath = nil;
        isImage = NO;
    }else{
        AlertToastTitle(@"上传文件为空");
        return;
    }
    if (isImage) {
        [self.uploadTool uploadImageData:data fileName:self.uploadFileName progress:self.puProgressBlock finish:self.puFinishBlock];
    }else{
        if (videoPath) {
            [self.uploadTool uploadVideoPath:videoPath fileName:self.uploadFileName progress:self.puProgressBlock finish:self.puFinishBlock];
        }else{
            [self.uploadTool uploadVideoData:data fileName:self.uploadFileName progress:self.puProgressBlock finish:self.puFinishBlock];
        }
        
    }
}

- (void)cancleUpload {
    if (self.uploadTool) {
        [self.uploadTool cancleUpload];
    }
}

@end

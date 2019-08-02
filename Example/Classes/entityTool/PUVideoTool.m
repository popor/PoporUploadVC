//
//  VideoServer.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import "PUVideoTool.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <PoporFoundation/NSDate+Tool.h>

#import "NSFileManager+Tool.h"

@implementation PUVideoTool

//压缩视频
+ (void)systemCompressVideoURL:(NSURL *)originVideoPath finishBlock:(void(^)(NSString * saveUrl))finishBlock {
    AVURLAsset *avAsset        = [[AVURLAsset alloc] initWithURL:originVideoPath options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSString * saveUrl         = [PUVideoTool videoCompressPath_time];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [NSURL URLWithString:saveUrl];//设置压缩后视频流导出的路径
        exportSession.shouldOptimizeForNetworkUse = true;
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        //异步导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                //NSLog(@"视频压缩成功,压缩后大小 %f MB",[VideoServer fileSize:[self compressedURL]]);
                //压缩成功视频流回调回去
                if (finishBlock) {
                    if ([NSFileManager isFileExist:saveUrl]) {
                        finishBlock(saveUrl);
                    }
                }
            }else{
                //压缩失败的回调
                if (finishBlock) {
                    finishBlock(nil);
                }
            }
        }];
    }
}

+ (void)systemCompressVideoPHAsset:(PHAsset *)myAsset finishBlock:(void(^)(NSString * saveUrl))finishBlock {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    [[PHImageManager defaultManager] requestAVAssetForVideo:myAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        NSURL *fileRUL = [asset valueForKey:@"URL"];
        [PUVideoTool systemCompressVideoURL:fileRUL finishBlock:finishBlock];
    }];
}

#pragma mark 计算视频大小
+ (CGFloat)fileSize:(NSURL *)path {
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

/**
 *  通过视频的URL，获得视频缩略图
 *  @param url 视频URL
 *  @return首帧缩略图
 */
#pragma mark 获取视频的首帧缩略图
+ (UIImage *)imageWithVideoURL:(NSURL *)url {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    // 根据asset构造一张图
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    // 设定缩略图的方向
    // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的（自己的理解）
    generator.appliesPreferredTrackTransform = YES;
    // 设置图片的最大size(分辨率)
    generator.maximumSize = CGSizeMake(600, 450);
    NSError *error = nil;
    // 根据时间，获得第N帧的图片
    // CMTimeMake(a, b)可以理解为获得第a/b秒的frame
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10000) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    return image;
}

+ (NSString *)videoCompressCacheFolderPath {
    NSArray * pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * tempPath        = [[NSMutableString alloc] initWithString:[pathsToDocuments objectAtIndex:0]];
    NSString * folderPath      = [tempPath stringByReplacingOccurrencesOfString:@"/Documents" withString:@"/Library/Caches"];
    [NSFileManager createCachesFolder:VideoCompressCacheFolder];
    
    return [NSString stringWithFormat:@"%@/%@", folderPath, VideoCompressCacheFolder];
}

+ (NSString *)videoCompressPath_time {
    NSString * time = [NSDate stringFromNow:@"yyyy-MM-dd_HH:mm:ss"];
    return [NSString stringWithFormat:@"%@/%@.mp4", [PUVideoTool videoCompressCacheFolderPath], time];
}



//作者：键盘上的演绎者
//链接：https://www.jianshu.com/p/f136c6d991ca
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

@end

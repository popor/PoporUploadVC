//
//  PoporUploadServiceConfig.m
//  PoporUploadVC_Example
//
//  Created by apple on 2019/8/9.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporUploadServiceConfig.h"

@implementation PoporUploadServiceConfig
@synthesize progressBlock;
@synthesize finishBlock;

+ (void)setPushareCommonBlock {
    PUShare * pushare = [PUShare share];
    
    pushare.createUploadServiceBlock = ^id<PoporUploadServiceProtocol>{
        return [PoporUploadServiceConfig new];
    };
    pushare.createImageThumbUrlBlock = ^NSString * _Nullable (NSString * url, CGSize ccSize){
        return [NSString stringWithFormat:@"%@?width=%i&height=%i", url, (int)ccSize.width, (int)ccSize.height];
    };
    pushare.videoPlayExtraSetBlock = ^void(UINavigationController * nc, UIViewController * vc){
        //vc.hiddenNcBar = YES;
    };
    
    pushare.audioPlayExtraSetBlock = ^void(UINavigationController * nc, UIViewController * vc){
        //vc.hiddenNcBar = YES;
    };
    //pushare.videoPlayBlock = ^void (NSDictionary * dic){};
    
}

- (void)uploadVideoData:(NSData *)data fileName:(NSString *)fileName progress:(PoporUpload_ProgressBlock)progressBlock finish:(PoporUpload_FinishBlock)finishBlock {
    if (finishBlock) {
        finishBlock(NO, NO, nil, nil);
    }
}

- (void)uploadVideoPath:(NSString *)path fileName:(NSString *)fileName progress:(PoporUpload_ProgressBlock)progressBlock finish:(PoporUpload_FinishBlock)finishBlock {
    if (finishBlock) {
        finishBlock(NO, NO, nil, nil);
    }
}

#pragma mark - 普通文件
- (void)uploadImageData:(NSData *)data fileName:(NSString *)fileName   progress:(PoporUpload_ProgressBlock)progressBlock finish:(PoporUpload_FinishBlock)finishBlock {
        if (finishBlock) {
            finishBlock(NO, NO, nil, nil);
        }
}

- (void)cancleUpload {
    
    
}

@end

//
//  PHAsset+data.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (data)

+ (void)getImageFromPHAsset:(PHAsset *)asset finish:(void (^)(NSData *data))block;

@end

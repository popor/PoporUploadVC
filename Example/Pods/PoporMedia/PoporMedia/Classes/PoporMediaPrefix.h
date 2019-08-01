//
//  PoporMediaPrefix.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#ifndef PoporMediaPrefix_h
#define PoporMediaPrefix_h

#import <UIKit/UIKit.h>
#import "PoporMediaImageBundle.h"

#import <ReactiveObjC/ReactiveObjC.h>

@class PoporImagePickerVC;
@class TZImagePickerController;

typedef void(^PoporImagePickerCameraBlock)(PoporImagePickerVC * vc, CGRect availableRect);
typedef void(^PoporImagePickerAlbumBlock)(TZImagePickerController * vc);

#endif /* PoporMediaPrefix_h */

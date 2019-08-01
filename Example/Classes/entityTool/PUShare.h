//
//  PoporUploadShare.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PoporUploadVCProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PUShare : NSObject

+ (instancetype)share;

@property (nonatomic, strong) NSString * image_Add;
@property (nonatomic, strong) UIColor  * image_Add_bgColor;
@property (nonatomic, strong) NSString * image_SelectN;
@property (nonatomic, strong) NSString * image_SelectS;
@property (nonatomic, strong) NSString * image_Resume;
@property (nonatomic        ) float    fileUploadCcIvCorner;
@property (nonatomic        ) UIColor  * fileUploadCcIvBorderColor;
@property (nonatomic        ) float    fileUploadCcIvBorderWidth;

@property (nonatomic        ) CGFloat fileUploadCcBtXGap;
@property (nonatomic        ) CGFloat fileUploadCcBtYGap;
@property (nonatomic        ) CGFloat fileUploadCcIvXGap;
@property (nonatomic        ) CGFloat fileUploadCcIvYGap;
@property (nonatomic, getter=isShowCcBG) BOOL showCcBG;// 显示bg颜色

@end

NS_ASSUME_NONNULL_END

//
//  PoporUploadShare.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 因为UICollectionViewCell 的复用机制不好用
@interface PUShare : NSObject

+ (instancetype)share;

@property (nonatomic, strong) UIColor  * image_Add_bgColor;

@property (nonatomic, strong) UIImage * image_Add;
@property (nonatomic, strong) UIImage * image_SelectN;
@property (nonatomic, strong) UIImage * image_SelectS;
@property (nonatomic, strong) UIImage * image_Resume;

@property (nonatomic        ) float    ccIvCorner;
@property (nonatomic        ) UIColor  * ccIvBorderColor;
@property (nonatomic        ) float    ccIvBorderWidth;

@property (nonatomic        ) CGFloat ccBtXGap;
@property (nonatomic        ) CGFloat ccBtYGap;
@property (nonatomic        ) CGFloat ccIvXGap;
@property (nonatomic        ) CGFloat ccIvYGap;
@property (nonatomic, getter=isShowCcBG) BOOL showCcBG;// 显示bg颜色

// 获取本framework图片
+ (UIImage *)imageBundleNamed:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END

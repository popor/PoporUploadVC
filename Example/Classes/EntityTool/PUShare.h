//
//  PoporUploadShare.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoporUploadVCPrefix.h"
#import "PoporUploadEntity.h"

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

// 以下设置一些公共的block,比如图片缩略图block等
// 自定义视频播放block
@property (nonatomic, copy  ) BlockPDic                       videoPlayBlock;

// 自定义视频播放额外设置block, 比如隐藏系统默认导航栏,这个必须设置,不然和我的相冲突
@property (nonatomic, copy  ) PoporUpload_PNcVc               videoPlayExtraSetBlock;

// 获取生成上传tool的block
@property (nonatomic, copy  ) PoporUpload_RUploadServicePVoid createUploadServiceBlock;

// 获取图片缩略图的block, 根据不同的图床平台,请设置对应的缩略图url,供ccIV使用
@property (nonatomic, copy  ) PoporUpload_RStringPStringSize  createIvThumbUrlBlock;


@end

NS_ASSUME_NONNULL_END

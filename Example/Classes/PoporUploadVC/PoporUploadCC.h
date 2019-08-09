//
//  PoporUploadCC.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PoporUploadCCProtocol.h"
#import "PoporUploadVCPrefix.h"
#import "UIView+PoporUpload.h"

@class PoporUploadVC;

NS_ASSUME_NONNULL_BEGIN

static NSString * PoporUploadCCAddKey    = @"PoporUploadCCIdAdd";
static NSString * PoporUploadCCNormalKey = @"PoporUploadCCIdNormal";

@class PoporUploadEntity;

@interface PoporUploadCC : UICollectionViewCell <PoporUploadCCProtocol>

@property (nonatomic, getter=isInit) BOOL init;
@property (nonatomic        ) PoporUploadCCFunType funType;
@property (nonatomic, strong) NSIndexPath * indexPath;

// 用于继承
- (void)addViews;

// 设定了 funType 和 uiType 之后,需要运行
- (void)layoutSubviewsCustom;

@end

NS_ASSUME_NONNULL_END


//
//  FileUploadCC.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PoporUploadVCPrefix.h"
#import "UIView+PoporUpload.h"

@class PoporUploadVC;

NS_ASSUME_NONNULL_BEGIN

static NSString * FileUploadCCAddKey    = @"FileUploadCCIdAdd";
static NSString * FileUploadCCNormalKey = @"FileUploadCCIdNormal";

@class PoporUploadEntity;

@interface PoporUploadCC : UICollectionViewCell

@property (nonatomic, getter=isInit) BOOL init;
@property (nonatomic        ) FileUploadCCFunType funType;

@property (nonatomic, strong) UIImageView * imageIV;
@property (nonatomic, strong) UIButton    * selectBT; // selectBT 最小点击范围是30*30.
@property (nonatomic, strong) UILabel     * tagL;

@property (nonatomic, weak  ) PoporUploadEntity * uploadEntity;
@property (nonatomic, strong) NSIndexPath * indexPath;

// 用于继承
- (void)addViews;

// 设定了 funType 和 uiType 之后,需要运行
- (void)layoutSubviewsCustom;

@end

NS_ASSUME_NONNULL_END


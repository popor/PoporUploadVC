//
//  BurstShotImagePickerVC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKFCamera/LLSimpleCamera.h>
#import "PoporMediaPrefix.h"

typedef void(^PoporImagePickerFinishBlock) (NSArray * array);

@interface PoporImagePickerVC : UIViewController

@property (nonatomic, strong) LLSimpleCamera   *camera;
@property (strong, nonatomic) UILabel          *errorLabel;
@property (strong, nonatomic) UIButton         *snapButton;
@property (strong, nonatomic) UIButton         *switchButton;
@property (strong, nonatomic) UIButton         *flashButton;
@property (strong, nonatomic) UIButton         *backButton;

@property (nonatomic, strong) UIButton         *completeBT;

@property (nonatomic, strong) NSMutableArray   *imageArray;// 针对连拍图片数组
@property (nonatomic        ) int              maxNum;
@property (nonatomic, strong) UICollectionView *previewCV;
@property (nonatomic        ) CGSize           ccSize;

@property (nonatomic, getter=isSingleOrigin) BOOL             singleOrigin;//单拍照片是否使用原图

@property (nonatomic, copy  ) PoporImagePickerCameraBlock appearBlock;

// 大于1张的话,不开启编辑图片功能.
- (id)initWithMaxNum:(int)maxNum singleOrigin:(BOOL)singleOrigin finishBlock:(PoporImagePickerFinishBlock)block;

@end

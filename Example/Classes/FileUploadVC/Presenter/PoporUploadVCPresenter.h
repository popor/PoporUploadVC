//
//  FileUploadVCPresenter.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PoporUploadVCProtocol.h"
#import "PoporUploadVcCellPresent.h"
#import "PoporUploadVcShowPresent.h"

// 处理和View事件
@interface PoporUploadVCPresenter : NSObject <FileUploadVCEventHandler, FileUploadVCDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) PoporUploadVcCellPresent * cellPresent;
@property (nonatomic, strong) PoporUploadVcShowPresent * showPresent;

// 初始化数据处理
- (void)setMyInteractor:(id)interactor;

// 很多操作,需要在设置了view之后才可以执行.
- (void)setMyView:(id)view;

// !!!:  图片选择部分: 顺序增加
- (void)showImageACAdd;

// !!!:  图片选择部分: 指定替换
- (void)showImageACReplaceIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 视频选择部分
- (void)showVideoAC;

- (PoporUploadEntity *)getCellEntityAt:(NSIndexPath *)indexPath;

@end

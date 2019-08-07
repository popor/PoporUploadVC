//
//  PoporUploadVCPresenter.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PoporUploadVCProtocol.h"
#import "PoporUploadVcCellPresent.h"
#import "PoporUploadVcShowPresent.h"

// 处理和View事件
@interface PoporUploadVCPresenter : NSObject <PoporUploadVCEventHandler, PoporUploadVCDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) PoporUploadVcCellPresent * cellPresent;
@property (nonatomic, strong) PoporUploadVcShowPresent * showPresent;

- (void)setMyInteractor:(id)interactor;

- (void)setMyView:(id)view;

// 开始执行事件,比如获取网络数据
- (void)startEvent;

// !!!:  图片选择部分: 顺序增加
- (void)showImageACAdd;

// !!!:  图片选择部分: 指定替换
- (void)showImageACReplaceIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 视频选择部分
- (void)showVideoAC;

- (PoporUploadEntity *)getCellEntityAt:(NSIndexPath *)indexPath;

@end

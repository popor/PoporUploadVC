//
//  FileUploadVcCellPresent.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoporUploadVCProtocol.h"
#import "PoporUploadCC.h"
#import "PoporUploadEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoporUploadVcCellPresent : NSObject

- (void)setMyView:(id<PoporUploadVCProtocol>)view;
- (void)setMyPresent:(id)present;

// 图片上传
- (void)freshImageUploadCell:(PoporUploadCC *)cell needBind:(BOOL)needBind;

- (void)setImageUploadSelectCell:(PoporUploadCC *)cell;

// 视频上传绑定
- (void)freshVideoCell:(PoporUploadCC *)cell needBind:(BOOL)needBind;

- (void)setVideoUploadSelectCell:(PoporUploadCC *)cell;

// cell 选择按钮事件: 只针对选择模式
- (void)freshImageVideoSelectCell:(PoporUploadCC *)cell;

// !!!: 刷新上传时对应的cell图片
- (void)freshCellIvImage:(PoporUploadCC *)cell;

- (void)showFileNameEvent:(PoporUploadCC *)cc;

- (NSString *)imageIconUrlEntity:(PoporUploadEntity *)entity;

- (NSInteger)arrayOrderAt:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

//
//  PoporUploadVcCellPresent.h
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

#pragma mark 上传图片
- (void)freshImageBlockEntity:(PoporUploadEntity *)entity needBind:(BOOL)needBind;
- (void)freshImageSelectEntity:(PoporUploadEntity *)entity;

#pragma mark 上传视频
- (void)freshVideoBlockEntity:(PoporUploadEntity *)entity needBind:(BOOL)needBind;
- (void)freshVideoSelectEntity:(PoporUploadEntity *)entity;
- (void)uploadVideo:(PoporUploadEntity *)entity;

#pragma mark 选择图片视频
- (void)freshImageVideoSelectEntity:(PoporUploadEntity *)entity;

// !!!: 刷新上传时对应的cell图片
- (void)freshCellIvImageEntity:(PoporUploadEntity *)entity;

- (void)showFileNameEventEntity:(PoporUploadEntity *)entity;

- (NSString *)imageIconUrlEntity:(PoporUploadEntity *)entity;

- (NSInteger)arrayOrderAt:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

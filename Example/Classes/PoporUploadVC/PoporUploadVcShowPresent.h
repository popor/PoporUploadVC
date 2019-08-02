//
//  PoporUploadVCProtocol.h
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

@interface PoporUploadVcShowPresent : NSObject

- (void)setMyView:(id<PoporUploadVCProtocol>)view;
- (void)setMyPresent:(id)present;

- (void)showImageBrowerVCIndexPath:(NSIndexPath *)indexPath all:(BOOL)all;

- (void)showVideoPlayVC:(PoporUploadCC *)cc;

@end

NS_ASSUME_NONNULL_END

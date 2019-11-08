//
//  PoporUploadCCProtocol.h
//  PoporUploadVC
//
//  Created by apple on 2019/8/9.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PoporUploadEntity.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PoporUploadCCProtocol <NSObject>

@property (nonatomic, strong) UIImageView * imageIV;
@property (nonatomic, strong) UIButton    * selectBT; // selectBT 最小点击范围是30*30.
@property (nonatomic, strong) UILabel     * tagL;
@property (nonatomic, weak  ) PoporUploadEntity * uploadEntity;


@end

NS_ASSUME_NONNULL_END

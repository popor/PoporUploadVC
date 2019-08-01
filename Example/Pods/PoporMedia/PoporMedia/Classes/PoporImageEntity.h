//
//  PoporImageEntity.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <PoporImageBrower/PoporImageBrower.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoporImageEntity : PoporImageBrowerEntity

@property (nonatomic, getter=isIgnore) BOOL ignore;  // 是否忽略,用于NSObject+PickImage

@end

NS_ASSUME_NONNULL_END

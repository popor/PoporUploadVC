//
//  BurstShotImagePreviewCC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoporImageEntity.h"
#import "PoporMediaPrefix.h"

@interface PoporImagePreviewCC : UICollectionViewCell

@property (nonatomic, strong) UIImageView * iconIV;
@property (nonatomic, strong) UIButton    * selectBT;
@property (nonatomic, weak  ) PoporImageEntity * weakEntity;

- (void)setImageEntity:(PoporImageEntity *)entity;

@end

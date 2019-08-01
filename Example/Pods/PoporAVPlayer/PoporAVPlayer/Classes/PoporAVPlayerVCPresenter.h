//
//  PoporAVPlayerVCPresenter.h
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "PoporAVPlayerVCProtocol.h"

// 处理和View事件
@interface PoporAVPlayerVCPresenter : NSObject <PoporAVPlayerVCEventHandler, PoporAVPlayerVCDataSource>

- (void)setMyView:(id)view;
- (void)initInteractors;

@end

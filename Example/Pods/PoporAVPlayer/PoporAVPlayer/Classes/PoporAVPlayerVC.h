//
//  PoporAVPlayerVC.h
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.

#import <UIKit/UIKit.h>
#import "PoporAVPlayerVCProtocol.h"

@interface PoporAVPlayerVC : UIViewController <PoporAVPlayerVCProtocol>

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

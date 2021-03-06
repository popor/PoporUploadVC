//
//  PoporUploadVC.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.

#import <UIKit/UIKit.h>
#import "PoporUploadVCProtocol.h"
/*
 这个类的缺点就是block用的太多,复杂度跟delegate差不多.
 一些dic设置请查看PoporUploadVCProtocol
 //*/

@interface PoporUploadVC : UIViewController <PoporUploadVCProtocol>

- (id)initWithDic:(NSDictionary *)dic;

- (void)addViews;

// 开始执行事件,比如获取网络数据
- (void)startEvent;


@end

//
//  UIView+PoporUpload.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PoporFoundation/PrefixBlock.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PoporUpload)

@property (nonatomic, strong) UIView                  * puGrayView;
@property (nonatomic, strong) UILabel                 * puInfoL;
@property (nonatomic, strong) UIActivityIndicatorView * puUploadAIV;
@property (nonatomic, strong) NSString                * puTapGRMessage;

@property (nonatomic, strong, nullable) UITapGestureRecognizer  * puTapGR;
@property (nonatomic, copy  , nullable) BlockPVoid              puTapGRBlock;
@property (nonatomic, strong, nullable) UIImageView             * puErrorIV;

- (void)puAddUploadStatusViews;

// 不知道 具体值只有状态
- (void)puUpdating;
- (void)puUpdateProgress:(CGFloat)progress;

- (void)puAddErrorIVAsyn:(BOOL)asyn;

- (void)puAddTapGRActionMessage:(NSString * _Nullable)message asyn:(BOOL)asyn block:(UIImageViewTapGRBlock)block;

- (void)puRemoveError_puTapGRActionAsyn:(BOOL)asyn;

@end

NS_ASSUME_NONNULL_END

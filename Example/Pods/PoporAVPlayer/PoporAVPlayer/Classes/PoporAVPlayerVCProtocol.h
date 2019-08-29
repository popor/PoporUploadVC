//
//  PoporAVPlayerVCProtocol.h
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

#import "PoporAVPlayerTimeIndicatorView.h"
#import "PoporAVPlayerPrifix.h"

#import "PoporAVPlayerlayer.h"
#import <PoporOrientation/PoporOrientation.h>
#import <PoporFoundation/PrefixBlock.h>


// 对外接口
@protocol PoporAVPlayerVCProtocol <NSObject>

- (UIViewController *)vc;
- (void)preDealloc;

@property (nonatomic, strong) AVPlayer * avPlayer;
@property (nonatomic, strong) PoporAVPlayerlayer * PoporAVPlayerlayer;

// UI
@property (nonatomic, strong) UIView         * topBar;
@property (nonatomic, strong) UIButton       * backButton;/// 返回按钮
@property (nonatomic, strong) UILabel        * titleLabel;/// 标题

@property (nonatomic, strong) UIView         * bottomBar;
@property (nonatomic, strong) UIButton       * playButton;
@property (nonatomic, strong) UISlider       * progressSlider;
@property (nonatomic, strong) UIProgressView * bufferProgressView;/// 缓冲进度条
@property (nonatomic, strong) UILabel        * timeLabel;
@property (nonatomic, strong) UIButton       * rotateButton; // 视频旋转按钮
@property (nonatomic, strong) UIButton       * lockRotateBT;

@property (nonatomic, strong) NSURL          * videoURL;
@property (nonatomic        ) NSInteger      startTick;// 开始播放视频的时间

@property (nonatomic, strong) PoporAVPlayerTimeIndicatorView *timeIndicatorView;/// 快进、快退指示器

// vc 关闭的block,假如没有设置则把状态栏颜色设置为app之前的颜色
@property (nonatomic, copy  ) BlockPVoid    deallocBlock;
@property (nonatomic        ) UIStatusBarStyle appStatusBarStyle;

// vc 打开的block,假如没有设置则把状态栏颜色设置为白色
@property (nonatomic, copy  ) BlockPVoid    viewDidLoadBlock;

@property (nonatomic, copy  ) BlockPVoid    willAppearBlock;
@property (nonatomic, copy  ) BlockPVoid    willDisappearBlock;
@property (nonatomic        ) BOOL          showLockRotateBT;// 是否显示锁定按钮

@end


// 数据来源
@protocol PoporAVPlayerVCDataSource <NSObject>

#pragma mark - 设置播放进度时间为0
- (void)setDefaultProgressTime;

// app 前后台切换
- (void)applicationWillResignActive:(NSNotification *)notification;
- (void)applicationDidBecomeActive:(NSNotification *)notification;

// 移除KVO
- (void)removeKVO;

@end


// UI事件
@protocol PoporAVPlayerVCEventHandler <NSObject>
//- (void)didTouchLoginButton;

- (void)handleSingleTapGesture:(UITapGestureRecognizer *)recognizer;
- (void)setupVideoPlaybackForURL:(NSURL*)url;
- (void)playButtonTouched:(id)sender;

- (void)beginScrub:(UISlider *)sender;
- (void)scrubbing:(UISlider *)sender;
- (void)endScrub:(UISlider *)sender;
- (void)backButtonClick;
- (void)rotateAction:(UIButton *)sender;
- (void)lockRotateAction:(UIButton *)sender;

@end

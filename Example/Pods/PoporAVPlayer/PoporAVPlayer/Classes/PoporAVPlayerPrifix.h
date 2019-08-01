//
//  ZBPlayerPrifix.h
//  AppStore
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

static const CGFloat GLVideoControlBarHeight             = 20.0 + 44.0;
//static const CGFloat GLVideoControlAnimationTimeInterval = 0.3;
static const CGFloat GLVideoControlTimeLabelFontSize     = 14.0;
//static const CGFloat GLVideoControlBarAutoFadeOutTimeInterval = 5.0;

#define GLVideoPlayerOriginalWidth  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define GLVideoPlayerOriginalHeight (GLVideoPlayerOriginalWidth * (9.0 / 16.0))


#define ONE_FRAME_DURATION 0.033
#define HIDE_CONTROL_DELAY 3.0
#define DEFAULT_VIEW_ALPHA 1.0

//
//  PoporAVPlayerTimeIndicatorView.h
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PoporAVPlayerTimeIndicatorPlayState) {
    AVPlayerTimeIndicatorRewind,      // rewind
    AVPlayerTimeIndicatorFastForward, // fast forward
};

static const CGFloat GLVideoTimeIndicatorViewSide = 96;

@interface PoporAVPlayerTimeIndicatorView : UIView

@property (nonatomic, strong, readwrite) NSString *labelText;
@property (nonatomic, assign, readwrite) PoporAVPlayerTimeIndicatorPlayState playState;

@end

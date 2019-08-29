//
//  PoporAVPlayerTimeIndicatorView.m
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporAVPlayerTimeIndicatorView.h"

#import "PoporAVPlayerBundle.h"

static const CGFloat ZBViewSpacing                          = 15.0;
static const CGFloat ZBTimeIndicatorAutoFadeOutTimeInterval = 1.0;

@interface PoporAVPlayerTimeIndicatorView ()

@property (nonatomic, strong, readwrite) UIImageView *arrowImageView;
@property (nonatomic, strong, readwrite) UILabel     *timeLabel;

@end

@implementation PoporAVPlayerTimeIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden              = YES;
        self.layer.cornerRadius  = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor     = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        [self createTimeIndicator];
    }
    return self;
}

- (void)setLabelText:(NSString *)labelText {
    self.hidden = NO;
    self.timeLabel.text = labelText;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:ZBTimeIndicatorAutoFadeOutTimeInterval];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.playState == AVPlayerTimeIndicatorRewind) {
        [self.arrowImageView setImage:[PoporAVPlayerBundle imageBundleNamed:@"rewind"]];
    } else {
        [self.arrowImageView setImage:[PoporAVPlayerBundle imageBundleNamed:@"fastForward"]];
    }
}

- (void)createTimeIndicator {
    CGFloat margin = (GLVideoTimeIndicatorViewSide - 24 - 12 - ZBViewSpacing) / 2;
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((GLVideoTimeIndicatorViewSide - 44) / 2, margin, 44, 24)];
    [self addSubview:_arrowImageView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, margin + 24 + ZBViewSpacing, GLVideoTimeIndicatorViewSide, 12)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];
}

- (void)animateHide {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
        self.superview.accessibilityIdentifier = nil;
    }];
}

@end

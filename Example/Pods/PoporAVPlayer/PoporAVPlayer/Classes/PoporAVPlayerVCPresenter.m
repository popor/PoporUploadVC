//
//  PoporAVPlayerVCPresenter.m
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.

#import "PoporAVPlayerVCPresenter.h"
#import "PoporAVPlayerVCInteractor.h"

#import <KVOController/KVOController.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import <PoporUI/IToastKeyboard.h>

static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;

NSString * const kTracksKey      = @"tracks";
NSString * const kPlayableKey    = @"playable";

//NSString * const kRateKey        = @"rate";
//NSString * const kCurrentItemKey = @"currentItem";
NSString * const kStatusKey      = @"status";

@interface PoporAVPlayerVCPresenter ()

@property (nonatomic, weak  ) id<PoporAVPlayerVCProtocol> view;
@property (nonatomic, strong) PoporAVPlayerVCInteractor * interactor;

@property (strong, nonatomic) AVPlayerItem            *playerItem;
@property (strong, nonatomic) id                      timeObserver;
@property (assign, nonatomic) CGFloat                 mRestoreAfterScrubbingRate;
@property (assign, nonatomic) BOOL                    seekToZeroBeforePlay; // 假如需要重新播放,或者播放下一级的话

@property (nonatomic, strong) FBKVOController        * fbKVO;

@end

@implementation PoporAVPlayerVCPresenter

- (id)init {
    if (self = [super init]) {
        [self initInteractors];
        
    }
    return self;
}

- (void)setMyView:(id<PoporAVPlayerVCProtocol>)view {
    self.view = view;
}

- (void)initInteractors {
    if (!self.interactor) {
        self.interactor = [PoporAVPlayerVCInteractor new];
        
    }
}

#pragma mark - VC_DataSource

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self pauseVideoEvent];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self playVideoEvent];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer *)recognizer {
    if(self.view.topBar.hidden){
        [self showControlsEvent];
    }else{
        [self hideControlsFast];
    }
}

// 移除KVO
- (void)removeKVO {
    if (self.playerItem) {
        [self.fbKVO unobserve:self.playerItem keyPath:kStatusKey];
    }
}
// 强制显示3秒以上
- (void)showControlsEvent {
    [self scheduleHideControls];
    [self showControlsFast];
}

- (void)scheduleHideControls {
    if(!self.view.topBar.hidden) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hideControlsFast) withObject:nil afterDelay:HIDE_CONTROL_DELAY];
    }
}

- (void)hideControlsFast {
    self.view.topBar.alpha = DEFAULT_VIEW_ALPHA;
    self.view.bottomBar.alpha = DEFAULT_VIEW_ALPHA;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.topBar.alpha    = 0.0f;
        self.view.bottomBar.alpha = 0.0f;
    } completion:^(BOOL finished){
        if(finished){
            self.view.topBar.hidden   = YES;
            self.view.bottomBar.alpha = 0.0f;
        }
    }];
}

- (void)showControlsFast {
    self.view.topBar.alpha = 0.0;
    self.view.topBar.hidden = NO;
    
    self.view.bottomBar.alpha = 0.0;
    self.view.bottomBar.hidden = NO;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.topBar.alpha    = DEFAULT_VIEW_ALPHA;
        self.view.bottomBar.alpha = DEFAULT_VIEW_ALPHA;
    } completion:nil];
}

- (void)enablePlayerButtons {
    self.view.playButton.enabled = YES;
}

- (void)disablePlayerButtons {
    self.view.playButton.enabled = NO;
}

- (void)setupVideoPlaybackForURL:(NSURL*)url {
    if(!self.fbKVO){
        FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
        self.fbKVO = KVOController;
    }
    NSError *error = nil;
    BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (!success) {
        AlertToastTitle(@"无法播放");
        return;
    }
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    __weak typeof(self) weakSelf = self;
    NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
    
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
        dispatch_async( dispatch_get_main_queue(), ^{
            /* Make sure that the value of each key has loaded successfully. */
            for (NSString *thisKey in requestedKeys) {
                NSError *error = nil;
                AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
                if (keyStatus == AVKeyValueStatusFailed) {
                    [weakSelf assetFailedToPrepareForPlayback:error];
                    return;
                }
            }
            NSError* error = nil;
            AVKeyValueStatus status = [asset statusOfValueForKey:kTracksKey error:&error];
            if (status == AVKeyValueStatusLoaded) {
                if (self.playerItem) {
                    
                    // 移除一个通知
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
                    
                    [self.fbKVO unobserve:self.playerItem keyPath:kStatusKey];
                    self.playerItem = nil;
                }
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                [self.view.avPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
                
                /* When the player item has played to its end time we'll toggle
                 the movie controller Pause button to be the Play button */
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
                
                self.seekToZeroBeforePlay = NO;
                
                @weakify(self);
                [self.fbKVO observe:self.playerItem keyPath:kStatusKey options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                    @strongify(self);
                    AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
                    switch (status) {
                            /* Indicates that the status of the player is not yet known because
                             it has not tried to load new media resources for playback */
                            case AVPlayerStatusUnknown: {
                                [self removePlayerTimeObserver];
                                //[self syncScrubber];
                                [self disableScrubber];
                                [self disablePlayerButtons];
                                break;
                            }
                            case AVPlayerStatusReadyToPlay: {
                                /* Once the AVPlayerItem becomes ready to play, i.e.
                                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                                 its duration can be fetched from the item. */
                                [self initScrubberTimer];
                                [self enableScrubber];
                                [self enablePlayerButtons];
                                break;
                            }
                            case AVPlayerStatusFailed: {
                                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                                [self assetFailedToPrepareForPlayback:playerItem.error];
                                NSLog(@"Error fail : %@", playerItem.error);
                                break;
                            }
                    }
                }];
                //[self.playerItem wm_addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
                {
                    int tick = 0;
                    if (tick > 0) {
                        [self.view.avPlayer seekToTime:CMTimeMakeWithSeconds(tick, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
                        // tick = 0; //scb hidden
                    }
                }
                [self playVideoEvent];
                
            } else {
                NSLog(@"%@ Failed to load the tracks.", weakSelf);
            }
        });
    }];
}

#pragma mark - slider progress management
- (void)initScrubberTimer {
    // 先移除之前的
    [self removePlayerTimeObserver];
    
    double interval = .1f;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        CGFloat width = CGRectGetWidth([self.view.progressSlider bounds]);
        interval = 0.5f * duration / width;
    }
    
    __weak typeof(self) weakSelf = self;
    /* If you pass NULL, the main queue is used. */
    self.timeObserver = [self.view.avPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        [weakSelf syncScrubber:time];
    }];
}

- (CMTime)playerItemDuration {
    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        return ([self.playerItem duration]);
    }
    return (kCMTimeInvalid);
}

- (void)syncScrubber:(CMTime)time {
    __weak typeof (self) weakSelf = self;
    double currentTime = CMTimeGetSeconds(time);
    double duration = CMTimeGetSeconds(self.view.avPlayer.currentItem.duration);
    double cacheTime = [weakSelf availableDuration];
    [weakSelf currentTime:currentTime cacheTime:cacheTime duration:duration];
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.view.avPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

-(void)currentTime:(double)currentTime cacheTime:(double)cacheTime duration:(double)duration {
    [self setTimeLabelValues:currentTime totalTime:duration];
    // 更新播放进度
    if (!isnan(duration)) {
        self.view.progressSlider.maximumValue = ceil(duration);
        self.view.progressSlider.value        = ceil(currentTime);
        // 更新缓冲进度
        self.view.bufferProgressView.progress = cacheTime / duration;
    }
}

/// 更新播放时间显示
- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    // 防止当前视频比total多1秒.
    //    if (currentTime>totalTime) {
    //        currentTime = totalTime;
    //    }
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);
    double secondsRemaining = fmod(totalTime, 60.0);
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    //NSLog(@"播放时间%@/%@",timeElapsedString,timeRmainingString);
    self.view.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
}

/* The user is dragging the movie controller thumb to scrub through the movie. */
- (void)beginScrub:(UISlider *)sender {
    self.mRestoreAfterScrubbingRate = [self.view.avPlayer rate];
    [self.view.avPlayer setRate:0.f];
    
    /* Remove previous timer. */
    [self removePlayerTimeObserver];
}

/* Set the player current time to match the scrubber position. */
- (void)scrubbing:(UISlider *)sender {
    double currentTime = floor(sender.value);
    double totalTime   = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (void)endScrub:(UISlider *)sender {
    if (!self.timeObserver) {
        //self.seekTime = floor(slider.value);
        [self.view.avPlayer seekToTime:CMTimeMakeWithSeconds(floor(sender.value), NSEC_PER_SEC)];
        //[self seekToTime:floor(sender.value)];
        [self playVideoEvent];
    }
    
    if (self.mRestoreAfterScrubbingRate) {
        [self.view.avPlayer setRate:self.mRestoreAfterScrubbingRate];
        self.mRestoreAfterScrubbingRate = 0.f;
    }
}

-(double)duration{
    if(self.view.avPlayer.currentItem){
        CMTime durationTime = self.view.avPlayer.currentItem.duration;
        return CMTimeGetSeconds(durationTime);
    }
    return 0;
}

- (BOOL)isScrubbing {
    return self.mRestoreAfterScrubbingRate != 0.f;
}

- (void)enableScrubber {
    self.view.progressSlider.enabled = YES;
}

- (void)disableScrubber {
    self.view.progressSlider.enabled = NO;
}

- (void)assetFailedToPrepareForPlayback:(NSError *)error {
    [self removePlayerTimeObserver];
    //[self syncScrubber];
    [self disableScrubber];
    [self disablePlayerButtons];
    
    //    AlertToastTitle([error localizedFailureReason]);
}

- (BOOL)isPlaying {
    return self.mRestoreAfterScrubbingRate != 0.f || [self.view.avPlayer rate] != 0.f;
}

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    /* After the movie has played to its end time, seek back to time zero
     to play it again. */
    self.seekToZeroBeforePlay = YES;
    [self showControlsFast];
    //int currentVideoTick = self.view.progressSlider.maximumValue;
    
    // wkq 暂停当前,播放下一个
    //[self.view pauseVideoEvent];
}

/* Cancels the previously registered time observer. */
- (void)removePlayerTimeObserver {
    if (self.timeObserver) {
        [self.view.avPlayer removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

#pragma mark - VC_EventHandler
- (void)configurePlayButton{
    [self disablePlayerButtons];
}

- (void)playButtonTouched:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if ([self isPlaying]) {
        [self pauseVideoEvent];
    } else {
        [self playVideoEvent];
    }
}

- (void)playVideoEvent {
    if (![self isPlaying]) {
        [self play];
    }
    self.view.playButton.selected = YES;
    [self initScrubberTimer];
}

- (void)pauseVideoEvent {
    if ([self isPlaying]) {
        [self pause];
    }
    self.view.playButton.selected = NO;
    [self removePlayerTimeObserver];
}

- (void)play {
    if ([self isPlaying]){
        return;
    }else{
        /* 假如需要重新播放,或者播放下一级的话 */
        if (self.seekToZeroBeforePlay) {
            self.seekToZeroBeforePlay = NO;
            [self.view.avPlayer seekToTime:kCMTimeZero];
        }
        [self.view.avPlayer play];
        [self scheduleHideControls];
    }
}

- (void)pause {
    if (![self isPlaying]){
        return;
    }else{
        [self.view.avPlayer pause];
        [self scheduleHideControls];
    }
}

// 设置默认的0
- (void)setDefaultProgressTime {
    [self.view.avPlayer setRate:0];
    [self.view.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self pauseVideoEvent];
    
    [self showControlsEvent];
    [self setTimeLabelValues:0 totalTime:0];
    self.view.progressSlider.value = 0;
}

// MARK: 屏幕旋转
- (void)rotateAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        __weak typeof(self) weakSelf = self;
        //        [PoporOrientation enableAutoFinish:^(UIDeviceOrientation orientation) {
        //            if (weakSelf) {
        //                if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        //                    weakSelf.view.vc.navigationController.interactivePopGestureRecognizer.enabled = NO;
        //                }else{
        //                    weakSelf.view.vc.navigationController.interactivePopGestureRecognizer.enabled = YES;
        //                }
        //            }
        //        }];
        [PoporOrientation enablePriorityLeftFinish:^(UIDeviceOrientation orientation) {
            if (weakSelf) {
                if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
                    weakSelf.view.vc.navigationController.interactivePopGestureRecognizer.enabled = NO;
                }else{
                    weakSelf.view.vc.navigationController.interactivePopGestureRecognizer.enabled = YES;
                }
            }
        }];
    }else{
        [PoporOrientation disable];
    }
}

- (void)backButtonClick {
    if (self.view.rotateButton.isSelected) {
        [self rotateAction:self.view.rotateButton];
    }else{
        if (self.view.vc.navigationController) {
            [self.view.vc.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view.vc dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)lockRotateAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [PoporOrientation share].lock = sender.isSelected;
}

#pragma mark - Interactor_EventHandler

@end

//
//  PoporAVPlayerVC.m
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.

#import "PoporAVPlayerVC.h"
#import "PoporAVPlayerVCPresenter.h"
#import "PoporAVPlayerVCInteractor.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import <PoporUI/UIView+pExtension.h>
#import <PoporFoundation/NSAssistant.h>

#import "PoporAVPlayerBundle.h"

static int GLViewIndex0     = 0;
static int GLControllIndex1 = 1;


@interface PoporAVPlayerVC ()

@property (nonatomic, strong) PoporAVPlayerVCPresenter * present;

@end

@implementation PoporAVPlayerVC
@synthesize avPlayer;
@synthesize PoporAVPlayerlayer;

@synthesize topBar;
@synthesize bottomBar;

@synthesize playButton;
@synthesize progressSlider;
@synthesize backButton;/// 返回按钮
@synthesize timeLabel;
@synthesize titleLabel;/// 标题
@synthesize bufferProgressView;/// 缓冲进度条

@synthesize videoURL;
@synthesize startTick;// 开始播放视频的时间

@synthesize rotateButton;
@synthesize timeIndicatorView;

@synthesize deallocBlock, appStatusBarStyle, viewDidLoadBlock;

@synthesize willAppearBlock;
@synthesize willDisappearBlock;
@synthesize lockRotateBT;
@synthesize showLockRotateBT;

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [NSAssistant setVC:self dic:dic];
    }
    return self;
}

- (void)dealloc {
    [self preDealloc];
    //NSLog(@"PoporAVPlayerVC dealloc, work well.");
}

- (void)preDealloc {
    [self.present removeKVO];
    if (self.deallocBlock) {
        self.deallocBlock();
    } else {
        [UIApplication sharedApplication].statusBarStyle = self.appStatusBarStyle;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.willAppearBlock) {
        self.willAppearBlock();
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self addNC:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.willDisappearBlock) {
        self.willDisappearBlock();
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    [self addNC:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 恢复旋转锁.
    [PoporOrientation share].lock = NO;
}

- (void)viewDidLoad {
    [self assembleViper];
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"播放器";
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)assembleViper {
    if (!self.present) {
        PoporAVPlayerVCPresenter * present = [PoporAVPlayerVCPresenter new];
        PoporAVPlayerVCInteractor * interactor = [PoporAVPlayerVCInteractor new];
        
        self.present = present;
        [present setMyInteractor:interactor];
        [present setMyView:self];
        
        [self addViews];
        [self startEvent];
    }
}

#pragma mark - views
- (void)addViews {
    if (!self.avPlayer) {
        self.avPlayer = [[AVPlayer alloc] init];
        
    }
    if (!self.PoporAVPlayerlayer) {
        self.PoporAVPlayerlayer = [[PoporAVPlayerlayer alloc] init];
        self.PoporAVPlayerlayer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.view insertSubview:self.PoporAVPlayerlayer atIndex:GLViewIndex0];
        AVPlayerLayer * layer = (AVPlayerLayer *)self.PoporAVPlayerlayer.layer;
        [layer setPlayer:self.avPlayer];
    }
    [self addTopBottomBarViews];
    [self addTopBottomBarTargetAction];
    [self addGR];
    [self masLayoutSubviews];
    
    if (self.viewDidLoadBlock) {
        self.viewDidLoadBlock();
    } else {
        self.appStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
    [self.present setDefaultProgressTime];
    [self.present setupVideoPlaybackForURL:self.videoURL];
}

- (void)addGR {
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.present action:@selector(handleSingleTapGesture:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapRecognizer];
}

- (void)addTopBottomBarViews {
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view insertSubview:self.topBar    atIndex:GLControllIndex1];
    [self.view insertSubview:self.bottomBar atIndex:GLControllIndex1];
    
    [self.bottomBar addSubview:self.playButton];
    [self.bottomBar addSubview:self.rotateButton];
    [self.bottomBar addSubview:self.progressSlider];
    [self.bottomBar addSubview:self.timeLabel];
    
    // 返回按钮
    [self.topBar    addSubview:self.backButton];
    // 缓冲进度条
    [self.bottomBar insertSubview:self.bufferProgressView belowSubview:self.progressSlider];
    // 快进、快退指示器
    [self.view      addSubview:self.timeIndicatorView];
    // 标题
    [self.topBar    addSubview:self.titleLabel];
    // 方向锁
    if (self.showLockRotateBT) {
        [self.topBar addSubview:self.lockRotateBT];
    }
}

- (void)addTopBottomBarTargetAction {
    [self.playButton       addTarget:self.present action:@selector(playButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.rotateButton     addTarget:self.present action:@selector(rotateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton       addTarget:self.present action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.showLockRotateBT) {
        [self.lockRotateBT addTarget:self.present action:@selector(lockRotateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.progressSlider addTarget:self.present action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
    [self.progressSlider addTarget:self.present action:@selector(scrubbing:) forControlEvents:UIControlEventValueChanged];
    [self.progressSlider addTarget:self.present action:@selector(endScrub:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self.present action:@selector(endScrub:) forControlEvents:UIControlEventTouchUpOutside];
    [self.progressSlider addTarget:self.present action:@selector(endScrub:) forControlEvents:UIControlEventTouchCancel];
}

- (void)addNC:(BOOL)isAdd {
    if (isAdd) {
        [[NSNotificationCenter defaultCenter] addObserver:self.present selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self.present selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self.present name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self.present name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self.present name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
}

#pragma mark - getter
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (UIView *)topBar {
    if (!topBar) {
        topBar = [UIView new];
        topBar.accessibilityIdentifier = @"TopBar";
        topBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return topBar;
}

- (UIView *)bottomBar {
    if (!bottomBar) {
        bottomBar = [UIView new];
        bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return bottomBar;
}

- (UIButton *)playButton {
    if (!playButton) {
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [playButton setImage:[PoporAVPlayerBundle imageBundleNamed:@"play"] forState:UIControlStateNormal];
        [playButton setImage:[PoporAVPlayerBundle imageBundleNamed:@"pause"] forState:UIControlStateSelected];
        playButton.bounds = CGRectMake(0, 0, GLVideoControlBarHeight, GLVideoControlBarHeight);
    }
    return playButton;
}

- (UIButton *)lockRotateBT {
    if (!lockRotateBT) {
        lockRotateBT = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [lockRotateBT setImage:[PoporAVPlayerBundle imageBundleNamed:@"unlock"] forState:UIControlStateNormal];
        [lockRotateBT setImage:[PoporAVPlayerBundle imageBundleNamed:@"lock"] forState:UIControlStateSelected];
        lockRotateBT.bounds = CGRectMake(0, 0, GLVideoControlBarHeight, GLVideoControlBarHeight);
    }
    return lockRotateBT;
}

- (UIButton *)rotateButton {
    if (!rotateButton) {
        rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rotateButton setImage:[PoporAVPlayerBundle imageBundleNamed:@"fullscreen"] forState:UIControlStateNormal];
        [rotateButton setImage:[PoporAVPlayerBundle imageBundleNamed:@"shrinkscreen"] forState:UIControlStateSelected];
        rotateButton.bounds = CGRectMake(0, 0, GLVideoControlBarHeight, GLVideoControlBarHeight);
    }
    return rotateButton;
}

- (UISlider *)progressSlider {
    if (!progressSlider) {
        progressSlider = [[UISlider alloc] init];
        [progressSlider setThumbImage:[PoporAVPlayerBundle imageBundleNamed:@"point"] forState:UIControlStateNormal];
        [progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [progressSlider setMaximumTrackTintColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.4]];
        progressSlider.value = 0.f;
        progressSlider.continuous = YES;
    }
    return progressSlider;
}

- (UILabel *)timeLabel {
    if (!timeLabel) {
        timeLabel = [UILabel new];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:GLVideoControlTimeLabelFontSize];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.frame = CGRectMake(0, 0, 0, GLVideoControlTimeLabelFontSize+3);
        
        [timeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        timeLabel.numberOfLines =0;
    }
    return timeLabel;
}

- (UIButton *)backButton {
    if (!backButton) {
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GLVideoControlBarHeight , GLVideoControlBarHeight)];
        [backButton setImage:[PoporAVPlayerBundle imageBundleNamed:@"back"] forState:UIControlStateNormal];
        backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        backButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        backButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    }
    return backButton;
}

- (UIProgressView *)bufferProgressView {
    if (!bufferProgressView) {
        bufferProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        bufferProgressView.progressTintColor = [UIColor colorWithWhite:1 alpha:0.3];
        bufferProgressView.trackTintColor = [UIColor clearColor];
    }
    return bufferProgressView;
}

- (PoporAVPlayerTimeIndicatorView *)timeIndicatorView {
    if (!timeIndicatorView) {
        timeIndicatorView = [[PoporAVPlayerTimeIndicatorView alloc] initWithFrame:CGRectMake(0, 0, GLVideoTimeIndicatorViewSide, GLVideoTimeIndicatorViewSide)];
    }
    return timeIndicatorView;
}

- (UILabel *)titleLabel {
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor     = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.title;
        [titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        titleLabel.numberOfLines =0;
    }
    return titleLabel;
}


- (void)masLayoutSubviews {
    __weak typeof(self) weakSelf = self;
    [self.PoporAVPlayerlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    {
        // 上面的
        [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            
            make.height.mas_equalTo(GLVideoControlBarHeight);
        }];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(44);
        }];
        if (self.showLockRotateBT) {
            [self.lockRotateBT mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.left.mas_equalTo(weakSelf.backButton.mas_right);
                make.right.mas_equalTo(0);
                make.centerY.mas_equalTo(weakSelf.backButton.mas_centerY);
                //make.centerX.mas_equalTo(0);
                make.width.mas_equalTo(self.backButton.mas_width);
                make.height.mas_equalTo(self.backButton.mas_height);
            }];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.backButton.mas_right);
                make.right.mas_equalTo(weakSelf.lockRotateBT.mas_left);
                make.centerY.mas_equalTo(weakSelf.backButton.mas_centerY);
                make.centerX.mas_equalTo(0);
                make.height.mas_equalTo(40);
            }];
        }else{
            
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.backButton.mas_right);
                //make.right.mas_equalTo(weakSelf.backButton.mas_right);
                make.centerY.mas_equalTo(weakSelf.backButton.mas_centerY);
                make.centerX.mas_equalTo(0);
                make.height.mas_equalTo(40);
            }];
        }
    }
    {
        // 下面的
        [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(GLVideoControlBarHeight);
        }];
        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(weakSelf.playButton.width);
            make.height.mas_equalTo(weakSelf.playButton.height);
        }];
        [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(weakSelf.rotateButton.width);
            make.height.mas_equalTo(weakSelf.rotateButton.height);
        }];
        [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.playButton.mas_right).mas_offset(5);
            make.right.mas_equalTo(weakSelf.rotateButton.mas_left).mas_offset(5);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(GLVideoControlBarHeight);
        }];
        [self.bufferProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.progressSlider.mas_left);
            make.right.mas_equalTo(weakSelf.progressSlider.mas_right);
            make.centerY.mas_equalTo(weakSelf.progressSlider.mas_centerY).mas_equalTo(1);
            make.height.mas_equalTo(2);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.bufferProgressView.mas_right);
            make.top.mas_equalTo(weakSelf.bufferProgressView.mas_bottom).mas_equalTo(5);
            make.height.mas_equalTo(weakSelf.timeLabel.height);
        }];
    }
}

#pragma mark - VCProtocol
- (UIViewController *)vc {
    return self;
}

- (void)setMyPresent:(id)present {
    self.present = present;
}


@end

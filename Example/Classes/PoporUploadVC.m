//
//  PoporUploadVC.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.

#import "PoporUploadVC.h"
#import "PoporUploadVCPresenter.h"
#import "PoporUploadVCInteractor.h"

#import "PUShare.h"
#import <PoporFoundation/NSAssistant.h>
#import <PoporFoundation/Size+pPrefix.h>
#import <Masonry/Masonry.h>

@interface PoporUploadVC ()
@property (nonatomic, strong) PoporUploadVCPresenter * present;

@end

@implementation PoporUploadVC

@synthesize cvSectionEdgeInsets, ccXGap, ccYGap, lineNumber, ccSize;
@synthesize infoCV;

@synthesize image_Add, image_Add_bgColor;
@synthesize image_SelectN;
@synthesize image_SelectS;
@synthesize image_Resume;
@synthesize ccPlacehlodImage;

@synthesize maxUploadNum;

@synthesize imageAllowSelectBlock;

@synthesize uploadType;
@synthesize infoCvBgColor;
@synthesize compressType;
@synthesize videoUploadMaxSize;

@synthesize weakPuEntityArray;
@synthesize uploadFinishBlock;
@synthesize willAppearBlock, didAppearBlock, viewDidLoadBlock;
@synthesize deallocBlock;
@synthesize ncSelectBlock;
@synthesize ccSelectBlock, ccDeleteBlock;
@synthesize showFileName;
@synthesize showAddCC;
@synthesize showCcSelectBT;
@synthesize addType;

@synthesize ccIvCorner;
@synthesize ccIvBorderColor;
@synthesize ccIvBorderWidth;

@synthesize ccBtXGap;
@synthesize ccBtYGap;
@synthesize ccIvXGap;
@synthesize ccIvYGap;
@synthesize showCcBG;

@synthesize videoPlayBlock;
@synthesize videoPlayExtraSetBlock;
@synthesize audioPlayBlock;
@synthesize audioPlayExtraSetBlock;
@synthesize createUploadServiceBlock;
@synthesize createImageThumbUrlBlock;

@synthesize ffmpegCompressBlock;

- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [NSAssistant setVC:self dic:dic];
        [self updatePUShare];
        
        if (UIEdgeInsetsEqualToEdgeInsets(self.cvSectionEdgeInsets, UIEdgeInsetsZero)) {
            self.cvSectionEdgeInsets = CvSectionDefaultEdgeInsets;
        }
        {
            int colume  = self.lineNumber <= 0 ? 4:self.lineNumber;
            float width =  (PSCREEN_SIZE.width
                            - self.cvSectionEdgeInsets.left
                            - self.cvSectionEdgeInsets.right
                            + self.ccIvXGap
                            - self.ccXGap*(self.lineNumber-1)
                            - 1
                            )/colume;
            self.ccSize = CGSizeMake(width, width);
        }
        switch (self.addType) {
                case PoporUploadAddTypeNone: {
                    self.showAddCC = NO;
                    break;
                }
                case PoporUploadAddTypeOrder: {
                    self.showAddCC = YES;
                    break;
                }
                case PoporUploadAddTypeReplace: {
                    self.showAddCC = NO;
                    break;
                }
        }
    }
    return self;
}

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.willAppearBlock) {
        self.willAppearBlock(self);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.didAppearBlock) {
        self.didAppearBlock(self);
    }
}

- (void)viewDidLoad {
    [self assembleViper];
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"上传";
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)assembleViper {
    if (!self.present) {
        PoporUploadVCPresenter * present = [PoporUploadVCPresenter new];
        PoporUploadVCInteractor * interactor = [PoporUploadVCInteractor new];
        
        self.present = present;
        [present setMyInteractor:interactor];
        [present setMyView:self];
        
        [self addViews];
        [self startEvent];
    }
}

- (void)addViews {
    if (self.uploadType == PoporUploadType_imageSelect ||
        self.uploadType == PoporUploadType_videoSelect ) {
        [self imageVideoSelectType];
    }
    
    [self.present cleanIVSelectStatus];
    
    self.infoCV = [self addCV];
    self.infoCV.allowsMultipleSelection = YES;
    
    if (self.viewDidLoadBlock) {
        self.viewDidLoadBlock(self);
    }
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
}

// -----------------------------------------------------------------------------

- (void)imageVideoSelectType {
    {
        UIBarButtonItem *itemMessagge = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self.present action:@selector(selectFinishAction)];
        self.navigationItem.rightBarButtonItems = @[itemMessagge];
    }
}

- (UICollectionView *)addCV {
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置headerView的尺寸大小
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 20);
    //该方法也可以设置itemSize
    //layout.itemSize =CGSizeMake(110, 150);
    
    //2.初始化collectionView
    UICollectionView * cv = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    if (self.infoCvBgColor) {
        cv.backgroundColor = self.infoCvBgColor;
    }else{
        cv.backgroundColor = PRGB16(0XF9F9F9);
    }
    
    [self.view addSubview:cv];
    //cv.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [cv registerClass:[PoporUploadCC class] forCellWithReuseIdentifier:PoporUploadCCAddKey];
    [cv registerClass:[PoporUploadCC class] forCellWithReuseIdentifier:PoporUploadCCNormalKey];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    //[cv registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    cv.delegate   = self.present;
    cv.dataSource = self.present;
    
    [cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    return cv;
}

#pragma mark - VCProtocol
- (UIViewController *)vc {
    return self;
}

- (void)updatePUShare {
    PUShare * tool = [PUShare share];
    
    self.image_Add         = self.image_Add     ? : [PUShare imageBundleNamed:PoporUploadImage_Add];
    self.image_SelectN     = self.image_SelectN ? : [PUShare imageBundleNamed:PoporUploadImage_SelectN];
    self.image_SelectS     = self.image_SelectS ? : [PUShare imageBundleNamed:PoporUploadImage_SelectS];
    self.image_Resume      = self.image_Resume  ? : [PUShare imageBundleNamed:PoporUploadImage_Resume];
    
    tool.image_Add         = self.image_Add;
    tool.image_SelectN     = self.image_SelectN;
    tool.image_SelectS     = self.image_SelectS;
    tool.image_Resume      = self.image_Resume;
    
    tool.image_Add_bgColor = self.image_Add_bgColor;
    
    tool.ccBtXGap          = self.ccBtXGap;
    tool.ccBtYGap          = self.ccBtYGap;
    tool.ccIvXGap          = self.ccIvXGap;
    tool.ccIvYGap          = self.ccIvYGap;
    
    tool.ccIvCorner        = self.ccIvCorner;
    tool.ccIvBorderColor   = self.ccIvBorderColor;
    tool.ccIvBorderWidth   = self.ccIvBorderWidth;
    
    tool.showCcBG          = self.isShowCcBG;
}

@end

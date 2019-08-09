//
//  PoporUploadVCViewController.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import "PoporUploadVCViewController.h"

#import "PoporUploadVC.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <PoporUI/IToastKeyboard.h>

@interface PoporUploadVCViewController ()

@property (nonatomic, strong) NSMutableArray * imageUploadArray;
@property (nonatomic, strong) NSMutableArray * videoUploadArray;
@end

@implementation PoporUploadVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传";
    
    self.imageUploadArray = [NSMutableArray new];
    self.videoUploadArray = [NSMutableArray new];
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(100, 100, 80, 44);
        [button setTitle:@"图片" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor brownColor]];
        
        // button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        button.clipsToBounds = YES;
        
        [self.view addSubview:button];
        
        [button addTarget:self action:@selector(btImageAction) forControlEvents:UIControlEventTouchUpInside];
        
    };
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(100, 160, 80, 44);
        [button setTitle:@"视频" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor brownColor]];
        
        // button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        button.clipsToBounds = YES;
        
        [self.view addSubview:button];
        
        [button addTarget:self action:@selector(btVideoAction) forControlEvents:UIControlEventTouchUpInside];
        
    };
}

- (void)btImageAction {
    
    PoporUploadAddType addType = PoporUploadAddTypeOrder;
    PoporUploadType uploadType = PoporUploadType_imageUploadBind;
    BOOL showCcSelectBT        = YES;
    
    int ccBtXGap = 0;
    int ccBtYGap = 0;
    int ccIvXGap = 0;
    int ccIvYGap = 0;
    
    if (showCcSelectBT) {
        ccBtXGap = -5;
        ccBtYGap = -5;
        ccIvXGap =  5;
        ccIvYGap =  8;
    }
    
    BlockPVoid deallocBlock = ^(void){
        
    };
    
    BlockPDic uploadFinishBlock = ^(NSDictionary * dic) {
        
    };
    
    PoporUpload_PEntityFinish ccDeleteBlock = ^(PoporUploadEntity * puEntity, BlockPBool finishBlock) {
        
        // 网络删除cc.uploadEntity对应的图片url什么的.
        // 假如是upload模式,只需要删除本地数组就好了,直接返回YES.finishBlock(YES);
        
        // 假如是uploadBind模式,那么需要删除网络请求.
        if (finishBlock) {
            NSLog(@"请设置删除图片对应的URL请求");
            AlertToastTitle(@"请设置删除图片对应的URL请求");
            finishBlock(NO);
        }
    };
    
    NSDictionary * dic =
    @{
      @"weakPuEntityArray": self.imageUploadArray,
      @"title":             @"上传图片",
      
      @"uploadType":        @(uploadType),
      @"addType":           @(addType),
      @"showCcSelectBT":    @(showCcSelectBT),
      @"deallocBlock":      deallocBlock,
      @"uploadFinishBlock": uploadFinishBlock,
      //@"ccSelectBlock":     ccSelectBlock,
      @"ccDeleteBlock":     ccDeleteBlock,
      
      //PoporUploadVC------ Cell UI
      @"ccXGap":  @(8),
      @"ccYGap":  @(8),
      @"ccBtXGap":@(ccBtXGap),
      @"ccBtYGap":@(ccBtYGap),
      @"ccIvXGap":@(ccIvXGap),
      @"ccIvYGap":@(ccIvYGap),
      @"image_SelectN":[PUShare imageBundleNamed:PoporUploadImage_Delete],
      @"image_SelectS":[PUShare imageBundleNamed:PoporUploadImage_Delete],
      @"cvSectionEdgeInsets":[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(16, 16, 16, 16)],
      //@"cvSectionEdgeInsets":UIEdgeInsetsMake(5, 16, 16, 16),
      // ---
      @"lineNumber":           @(3),
      @"ccIvCorner": @(0),
      @"maxUploadNum":         @(0),
      
      //debug
      @"showCcBG": @(NO),
      
      };
    
    [self.navigationController pushViewController:[[PoporUploadVC alloc] initWithDic:dic] animated:YES];
}

- (void)btVideoAction {
    
    PoporUploadAddType addType = PoporUploadAddTypeOrder;
    PoporUploadType uploadType = PoporUploadType_videoUploadBind;
    BOOL showCcSelectBT        = YES;
    
    int ccBtXGap = 0;
    int ccBtYGap = 0;
    int ccIvXGap = 0;
    int ccIvYGap = 0;
    
    if (showCcSelectBT) {
        ccBtXGap = -5;
        ccBtYGap = -5;
        ccIvXGap =  5;
        ccIvYGap =  8;
    }
    
    BlockPVoid deallocBlock = ^(void){
        
    };
    
    BlockPDic uploadFinishBlock = ^(NSDictionary * dic) {
        
    };
    
    PoporUpload_PEntityFinish ccDeleteBlock = ^(PoporUploadEntity * puEntity, BlockPBool finishBlock) {
        
        // 网络删除cc.uploadEntity对应的图片url什么的.
        // 假如是upload模式,只需要删除本地数组就好了,直接返回YES.finishBlock(YES);
        
        // 假如是uploadBind模式,那么需要删除网络请求.
        if (finishBlock) {
            NSLog(@"请设置删除图片对应的URL请求");
            AlertToastTitle(@"请设置删除图片对应的URL请求");
            finishBlock(NO);
        }
    };
    
    NSDictionary * dic =
    @{
      @"weakPuEntityArray": self.videoUploadArray,
      @"title":             @"上传视频",
      
      @"uploadType":        @(uploadType),
      @"addType":           @(addType),
      @"showCcSelectBT":    @(showCcSelectBT),
      
      //PoporUploadVC------ Cell UI
      @"ccXGap":  @(8),
      @"ccYGap":  @(8),
      @"ccBtXGap":@(ccBtXGap),
      @"ccBtYGap":@(ccBtYGap),
      @"ccIvXGap":@(ccIvXGap),
      @"ccIvYGap":@(ccIvYGap),
      @"image_SelectN":[PUShare imageBundleNamed:PoporUploadImage_Delete],
      @"image_SelectS":[PUShare imageBundleNamed:PoporUploadImage_Delete],
      @"cvSectionEdgeInsets":[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(16, 16, 16, 16)],
      
      // ---
      @"lineNumber":   @(3),
      @"ccIvCorner":   @(0),
      @"maxUploadNum": @(0),
      @"compressType": @(PoporUploadVideoCompressTypeNone + PoporUploadVideoCompressTypeSystem),
      
      //block
      @"deallocBlock":      deallocBlock,
      @"uploadFinishBlock": uploadFinishBlock,
      @"ccDeleteBlock":     ccDeleteBlock,
      
      //debug
      @"showCcBG": @(NO),
      
      };
    
    [self.navigationController pushViewController:[[PoporUploadVC alloc] initWithDic:dic] animated:YES];
}

@end

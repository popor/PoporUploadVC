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

@property (nonatomic, strong) NSMutableArray * uploadArray;

@end

@implementation PoporUploadVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传";
    
    self.uploadArray = [NSMutableArray new];
    UIButton * oneBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(100, 100, 80, 44);
        [button setTitle:@"TEST" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor brownColor]];
        
        // button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        button.clipsToBounds = YES;
        
        [self.view addSubview:button];
        
        [button addTarget:self action:@selector(btAction) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
}

- (void)btAction {
    
    FileUploadAddType addType = FileUploadAddTypeOrder;
    FileUploadCvType cvType   = FileUploadCvType_imageUploadBind;
    BOOL showCcSelectBT       = YES;
    
    int fileUploadCcBtXGap = 0;
    int fileUploadCcBtYGap = 0;
    int fileUploadCcIvXGap = 0;
    int fileUploadCcIvYGap = 0;
    
    if (showCcSelectBT) {
        fileUploadCcBtXGap = -5;
        fileUploadCcBtYGap = -5;
        fileUploadCcIvXGap =  5;
        fileUploadCcIvYGap =  8;
    }
    
    BlockPVoid deallocBlock = ^(void){
        
    };
    
    BlockPDic uploadFinishBlock = ^(NSDictionary * dic) {
        
    };
    
    BlockPVcCellFinish ccDeleteBlock = ^(UIViewController * vc, PoporUploadCC * cc, BlockPBool finishBlock) {
        
        // 网络删除cc.uploadEntity对应的图片url什么的.
        // 假如是upload模式,只需要删除本地数组就好了,直接返回YES.finishBlock(YES);
        
        // 假如是uploadBind模式,那么需要删除网络请求.
        if (finishBlock) {
            AlertToastTitle(@"请设置删除图片对应的URL请求");
            finishBlock(NO);
        }
    };
    
    NSDictionary * dic =
    @{
      @"weakImageArray":    self.uploadArray,
      @"title":             @"上传图片",
      
      @"cvType":            @(cvType),
      @"addType":           @(addType),
      @"showCcSelectBT":    @(showCcSelectBT),
      @"deallocBlock":      deallocBlock,
      @"uploadFinishBlock": uploadFinishBlock,
      //@"ccSelectBlock":     ccSelectBlock,
      @"ccDeleteBlock":     ccDeleteBlock,
      
      //FileUploadVC------ Cell UI
      @"fileUploadCcXGap":  @(8),
      @"fileUploadCcYGap":  @(8),
      @"fileUploadCcBtXGap":@(fileUploadCcBtXGap),
      @"fileUploadCcBtYGap":@(fileUploadCcBtYGap),
      @"fileUploadCcIvXGap":@(fileUploadCcIvXGap),
      @"fileUploadCcIvYGap":@(fileUploadCcIvYGap),
      @"image_SelectN":PoporFUImage_Delete,
      @"image_SelectS":PoporFUImage_Delete,
      @"cvSectionEdgeInsets":[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(16, 16, 16, 16)],
      //@"cvSectionEdgeInsets":UIEdgeInsetsMake(5, 16, 16, 16),
      // ---
      @"lineNumber":           @(3),
      @"fileUploadCcIvCorner": @(0),
      @"maxUploadNum":         @(0),
      
      //debug
      @"showCcBG": @(NO),
      
      };
    
    [self.navigationController pushViewController:[[PoporUploadVC alloc] initWithDic:dic] animated:YES];
}

@end

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

#import <Masonry.h>

@interface PoporUploadVCViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * imageUploadArray;
@property (nonatomic, strong) NSMutableArray * videoUploadArray;

@property (nonatomic, strong) UITableView * infoTV;

@end

@implementation PoporUploadVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传";
    
    self.imageUploadArray = [NSMutableArray new];
    self.videoUploadArray = [NSMutableArray new];
    
    self.infoTV = [self addTVs];
}

#pragma mark - UITableView
- (UITableView *)addTVs {
    UITableView * oneTV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    oneTV.delegate   = self;
    oneTV.dataSource = self;
    
    oneTV.allowsMultipleSelectionDuringEditing = YES;
    oneTV.directionalLockEnabled = YES;
    
    oneTV.estimatedRowHeight           = 0;
    oneTV.estimatedSectionHeaderHeight = 0;
    oneTV.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:oneTV];
    
    [oneTV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    return oneTV;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"图片";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", (int)self.imageUploadArray.count];
            break;
        }
        case 1: {
            cell.textLabel.text = @"视频";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", (int)self.videoUploadArray.count];
            break;
        }
        case 2: {
            cell.textLabel.text = @"图片";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", (int)self.imageUploadArray.count];
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            [self btImageAction];
            break;
        }
        case 1: {
            [self btVideoAction];
            break;
        }
        case 2: {
            
            break;
        }
        default:
            break;
    }
}

- (void)btImageAction {
    
    PoporUploadAddType addType = PoporUploadAddTypeOrder;
    PoporUploadType uploadType = PoporUploadType_imageUploadBind;
    BOOL showCcSelectBT        = YES;
    @weakify(self);
    
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
        @strongify(self);
        [self.infoTV reloadData];
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
    @weakify(self);
    
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
        @strongify(self);
        [self.infoTV reloadData];
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

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
#import <PoporUI/IToastPTool.h>
#import "PoporUploadServiceConfig.h"

#import <PoporMedia/PoporMedia.h>

#import <Masonry.h>

@interface PoporUploadVCViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * imageUploadArray;
@property (nonatomic, strong) NSMutableArray * videoUploadArray;

@property (nonatomic, strong) UIImageView    * iconIV;
@property (nonatomic, strong) PoporUploadEntity * iconPUE;

@property (nonatomic, weak  ) PUShare * puShare;

@property (nonatomic, strong) PoporMedia * poporMedia;

@property (nonatomic, strong) UITableView * infoTV;

@end

@implementation PoporUploadVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传";
    
    // 设置公共block等
    [PoporUploadServiceConfig setPushareCommonBlock];
    
    self.puShare = [PUShare share];
    
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 2: {
            return 80;
        }
        default:
            break;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * CellID = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    switch (indexPath.row) {
        case 0: {
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"图片 UICollectionView";
            }
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", (int)self.imageUploadArray.count];
            break;
        }
        case 1: {
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"视频 UICollectionView";
            }
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", (int)self.videoUploadArray.count];
            break;
        }
        case 2: {
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
                cell.textLabel.text = @"图片 UITableViewCell 上";
                cell.detailTextLabel.text = nil;
                
                self.iconIV = ({
                    UIImageView * iv = [UIImageView new];
                    iv.backgroundColor    = [UIColor lightGrayColor];
                    iv.layer.cornerRadius = 5;
                    iv.clipsToBounds      = YES;
                    iv.contentMode        = UIViewContentModeScaleAspectFill;
                    
                    [cell.contentView addSubview:iv];
                    iv;
                });
                [self.iconIV puAddUploadStatusViews];
                
                [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(5);
                    make.bottom.mas_equalTo(-5);
                    make.right.mas_equalTo(-16);
                    
                    make.width.mas_equalTo(self.iconIV.mas_height);
                }];
            }
            
            break;
        }
        case 3: {
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
            }
            cell.textLabel.text = nil;
            cell.detailTextLabel.text = nil;
            break;
        }
        default: {
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
            }
            break;
        }
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
            [self showSelectIconIVAction];
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
      @"compressType": @(PoporUploadVideoCompressTypeNone + PoporUploadVideoCompressTypeSystem + PoporUploadVideoCompressTypeNoMov),
      
      //block
      @"deallocBlock":      deallocBlock,
      @"uploadFinishBlock": uploadFinishBlock,
      @"ccDeleteBlock":     ccDeleteBlock,
      
      //debug
      @"showCcBG": @(NO),
      
      };
    
    [self.navigationController pushViewController:[[PoporUploadVC alloc] initWithDic:dic] animated:YES];
}

- (void)showSelectIconIVAction {
    
    @weakify(self);
    self.poporMedia = [PoporMedia new];
    [self.poporMedia showImageACTitle:@"选取照片" message:nil vc:self maxCount:1 origin:NO actions:nil finish:^(NSArray *images, NSArray *assets, BOOL origin) {
        @strongify(self);
        
        if (images.count>0) {
            self.iconIV.image = images.firstObject;
            if (!self.iconPUE) {
                self.iconPUE = [PoporUploadEntity new];
            }
            PoporUploadEntity * ue = self.iconPUE;
            ue.bindOK = NO;
            
            ue.imageUploadTool = [PoporUploadTool new];
            ue.imageUploadTool.uploadService = [PoporUploadServiceConfig new];
            ue.imageUploadStatus             = PoporUploadStatusInit;
            ue.imageUploadTool.image         = images.firstObject;
            ue.weakUploadProgressView        = self.iconIV;
            
            [self uploadImageView:ue];
        }
    }];
}

- (void)uploadImageView:(PoporUploadEntity *)entity {
    
    @weakify(entity);
    
    [entity.imageUploadTool updateProgressBlock:^(CGFloat progress) {
        @strongify(entity);
        [entity.weakUploadProgressView puUpdateProgress:progress];
        //NSLog(@"progress: %f", progress);
    }];
    
    [entity.imageUploadTool updateFinishBlock:^(BOOL isSuccess, BOOL isCancle, NSString *fileUrl, NSString *requestId) {
        @strongify(entity);
        //
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [entity.weakUploadProgressView puUpdateProgress:1.0];
        });
        NSLog(@"updateFinishBlock : %i, targetUrl: %@", isSuccess, fileUrl);
        if (isSuccess) {
            entity.imageUploadStatus = PoporUploadStatusFinish;
            entity.imageUrl          = fileUrl;
            [entity.weakUploadProgressView puRemoveError_puTapGRActionAsyn:YES];
            
        }else{
            AlertToastTitle(@"上传图片失败");
            entity.imageUploadStatus = PoporUploadStatusFailed;
            [entity.weakUploadProgressView puAddTapGRActionMessage:nil asyn:YES tapBlock:^{
                entity.imageUploadStatus = PoporUploadStatusUploading;
                [entity.imageUploadTool startUpload];
                [entity.weakUploadProgressView puUpdateProgress:0.01];
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                entity.weakUploadProgressView.puErrorIV.center
                = CGPointMake(entity.weakUploadProgressView.frame.size.width/2, entity.weakUploadProgressView.frame.size.height/2);
            });
        }
    }];
    entity.imageUploadStatus = PoporUploadStatusUploading;
    [entity.imageUploadTool startUpload];
    
}

@end

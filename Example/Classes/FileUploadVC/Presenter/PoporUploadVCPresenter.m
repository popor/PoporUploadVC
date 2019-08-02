//
//  FileUploadVCPresenter.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.

#import "PoporUploadVCPresenter.h"
#import "PoporUploadVCInteractor.h"
#import "PoporUploadVCProtocol.h"

#import "PoporUploadCC.h"
#import "PoporUploadEntity.h"

#import <PoporMedia/PoporMedia.h>
#import <PoporImageBrower/PoporImageBrower.h>
#import <UIImageView+WebCache.h>

#import <AVFoundation/AVFoundation.h>

#import "PUVideoTool.h"
#import <PoporFoundation/NSFileManager+Tool.h>
#import <PoporFoundation/PrefixFun.h>

#import <Photos/Photos.h>
#import <DMProgressHUD.h>

#if __has_include(<PoporFFmpegCompress/PoporFFmpegCompress.h>)
#define HasFFmpeg YES
#import <PoporFFmpegCompress/PoporFFmpegCompress.h>

#else
#define HasFFmpeg NO
#endif

//#import "UIImageView+UploadABCBlock.h"
#import <PoporUI/IToastKeyboard.h>

@interface PoporUploadVCPresenter ()

@property (nonatomic, weak  ) id<PoporUploadVCProtocol> view;
@property (nonatomic, strong) PoporUploadVCInteractor * interactor;

@property (nonatomic, strong) PoporMedia * media;

#ifndef HasFFmpeg
@property (nonatomic, strong) PoporFFmpegCompress * ffmpegCmd;

#endif

@end

@implementation PoporUploadVCPresenter

- (id)init {
    if (self = [super init]) {
        _cellPresent = [PoporUploadVcCellPresent new];
        _showPresent = [PoporUploadVcShowPresent new];
    }
    return self;
}

// 初始化数据处理
- (void)setMyInteractor:(PoporUploadVCInteractor *)interactor {
    self.interactor = interactor;
    
}

// 很多操作,需要在设置了view之后才可以执行.
- (void)setMyView:(id<PoporUploadVCProtocol>)view {
    self.view = view;
    [self.cellPresent setMyView:view];
    [self.showPresent setMyView:view];
    
    [self.cellPresent setMyPresent:self];
    [self.showPresent setMyPresent:self];
    
    // 对外接口
}

#pragma mark - VCDataSource
// 页面进来之后头几件事情
- (void)cleanIVSelectStatus {
    for (PoporUploadEntity * entity in self.view.weakImageArray) {
        entity.select = NO;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.ccSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(self.view.cvSectionEdgeInsets.top,
                            self.view.cvSectionEdgeInsets.left,
                            self.view.cvSectionEdgeInsets.bottom,
                            self.view.cvSectionEdgeInsets.right - self.view.fileUploadCcIvXGap);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.view.fileUploadCcYGap;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.view.fileUploadCcXGap;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.view.isShowAddCC) {
        return self.view.weakImageArray.count + 1;
    }else{
        return self.view.weakImageArray.count;
    }
}

// !!!: 设置 CC
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PoporUploadCC *cell;
    // !!!: 这个只显示➕cell
    if (self.view.isShowAddCC && indexPath.row == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:FileUploadCCAddKey forIndexPath:indexPath];
        
        if (!cell.imageIV.image) {
            cell.imageIV.image = [UIImage imageNamed:self.view.image_Add];
            cell.imageIV.contentMode = UIViewContentModeCenter;
            if (self.view.image_Add_bgColor) {
                cell.imageIV.backgroundColor = self.view.image_Add_bgColor;
            }else{
                cell.imageIV.backgroundColor = [UIColor whiteColor];
            }
            cell.selectBT.hidden = YES;
            
            cell.funType = FileUploadCCFunTypeAdd;
            [cell.imageIV puUpdateProgress:1];
        }
        return cell;
    }
    // !!!: 正常cell
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:FileUploadCCNormalKey forIndexPath:indexPath];
    if (!cell.isInit) {
        cell.init = YES;
        cell.funType         = FileUploadCCFunTypeNormal;
        cell.selectBT.hidden = !self.view.isShowCcSelectBT;
    }
    [cell.imageIV puUpdateProgress:1];
    [cell.imageIV puRemoveError_puTapGRActionAsyn:NO];
    
    PoporUploadEntity * entity = [self getCellEntityAt:indexPath];
    cell.uploadEntity = entity;
    cell.indexPath              = indexPath;
    
    [self.cellPresent freshCellIvImage:cell];
    
    switch(self.view.cvType) {
        case FileUploadCvType_imageUpload: {
            [self.cellPresent freshImageUploadCell:cell needBind:NO];
            [self.cellPresent setImageUploadSelectCell:cell];
            break;
        }
        case FileUploadCvType_videoUpload: {
            [self.cellPresent freshVideoCell:cell needBind:NO];
            [self.cellPresent setVideoUploadSelectCell:cell];
            break;
        }
        case FileUploadCvType_imageUploadBind: {
            [self.cellPresent freshImageUploadCell:cell needBind:YES];
            [self.cellPresent setImageUploadSelectCell:cell];
            break;
        }
        case FileUploadCvType_videoUploadBind: {
            [self.cellPresent freshVideoCell:cell needBind:YES];
            break;
        }
        case FileUploadCvType_imageDisplay:
        case FileUploadCvType_videoDisplay: {
            
            break;
        }
        case FileUploadCvType_imageSelect:
        case FileUploadCvType_videoSelect: {
            [self.cellPresent freshImageVideoSelectCell:cell];
            break;
        }
    }
    
    [self.cellPresent showFileNameEvent:cell];
    return cell;
}

// MARK: cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PoporUploadCC * cc = (PoporUploadCC *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cc.funType == FileUploadCCFunTypeAdd) {
        // 增加模式
        if (self.view.cvType == FileUploadCvType_imageUpload ||
            self.view.cvType == FileUploadCvType_imageUploadBind) {
            [self showImageACAdd];
        }else if (self.view.cvType == FileUploadCvType_videoUpload ||
                  self.view.cvType == FileUploadCvType_videoUploadBind) {
            [self showVideoAC];
        }else{
            AlertToastTitle(@"模式设定出错");
        }
    }else{
        // 查看详情模式
        switch (self.view.cvType) {
            case FileUploadCvType_imageDisplay :
            case FileUploadCvType_imageUpload :
            case FileUploadCvType_imageUploadBind :{
                if (self.view.addType == FileUploadAddTypeReplace) {
                    PoporUploadEntity * entity = [self getCellEntityAt:indexPath];
                    if (entity.ivUrl) {
                        // 查看单张图片
                        [self.showPresent showImageBrowerVCIndexPath:indexPath all:NO];
                    }else{
                        // 上传图片
                        [self showImageACReplaceIndexPath:indexPath];
                    }
                }else{
                    // 查看全部
                    [self.showPresent showImageBrowerVCIndexPath:indexPath all:YES];
                }
                break;
            }
            case FileUploadCvType_videoDisplay:
            case FileUploadCvType_videoUpload:
            case FileUploadCvType_videoUploadBind:
            case FileUploadCvType_videoSelect: {
                [self.showPresent showVideoPlayVC:cc];
                break;
            }
            case FileUploadCvType_imageSelect:{
                [self.showPresent showImageBrowerVCIndexPath:indexPath all:YES];
                break;
            }
        }
    }
}

// !!!:  图片选择部分: 顺序增加
- (void)showImageACAdd {
    @weakify(self);
    NSInteger maxCount = 20;
    if (self.view.maxUploadNum > 0) {
        maxCount = self.view.maxUploadNum - self.view.weakImageArray.count;
        if (maxCount <= 0) {
            NSString * info = [NSString stringWithFormat:@"已经超过最大上传个数: %li", maxCount];
            AlertToastTitle(info);
            return;
        }
    }
    self.media = [PoporMedia new];
    [self.media showImageACTitle:@"新增照片" message:nil vc:self.view.vc maxCount:(int)maxCount origin:YES finish:^(NSArray *images, NSArray *assets, BOOL origin) {
        @strongify(self);
        
        if (assets) {
            // 可以使用原图上传的情况
            for (int i = 0; i<images.count; i++) {
                PoporUploadEntity * entity = [PoporUploadEntity new];
                [self assembleImagePoporUploadEntity:entity image:images[i] PHAsset:assets[i] origin:origin];
                
                [self.view.weakImageArray addObject:entity];
            }
        }else{
            for (UIImage * image in images) {
                PoporUploadEntity * entity = [PoporUploadEntity new];
                [self assembleImagePoporUploadEntity:entity image:image];
                [self.view.weakImageArray addObject:entity];
            }
        }
        
        [self.view.infoCV reloadData];
    }];
}

// !!!:  图片选择部分: 指定替换
- (void)showImageACReplaceIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self);
    self.media = [PoporMedia new];
    [self.media showImageACTitle:@"新增照片" message:nil vc:self.view.vc maxCount:1 origin:YES finish:^(NSArray *images, NSArray *assets, BOOL origin) {
        @strongify(self);
        
        if (assets) {
            // 可以使用原图上传的情况
            for (int i = 0; i<images.count; ) {
                PoporUploadEntity * entity = [self getCellEntityAt:indexPath];
                [self assembleImagePoporUploadEntity:entity image:images[i] PHAsset:assets[i] origin:origin];
                break;
            }
        }else{
            for (UIImage * image in images) {
                PoporUploadEntity * entity = [self getCellEntityAt:indexPath];
                [self assembleImagePoporUploadEntity:entity image:image];
                break;
            }
        }
        
        [self.view.infoCV reloadItemsAtIndexPaths:@[indexPath]];
    }];
}

- (void)assembleImagePoporUploadEntity:(PoporUploadEntity *)entity image:(UIImage *)image PHAsset:(PHAsset *)asset origin:(BOOL)origin {
    
    entity.uploadFinishBlock = self.view.uploadFinishBlock;
    
    entity.ivUploadTool = [PoporUploadTool new];
    if (self.view.createUploadBlock) {
        entity.ivUploadTool.uploadTool = self.view.createUploadBlock();
    }
    entity.ivUploadTool.image = image;
    entity.ivUploadTool.originFile = @(origin);
    
    [PHAsset getImageFromPHAsset:asset finish:^(NSData *data) {
        entity.ivUploadTool.imageData  = data;
    }];
    entity.ivUploadStatus = PoporUploadStatusInit;
    
}

- (void)assembleImagePoporUploadEntity:(PoporUploadEntity *)entity image:(UIImage *)image {
    entity.uploadFinishBlock = self.view.uploadFinishBlock;
    
    entity.ivUploadStatus = PoporUploadStatusInit;
    
    entity.ivUploadTool = [PoporUploadTool new];
    entity.ivUploadTool.image    = image;
    if (self.view.createUploadBlock) {
        entity.ivUploadTool.uploadTool = self.view.createUploadBlock();
    }
}

#pragma mark - 视频选择部分
- (void)showVideoAC {
    if (self.view.maxUploadNum > 0) {
        NSInteger maxCount = self.view.maxUploadNum - self.view.weakImageArray.count;
        if (maxCount <= 0) {
            NSString * info = [NSString stringWithFormat:@"已经超过最大上传个数: %li", maxCount];
            AlertToastTitle(info);
            return;
        }
    }
    
    @weakify(self);
    
    self.media = [PoporMedia new];
    [self.media showVideoACTitle:@"新增视频" message:nil vc:self.view.vc videoIconSize:self.view.ccSize qualityType:UIImagePickerControllerQualityType640x480 finish:^(NSURL *videoURL, NSString *videoPath, NSData *imageData, UIImage *image, PHAsset *phAsset, CGFloat time, CGFloat videoSize) {
        @strongify(self);
        
        if (!videoPath) {
            return;
        }
        NSLog(@"视频 videoPath: %@, time:%i秒, size:%.02fMB", videoPath, (int)time, videoSize);
        
        PoporUploadEntity * entity = [PoporUploadEntity new];
        entity.hasData = YES;
        entity.uploadFinishBlock = self.view.uploadFinishBlock;
        
        entity.ivUploadTool           = [PoporUploadTool new];
        entity.videoUploadTool        = [PoporUploadTool new];
        if (self.view.createUploadBlock) {
            entity.ivUploadTool.uploadTool    = self.view.createUploadBlock();
            entity.videoUploadTool.uploadTool = self.view.createUploadBlock();
        }
        
        if (imageData) {
            entity.ivUploadTool.image     = [UIImage imageWithData:imageData];
            entity.ivUploadTool.imageData = imageData;
        }else if (image) {
            entity.ivUploadTool.image     = image;
        }
        entity.ivUploadStatus = PoporUploadStatusInit;
        
        @weakify(entity);
        
        [self.view.weakImageArray addObject:entity];
        BOOL isCamera = phAsset ? NO:YES;
        
        [self compressVideoTime:time size:videoSize camera:isCamera Block:^(int number) {
            @strongify(self);
            @strongify(entity);
            
            switch (number) {
                case -1:{
                    // 取消
                    [self.view.weakImageArray removeObject:entity];
                    break;
                }
                case 0:{
#if HasFFmpeg
                    //NSLog(@"开始标准压缩");
                    if (!self.ffmpegCmd) {
                        self.ffmpegCmd = [PoporFFmpegCompress new];
                    }
                    {
                        self.view.vc.navigationController.view.userInteractionEnabled = NO;
                        DMProgressHUD * hud = [DMProgressHUD showLoadingHUDAddedTo:self.view.vc.navigationController.view];
                        //hud.text = @"每分钟大约花费20秒时间\n压缩视频中~";
                        //hud.text = [NSString stringWithFormat:@"大约需需要:%i分，压缩视频中~", MAX(1, (int)(time*0.025))];
                        hud.text = @"压缩视频中~";
                        
                        __weak typeof(hud) weakHud = hud;
                        NSString *resultPath = [VideoServer videoCompressPath_time];
                        [self.ffmpegCmd compressVideoUrl:videoPath size:CGSizeMake(540, 960) tPath:resultPath finish:^(BOOL finished, NSString *info) {
                            [weakHud dismiss];
                            if (finished) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.view.vc.navigationController.view.userInteractionEnabled = YES;
                                    if (IsDebugVersion) {
                                        NSData * data = [NSData dataWithContentsOfFile:resultPath];
                                        NSLog(@"FFMpeg video size : %02fMB", data.length/1024.0f/1024.0f);
                                    }
                                    entity.videoUpload.videoFileURL = resultPath;
                                    [self.view.infoCV reloadData];
                                });
                            }else{
                                AlertToastTitle(info);
                                [self.view.weakImageArray removeObject:entity];
                            }
                        }];
                    }
#else
                    AlertToastTitle(@"未引入FFMpeg");
#endif
                    break;
                }
                case 1:{
                    NSLog(@"开始快速压缩");
                    // sys压缩,快速压缩
                    self.view.vc.navigationController.view.userInteractionEnabled = NO;
                    DMProgressHUD * hud = [DMProgressHUD showLoadingHUDAddedTo:self.view.vc.navigationController.view];
                    hud.text = @"压缩视频中";
                    __weak typeof(hud) weakHud = hud;
                    
                    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
                    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPreset640x480];
                    // AVAssetExportPresetHighestQuality 45s 80M, 60s 100M
                    // AVAssetExportPresetMediumQuality
                    // AVAssetExportPresetHighestQuality
                    // AVAssetExportPreset960x540        45s 30M, 60s 40M
                    // 创建导出的url
                    NSString *resultPath = [PUVideoTool videoCompressPath_time];
                    session.outputURL = [NSURL fileURLWithPath:resultPath];
                    session.outputFileType = AVFileTypeMPEG4;
                    // 导出视频
                    [session exportAsynchronouslyWithCompletionHandler:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.view.vc.navigationController.view.userInteractionEnabled = YES;
                            [weakHud dismiss];
                        });
                        if(session.status==AVAssetExportSessionStatusCompleted) {
                            //NSLog(@"压缩后---%.2fk",[self getFileSize:resultPath]);
                            NSLog(@"视频导出完成");
                            if ([NSFileManager isFileExist:resultPath]) {
                                NSLog(@"视频导出完成 ok");
                                if (IsDebugVersion) {
                                    NSData * data = [NSData dataWithContentsOfFile:resultPath];
                                    NSLog(@"Apple video size : %02fMB", data.length/1024.0f/1024.0f);
                                }
                                entity.videoUploadTool.videoFileURL = resultPath;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.view.infoCV reloadData];
                                });
                            }else{
                                NSLog(@"视频导出完成 error");
                                [self.view.weakImageArray removeObject:entity];
                            }
                        }else{
                            NSLog(@"视频导出完成 error");
                            [self.view.weakImageArray removeObject:entity];
                        }
                    }];
                    
                    break;
                }
                case 2:{
                    // 不压缩
                    entity.videoUploadTool.videoFileURL = videoPath;
                    [self.view.infoCV reloadData];
                    break;
                }
                default:
                    break;
            }
        }];
    }];
}

- (void)compressVideoTime:(int)time size:(CGFloat)size camera:(BOOL)isCamera Block:(BlockPInt)block {
    if (isCamera) {
        if (!self.view.videoFromCamraUseCompress) {
            // 拍摄的视频不需要压缩情形
            block(2);
            return;
        }
    }
    
    {
        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            block(-1);
        }];
        
        float compressFFMpegSize = time*0.15;
        NSString * titleFFMpeg = [NSString stringWithFormat:@"标准压缩(约%.01fM，花费%i秒)", compressFFMpegSize, MAX(1, (int)(time*1.7))];
        if (self.view.videoUploadMaxSize > 0 &&
            compressFFMpegSize >= self.view.videoUploadMaxSize) {
            NSString * info = [NSString stringWithFormat:@"压缩完之后可能容量超过%i兆，无法上传。", self.view.videoUploadMaxSize];
            AlertToastTitleTime(info, 5);
        }
        
        UIAlertAction * ffmpegCompressAction = [UIAlertAction actionWithTitle:titleFFMpeg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(0);
        }];
        // 960*540 的比例分别为0.65和6.5
        // 640*480 的比例分别为0.45和5.0
        UIAlertAction * sysCompressAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"快速压缩(%.01fM，%i秒)", time*0.45, MAX(1, (int)(time/5.0))] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(1);
        }];
        
        //NSString * nonCompressTitle = isCamera ? @"上传视频":@"不压缩";
        NSString * nonCompressTitle = @"不压缩";
        UIAlertAction * nonCompressAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@(%.01fM)", nonCompressTitle, size] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(2);
        }];
        
        [oneAC addAction:cancleAction];
        
        if (self.view.compressType & FileUploadVideoCompressTypeFFMpeg) {
            [oneAC addAction:ffmpegCompressAction];
        }
        if (self.view.compressType & FileUploadVideoCompressTypeSystem) {
            [oneAC addAction:sysCompressAction];
        }
        if (self.view.compressType & FileUploadVideoCompressTypeNone) {
            [oneAC addAction:nonCompressAction];
        }
        
        [self.view.vc presentViewController:oneAC animated:YES completion:nil];
    }
}

#pragma mark - 删除部分
- (void)updateSelectStatusCC:(PoporUploadCC *)cc {
    cc.uploadEntity.select = !cc.uploadEntity.isSelect;
    if (cc.uploadEntity.isSelect) {
        [cc setSelected:YES];
    }else{
        [cc setSelected:NO];
    }
}

- (void)selectFinishAction {
    if (self.view.ncSelectBlock) {
        if (self.view.ncSelectBlock()) {
            [self.view.vc.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.view.vc.navigationController popViewControllerAnimated:YES];
    }
}

- (PoporUploadEntity *)getCellEntityAt:(NSIndexPath *)indexPath {
    return self.view.weakImageArray[[self.cellPresent arrayOrderAt:indexPath]];
}

@end

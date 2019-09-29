//
//  PoporUploadVCPresenter.m
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
#import <SDWebImage/UIImageView+WebCache.h>

#import <AVFoundation/AVFoundation.h>

#import "PUVideoTool.h"
#import <PoporFoundation/NSFileManager+pTool.h>
#import <PoporFoundation/Fun+pPrefix.h>

#import <Photos/Photos.h>
#import <DMProgressHUD/DMProgressHUD.h>

//#if __has_include(<PoporFFmpegCompress/PoporFFmpegCompress.h>)
//#define HasFFmpeg 1
//#import <PoporFFmpegCompress/PoporFFmpegCompress.h>
//
//#else
//#define HasFFmpeg 0
//
//#endif

#import "PUVideoTool.h"
#import <PoporUI/IToastKeyboard.h>

@interface PoporUploadVCPresenter ()

@property (nonatomic, weak  ) id<PoporUploadVCProtocol> view;
@property (nonatomic, strong) PoporUploadVCInteractor * interactor;

@property (nonatomic, strong) PoporMedia * media;

//#if HasFFmpeg == 1
//@property (nonatomic, strong) PoporFFmpegCompress * ffmpegCmd;
//
//#endif

@end

@implementation PoporUploadVCPresenter

- (id)init {
    if (self = [super init]) {
        _cellPresent = [PoporUploadVcCellPresent new];
        _showPresent = [PoporUploadVcShowPresent new];
    }
    return self;
}

- (void)setMyInteractor:(PoporUploadVCInteractor *)interactor {
    self.interactor = interactor;
}

- (void)setMyView:(id<PoporUploadVCProtocol>)view {
    self.view = view;
    [self.cellPresent setMyView:view];
    [self.showPresent setMyView:view];
    
    [self.cellPresent setMyPresent:self];
    [self.showPresent setMyPresent:self];
    
    // 对外接口
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    
    
}

#pragma mark - VCDataSource
// 页面进来之后头几件事情
- (void)cleanIVSelectStatus {
    for (PoporUploadEntity * entity in self.view.weakPuEntityArray) {
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
                            self.view.cvSectionEdgeInsets.right - self.view.ccIvXGap);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.view.ccYGap;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.view.ccXGap;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.view.isShowAddCC) {
        return self.view.weakPuEntityArray.count + 1;
    }else{
        return self.view.weakPuEntityArray.count;
    }
}

// !!!: 设置 CC
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PoporUploadCC *cell;
    // !!!: 这个只显示➕cell
    if (self.view.isShowAddCC && indexPath.row == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:PoporUploadCCAddKey forIndexPath:indexPath];
        
        if (!cell.imageIV.image) {
            cell.imageIV.image = self.view.image_Add;
            cell.imageIV.contentMode = UIViewContentModeCenter;
            if (self.view.image_Add_bgColor) {
                cell.imageIV.backgroundColor = self.view.image_Add_bgColor;
            }else{
                cell.imageIV.backgroundColor = [UIColor whiteColor];
            }
            cell.selectBT.hidden = YES;
            
            cell.funType = PoporUploadCCFunTypeAdd;
            [cell.imageIV puUpdateProgress:1];
        }
        return cell;
    }
    // !!!: 正常cell
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:PoporUploadCCNormalKey forIndexPath:indexPath];
    if (!cell.isInit) {
        cell.init = YES;
        cell.funType         = PoporUploadCCFunTypeNormal;
        cell.selectBT.hidden = !self.view.isShowCcSelectBT;
    }
    [cell.imageIV puUpdateProgress:1];
    [cell.imageIV puRemoveError_puTapGRActionAsyn:NO];
    
    PoporUploadEntity * entity = [self getCellEntityAt:indexPath];
    // cell 属性
    cell.uploadEntity             = entity;
    cell.indexPath                = indexPath;
    // entity 属性
    entity.weakCV                 = collectionView;
    entity.weakCC                 = cell;
    entity.weakPuEntityArray      = self.view.weakPuEntityArray;
    entity.weakUploadProgressView = cell.imageIV;
    entity.indexPath              = indexPath;
    entity.uploadType             = self.view.uploadType;
    entity.addType                = self.view.addType;
    
    [self.cellPresent freshCellIvImageEntity:entity];
    
    switch(self.view.uploadType) {
        case PoporUploadType_imageUpload: {
            [self.cellPresent freshImageBlockEntity:entity needBind:NO];
            [self.cellPresent freshImageSelectEntity:entity];
            break;
        }
        case PoporUploadType_imageUploadBind: {
            [self.cellPresent freshImageBlockEntity:entity needBind:YES];
            [self.cellPresent freshImageSelectEntity:entity];
            break;
        }
        case PoporUploadType_videoUpload: {
            [self.cellPresent freshVideoBlockEntity:entity needBind:NO];
            [self.cellPresent freshVideoSelectEntity:entity];
            break;
        }
        case PoporUploadType_videoUploadBind: {
            [self.cellPresent freshVideoBlockEntity:entity needBind:YES];
            [self.cellPresent freshVideoSelectEntity:entity];
            break;
        }
        case PoporUploadType_imageDisplay:
        case PoporUploadType_videoDisplay:
        case PoporUploadType_audioDisplay: {
            
            break;
        }
        case PoporUploadType_imageSelect:
        case PoporUploadType_videoSelect: {
            [self.cellPresent freshImageVideoSelectEntity:entity];
            break;
        }
    }
    
    [self.cellPresent showFileNameEventEntity:entity];
    return cell;
}

// MARK: cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PoporUploadCC * cc = (PoporUploadCC *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cc.funType == PoporUploadCCFunTypeAdd) {
        // 增加模式
        if (self.view.uploadType == PoporUploadType_imageUpload ||
            self.view.uploadType == PoporUploadType_imageUploadBind) {
            [self showImageACAdd];
        }else if (self.view.uploadType == PoporUploadType_videoUpload ||
                  self.view.uploadType == PoporUploadType_videoUploadBind) {
            [self showVideoAC];
        }else{
            AlertToastTitle(@"模式设定出错");
        }
    }else{
        // 查看详情模式
        PoporUploadEntity * entity = [self getCellEntityAt:indexPath];
        switch (self.view.uploadType) {
            case PoporUploadType_imageDisplay :
            case PoporUploadType_imageUpload :
            case PoporUploadType_imageUploadBind : {
                if (self.view.addType == PoporUploadAddTypeReplace) {
                    if (entity.imageUrl) {
                        // 查看单张图片
                        [self.showPresent showImageBrowerVCEntity:entity all:NO];
                    }else{
                        // 上传图片
                        [self showImageACReplaceIndexPath:indexPath];
                    }
                }else{
                    // 查看全部
                    [self.showPresent showImageBrowerVCEntity:entity all:YES];
                }
                break;
            }
            case PoporUploadType_videoDisplay:
            case PoporUploadType_videoUpload:
            case PoporUploadType_videoUploadBind:
            case PoporUploadType_videoSelect: {
                [self.showPresent showVideoPlayEntity:entity];
                break;
            }
            case PoporUploadType_audioDisplay: {
                [self.showPresent showAudioPlayEntity:entity array:self.view.weakPuEntityArray];
                break;
            }
            case PoporUploadType_imageSelect:{
                [self.showPresent showImageBrowerVCEntity:entity all:YES];
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
        maxCount = self.view.maxUploadNum - self.view.weakPuEntityArray.count;
        if (maxCount <= 0) {
            NSString * info = @"已经超过最大上传个数";
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
                
                [self.view.weakPuEntityArray addObject:entity];
            }
        }else{
            for (UIImage * image in images) {
                PoporUploadEntity * entity = [PoporUploadEntity new];
                [self assembleImagePoporUploadEntity:entity image:image];
                [self.view.weakPuEntityArray addObject:entity];
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
    
    entity.imageUploadTool = [PoporUploadTool new];
    entity.imageUploadTool.uploadService = [self getPoporUploadService];
    entity.imageUploadTool.image = image;
    entity.imageUploadTool.originFile = @(origin);
    
    [PHAsset getImageFromPHAsset:asset finish:^(NSData *data) {
        entity.imageUploadTool.imageData  = data;
    }];
    entity.imageUploadStatus = PoporUploadStatusInit;
    
}

- (void)assembleImagePoporUploadEntity:(PoporUploadEntity *)entity image:(UIImage *)image {
    entity.uploadFinishBlock = self.view.uploadFinishBlock;
    
    entity.imageUploadStatus = PoporUploadStatusInit;
    
    entity.imageUploadTool = [PoporUploadTool new];
    entity.imageUploadTool.uploadService = [self getPoporUploadService];
    entity.imageUploadTool.image = image;
}

- (id<PoporUploadServiceProtocol>)getPoporUploadService {
    PUShare * puShare = [PUShare share];
    id<PoporUploadServiceProtocol> service;
    if (self.view.createUploadServiceBlock) {
        service = self.view.createUploadServiceBlock();
    } else if (puShare.createUploadServiceBlock){
        service = puShare.createUploadServiceBlock();
    } else{
        NSLog(@"\n❗️❗️❗️ \n❗️❗️❗️ \n请设置createUploadServiceBlock (可已设置PUShare里面的公共属性), 上传实体类. \n❗️❗️❗️  \n❗️❗️❗️ ");
        return nil;
    }
    return service;
}

#pragma mark - 视频选择部分
- (void)showVideoAC {
    if (self.view.maxUploadNum > 0) {
        NSInteger maxCount = self.view.maxUploadNum - self.view.weakPuEntityArray.count;
        if (maxCount <= 0) {
            NSString * info = @"已经超过最大上传个数";
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
        entity.uploadFinishBlock = self.view.uploadFinishBlock;
        entity.weakCV            = self.view.infoCV;
        entity.weakPuEntityArray = self.view.weakPuEntityArray;
        
        entity.imageUploadTool   = [PoporUploadTool new];
        entity.videoUploadTool   = [PoporUploadTool new];
        entity.imageUploadTool.uploadService = [self getPoporUploadService];
        entity.videoUploadTool.uploadService = [self getPoporUploadService];
        
        if (imageData) {
            entity.imageUploadTool.image     = [UIImage imageWithData:imageData];
            entity.imageUploadTool.imageData = imageData;
        }else if (image) {
            entity.imageUploadTool.image     = image;
        }
        entity.imageUploadStatus = PoporUploadStatusInit;
        
        @weakify(entity);
        
        [self.view.weakPuEntityArray addObject:entity];
        BOOL isCamera = phAsset ? NO:YES;
        
        [self compressVideoTime:time size:videoSize camera:isCamera Block:^(int number) {
            @strongify(self);
            @strongify(entity);
            
            switch (number) {
                case -1:{
                    // 取消
                    [self.view.weakPuEntityArray removeObject:entity];
                    break;
                }
                case 0:{
                    if (self.view.ffmpegCompressBlock) {
                        self.view.vc.navigationController.view.userInteractionEnabled = NO;
                        DMProgressHUD * hud = [DMProgressHUD showLoadingHUDAddedTo:self.view.vc.navigationController.view];
                        //hud.text = @"每分钟大约花费20秒时间\n压缩视频中~";
                        //hud.text = [NSString stringWithFormat:@"大约需需要:%i分，压缩视频中~", MAX(1, (int)(time*0.025))];
                        hud.text = @"压缩视频中~";
                        
                        __weak typeof(hud) weakHud = hud;
                        NSString *resultPath = [PUVideoTool videoCompressPath_time];
                        
                        BlockPBool finish = ^(BOOL value) {
                            [weakHud dismiss];
                            if (value) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.view.vc.navigationController.view.userInteractionEnabled = YES;
                                    if (PIsDebugVersion) {
                                        NSData * data = [NSData dataWithContentsOfFile:resultPath];
                                        NSLog(@"FFMpeg video size : %02fMB", data.length/1024.0f/1024.0f);
                                    }
                                    entity.videoUploadTool.videoFileURL = resultPath;
                                    [entity.weakCV reloadData];
                                });
                            }else{
                                AlertToastTitle(@"视频压缩失败");
                                [entity.weakPuEntityArray removeObject:entity];
                            }
                        };
                        
                        self.view.ffmpegCompressBlock(videoPath, CGSizeMake(540, 960), resultPath, finish);
                    } else {
                        AlertToastTitle(@"未引入自定义FFMpeg视频压缩");
                        [entity.weakPuEntityArray removeObject:entity];
                    }
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
                                if (PIsDebugVersion) {
                                    NSData * data = [NSData dataWithContentsOfFile:resultPath];
                                    NSLog(@"Apple video size : %02fMB", data.length/1024.0f/1024.0f);
                                }
                                entity.videoUploadTool.videoFileURL = resultPath;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.view.infoCV reloadData];
                                });
                            }else{
                                NSLog(@"视频导出完成 error");
                                [self.view.weakPuEntityArray removeObject:entity];
                            }
                        }else{
                            NSLog(@"视频导出完成 error");
                            [self.view.weakPuEntityArray removeObject:entity];
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
        
        if (self.view.compressType & PoporUploadVideoCompressTypeFFMpeg) {
            [oneAC addAction:ffmpegCompressAction];
        }
        if (self.view.compressType & PoporUploadVideoCompressTypeSystem) {
            [oneAC addAction:sysCompressAction];
        }
        if (self.view.compressType & PoporUploadVideoCompressTypeNone) {
            [oneAC addAction:nonCompressAction];
        }
        if (oneAC.actions.count == 1) {
            AlertToastTitle(@"请设置 compressType, 视频压缩方式");
            NSLog(@"\n❗️❗️❗️ \n❗️❗️❗️ \n请设置 compressType, 视频压缩方式! \n❗️❗️❗️  \n❗️❗️❗️ ");
        }else{
            [self.view.vc presentViewController:oneAC animated:YES completion:nil];
        }
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
    return self.view.weakPuEntityArray[[self.cellPresent arrayOrderAt:indexPath]];
}

@end

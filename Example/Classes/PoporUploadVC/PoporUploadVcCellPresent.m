//
//  FileUploadVcCellPresent.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import "PoporUploadVcCellPresent.h"
#import "PoporUploadVCPresenter.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <PoporUI/IToastKeyboard.h>

@interface PoporUploadVcCellPresent ()

@property (nonatomic, weak  ) id<PoporUploadVCProtocol> view;
@property (nonatomic, weak  ) PoporUploadVCPresenter * present;
@property (nonatomic, weak  ) AFNetworkReachabilityManager * afn;

@end

@implementation PoporUploadVcCellPresent

- (id)init {
    if (self = [super init]) {
        _afn = [AFNetworkReachabilityManager sharedManager];
        [_afn startMonitoring];
    }
    return self;
}

- (void)dealloc {
    [_afn stopMonitoring];
    
}

- (void)setMyView:(id<PoporUploadVCProtocol>)view {
    self.view = view;
    
}

- (void)setMyPresent:(id)present {
    self.present = present;
    
}

// 要点:cell是循环使用的,如何打破这个规则.与tableviewcell的CellID机制不一致,不能每个cell单独使用.
// 所以这里的上传刷新机制要验证cell是否当前的entity一致.
#pragma mark 上传图片
- (void)freshImageBlockCell:(PoporUploadCC *)cell needBind:(BOOL)needBind {
    PoporUploadEntity * entity = cell.uploadEntity;
    NSIndexPath * indexPath    = cell.indexPath;
    @weakify(cell);
    @weakify(entity);
    
    // 更新block
    [entity.ivUploadTool updateProgressBlock:^(CGFloat progress) {
        @strongify(cell);
        @strongify(entity);
        if (entity == cell.uploadEntity) {// CellUI线程刷新
            [cell.imageIV puUpdateProgress:progress];
        }
    }];
    
    // bind部分
    [entity.ivUploadTool updateFinishBlock:^(BOOL isSuccess, BOOL isCancle, NSString * _Nullable fileUrl, NSString * _Nullable requestId) {
        @strongify(cell);
        @strongify(entity);
        
        if (entity == cell.uploadEntity) {// CellUI线程刷新
            [cell.imageIV puUpdateProgress:1];
        }
        //NSLog(@"updateFinishBlock : %i, fileName: %@", isSuccess, fileUrl);
        if (isSuccess) {
            entity.ivUploadStatus = PoporUploadStatusFinish;
            entity.ivUrl          = fileUrl;
            entity.ivRequestId    = requestId;
            entity.file_id        = [fileUrl lastPathComponent];
            if (entity.file_id.length>5) {
                entity.file_id    = entity.file_id.stringByDeletingPathExtension;
            }
            
            if (entity == cell.uploadEntity) {// CellUI线程刷新
                [cell.imageIV puRemoveError_puTapGRActionAsyn:YES];
                // 需要绑定
                if (needBind) {
                    [cell.imageIV puUpdating]; // 增加状态栏
                }
            }
            // 替换模式刷新图片
            if (self.view.addType == PoporUploadAddTypeReplace) {
                [self.view.infoCV reloadItemsAtIndexPaths:@[indexPath]];
            }
            // 需要绑定,并且有绑定block
            if (needBind && entity.uploadFinishBlock) {
                BlockPBool bindFinishBlock = ^(BOOL value){
                    @strongify(cell);
                    @strongify(entity);
                    entity.bindOK = value;
                    
                    if (entity == cell.uploadEntity) {// CellUI线程刷新
                        [cell.imageIV puUpdateProgress:1.0];//移除状态栏
                        if (entity.isBindOK) {
                            [cell.imageIV puRemoveError_puTapGRActionAsyn:YES];
                        }else{
                            [cell.imageIV puAddTapGRActionMessage:@"重新增加" asyn:YES block:^{
                                @strongify(entity);
                                if (entity.ivUploadTool.uploadTool.finishBlock) {
                                    entity.ivUploadTool.uploadTool.finishBlock(isSuccess, isCancle, entity.ivUrl, entity.ivRequestId);
                                }else{
                                    AlertToastTitle(@"uploadTool.finishBlock 被置空了");
                                }
                            }];
                        }
                    }
                };
                NSDictionary * dic = @{@"fileUrl":fileUrl, @"bindFinishBlock":bindFinishBlock};
                entity.uploadFinishBlock(dic);
            }
        }else{
            entity.ivUploadStatus = PoporUploadStatusFailed;
            if (entity == cell.uploadEntity) {// CellUI线程刷新
                [cell.imageIV puAddTapGRActionMessage:nil asyn:YES block:^{
                    @strongify(cell);
                    @strongify(entity);
                    
                    entity.ivUploadStatus = PoporUploadStatusUploading;
                    [entity.ivUploadTool startUpload];
                    
                    if (entity == cell.uploadEntity) {// CellUI
                        [cell.imageIV puUpdateProgress:0.01];
                    }
                }];
            }
        }
    }];
    
    // 刷新状态
    switch (entity.ivUploadStatus) {
        case PoporUploadStatusInit:{
            entity.ivUploadStatus = PoporUploadStatusUploading;
            [entity.ivUploadTool startUpload];
            break;
        }
        case PoporUploadStatusUploading:{
            [cell.imageIV puUpdating];
            break;
        }
        case PoporUploadStatusFailed:{
            // 假如刷新的时候发现是失败的,那么也要纠正一下. : 貌似没有清空记录
            [cell.imageIV puAddTapGRActionMessage:nil asyn:YES block:^{
                @strongify(cell);
                @strongify(entity);
                
                entity.ivUploadStatus = PoporUploadStatusUploading;
                [entity.ivUploadTool startUpload];
                [cell.imageIV puUpdateProgress:0.01];
            }];
            break;
        }
        case PoporUploadStatusFinish:{
            if (needBind && !entity.isBindOK) {
                // 这里不需要判断是否一致,因为是cell刷新触发的.
                [cell.imageIV puAddTapGRActionMessage:@"重新增加" asyn:NO block:^{
                    @strongify(entity);
                    if (entity.ivUploadTool.uploadTool.finishBlock) {
                        entity.ivUploadTool.uploadTool.finishBlock(YES, NO, entity.ivUrl, entity.ivRequestId);
                    }else{
                        AlertToastTitle(@"uploadTool.finishBlock 被置空了");
                    }
                }];
            }else{
                [cell.imageIV puRemoveError_puTapGRActionAsyn:NO];
            }
            break;
        }
        default:
            break;
    }
}

//- (void)setBindBlockFileUrl:(NSString *)fileUrl ccImageUrl:(NSString *)ccImageUrl entity:(PoporUploadEntity *)entity {}

- (void)freshImageSelectCell:(PoporUploadCC *)cell {
    PoporUploadEntity * entity = cell.uploadEntity;
    NSIndexPath * indexPath    = cell.indexPath;
    @weakify(self);
    @weakify(cell);
    
    switch (self.view.addType) {
        case PoporUploadAddTypeNone: {
            if (cell.selectBT.hidden) {
                break;
            }
            break;
        }
        case PoporUploadAddTypeOrder: {
            if (cell.selectBT.hidden) {
                break;
            }
            cell.selectBT.userInteractionEnabled = YES;
            [[[cell.selectBT rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                @strongify(cell);
                
                if (self.view.ccDeleteBlock) {
                    BlockPBool finishBlock = ^(BOOL value) {
                        @strongify(self);
                        if (value) {
                            NSInteger order = [self arrayOrderAt:indexPath];
                            [self.view.weakImageArray removeObjectAtIndex:order];
                            [self.view.infoCV reloadData];
                        }
                    };
                    self.view.ccDeleteBlock(self.view.vc, cell, finishBlock);
                }else{
                    NSLog(@"\n❗️请设置ccDeleteBlock");
                }
                
            }];
            break;
        }
        case PoporUploadAddTypeReplace:{
            if (cell.selectBT.hidden) {
                break;
            }
            if (self.view.isShowCcSelectBT) {
                cell.selectBT.hidden = !entity.ivUrl;
            }
            cell.selectBT.userInteractionEnabled = YES;
            [[[cell.selectBT rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                @strongify(cell);
                
                cell.uploadEntity.ivUrl              = nil;
                cell.uploadEntity.ivUploadTool.image = nil;
                cell.uploadEntity.ivUploadStatus     = 0;
                cell.uploadEntity.videoUploadStatus  = 0;
                
                NSIndexPath * ip = [self.view.infoCV indexPathForCell:cell];
                [self.view.infoCV reloadItemsAtIndexPaths:@[ip]];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark 上传视频
- (void)freshVideoBlockCell:(PoporUploadCC *)cell needBind:(BOOL)needBind {
    PoporUploadEntity * entity = cell.uploadEntity;
    @weakify(self);
    @weakify(cell);
    @weakify(entity);
    
    // 更新block
    // 上传视频的时候,并不显示视频封面进度
    [entity.videoUploadTool updateProgressBlock:^(CGFloat progress) {
        @strongify(cell);
        @strongify(entity);
        
        if (entity == cell.uploadEntity) {// CellUI线程刷新
            if (progress == 1) {
                [cell.imageIV puUpdateProgress:0.99];
            }else{
                [cell.imageIV puUpdateProgress:progress];
            }
        }
    }];
    // bind部分
    [entity.videoUploadTool updateFinishBlock:^(BOOL isSuccess, BOOL isCancle, NSString * _Nullable fileUrl, NSString * _Nullable requestId) {
        @strongify(self);
        @strongify(cell);
        @strongify(entity);
        
        //NSLog(@"updateFinishBlock : %i, fileName: %@", isSuccess, fileUrl);
        if (isSuccess) {
            if (entity == cell.uploadEntity) {// CellUI线程刷新
                // 成功的话,关闭progress的block.
                [cell.imageIV puRemoveError_puTapGRActionAsyn:YES];
                [cell.imageIV puUpdating];
            }
            entity.videoUploadStatus = PoporUploadStatusFinish;
            entity.videoUrl          = fileUrl;
            entity.videoRequestId    = requestId;
            entity.file_id           = [fileUrl lastPathComponent];
            if (entity.file_id.length>5) {
                entity.file_id = entity.file_id.stringByDeletingPathExtension;
            }
            
            // 需要绑定,并且有绑定block
            if (needBind && entity.uploadFinishBlock) {
                BlockPBool bindFinishBlock = ^(BOOL value){
                    @strongify(cell);
                    @strongify(entity);
                    entity.bindOK = value;
                    
                    if (entity == cell.uploadEntity) {// CellUI线程刷新
                        [cell.imageIV puUpdateProgress:1.0]; // 移除状态栏
                        if (entity.isBindOK) {
                            [cell.imageIV puRemoveError_puTapGRActionAsyn:YES];
                        }else{
                            [cell.imageIV puAddTapGRActionMessage:@"重新增加" asyn:YES block:^{
                                @strongify(entity);
                                if (entity.videoUploadTool.uploadTool.finishBlock) {
                                    entity.videoUploadTool.uploadTool.finishBlock(isSuccess, isCancle, entity.videoUrl, entity.videoRequestId);
                                }else{
                                    AlertToastTitle(@"uploadTool.finishBlock 被置空了");
                                }
                            }];
                        }
                    }
                };
                NSDictionary * dic = @{@"fileUrl":fileUrl, @"cover_image":entity.ivUrl, @"bindFinishBlock":bindFinishBlock};
                entity.uploadFinishBlock(dic);
            }else{
                if (entity == cell.uploadEntity) {// CellUI线程刷新
                    [cell.imageIV puUpdateProgress:1.0];
                }
            }
            
        }else{
            entity.videoUploadStatus = PoporUploadStatusFailed;
            if (entity == cell.uploadEntity) {// CellUI线程刷新
                // 失败的话关闭进度
                [cell.imageIV puUpdateProgress:1.0];
                // 假如刷新的时候发现是失败的,那么也要纠正一下.
                [cell.imageIV puAddTapGRActionMessage:@"重新上传视频" asyn:YES block:^{
                    @strongify(self);
                    @strongify(cell);
                    @strongify(entity);
                    
                    entity.videoUploadStatus = PoporUploadStatusUploading;
                    [cell.imageIV puUpdateProgress:0.01];
                    [self uploadVideo:entity];
                }];
            }
        }
    }];
    
    [entity.ivUploadTool updateFinishBlock:^(BOOL isSuccess, BOOL isCancle, NSString * _Nullable fileUrl, NSString * _Nullable requestId) {
        @strongify(self);
        @strongify(cell);
        @strongify(entity);
        
        if (isSuccess) {
            entity.ivUploadStatus = PoporUploadStatusFinish;
            entity.ivUrl          = fileUrl;
            entity.ivRequestId    = requestId;
            entity.videoUploadStatus = PoporUploadStatusInit;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadVideo:entity];
            });
            
            if (entity == cell.uploadEntity) {// CellUI线程刷新
                [cell.imageIV puRemoveError_puTapGRActionAsyn:YES];
                [cell.imageIV puUpdating]; // 增加状态栏
            }
        }else{
            entity.ivUploadStatus = PoporUploadStatusFailed;
            
            if (entity == cell.uploadEntity) {// CellUI线程刷新
                [cell.imageIV puAddTapGRActionMessage:@"重新上传视频封面" asyn:YES block:^{
                    @strongify(cell);
                    @strongify(entity);
                    
                    entity.ivUploadStatus = PoporUploadStatusUploading;
                    [cell.imageIV puUpdateProgress:0.01];
                    [entity.ivUploadTool startUpload];
                }];
            }
        }
    }];
    
    switch (entity.ivUploadStatus) {
        case PoporUploadStatusInit:{
            entity.ivUploadStatus = PoporUploadStatusUploading;
            // 上传视频起始点
            [entity.ivUploadTool startUpload];
            break;
        }
        case PoporUploadStatusUploading:{
            [cell.imageIV puUpdating];
            break;
        }
        case PoporUploadStatusFailed:{
            // 假如刷新的时候发现是失败的,那么也要纠正一下.
            [cell.imageIV puAddTapGRActionMessage:@"重新上传视频封面" asyn:NO block:^{
                //@strongify(self);
                @strongify(cell);
                @strongify(entity);
                
                entity.ivUploadStatus = PoporUploadStatusUploading;
                // 点击重新上传,肯定会在可见范围内的.
                //为了防止意外再加一次
                [cell.imageIV puUpdateProgress:0.01];
                [entity.ivUploadTool startUpload];
            }];
            break;
        }
        case PoporUploadStatusFinish:{
            [cell.imageIV puRemoveError_puTapGRActionAsyn:NO];
            break;
        }
        default:
            break;
    }
    switch (entity.videoUploadStatus) {
        case PoporUploadStatusInit:{
            // video的upload交给封面上传block.
            // weakEntity.videoUploadStatus = FileUploadStatusUploading;
            // [weakEntity.video abcUpload];
            break;
        }
        case PoporUploadStatusUploading:{
            [cell.imageIV puUpdating];
            break;
        }
        case PoporUploadStatusFailed:{
            [cell.imageIV puUpdateProgress:1];
            
            [cell.imageIV puAddTapGRActionMessage:@"重新上传视频" asyn:NO block:^{
                @strongify(self);
                @strongify(cell);
                @strongify(entity);
                
                entity.videoUploadStatus = PoporUploadStatusUploading;
                [cell.imageIV puUpdateProgress:0.01];
                [self uploadVideo:entity];
            }];
            break;
        }
        case PoporUploadStatusFinish:{
            [cell.imageIV puRemoveError_puTapGRActionAsyn:NO];
            break;
        }
        default:
            break;
    }
    if (entity.ivUploadStatus == PoporUploadStatusFinish && entity.videoUploadStatus == PoporUploadStatusFinish) {
        if (entity.isBindOK == NO &&
            self.view.cvType == PoporUploadCvType_videoUploadBind) {
            [cell.imageIV puAddTapGRActionMessage:@"重新增加" asyn:NO block:^{
                @strongify(entity);
                if (entity.videoUploadTool.uploadTool.finishBlock) {
                    entity.videoUploadTool.uploadTool.finishBlock(YES, NO, entity.videoUrl, entity.videoRequestId);
                }else{
                    AlertToastTitle(@"uploadTool.finishBlock 被置空了");
                }
            }];
        }
    }
}

- (void)freshVideoSelectCell:(PoporUploadCC *)cell {
    PoporUploadEntity * entity = cell.uploadEntity;
    NSIndexPath * indexPath    = cell.indexPath;
    @weakify(self);
    @weakify(cell);
    
    switch (self.view.addType) {
        case PoporUploadAddTypeNone: {
            if (cell.selectBT.hidden) {
                break;
            }
            break;
        }
        case PoporUploadAddTypeOrder: {
            if (cell.selectBT.hidden) {
                break;
            }
            [[[cell.selectBT rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                @strongify(cell);
                
                if (self.view.ccDeleteBlock) {
                    BlockPBool finishBlock = ^(BOOL value) {
                        @strongify(self);
                        if (value) {
                            NSInteger order = [self arrayOrderAt:indexPath];
                            [self.view.weakImageArray removeObjectAtIndex:order];
                            [self.view.infoCV reloadData];
                        }
                    };
                    self.view.ccDeleteBlock(self.view.vc, cell, finishBlock);
                }else{
                    NSLog(@"\n❗️请设置ccDeleteBlock");
                }
                
            }];
            
            break;
        }
        case PoporUploadAddTypeReplace:{
            if (cell.selectBT.hidden) {
                break;
            }
            if (self.view.isShowCcSelectBT) {
                cell.selectBT.hidden = !entity.ivUrl;
            }
            [[[cell.selectBT rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                @strongify(cell);
                
                cell.uploadEntity.ivUrl              = nil;
                cell.uploadEntity.ivUploadTool.image = nil;
                cell.uploadEntity.ivUploadStatus     = 0;
                cell.uploadEntity.videoUploadStatus  = 0;
                cell.uploadEntity.videoUrl           = nil;
                
                NSIndexPath * ip = [self.view.infoCV indexPathForCell:cell];
                [self.view.infoCV reloadItemsAtIndexPaths:@[ip]];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)uploadVideo:(PoporUploadEntity *)entity {
    // 设置容量
    if (entity.videoSizeMB == 0) {
        if ([entity.videoUploadTool.videoFileURL hasPrefix:@"file://"]) {
            NSData * data = [NSData dataWithContentsOfFile:[entity.videoUploadTool.videoFileURL substringFromIndex:7]];
            entity.videoSizeMB = ceil(data.length/1048576);
        }else{
            NSData * data = [NSData dataWithContentsOfFile:entity.videoUploadTool.videoFileURL];
            entity.videoSizeMB = ceil(data.length/1048576);
        }
    }
    //self.view.videoUploadMaxSize = 1;
    if (self.view.videoUploadMaxSize > 0 &&
        entity.videoSizeMB >= self.view.videoUploadMaxSize) {
        {
            NSString * message = [NSString stringWithFormat:@"该视频容量大于%i兆无法上传，请重新选择", self.view.videoUploadMaxSize];
            UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
            
            [oneAC addAction:cancleAction];
            
            [self.view.vc presentViewController:oneAC animated:YES completion:nil];
        }
        entity.ivUploadStatus = PoporUploadStatusFailed;
        entity.videoUploadStatus = PoporUploadStatusFailed;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.infoCV reloadData];
        });
        
        return;
    }
    @weakify(entity);
    if (entity.videoSizeMB >= 20 && self.is4GNet) {
        
        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"该视频容量为: %li兆，确认要使用移动网络上传吗?", (long)entity.videoSizeMB] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            @strongify(entity);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (entity.videoUploadTool.puFinishBlock) {
                    entity.videoUploadTool.puFinishBlock(NO, NO, nil, nil);
                }
            });
        }];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(entity);
            
            [entity.videoUploadTool startUpload];
        }];
        
        [oneAC addAction:cancleAction];
        [oneAC addAction:okAction];
        
        [self.view.vc presentViewController:oneAC animated:YES completion:nil];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [entity.videoUploadTool startUpload];
        });
    }
}

#pragma mark 选择图片视频
- (void)freshImageVideoSelectCell:(PoporUploadCC *)cell {
    @weakify(self);
    @weakify(cell);
    //@weakify(entity);
    
    [[[cell.selectBT rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(cell);
        @strongify(self);
        
        if (self.view.ccSelectBlock) {
            BlockPBool finishBlock = ^(BOOL value) {
                @strongify(cell);
                if (value) {
                    cell.uploadEntity.select = !cell.uploadEntity.isSelect;
                    [cell.selectBT setSelected:cell.uploadEntity.isSelect];
                }
            };
            self.view.ccSelectBlock(self.view.vc, cell, finishBlock);
        }
    }];
    cell.selectBT.selected = cell.uploadEntity.isSelect;
}

// !!!: 刷新上传时对应的cell图片
- (void)freshCellIvImage:(PoporUploadCC *)cell {
    PoporUploadEntity * entity = cell.uploadEntity;
    if (entity.ccImageUrl) {
        [cell.imageIV sd_setImageWithURL:[NSURL URLWithString:entity.ccImageUrl] placeholderImage:self.view.ccPlacehlodImage];
    }else if (entity.ivUploadTool.image) {
        cell.imageIV.image = entity.ivUploadTool.image;
    }else if(entity.ivUrl){
        [cell.imageIV sd_setImageWithURL:[NSURL URLWithString:[self imageIconUrlEntity:entity]] placeholderImage:self.view.ccPlacehlodImage];
    }
}

- (NSInteger)arrayOrderAt:(NSIndexPath *)indexPath {
    int num = self.view.isShowAddCC ? 0:1;
    NSInteger order = self.view.weakImageArray.count - indexPath.row - num;
    return order;
}

#pragma mark - cell 的刷新格式
- (void)showFileNameEvent:(PoporUploadCC *)cc {
    if (self.view.isShowFileName) {
        cc.tagL.hidden = NO;
        cc.tagL.text   = cc.uploadEntity.file_name;
    }else{
        cc.tagL.hidden = YES;
    }
}

- (NSString *)imageIconUrlEntity:(PoporUploadEntity *)entity {
    if (self.view.createIvThumbUrlBlock) {
        // ImageUrlWH(entity.ivUrl, self.view.ccSize.width*2, self.view.ccSize.height*2);
        return self.view.createIvThumbUrlBlock(entity.ivUrl, self.view.ccSize);
    }else{
        return entity.ivUrl;
    }
}

- (BOOL)is4GNet {
    switch (self.afn.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            break;
        case AFNetworkReachabilityStatusNotReachable:
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            break;
        default:
            break;
    }
    return NO;
}

@end

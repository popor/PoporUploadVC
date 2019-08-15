//
//  PoporUploadVcShowPresent.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import "PoporUploadVcShowPresent.h"
#import "PoporUploadVCPresenter.h"
#import <PoporUI/IToastKeyboard.h>
#import <PoporImageBrower/PoporImageBrower.h>
#import <PoporAVPlayer/PoporAVPlayerVC.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface PoporUploadVcShowPresent ()

@property (nonatomic, weak  ) id<PoporUploadVCProtocol> view;
@property (nonatomic, weak  ) PoporUploadVCPresenter * present;

@end

@implementation PoporUploadVcShowPresent

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setMyView:(id<PoporUploadVCProtocol>)view {
    self.view = view;
    
}

- (void)setMyPresent:(id)present {
    self.present = present;
    
}

// !!!: 查看图片
- (void)showImageBrowerVCEntity:(PoporUploadEntity *)entity all:(BOOL)all {
    NSIndexPath * indexPath = entity.indexPath;
    // 全选类别: 一般为all,替换模式为no
    UICollectionView * collectionView = self.view.infoCV;
    NSInteger count;
    NSInteger i;
    //NSInteger indexRowFirst = self.view.isShowAddCC ? 1:0 ;
    
    if (all) {
        count = [self.present collectionView:collectionView numberOfItemsInSection:indexPath.section];
        i = self.view.isShowAddCC ? 1:0 ;
    }else{
        count = indexPath.row+1;
        i = indexPath.row;
    }
    NSMutableArray * imageArray;
    {
        imageArray = [NSMutableArray new];
        for (; i < count; i++) {
            PoporImageBrowerEntity * entity = [PoporImageBrowerEntity new];
            PoporUploadEntity * pue = [self.present getCellEntityAt:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            
            if (pue.imageUrl) {
                entity.bigImageUrl = [NSURL URLWithString:pue.imageUrl];
            }else if (pue.imageUploadTool.image){
                entity.bigImage = pue.imageUploadTool.image;
            }
            
            [imageArray addObject:entity];
        }
        
        NSInteger showIndex;
        if (all) {
            if (self.view.isShowAddCC) {
                showIndex = indexPath.item - 1;
            }else{
                showIndex = indexPath.item;
            }
        }else{
            showIndex = 0;
        }
        
        @weakify(self);
        PoporImageBrower *photoBrower = [[PoporImageBrower alloc] initWithIndex:showIndex copyImageArray:imageArray presentVC:self.view.vc originImageBlock:^UIImageView *(PoporImageBrower *browerController, NSInteger index) {
            @strongify(self);
            if (self.view.isShowAddCC) {
                index ++;
            }
            PoporUploadCC * tempCC;
            if (all) {
                tempCC = (PoporUploadCC *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
            }else{
                tempCC = (PoporUploadCC *)[collectionView cellForItemAtIndexPath:indexPath];
            }
            return tempCC.imageIV;
        } disappearBlock:^(PoporImageBrower *browerController, NSInteger index) {
            @strongify(self);
            if (all) {
                if (self.view.isShowAddCC) {
                    index ++;
                }
                [self.view.infoCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:indexPath.section] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                //collectionView必须要layoutIfNeeded，否则cellForItemAtIndexPath,有可能获取到的是nil，
                [self.view.infoCV layoutIfNeeded];
            } else {
                // 单张显示的话,不需要刷新.
            }
        } placeholderImageBlock:^UIImage *(PoporImageBrower *browerController) {
            //return [UIImage imageNamed:@"placeholder"];
            return nil;
        }];
        
        photoBrower.showDownloadImageError = NO;
        [photoBrower show];
    }
}

- (void)showVideoPlayEntity:(PoporUploadEntity *)entity {
    PoporUploadCC * cc = (PoporUploadCC *)entity.weakCC;
    // 视频部分
    if (cc.uploadEntity.videoUploadStatus == PoporUploadStatusFailed) {
        NSLog(@"上传失败，无法播放");
        return;
    }
    
    NSString * videoURL = cc.uploadEntity.videoUrl;
    if (!videoURL) {
        AlertToastTitle(@"视频网址为空，无法播放");
        return;
    }
    
    if ([videoURL hasPrefix:@"//"]) {
        videoURL = [NSString stringWithFormat:@"http:%@", videoURL];
    }
    PUShare * pushare = [PUShare share];
    if (self.view.videoPlayBlock) {
        self.view.videoPlayBlock(@{@"videoURL":[NSURL URLWithString:videoURL],
                                   @"vc":self.view.vc,
                                   });
    }else if(pushare.videoPlayBlock){
        pushare.videoPlayBlock(@{@"videoURL":[NSURL URLWithString:videoURL],
                                 @"vc":self.view.vc,
                                   });
    } else {
        UIViewController * vc = [[PoporAVPlayerVC alloc] initWithDic:@{@"title":self.view.vc.title, @"videoURL":[NSURL URLWithString:videoURL], @"showLockRotateBT":@(NO)}];
        if (self.view.videoPlayExtraSetBlock) {
            self.view.videoPlayExtraSetBlock(self.view.vc.navigationController, vc);
        } else if (pushare.videoPlayExtraSetBlock){
            pushare.videoPlayExtraSetBlock(self.view.vc.navigationController, vc);
        } else {
            NSLog(@"\n❗️❗️❗️ \n❗️❗️❗️ \n请设置videoPlayExtraSetBlock (可已设置PUShare里面的公共属性), 设置隐藏导航栏, 不然和自带视频播放界面相冲突. \n❗️❗️❗️  \n❗️❗️❗️ ");
        }
        [self.view.vc.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showAudioPlayEntity:(PoporUploadEntity *)entity array:(NSMutableArray *)array {
    PoporUploadCC * cc = (PoporUploadCC *)entity.weakCC;
    
    NSString * fileUrl = cc.uploadEntity.fileUrl;
    if (!fileUrl) {
        AlertToastTitle(@"音频网址为空，无法播放");
        return;
    }
    
    if ([fileUrl hasPrefix:@"//"]) {
        fileUrl = [NSString stringWithFormat:@"http:%@", fileUrl];
    }
    PUShare * pushare = [PUShare share];
    if (self.view.audioPlayBlock) {
        self.view.audioPlayBlock(self.view.vc.navigationController, self.view.vc, entity, array);
    }else if(pushare.audioPlayBlock){
        pushare.audioPlayBlock(self.view.vc.navigationController, self.view.vc, entity, array);
    } else {
        UIViewController * vc = [[PoporAVPlayerVC alloc] initWithDic:@{@"title":self.view.vc.title, @"videoURL":[NSURL URLWithString:fileUrl], @"showLockRotateBT":@(NO)}];
        if (self.view.audioPlayExtraSetBlock) {
            self.view.audioPlayExtraSetBlock(self.view.vc.navigationController, vc);
        } else if (pushare.audioPlayExtraSetBlock){
            pushare.audioPlayExtraSetBlock(self.view.vc.navigationController, vc);
        } else {
            NSLog(@"\n❗️❗️❗️ \n❗️❗️❗️ \n请设置videoPlayExtraSetBlock (可已设置PUShare里面的公共属性), 设置隐藏导航栏, 不然和自带视频播放界面相冲突. \n❗️❗️❗️  \n❗️❗️❗️ ");
        }
        [self.view.vc.navigationController pushViewController:vc animated:YES];
    }
}

@end

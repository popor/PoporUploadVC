//
//  PoporUploadVCProtocol.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.

#import <Foundation/Foundation.h>

#import "PUShare.h" // 包含所有常用.h
#import "PoporUploadCC.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: 对外接口
@protocol PoporUploadVCProtocol <NSObject>

- (UIViewController *)vc;
- (void)updatePUShare;

// MARK: 自己的
@property (nonatomic, strong) UICollectionView * infoCV;

@property (nonatomic        ) CGSize ccSize;

// MARK: 外部注入
@property (nonatomic, weak  ) NSMutableArray<PoporUploadEntity*> * weakPuEntityArray;

@property (nonatomic        ) PoporUploadType uploadType;
@property (nonatomic        ) PoporUploadAddType addType;

@property (nonatomic, getter=isShowCcSelectBT) BOOL showCcSelectBT;// 是否在有素材的时候显示selectBT

// 是否显示新增按钮, 这个由addType决定, 最好不要在dic中设置了.
@property (nonatomic, getter=isShowAddCC) BOOL showAddCC;

// !!!: UI 参数
@property (nonatomic        ) int lineNumber; // 默认为4
@property (nonatomic        ) UIEdgeInsets cvSectionEdgeInsets;
@property (nonatomic        ) CGFloat ccXGap;
@property (nonatomic        ) CGFloat ccYGap;
// 从右上角开始计算
@property (nonatomic        ) CGFloat ccBtXGap;
@property (nonatomic        ) CGFloat ccBtYGap;
@property (nonatomic        ) CGFloat ccIvXGap;
@property (nonatomic        ) CGFloat ccIvYGap;
// cc
@property (nonatomic        ) float   ccIvCorner; // 图片圆角
@property (nonatomic        ) UIColor * ccIvBorderColor;// 边界颜色
@property (nonatomic        ) float   ccIvBorderWidth;// 边界宽度
@property (nonatomic        ) NSInteger  maxUploadNum; // 最大上传图片视频个数
@property (nonatomic, getter=isShowCcBG) BOOL showCcBG;// 显示bg颜色

// 图片
@property (nonatomic, strong) UIColor * infoCvBgColor;
@property (nonatomic, strong) UIColor * image_Add_bgColor;

@property (nonatomic, strong) UIImage * image_Add;
@property (nonatomic, strong) UIImage * image_SelectN;
@property (nonatomic, strong) UIImage * image_SelectS;
@property (nonatomic, strong) UIImage * image_Resume;

@property (nonatomic, strong) UIImage * ccPlacehlodImage; // 默认的 cc image

// 视频部分
@property (nonatomic        ) PoporUploadVideoCompressType compressType;
@property (nonatomic        ) BOOL videoFromCamraUseCompress; // 拍摄的视频是否压缩?
@property (nonatomic        ) int  videoUploadMaxSize; //视频上传最大容量,单位为MB 1024*1024.

// 是否显示file_name
@property (nonatomic, getter=isShowFileName) BOOL showFileName;

// --- block -------------------------------------------------------------------
@property (nonatomic, copy  ) BlockPDic                       uploadFinishBlock;// 上传好文件之后的block
@property (nonatomic, copy  ) BlockPVoid                      deallocBlock;// 该VC 注销之后的block
@property (nonatomic, copy  ) PoporUpload_RBoolPVoid          ncSelectBlock;// 选择模式下, nc 右边按钮事件

// 选择模式下, cc右上角按钮事件
@property (nonatomic, copy  ) PoporUpload_PEntityFinish       ccSelectBlock;
// 上传和上传绑定模式下, cc右上角按钮事件
@property (nonatomic, copy  ) PoporUpload_PEntityFinish       ccDeleteBlock;

@property (nonatomic, copy  ) BlockPViewController            willAppearBlock;
@property (nonatomic, copy  ) BlockPViewController            didAppearBlock;
@property (nonatomic, copy  ) BlockPViewController            viewDidLoadBlock;

// 下面是可以使用PUShare里面的公共block
// 自定义视频播放block
@property (nonatomic, copy  ) BlockPDic                       videoPlayBlock;

// 自定义视频播放额外设置block, 比如隐藏系统默认导航栏,这个必须设置,不然和我的相冲突
@property (nonatomic, copy  ) PoporUpload_PNcVc               videoPlayExtraSetBlock;

// 获取生成上传tool的block
@property (nonatomic, copy  ) PoporUpload_RUploadServicePVoid createUploadServiceBlock;

// 获取图片缩略图的block, 根据不同的图床平台,请设置对应的缩略图url,供ccIV使用
@property (nonatomic, copy  ) PoporUpload_RStringPStringSize  createIvThumbUrlBlock;




@end

// 数据来源
@protocol PoporUploadVCDataSource <NSObject>
- (void)cleanIVSelectStatus;

@end

// UI事件
@protocol PoporUploadVCEventHandler <NSObject>

- (void)selectFinishAction;

@end

NS_ASSUME_NONNULL_END

//
//  PoporUploadEntity.h
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PoporUploadTool.h"
#import "PoporUploadVCPrefix.h"
#import <PoporFoundation/PrefixBlock.h>

// 用于保存上传所需要的一些数据.

NS_ASSUME_NONNULL_BEGIN

@protocol PoporUploadEntity;
@interface PoporUploadEntity : JSONModel

// --- 公共参数 -----------------------------------------------------------------
// 考虑到cell可能属于不同的CV、VC，所以将刷新数据以entity为中心。相当于数据库的keyID
@property (nonatomic        ) PoporUploadType      uploadType;// 将该属性绑定到 entity 上, 是为了以后重构使用
@property (nonatomic        ) PoporUploadAddType   addType;// 将该属性绑定到 entity 上, 是为了以后重构使用

@property (nonatomic, weak  ) UICollectionView     * weakCV;
@property (nonatomic, weak  ) UICollectionViewCell * weakCC;
@property (nonatomic, weak  ) NSMutableArray       * weakPuEntityArray;// 自己位于哪个数组
@property (nonatomic, strong) NSIndexPath          * indexPath; // UI刷新不及时可能会出错

// 在本framework中,除了承担进度条之外,还承担了获取点击事件功能
@property (nonatomic, weak  ) UIView               * weakUploadProgressView;

// 默认图
@property (nonatomic, strong) NSString             * placeholderImageName;// 默认图片
@property (nonatomic, strong) NSString             * placeholderImageUrl;// 默认图片
@property (nonatomic, strong) UIImage              * placeholderImage;// 默认图片
// 缩略图
@property (nonatomic, strong) UIImage              * thumbnailImage;
@property (nonatomic, strong) NSString             * thumbnailImageUrl;

@property (nonatomic        ) PoporUploadStatus    ivUploadStatus;// 图片上传状态
@property (nonatomic        ) PoporUploadStatus    videoUploadStatus;// 视频上传状态

@property (nonatomic, strong) PoporUploadTool      * ivUploadTool;// 负责上传图片
@property (nonatomic, strong) PoporUploadTool      * videoUploadTool;// 负责上传视频
@property (nonatomic        ) NSInteger            videoSizeMB;// 单位为MB

// 用来区分是否使用网络图片.
// 用户绑定记录,例如用户头像和上传家访图片视频.
@property (nonatomic, getter = isBindOK)  BOOL bindOK; //绑定成功
@property (nonatomic, getter = isHasData) BOOL hasData;//是否有素材
@property (nonatomic, getter = isSelect)  BOOL select; //是否选中图片

// 上传返回的url
@property (nonatomic, strong, nullable) NSString * ivUrl;
@property (nonatomic, strong, nullable) NSString * videoUrl;

@property (nonatomic, strong, nullable) NSString * ivRequestId;
@property (nonatomic, strong, nullable) NSString * videoRequestId;

// --- 额外参数 -----------------------------------------------------------------
// 供其他情况使用额外参数
@property (nonatomic        ) int        fileIntID;
@property (nonatomic, strong) NSString * extraInfo1;
@property (nonatomic, strong) NSString * extraInfo2;
@property (nonatomic, strong) NSString * extraInfo3;
@property (nonatomic, strong) NSString * extraInfo4;
@property (nonatomic, strong) NSMutableDictionary * extraDic;

// 额外的weakView

@property (nonatomic, weak  ) UIView * weakView1;
@property (nonatomic, weak  ) UIView * weakView2;
@property (nonatomic, weak  ) UIView * weakView3;
@property (nonatomic, weak  ) UIView * weakView4;

@property (nonatomic, strong) UIView * strongView1;
@property (nonatomic, strong) UIView * strongView2;
@property (nonatomic, strong) UIView * strongView3;
@property (nonatomic, strong) UIView * strongView4;

@property (nonatomic, strong, nullable) NSString * file_name; // cc 上面的lable文字

// 主要来源于拷贝PoporUploadVC的uploadFinishBlock
@property (nonatomic, copy  ) BlockPDic  uploadFinishBlock;

// 其他字段
@property (nonatomic, strong, nullable) NSString * file_id; // 单独删除的时候会用到.

@end


// 系统只会给一瞬间的读取权限,过期就失效了,觉得很鸡肋.
//@class PHAsset;
//@property (nonatomic, strong) PHAsset      * videoPHAsset;// 视频
//@property (nonatomic, strong) NSString     * videoPath;

NS_ASSUME_NONNULL_END



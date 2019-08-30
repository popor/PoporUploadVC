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
#import <PoporFoundation/Block+pPrefix.h>

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

// 默认图: 可用于replace模式, 显示cellIV的时候优先显示以下三个参数.
@property (nonatomic, strong, nullable) UIImage           * placeholderImage;
@property (nonatomic, strong, nullable) NSString          * placeholderImageUrl;// 缩略图url
@property (nonatomic, strong, nullable) NSString          * placeholderImageName;// 缩略图name

// 用于替换模式
@property (nonatomic, strong, nullable) UIImage           * replaceImage;
@property (nonatomic, strong, nullable) NSString          * replaceImageUrl;// 缩略图url
@property (nonatomic, strong, nullable) NSString          * replaceImageName;// 缩略图name

// 图片视频文件区分开的好处:代码阅读性提高.个别地方不容易出错.
// 图片
@property (nonatomic, strong, nullable) PoporUploadTool   * imageUploadTool;// 负责上传图片
@property (nonatomic, strong, nullable) NSString          * imageUrl;
@property (nonatomic, strong, nullable) NSString          * imageRequestId;
@property (nonatomic                  ) PoporUploadStatus imageUploadStatus;// 上传图片状态

// 视频
@property (nonatomic, strong, nullable) PoporUploadTool   * videoUploadTool;// 负责上传视频
@property (nonatomic, strong, nullable) NSString          * videoUrl;
@property (nonatomic, strong, nullable) NSString          * videoRequestId;
@property (nonatomic                  ) PoporUploadStatus videoUploadStatus;// 上传视频状态
@property (nonatomic                  ) NSInteger         videoSizeMB;// 单位为MB

// 文件:mp3、doc等
@property (nonatomic, strong, nullable) PoporUploadTool   * fileUploadTool;// 负责文件视频
@property (nonatomic, strong, nullable) NSString          * fileUrl;
@property (nonatomic, strong, nullable) NSString          * fileRequestId;
@property (nonatomic                  ) PoporUploadStatus fileUploadStatus;// 上传文件状态
@property (nonatomic                  ) NSInteger         fileSizeMB;// 单位为MB

// 用来区分是否使用网络图片.
// 用户绑定记录,例如用户头像和上传家访图片视频.
@property (nonatomic, getter = isBindOK)  BOOL bindOK; //绑定成功
@property (nonatomic, getter = isSelect)  BOOL select; //是否选中图片

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
@property (nonatomic, copy  ) PoporUpload_PEntityFinish uploadFinishBlock;

// 其他字段
@property (nonatomic, strong, nullable) NSString * file_id; // 单独删除的时候会用到.

@end


// 系统只会给一瞬间的读取权限,过期就失效了,觉得很鸡肋.
//@class PHAsset;
//@property (nonatomic, strong) PHAsset      * videoPHAsset;// 视频
//@property (nonatomic, strong) NSString     * videoPath;

NS_ASSUME_NONNULL_END



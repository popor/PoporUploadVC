//
//  FileUploadCC.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import "PoporUploadCC.h"

#import "PUShare.h"
#import <Masonry/Masonry.h>

@implementation PoporUploadCC

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addViews];
        [self layoutSubviewsCustom];
        
    }
    return self;
}

- (void)addViews {
    PUShare * tool = [PUShare share];
    
    self.imageIV = ({
        UIImageView * iv   = [[UIImageView alloc] init];
        iv.backgroundColor = [UIColor whiteColor];
        iv.contentMode     = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds   = YES;
        
        [self addSubview:iv];
        iv;
    });
    self.selectBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:tool.image_SelectN] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:tool.image_SelectS] forState:UIControlStateSelected];
        
        [self addSubview:button];
        
        button;
    });
    self.tagL = ({
        UILabel * l = [UILabel new];
        l.backgroundColor    = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        l.font               = [UIFont systemFontOfSize:12];
        l.textColor          = [UIColor whiteColor];
        
        l.numberOfLines      = 1;
        l.hidden             = YES;
        l.textAlignment      = NSTextAlignmentCenter;
        
        [self addSubview:l];
        l;
    });
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds   = YES;
    
    [self.imageIV puAddUploadStatusViews];
    [self.imageIV puUpdateProgress:1.0]; // 初始化,需要移除.
    
    if (tool.isShowCcBG) {
        self.backgroundColor          = [UIColor lightGrayColor];
        self.imageIV.backgroundColor  = [UIColor blueColor];
        self.selectBT.backgroundColor = [UIColor redColor];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    //self.selectBT.selected = selected;
}

// 设定了 type 和 showType 之后,需要运行
- (void)layoutSubviewsCustom {
    PUShare * tool = [PUShare share];
    if (tool.fileUploadCcIvCorner > 0) {
        self.imageIV.layer.cornerRadius = tool.fileUploadCcIvCorner;
        self.imageIV.clipsToBounds = YES;
    }
    if (tool.fileUploadCcIvBorderWidth>0 &&
        tool.fileUploadCcIvBorderColor) {
        self.imageIV.layer.borderColor = tool.fileUploadCcIvBorderColor.CGColor;
        self.imageIV.layer.borderWidth = tool.fileUploadCcIvBorderWidth;
    }
    
    [self.imageIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(tool.fileUploadCcIvYGap, 0, 0, tool.fileUploadCcIvXGap));
    }];
    [self.selectBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tool.fileUploadCcBtYGap);
        make.right.mas_equalTo(-tool.fileUploadCcBtXGap);
        make.width.mas_equalTo(MAX(30, self.selectBT.imageView.image.size.width));
        make.height.mas_equalTo(MAX(30, self.selectBT.imageView.image.size.height));
    }];
    [self.tagL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-tool.fileUploadCcIvXGap);
        make.height.mas_equalTo(20);
    }];
}

@end

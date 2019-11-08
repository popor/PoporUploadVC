//
//  UIView+PoporUpload.m
//  PoporUploadVC
//
//  Created by popor on 07/31/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import "UIView+PoporUpload.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import "PoporUploadServiceProtocol.h"
#import "PUShare.h"

@implementation UIView (PoporUpload)
@dynamic puGrayView;
@dynamic puInfoL;
@dynamic puUploadAIV;
@dynamic puTapGR;
@dynamic puTapGRMessage;
@dynamic puTapGRBlock;
@dynamic puErrorIV;

- (void)puAddUploadStatusViews {
    if (!self.puGrayView) {
        UIView * iv = [UIView new];
        iv.userInteractionEnabled = NO;
        iv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        [self addSubview:iv];
        
        self.puGrayView = iv;
    }
    if (!self.puInfoL) {
        UILabel * oneL = [UILabel new];
        oneL.backgroundColor = [UIColor clearColor];
        oneL.font            = [UIFont systemFontOfSize:15];
        oneL.textColor       = [UIColor whiteColor];
        oneL.textAlignment   = NSTextAlignmentCenter;
        
        [self.puGrayView addSubview:oneL];
        self.puInfoL = oneL;
    }
    if (!self.puUploadAIV) {
        UIActivityIndicatorView * aiv;
        aiv=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aiv.hidesWhenStopped   = YES;
        aiv.backgroundColor    = [UIColor clearColor];
        
        [self.puGrayView addSubview:aiv];
        self.puUploadAIV = aiv;
    }
    [self usLayoutSubviews];
}

- (void)usLayoutSubviews {
    [self.puGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.puUploadAIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        //make.center.mas_equalTo(weakSelf.puGrayView.center);
    }];
    [self.puInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.puUploadAIV.mas_bottom);
        
        make.height.mas_equalTo(20);
    }];
}

// 不知道 具体值只有状态
- (void)puUpdating {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.puGrayView.hidden = NO;
        self.puInfoL.text      = @"";
        if (!self.puUploadAIV.isAnimating) {
            [self.puUploadAIV startAnimating];
        }
    });
}

- (void)puUpdateProgress:(CGFloat)progressF {
    NSString * text = [NSString stringWithFormat:@"%i %%", (int)(progressF*100)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.puGrayView) {
            NSLog(@"❗️未初始化图片进度UI层, 请给对应的UI执行 puAddUploadStatusViews.");
        }
        if (progressF == 1) {
            self.puGrayView.hidden = YES;
            [self.puUploadAIV stopAnimating];
        }else{
            self.puGrayView.hidden = NO;
            if (!self.puUploadAIV.isAnimating) {
                [self.puUploadAIV startAnimating];
            }
            self.puInfoL.text = text;
        }
    });
}

- (void)puAddTapGRActionMessage:(NSString * _Nullable)message asyn:(BOOL)asyn tapBlock:(BlockPVoid _Nullable)tapBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self puUpdateProgress:1.0];
        self.puTapGRMessage = message;
        self.puTapGRBlock   = nil;
        self.puTapGRBlock   = tapBlock;
        
        self.userInteractionEnabled=YES;
        if (self.puTapGR) {
            [self removeGestureRecognizer:self.puTapGR];
            self.puTapGR = nil;
        }
        if (!self.puTapGR) {
            self.puTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usShowUIMenuController:)];
            [self addGestureRecognizer:self.puTapGR];
        }
        
    });

    [self puAddErrorIVAsyn:asyn];
}

- (void)puAddErrorIVAsyn:(BOOL)asyn {
    if (asyn) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addErrorIV];
        });
    }else{
        [self addErrorIV];
    }
}

- (void)addErrorIV {
    if (!self.puErrorIV) {
        PUShare * tool = [PUShare share];
        
        UIImageView * iv = [[UIImageView alloc] initWithImage:tool.image_Resume];
        [self addSubview:iv];
        
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(3);
            make.left.mas_equalTo(3);
            make.size.mas_equalTo(iv.image.size);
        }];
        self.puErrorIV = iv;
    }
}

- (void)puRemoveError_puTapGRActionAsyn:(BOOL)asyn {
    if (self.puTapGR) {
        [self removeGestureRecognizer:self.puTapGR];
        self.puTapGR = nil;
    }
    if (asyn) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.puErrorIV) {
                [self.puErrorIV removeFromSuperview];
                self.puErrorIV = nil;
            }
        });
    }else{
        if (self.puErrorIV) {
            [self.puErrorIV removeFromSuperview];
            self.puErrorIV = nil;
        }
    }
}

- (void)usShowUIMenuController:(UITapGestureRecognizer *)tapGR {
    //NSLog(@"执行tap事件, showUIMenuController");
    [self becomeFirstResponder];
    UIMenuItem *reUploadImageMenuItem;
    if (self.puTapGRMessage) {
        reUploadImageMenuItem = [[UIMenuItem alloc] initWithTitle:self.puTapGRMessage action:@selector(reUploadImage:)];
    }else{
        reUploadImageMenuItem = [[UIMenuItem alloc] initWithTitle:@"重新上传" action:@selector(reUploadImage:)];
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:[NSArray arrayWithObjects:reUploadImageMenuItem, nil]];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

- (void)reUploadImage:(UIMenuItem *)sender {
    [self puRemoveError_puTapGRActionAsyn:YES];
    
    if (self.puTapGRBlock) {
        self.puTapGRBlock();
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    BOOL result = NO;
    if(@selector(reUploadImage:) == action) {
        result = YES;
    }
    return result;
}

#pragma mark - setget
- (void)setPuGrayView:(UIView *)puGrayView {
    objc_setAssociatedObject(self, @"puGrayView", puGrayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)puGrayView {
    return objc_getAssociatedObject(self, @"puGrayView");
}

- (void)setPuInfoL:(UILabel *)puInfoL {
    objc_setAssociatedObject(self, @"puInfoL", puInfoL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)puInfoL {
    return objc_getAssociatedObject(self, @"puInfoL");
}

- (void)setPuUploadAIV:(UIActivityIndicatorView *)puUploadAIV {
    objc_setAssociatedObject(self, @"puUploadAIV", puUploadAIV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)puUploadAIV {
     return objc_getAssociatedObject(self, @"puUploadAIV");
}

- (void)setPuTapGR:(UITapGestureRecognizer * _Nullable)puTapGR {
    objc_setAssociatedObject(self, @"puTapGR", puTapGR, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITapGestureRecognizer *)puTapGR {
    return objc_getAssociatedObject(self, @"puTapGR");
}

- (void)setPuTapGRMessage:(NSString *)puTapGRMessage {
    objc_setAssociatedObject(self, @"puTapGRMessage", puTapGRMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)puTapGRMessage {
    return objc_getAssociatedObject(self, @"puTapGRMessage");
}

- (void)setPuTapGRBlock:(BlockPVoid _Nullable)puTapGRBlock {
    objc_setAssociatedObject(self, @"puTapGRBlock", puTapGRBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BlockPVoid)puTapGRBlock {
    return objc_getAssociatedObject(self, @"puTapGRBlock");
}

- (void)setPuErrorIV:(UIImageView * _Nullable)puErrorIV {
    objc_setAssociatedObject(self, @"puErrorIV", puErrorIV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)puErrorIV {
    return objc_getAssociatedObject(self, @"puErrorIV");
}

@end

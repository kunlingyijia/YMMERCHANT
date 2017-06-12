//
//  ImageChooseVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

//枚举 请求类型
typedef enum : NSUInteger {
    EditedImage,//剪切
    OriginalImage//原始
    
}ImageType;
@interface ImageChooseVC : BaseViewController
///ImageChooseVCBlock
@property (nonatomic, copy) void(^ImageChooseVCBlock)(UIImage *image);
///图片类型 默认//剪切
@property (nonatomic, assign) ImageType  imageType ;
///比例
@property (nonatomic, assign) CGFloat  zoom ;




@end

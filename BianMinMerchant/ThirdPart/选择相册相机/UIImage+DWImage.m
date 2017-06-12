//
//  UIImage+DWImage.m
//  DWduifubao
//
//  Created by kkk on 16/9/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "UIImage+DWImage.h"


typedef NS_ENUM(NSUInteger, DiscardImageType) {
    DiscardImageUnknown = 0,
    DiscardImageTopSide = 1,
    DiscardImageRightSide = 2,
    DiscardImageBottomSide = 3,
    DiscardImageLeftSide = 4,
};


@implementation UIImage (DWImage)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        
        return img;
    }
}

+ (UIImage *)subimageInRect:(UIImage *)image rect:(CGRect)rect {
    CGImageRef newImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *img = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return img;
}

//压缩图片至指定尺寸,会变形
+ (UIImage *)scaleImageNotKeepingRatio:(UIImage *)image targetSize:(CGSize)targetSize {
    CGRect rect = (CGRect){CGPointZero, targetSize};
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

//压缩图片至指定像素点
+ (UIImage *)scaleImageAtPixel:(UIImage *)image pixel:(CGFloat)pixel {
    CGSize size = image.size;
    
    if (size.width <= pixel && size.height <= pixel) {
        return image;
    }
    CGFloat scale = size.width / size.height;
    if (size.width > size.height) {
        size.width = pixel;
        size.height = size.width / scale;
    }else {
        size.height = pixel;
        size.width = size.height * scale;
    }
    return [UIImage scaleImageNotKeepingRatio:image targetSize:size];
}

//在指定的size里面生成一个平铺的图片
+ (UIImage *)tiledImage:(UIImage *)image targetSize:(CGSize)targetSize {
    UIView *tempView = [[UIView alloc] init];
    tempView.bounds = (CGRect){CGPointZero, targetSize};
    tempView.backgroundColor = [UIColor colorWithPatternImage:image];
    UIGraphicsBeginImageContext(targetSize);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//UIView转化为UIImage
+ (UIImage *)imageWithView:(UIView *)view {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//将两张图片生成一张
+ (UIImage *)mergeImage:(UIImage *)image otherImage:(UIImage *)otherImage {
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat otherWidth = otherImage.size.width;
    CGFloat otherHeight = otherImage.size.height;
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    [otherImage drawInRect:CGRectMake(0, 0, otherWidth, otherHeight)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//不变形拉伸
+ (UIImage *)scaleImageKeepingRatio:(UIImage *)image targetSize:(CGSize)targetSize {
    //原图和目标图尺寸相同
    if (CGSizeEqualToSize(image.size, targetSize)) {
        return image;
    }
    
    //原图和目标尺寸图不同
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    //声明一个判断属性
    DiscardImageType discardType = DiscardImageUnknown;
    CGFloat targetWidth = 0.0f;
    CGFloat targetHeight = 0.0f;
    
    targetWidth = targetSize.width;//获取最终的目标宽度尺寸
    targetHeight = targetSize.height; //获取最终目标高度尺寸
    
    //先声明拉伸系数
    CGFloat scaleFactor = 0.0f;
    CGFloat scaledWidth = 0.0f;
    CGFloat scaledHeight = 0.0f;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);//这个是图片剪切的七点位置
    
    CGFloat widthFactor = targetWidth/imageWidth;
    CGFloat heightFactor = targetHeight/imageHeight;
    
    /*========分四种情况=========*/
    //第一种 widthFactor, heightFactor 都小于1 要缩小
    //第一种 需要判断要缩小哪个尺寸
    if (widthFactor < 1 && heightFactor < 1) {
        if (widthFactor > heightFactor) {
            //右部分空白
            discardType = DiscardImageRightSide;
            scaleFactor = heightFactor;
        }//scale to fit height
        else {
            //下部分空白
            discardType = DiscardImageBottomSide;
            scaleFactor = widthFactor;//scale to fit width
        }
    }
    
    //第二种, 宽度不够比例 高度缩小一点点
    else if (widthFactor > 1 && heightFactor < 1) {
        //右边空白
        discardType = DiscardImageRightSide;
        //采用高度拉伸比例
        scaleFactor = imageWidth/targetWidth;
    }
    //第三种 高度不够比例 宽度缩小一点点
    else if (heightFactor > 1 && widthFactor < 1) {
        //下边空白
        discardType = DiscardImageBottomSide;
        //采用高度拉伸比例
        scaleFactor = imageHeight / targetHeight;
    }
    
    //第四种 放大处理
    else {
        if (widthFactor > heightFactor) {
            //右部分空白
            discardType = DiscardImageRightSide;
            scaleFactor = heightFactor;//scale to fir height
        }else  {
            //下分发空白
            discardType = DiscardImageRightSide;
            scaleFactor = widthFactor;//scale to fit width
        }
    }
    
    scaledWidth = imageWidth * scaleFactor;
    scaledHeight = imageHeight * scaleFactor;
    
    switch (discardType) {
        case DiscardImageTopSide:
            
            break;
            
        case DiscardImageRightSide:
            //右部分空白
            targetSize.width = scaledWidth;
            break;
            
        case DiscardImageBottomSide:
            //下部分空白
            targetSize.height = scaledHeight;
            break;
            
        case DiscardImageLeftSide:
            
            break;
            
        case DiscardImageUnknown:
            
            break;
            
        default:
            break;
    }
    
    UIGraphicsBeginImageContext(targetSize);//开始剪切
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [image drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//截图拿到图片
    UIGraphicsEndImageContext();
    return newImage;
    
}
+(NSData * )scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    if (!image) {
        return        UIImageJPEGRepresentation(image, 1.0);
    }
    if (kb<1) {
        return        UIImageJPEGRepresentation(image, 1.0);
        
    }
    
    kb*=1024;
    
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
       //if (compression>0.5) {
            compression -= 0.1;
//        }else{
//            compression = 0.5;
//        }
        
        imageData = UIImageJPEGRepresentation(image, compression);
        NSLog(@"第一%lu",(unsigned long)[imageData length]);
    }
    
//    UIImage *compressedImage1 = [UIImage imageWithData:imageData];
//    CGFloat compression1 = 0.99f;
//    CGFloat maxCompression1 = 0.01f;
//    NSData *imageData1 = UIImageJPEGRepresentation(compressedImage1, compression1);
//    while ([imageData1 length] > kb && compression1 > maxCompression1) {
//        compression1 -= 0.01;
//        imageData1 = UIImageJPEGRepresentation(compressedImage1, compression1);
//        NSLog(@"第二%lu",(unsigned long)[imageData length]);
//    }
    
    
    //UIImage *compressedImage = [UIImage imageWithData:imageData1];
     NSLog(@"imageData大小:%fkb",(float)[imageData length]/1024.0f);
    //NSLog(@"imageData1大小:%fkb",(float)[imageData1 length]/1024.0f);
    return imageData;
    
    
    
}


@end

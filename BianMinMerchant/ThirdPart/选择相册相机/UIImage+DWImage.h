//
//  UIImage+DWImage.h
//  DWduifubao
//
//  Created by kkk on 16/9/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DWImage)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//截取当前image对象rect区域内的图像
+ (UIImage *)subimageInRect:(UIImage *)image rect:(CGRect)rect;

//压缩图片至指定尺寸,会变形
+ (UIImage *)scaleImageNotKeepingRatio:(UIImage *)image targetSize:(CGSize)targetSize;

//压缩图片至指定像素点
+ (UIImage *)scaleImageAtPixel:(UIImage *)image pixel:(CGFloat)pixel;

//在指定的size里面生成一个  平铺的图片
+ (UIImage *)tiledImage:(UIImage *)image targetSize:(CGSize)targetSize;

//UIView转化为UIImage
+ (UIImage *)imageWithView:(UIView *)view;

//将两张图片生成一张
+ (UIImage *)mergeImage:(UIImage *)image otherImage:(UIImage *)otherImage;

//不变形拉伸
+ (UIImage *)scaleImageKeepingRatio:(UIImage *)image targetSize:(CGSize)targetSize;
//压缩图片至指定大小kb
+(NSData * )scaleImage:(UIImage *)image toKb:(NSInteger)kb;
@end

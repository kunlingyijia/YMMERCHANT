//
//  DWTools.h
//  BianMin
//
//  Created by z on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWTools : NSObject

//获取版本号
+ (NSString *)getXKVersion;

//获取编译版本号
+ (NSString *)getXKBuildVersion;

//版本比对, 版本号格式  1.0.0    主版本.副版本.小版本
+ (BOOL)compareHasNewVersion:(NSString *)compareVerion;

//获取网络状态
//+ (void)getNetworkReachabilityStatus:(XKNetworkStatus)block;


@end

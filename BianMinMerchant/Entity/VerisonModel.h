//
//  VerisonModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerisonModel : NSObject
///os
@property (nonatomic, assign) int os;
///最新版本
@property (nonatomic, strong) NSString *versionName ;
///下载链接
@property (nonatomic, strong) NSString *downloadUrl ;
///安装包大小
@property (nonatomic, strong) NSString *packageSize ;
///更新时间
@property (nonatomic, strong) NSString *createTime	 ;
///版本更新 内容
@property (nonatomic, strong) NSString *content ;
///1-用户app，2-商户app
@property (nonatomic, strong) NSString *type ;
///是否强制更新：0-否  1-是
@property (nonatomic, strong) NSString *isMustUpdate ;








@end

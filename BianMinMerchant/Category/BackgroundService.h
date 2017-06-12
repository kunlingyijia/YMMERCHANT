//
//  BackgroundService.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RequestMerchantInfoModel;
typedef void (^MySelf)();

@interface BackgroundService : NSObject
///myself
@property (nonatomic, copy) MySelf  myself ;
@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;
///获取商家资料
+(void)requestPushVC:(BaseViewController*)VC MyselfAction:(MySelf)myself;

+(void)requestDriverInfoPushVC:(BaseViewController*)VC MyselfAction:(MySelf)myself;
@end

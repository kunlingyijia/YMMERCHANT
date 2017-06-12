//
//  RequestMerchantApply.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantApply : NSObject

@property (nonatomic, assign) NSInteger merchantType;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger regionId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger industry;//1-普通 2-便民 3-出行



///区域名称
@property (nonatomic, strong) NSString  *regionName ;
///省份名称
@property (nonatomic, strong) NSString  *provinceName ;
///城市名称
@property (nonatomic, strong) NSString  *cityName ;








@end

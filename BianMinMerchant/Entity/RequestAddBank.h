//
//  RequestAddBank.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestAddBank : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankAccount;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger regionId;
///省名称
@property (nonatomic, strong) NSString  *provinceName ;
///市名称

@property (nonatomic, strong) NSString  *cityName ;
///bankBranch
@property (nonatomic, strong) NSString  *bankBranch ;


@end

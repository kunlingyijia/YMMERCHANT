//
//  RequestUpdateCoupon.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUpdateCoupon : NSObject

@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, copy) NSString *couponContent;
@property (nonatomic, copy) NSString * storeAmount;
@property (nonatomic, copy) NSString * lValue;
@property (nonatomic, copy) NSString * dValue;
@property (nonatomic, copy) NSString * mPrice;
@property (nonatomic, copy) NSString * mVaule;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@end

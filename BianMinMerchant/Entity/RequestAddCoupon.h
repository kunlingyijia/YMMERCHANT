//
//  RequestAddCoupon.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestAddCoupon : NSObject

@property (nonatomic, assign) NSInteger couponType;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, copy) NSString *couponContent;
@property (nonatomic, copy) NSString * storeAmount;
@property (nonatomic, copy) NSString *beginTime;




@property (nonatomic, copy) NSString *endTime;
///满减券，多少满减。 （可选）
@property (nonatomic, copy) NSString * mPrice;
///满减的额度，满减券
@property (nonatomic, copy) NSString * mVaule;
///立减多少钱. 立减券（可选）
@property (nonatomic, copy) NSString * lValue;
///折扣，10 表示 1折扣。 折扣券
@property (nonatomic, copy) NSString * dValue;
@end

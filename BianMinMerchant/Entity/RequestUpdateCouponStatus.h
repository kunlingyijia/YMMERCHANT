//
//  RequestUpdateCouponStatus.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUpdateCouponStatus : NSObject

@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, copy) NSString *status;

@end

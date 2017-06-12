//
//  RequestUpdateCouponStore.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUpdateCouponStore : NSObject

@property (nonatomic,copy) NSString *couponId;
@property (nonatomic,assign) NSInteger storeAmount;

@end

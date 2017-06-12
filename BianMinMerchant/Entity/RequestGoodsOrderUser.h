//
//  RequestGoodsOrderUser.h
//  BianMinMerchant
//
//  Created by kkk on 16/7/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestGoodsOrderUser : NSObject
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *couponNo;




///订单Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderId ;
///团购券Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderCouponId ;

@end

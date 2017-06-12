//
//  RequestRefundOrderStatus.h
//  BianMinMerchant
//
//  Created by kkk on 16/7/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestRefundOrderStatus : NSObject

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *refuseReason;
///订单Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderId ;



@end

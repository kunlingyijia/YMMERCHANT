//
//  RequestBminDeelOrder.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBminDeelOrder : NSObject

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, assign) NSInteger status;//1-接单，2-上门服务,4-帮取消订单,5-商家拒单
///订单Id(新增)
@property (nonatomic, strong) NSString  *bminOrderId ;


@end

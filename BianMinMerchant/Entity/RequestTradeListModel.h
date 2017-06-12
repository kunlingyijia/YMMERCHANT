//
//  RequestTradeListModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestTradeListModel : NSObject

@property (nonatomic , assign) NSInteger status;//0-未付款  1-已付款  2-退款中  3-等待评价   4-已经退款  5-取消订单 6-已完成
@property (nonatomic , assign) NSInteger orderId;
@property (nonatomic , assign) CGFloat payAmount;
@property (nonatomic , assign) NSInteger payType;//1-支付宝 2-微信支付
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *mobile;
///订单Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderId ;


@end

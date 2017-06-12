//
//  RequestMyBminorderDetailModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMyBminorderDetailModel : NSObject

@property (nonatomic, assign) NSInteger status;//0-已预约(未接单),1-已接单(未上门),2-待支付(已上门),3-已完成,4-取消订单
@property (nonatomic, assign) NSInteger payType;//1-支付宝 2-微信支付 3-优惠券支付 4-线下支付
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *bminOrderId;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *bminServiceNameList;
@property (nonatomic, copy) NSString *bookingStartTime;
@property (nonatomic, copy) NSString *bookingEndTime;
@property (nonatomic, copy) NSString *urgeNumber;
@property (nonatomic, copy) NSString *lastUrgeTime;
@property (nonatomic, copy) NSString *content;
///订单Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderId ;


@end

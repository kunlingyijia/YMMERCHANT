//
//  RequestBminorderListModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBminorderListModel : NSObject

@property (nonatomic, copy) NSString *bminOrderId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *bookingStartTime;
@property (nonatomic, copy) NSString *bookingEndTime;
//0-已预约(未接单),1-已接单(未上门),2-待支付(已上门),3-已完成,4-取消订单(商家已接单可帮取消)，5-商家拒接接单（未接单时）
@property (nonatomic, assign) NSInteger status;

///参考价
@property (nonatomic, strong) NSString  *price ;

///	[｛bminServiceId:1,,price:100｝,｛bminServiceId:1,serviceName:补胎,price:100｝]	服务项目
@property (nonatomic, strong) NSArray  *bminServiceList ;
///
@property (nonatomic, strong) NSString  *serviceName ;
///项目id
@property (nonatomic, strong) NSString  *bminServiceId ;
///实际金额
@property (nonatomic, strong) NSString  *payAmount ;
///备注
@property (nonatomic, strong) NSString  *content ;
///预定时间（新增）
@property (nonatomic, strong) NSString  *bookingTime ;
///下单时间
@property (nonatomic, strong) NSString  *createTime ;


///催单次数
@property (nonatomic, strong) NSString  *urgeNumber ;

///最后催单时间
@property (nonatomic, strong) NSString  *lastUrgeTime ;

///纬度（新增）
@property (nonatomic, assign) double lat;

///经度（新增）
@property (nonatomic, assign) double lng	;

///0-不支持，1-支持
@property (nonatomic, strong) NSString  *isOpenGPSService;























@end

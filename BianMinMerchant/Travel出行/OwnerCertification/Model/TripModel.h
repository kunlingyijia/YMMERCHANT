//
//  TripModel.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripModel : NSObject
///出发地 纬度
@property (nonatomic, strong) NSString  *startPlaceLat ;
///出发地 经度
@property (nonatomic, strong) NSString  *startPlaceLng ;
///出发地
@property (nonatomic, strong) NSString  *startPlace ;
///可提供座位数量
@property (nonatomic, strong) NSString  *seatNumber ;
///发车时间:HH:II
@property (nonatomic, strong) NSString  *time ;
///发车时间:YYYY-MM-DD
@property (nonatomic, strong) NSString  *date ;
///每座价格
@property (nonatomic, strong) NSString  *price ;
///目的地 纬度
@property (nonatomic, strong) NSString  *endPlaceLat ;
///目的地 经度
@property (nonatomic, strong) NSString  *endPlaceLng ;
///目的地
@property (nonatomic, strong) NSString  *endPlace ;
///行程状态：1-待发布，2-已发布 ，3-待发车,4-已发车 ，5-已结束 订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
@property (nonatomic, strong) NSString  *status ;
///路线id
@property (nonatomic, strong) NSString  *planId ;

///已经预约的人数
@property (nonatomic, strong) NSString  *bookNumber ;
///1-待上车，2-已上车
@property (nonatomic, strong) NSString  *orderStatus ;
///联系电话
@property (nonatomic, strong) NSString  *tel	 ;

///联系名字
@property (nonatomic, strong) NSString  *name ;

///	下单时间
@property (nonatomic, strong) NSString  *createTime ;
///订单id
@property (nonatomic, strong) NSString  *orderId;
///订单号
@property (nonatomic, strong) NSString  *orderNo ;
///备注
@property (nonatomic, strong) NSString  *remark ;
///4/6座

@property (nonatomic, strong) NSString  *bookSeat ;

///预定情况描述
@property (nonatomic, strong) NSString  *bookSeatDesc ;

/// 待上车人数
@property (nonatomic, strong) NSString  *notAboardNumber ;


	


	



@end

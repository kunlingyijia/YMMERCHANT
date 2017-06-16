//
//  RequestMerchantInfoModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/7/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantInfoModel : NSObject
///商户类型:1-团购 2-便民 3-出行（新增）
@property (nonatomic, strong) NSString  *industry ;
@property (nonatomic, copy) NSString *merchantNo;
@property (nonatomic, copy) NSString *merchantName;
//商户状态 1-正常 2-待补全质料,3-待审核
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) CGFloat tradeMoneyDay;

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, strong) NSString* iconUrl;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString* merchantCategoryId;
@property (nonatomic, copy) NSString* businessAreaId;

@property (nonatomic, assign) NSInteger haveWifi;
@property (nonatomic, assign) NSInteger havaNoSmokingRoom;
@property (nonatomic, assign) NSInteger havaAirCondition;
@property (nonatomic, assign) NSInteger haveParking;
@property (nonatomic, assign) NSInteger have24hourWater;

@property (nonatomic, copy) NSString *content;

///线上账户余额
@property (nonatomic, strong) NSString  *onlineAccount;
///账户余额(新增)
@property (nonatomic, strong) NSString  *account ;
///便民商户才有：线下账户(新增)
@property (nonatomic, strong) NSString  *offlineAccount	 ;
///商户总服务费账户(新增)
@property (nonatomic, strong) NSString  *serviceFeeAccount ;
///推送别名（新增）
@property (nonatomic, strong) NSString  *pushAlias;


///营业开始时间
@property (nonatomic, strong) NSString  *openStartTime ;
///营业结束时间
@property (nonatomic, strong) NSString  *openEndTime ;


@property (nonatomic, strong) id images;
///开通行业抵用券  1-未开通, 2-开通中,3-开通失败, 4-已开通, 5-暂停业务
@property (nonatomic, strong) NSString  *industryCouponStatus ;
///行业抵用券业务原因
@property (nonatomic, strong) NSString  *industryCouponRefuseReason ;







@end

//
//  RequestMerchantCompleteInfo.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/24.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantCompleteInfo : NSObject

@property (nonatomic, copy) NSString* merchantCategoryId;
@property (nonatomic, copy) NSString* businessAreaId;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, assign) NSInteger haveWifi;
@property (nonatomic, assign) NSInteger havaNoSmokingRoom;
@property (nonatomic, assign) NSInteger havaAirCondition;
@property (nonatomic, assign) NSInteger haveParking;
@property (nonatomic, assign) NSInteger have24hourWater;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double lat;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) NSString* provinceId;
@property (nonatomic, assign) NSString* cityId;
@property (nonatomic, assign) NSString* regionId;
///营业开始时间
@property (nonatomic, strong) NSString  *openStartTime ;
///营业结束时间
@property (nonatomic, strong) NSString  *openEndTime ;

///area
@property (nonatomic, strong) NSString  *area ;




@end

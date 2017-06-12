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
///行程状态：1-待发布，2-已发布 ，3-待发车,4-已发车 ，5-已结束
@property (nonatomic, strong) NSString  *status ;






@end

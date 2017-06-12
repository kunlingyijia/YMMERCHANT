//
//  RequestGetCouponUserList.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestGetCouponUserList : NSObject

@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;


@end

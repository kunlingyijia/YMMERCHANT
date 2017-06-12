//
//  GetCouponUserListModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetCouponUserListModel : NSObject

@property (nonatomic ,copy) NSString *couponName;
@property (nonatomic ,assign) NSInteger couponType;
@property (nonatomic ,assign) NSInteger status;
@property (nonatomic ,assign) NSInteger userId;
@property (nonatomic ,copy) NSString *userTime;
@property (nonatomic ,copy) NSString *createTime;
@property (nonatomic ,copy) NSString *userName;
@property (nonatomic ,copy) NSString *mobile;
@property (nonatomic ,copy) NSString *avatarUrl;
@end

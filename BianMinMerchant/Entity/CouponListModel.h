//
//  CouponListModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponListModel : NSObject

@property (nonatomic, assign) NSInteger couponType;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, copy) NSString *couponContent;
@property (nonatomic, assign) NSInteger storeAmount;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString * mPrice;
@property (nonatomic, copy) NSString * mVaule;
@property (nonatomic, copy) NSString * lValue;
@property (nonatomic, assign) NSInteger  dValue;
@property (nonatomic, assign) NSInteger  status;
@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, assign) NSInteger couRecNum;
@property (nonatomic, assign) NSInteger couUseNum;
///是否编辑：0-否，1-是（新增）
@property (nonatomic, strong) NSString  *isEdit	 ;




@end

//
//  IndustryModel.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface IndustryModel : NSObject
///申请总面额/总面额
@property (nonatomic, strong) NSString  *totalFaceAmount	 ;
///有效期起
@property (nonatomic, strong) NSString  *beginTime;
///有效期止
@property (nonatomic, strong) NSString  *endTime;
///面额id
@property (nonatomic, strong) NSString  *faceId ;
///1-待审核 , 2-审核失败(可删除)，3-审核通过 ，4-已过期/	1-已发放, 2-已取消, 3-已过期, 4-已结束
@property (nonatomic, strong) NSString  *status ;
///余额
@property (nonatomic, strong) NSString  *balanceFaceAmount ;
///行业抵用券id
@property (nonatomic, strong) NSString  *industryCouponId ;
///面额
@property (nonatomic, strong) NSString  *faceAmount ;
///发放对象名称/面额
@property (nonatomic, strong) NSString  *name ;
///领取数量
@property (nonatomic, strong) NSString  *receiveNumber ;
///满xx元可用
@property (nonatomic, strong) NSString  *limitAmount ;
///发放数量
@property (nonatomic, strong) NSString  *stock ;
///目标车行id
@property (nonatomic, strong) NSString  *companyId ;
///车行名称
@property (nonatomic, strong) NSString  *companyName ;
///值
@property (nonatomic, strong) NSString  *value ;
///审核不通过的原因
@property (nonatomic, strong) NSString  *refuseReason;
///名称:NO.1001
@property (nonatomic, strong) NSString  *no ;
///行业劵id
@property (nonatomic, strong) NSString  *receiveId ;




@end

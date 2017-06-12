//
//  TravelBanckModel.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelBanckModel : NSObject
///绑定id
@property (nonatomic, strong) NSString  *bankId ;
///	张三	string	开户人
@property (nonatomic, strong) NSString  *name ;
///中国银行	string	开户银行
@property (nonatomic, strong) NSString  *bankName ;
///银行卡号
@property (nonatomic, strong) NSString  *bankAccount ;
///创建时间
@property (nonatomic, strong) NSString  *createTime ;
///市名称
@property (nonatomic, strong) NSString  *cityName ;
///	市
@property (nonatomic, strong) NSString  *cityId ;
///省名称
@property (nonatomic, strong) NSString  *provinceName ;
///int	省份
@property (nonatomic, strong) NSString  *provinceId ;
///支行名称
@property (nonatomic, strong) NSString  *bankBranch ;
///流水号
@property (nonatomic, strong) NSString  *flowId ;

///提现金额
@property (nonatomic, strong) NSString  *amount ;

///提现状态:1-待审核，2-待打款(审核通过)，3-已打款，4-审核不通过（需要备注）//1- 审核中，2-审核通过，3-审核不通过（新增）
@property (nonatomic, strong) NSString  *status ;
///	提现金额,>=50可提

@property (nonatomic, strong) NSString  *Intamount ;
///拒绝原因（新增）
@property (nonatomic, strong) NSString  *refuseReason ;







	






@end

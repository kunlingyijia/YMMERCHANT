//
//  CashAccountModel.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/5/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CashAccountModel : NSObject
///流水号
@property (nonatomic, strong) NSString  *flowId ;
///0-全部，1-收入，2-支出
@property (nonatomic, strong) NSString  *type	 ;
///金额
@property (nonatomic, strong) NSString  *amount ;
///1-订单收益，2-服务费，3- 利润提成 ，4-提现
@property (nonatomic, strong) NSString  *amountType ;
///描述
@property (nonatomic, strong) NSString  *remark ;
///时间
@property (nonatomic, strong) NSString  *createTime ;


@end

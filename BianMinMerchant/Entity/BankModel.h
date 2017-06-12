//
//  BankModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject

@property (nonatomic, assign) NSInteger bankId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankAccount;
@property (nonatomic, copy) NSString *createTime;

@end

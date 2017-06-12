//
//  TravelwithdrawalVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface TravelwithdrawalVC : BaseViewController
///余额
@property (nonatomic, strong) NSString  *account ;
@property (nonatomic, copy) void(^ TravelwithdrawalVCBlock)();

@end

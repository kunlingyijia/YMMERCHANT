//
//  ChooseCarListVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseCarListVC : BaseViewController
	
@property (nonatomic, copy) void(^ ChooseCarListVCBlock)(NSString *companyId,NSString *companyName);
@end

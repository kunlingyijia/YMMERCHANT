//
//  AddIndustryVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface AddIndustryVC : BaseViewController
@property (nonatomic, copy) void(^ AddIndustryVCBlock)(NSString*balanceFaceAmount);
@property (weak, nonatomic) IBOutlet UIButton *companyNameBtn;

///发放数量
@property (weak, nonatomic) IBOutlet UITextField *nstockTF;
///面额
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UITextField *limitAmount;

@property (weak, nonatomic) IBOutlet UIButton *beginTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@end

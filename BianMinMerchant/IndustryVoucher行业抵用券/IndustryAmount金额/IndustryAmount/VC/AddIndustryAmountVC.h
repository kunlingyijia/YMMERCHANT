//
//  AddIndustryAmountVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class IndustryModel;
@interface AddIndustryAmountVC : BaseViewController
@property (nonatomic, copy) void(^ AddIndustryAmountVCBlock)();
@property (weak, nonatomic) IBOutlet UIView *refuseReasonView;
@property (weak, nonatomic) IBOutlet UILabel *refuseReason;
@property (weak, nonatomic) IBOutlet UITextField *totalFaceAmount;
///开始时间
@property (weak, nonatomic) IBOutlet UIButton *beginTime;
///结束时间
@property (weak, nonatomic) IBOutlet UIButton *endTime;
///
@property (nonatomic, strong) IndustryModel  * model;
@end

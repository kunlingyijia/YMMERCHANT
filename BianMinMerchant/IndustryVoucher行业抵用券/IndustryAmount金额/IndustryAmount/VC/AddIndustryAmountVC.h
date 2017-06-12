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
@property (weak, nonatomic) IBOutlet UIView *refuseReasonView;

@property (weak, nonatomic) IBOutlet UILabel *refuseReason;
@property (weak, nonatomic) IBOutlet UITextField *totalFaceAmount;

@property (weak, nonatomic) IBOutlet UIButton *beginTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
///
@property (nonatomic, strong) IndustryModel  * model;
@end

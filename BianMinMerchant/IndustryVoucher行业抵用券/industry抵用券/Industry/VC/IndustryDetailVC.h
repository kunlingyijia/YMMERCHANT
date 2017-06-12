//
//  IndustryDetailVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface IndustryDetailVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *companyNameBtn;
///发放数量
@property (weak, nonatomic) IBOutlet UITextField *nstockTF;
///面额
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UITextField *limitAmount;

@property (weak, nonatomic) IBOutlet UIButton *beginTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UITextField *status;
@property (weak, nonatomic) IBOutlet UITextField *receiveNumber;



@end

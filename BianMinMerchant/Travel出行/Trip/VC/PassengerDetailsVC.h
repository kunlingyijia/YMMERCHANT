//
//  PassengerDetailsVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class TripModel;
@interface PassengerDetailsVC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UITextField *startPlace;
@property (weak, nonatomic) IBOutlet UITextField *endPlace;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *orderNo;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *createTime;
@property (weak, nonatomic) IBOutlet UITextField *status;

@property (weak, nonatomic) IBOutlet UILabel *remark;

///planId
@property (nonatomic, strong) NSString* orderIdStr;






@end

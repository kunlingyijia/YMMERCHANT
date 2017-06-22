//
//  IndustryListVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class IndustryModel;
@interface IndustryListVC : BaseViewController
@property (nonatomic, copy) void(^ IndustryListVCBlock)();
@property (weak, nonatomic) IBOutlet UILabel *balanceFaceAmount;
///
@property (nonatomic, strong) IndustryModel  *model;
@end

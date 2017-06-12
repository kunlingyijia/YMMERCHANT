//
//  LoginController.h
//  BianMinMerchant
//
//  Created by kkk on 16/5/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (nonatomic, copy) NSString *shopKind;
@property (nonatomic, assign) NSInteger industry;
@end

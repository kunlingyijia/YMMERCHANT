//
//  AddStaffViewController.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "RequestMerchantEmployeeListModel.h"
@interface AddStaffViewController : BaseViewController

@property (nonatomic, copy)void(^backBlockAction)(NSString *str);
@property (nonatomic, strong) RequestMerchantEmployeeListModel *model;
@property (nonatomic, assign) NSInteger isNewC;
@end
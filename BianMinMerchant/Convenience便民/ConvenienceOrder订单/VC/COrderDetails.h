//
//  COrderDetails.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@interface COrderDetails : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *RightBtn;
@property (weak, nonatomic) IBOutlet UIButton *LeftBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BtnConstraintHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy)void(^backBlockAction)(NSString *str);
@property (nonatomic, copy) NSString *orderNo;
///bminOrderId
@property (nonatomic, strong) NSString  *bminOrderId;
@end

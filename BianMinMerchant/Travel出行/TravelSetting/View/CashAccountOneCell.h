//
//  CashAccountOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/5/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CashAccountModel;
@interface CashAccountOneCell : UITableViewCell
///model
@property (nonatomic, strong) CashAccountModel *model ;

@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@end

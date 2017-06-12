//
//  StaffViewCell.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMerchantEmployeeListModel.h"
@interface StaffViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)cellGetData:(RequestMerchantEmployeeListModel *)model;

@end

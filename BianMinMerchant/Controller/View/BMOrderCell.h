//
//  BMOrderCell.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/18.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestBminorderListModel.h"
@interface BMOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (void)cellGetDataWithModel:(RequestBminorderListModel *)model;

@end

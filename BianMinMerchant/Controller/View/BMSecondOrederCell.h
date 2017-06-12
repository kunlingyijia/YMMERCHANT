//
//  BMSecondOrederCell.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/18.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestBminorderListModel.h"
@interface BMSecondOrederCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *adressL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;

- (void)cellGetDataWithModel:(RequestBminorderListModel *)model;

@end

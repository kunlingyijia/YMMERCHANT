//
//  IndustryAmountLIstOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndustryModel;
@interface IndustryAmountLIstOneCell : UITableViewCell
///model
@property (nonatomic, strong) IndustryModel *model ;
@property (weak, nonatomic) IBOutlet UILabel *no;

@property (weak, nonatomic) IBOutlet UILabel *totalFaceAmount;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeAndendTime;


@end

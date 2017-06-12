//
//  TravelwithdrawalTwoCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TravelBanckModel;
@interface TravelwithdrawalTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankAccount;
-(void)CellGetData:(TravelBanckModel*)model;
@end

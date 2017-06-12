//
//  TravelwithdrawalListCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TravelBanckModel;
@interface TravelwithdrawalListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *status;
-(void)CellGetData:(TravelBanckModel*)model;
@end

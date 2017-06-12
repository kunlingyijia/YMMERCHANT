//
//  COrderDetailsFourCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestBminorderListModel;

@interface COrderDetailsFourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *payAmount;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *urgeNumber;
@property (weak, nonatomic) IBOutlet UILabel *lastUrgeTime;

@property (nonatomic, strong) RequestBminorderListModel  *model ;
@end

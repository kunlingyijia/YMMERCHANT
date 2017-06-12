//
//  COrderDetailsTwoCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestBminorderListModel;
@interface COrderDetailsTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *price;
///RequestBminorderListModel
@property (nonatomic, strong) RequestBminorderListModel  *model ;
@end

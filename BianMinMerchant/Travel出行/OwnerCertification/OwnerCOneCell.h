//
//  OwnerCOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OwnerModel;
@interface OwnerCOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *refuseReason;
-(void)CellgetData:(OwnerModel*)model;

@end

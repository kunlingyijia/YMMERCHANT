//
//  TravelSetThreeCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OwnerModel;
@interface TravelSetThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *status;
-(void)CellgetData:(OwnerModel*)model;
@end

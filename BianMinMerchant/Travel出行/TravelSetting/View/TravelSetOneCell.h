//
//  TravelSetOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OwnerModel;
@interface TravelSetOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carNo;
@property (weak, nonatomic) IBOutlet UIImageView *avatarUrl;
-(void)CellgetData:(OwnerModel*)model;
@end

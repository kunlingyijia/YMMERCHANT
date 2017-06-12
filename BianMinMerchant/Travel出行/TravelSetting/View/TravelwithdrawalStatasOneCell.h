//
//  TravelwithdrawalStatasOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TravelBanckModel;
@interface TravelwithdrawalStatasOneCell : UITableViewCell
///TravelBanckModel
@property (nonatomic, strong) TravelBanckModel  *model ;


@property (weak, nonatomic) IBOutlet UIImageView *RightImage;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *LeftImage;

@end

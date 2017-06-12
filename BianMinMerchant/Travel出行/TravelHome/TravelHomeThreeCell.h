//
//  TravelHomeThreeCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TripModel;
@interface TravelHomeThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeAndSeatNumber;
-(void)CellGetData:(TripModel*)model;
@end

//
//  TripDetailsOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/15.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TripModel;
@interface TripDetailsOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *startPlace;
@property (weak, nonatomic) IBOutlet UITextField *endPlace;
@property (weak, nonatomic) IBOutlet UITextField *dateAndTime;
@property (weak, nonatomic) IBOutlet UITextField *seatNumber;
@property (weak, nonatomic) IBOutlet UIButton *LeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *RightBtn;
-(void)CellGetData:(TripModel*)model;
@end

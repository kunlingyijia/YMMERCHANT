//
//  ReleaseTripVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/15.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class TripModel;
@interface ReleaseTripVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *seatNumber;
@property (weak, nonatomic) IBOutlet UITextField *startPlace;
@property (weak, nonatomic) IBOutlet UITextField *endPlace;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *AllPrice;




@property(nonatomic,strong)TripModel *tripModel;
@end

//
//  AddTripVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/12.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class TripModel;
typedef void(^ReturnAddTripVC1)(TripModel*tripModel);
@interface AddTripVC1 : BaseViewController
///Block属性 传值一
@property(nonatomic,copy) ReturnAddTripVC1 returnAddTripVC1;
//block 传值 二  block 作为方法参数传值

-(void)ReturnAddTripVC1:(ReturnAddTripVC1)block;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *seatNumber;
@property (weak, nonatomic) IBOutlet UITextField *startPlace;
@property (weak, nonatomic) IBOutlet UITextField *endPlace;
@property (weak, nonatomic) IBOutlet UITextField *price;
///属性传值
@property (nonatomic, strong) TripModel  *tripModel ;
///titleStr
@property (nonatomic, strong) NSString  *titleStr;




@end

//
//  TicketMessageController.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface TicketMessageController : BaseViewController

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, copy)void(^balkTicket)(NSString *str);

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *startTimeL;
@property (weak, nonatomic) IBOutlet UILabel *endTimeL;
@property (weak, nonatomic) IBOutlet UILabel *storeNum;

@end

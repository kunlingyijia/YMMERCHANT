//
//  AddTicketViewController.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class CouponInfoModel;
typedef enum : NSUInteger {
    fullTicket,//满减券
    erectTicket,//立减券
    discountTicket,//折扣券
} TicketKind;


@interface AddTicketViewController : BaseViewController

//标识是那种券
@property (nonatomic, assign) TicketKind ticketKind;
@property (nonatomic, copy)void(^balkAction)(NSString *);
@property (nonatomic, copy)void(^settingBlock)(NSString *);
//标识是添加信息还是修改信息
@property (nonatomic, assign) BOOL isAddMessage;
@property (nonatomic, strong) CouponInfoModel *model;
@property (nonatomic, copy) NSString *coundID;


@end

//
//  BindBankCardViewController.h
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class TravelBanckModel;
@interface BindBankCardViewController : BaseViewController

@property (nonatomic, copy)void(^backBlock)(NSString *str);
@property(nonatomic,strong)TravelBanckModel* travelBanckModel;
@end

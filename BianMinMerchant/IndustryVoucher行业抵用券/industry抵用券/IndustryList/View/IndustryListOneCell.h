//
//  IndustryListOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndustryModel;
@interface IndustryListOneCell : UITableViewCell
///model
@property (nonatomic, strong) IndustryModel *model ;
@property (weak, nonatomic) IBOutlet UIView *LeftView;
///符号
@property (weak, nonatomic) IBOutlet UILabel *symbol;
@property (weak, nonatomic) IBOutlet UILabel *faceAmount;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *receiveNumberAndstock;
@property (weak, nonatomic) IBOutlet UILabel *limitAmount;

@property (weak, nonatomic) IBOutlet UILabel *beginTimeAndendtime;

@end

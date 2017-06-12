//
//  BuyMessageCell.h
//  0803
//
//  Created by 月美 刘 on 16/8/3.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestOrderListByGoodsModel.h"
@interface BuyMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *buyNum;
@property (weak, nonatomic) IBOutlet UILabel *orderMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

- (void)cellGetDataModel:(RequestOrderListByGoodsModel *)model withVC:(BaseViewController *)vc;

@end

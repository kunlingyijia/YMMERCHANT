//
//  BuyMessageCell.m
//  0803
//
//  Created by 月美 刘 on 16/8/3.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "BuyMessageCell.h"

@implementation BuyMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetDataModel:(RequestOrderListByGoodsModel *)model withVC:(BaseViewController *)vc {
    self.userName.text = [NSString stringWithFormat:@"用户名:%@", model.userName];
    self.phoneNum.text = [NSString stringWithFormat:@"手机号:%@", model.mobile];
    self.buyNum.text = [NSString stringWithFormat:@"购买数量:%@", model.goodsNumber];
    self.orderMoney.text = [NSString stringWithFormat:@"订单金额:%.2f", model.payAmount];
    self.orderNo.text = [NSString stringWithFormat:@"订单号:%@", model.orderNo];
    self.createTime.text = [NSString stringWithFormat:@"创建时间:%@", model.createTime];
}

@end

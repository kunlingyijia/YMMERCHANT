//
//  MessageCenterCell.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MessageCenterCell.h"
#import "RequestTradeListModel.h"
@implementation MessageCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.agreeBtn.layer.borderColor = [UIColor colorWithHexString:kSubTitleColor].CGColor;
    self.agreeBtn.layer.borderWidth = 1;
    self.agreeBtn.layer.masksToBounds = YES;
    self.agreeBtn.layer.cornerRadius = 4;
    self.refuseBtn.layer.borderColor = [UIColor colorWithHexString:kSubTitleColor].CGColor;
    self.refuseBtn.layer.borderWidth = 1;
    self.refuseBtn.layer.masksToBounds = YES;
    self.refuseBtn.layer.cornerRadius = 4;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)agreeAction:(id)sender {
    self.agreeBackAction(self.orderModel.orderNo,self.orderModel.goodsOrderId);
    OKLog(@"同意退款");
}

- (IBAction)refuseAction:(id)sender {
    self.refuseBackAction(self.orderModel.orderNo,self.orderModel.goodsOrderId);
    OKLog(@"拒绝退款");
}

- (void)cellGetDataModel:(RequestTradeListModel *)model {
    self.orderModel = model;
    self.nameL.text = [NSString stringWithFormat:@"商品名称:%@", model.goodsName];
    self.userNamL.text = [NSString stringWithFormat:@"用户名:%@", model.userName];
    self.timeLabel.text = [NSString stringWithFormat:@"交易时间:%@", model.createTime];
    self.orderL.text = [NSString stringWithFormat:@"订单号:%@", model.orderNo];
    self.phoneNum.text = [NSString stringWithFormat:@"手机号:%@", model.mobile];
    self.moneyL.text = [NSString stringWithFormat:@"金额:%.2f", model.payAmount];
    switch (model.payType) {
        case 1:
            self.payType.text = @"支付方式:支付宝";
            break;
        case 2:
            self.payType.text = @"支付方式:微信";
            break;
        default:
            self.payType.text = @"支付方式:无";
            break;
    }
    
    if (model.status == 2) {
        self.lineView.hidden = NO;
        self.bgView.hidden = NO;
    }else {
        self.lineView.hidden = YES;
        self.bgView.hidden = YES;
    }
    
    
    switch (model.status) {
        case 0:
            self.isFinish.text = @"状态:未付款";
            break;
        case 1:
            self.isFinish.text = @"状态:已付款";
            break;
        case 2:
            self.isFinish.text = @"状态:退款中";
            break;
        case 3:
            self.isFinish.text = @"状态:等待评价";
            break;
        case 4:
            self.isFinish.text = @"状态:已经退款";
            break;
        case 5:
            self.isFinish.text = @"状态:取消订单";
            break;
        case 6:
            self.isFinish.text = @"状态:已完成";
            break;
        default:
            break;
    }
}
@end

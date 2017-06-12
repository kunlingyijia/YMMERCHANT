//
//  TicketListViewCell.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "TicketListViewCell.h"
#import "CouponListModel.h"
@implementation TicketListViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetDataWithModel:(CouponListModel *)model {
    if (model.couponType == 1) {
        
        self.nameLabel.text = [NSString stringWithFormat:@"满%.2f元,立减%.2f元", [model.mPrice floatValue] ,[model.mVaule floatValue]];
    }else if (model.couponType == 2) {
        self.nameLabel.text = [NSString stringWithFormat:@"下单立减%.2f元", [model.lValue floatValue]];
        
    }else {
        NSString * dValue =[NSString stringWithFormat:@"%ld", (long)(model.dValue)];
       
        self.nameLabel.text = [NSString stringWithFormat:@"本商品打%.2f折",  [dValue floatValue]/100.0];
    }
    self.goodsNameL.text = model.couponName;
    self.numberLabel.text = [NSString stringWithFormat:@"库存%ld件", (long)model.storeAmount];
    self.startTimeL.text = [NSString stringWithFormat:@"券有效期:%@", model.beginTime];
    self.endTimeL.text = [NSString stringWithFormat:@"发放期至:%@", model.endTime];
    self.alreadyUseL.text = [NSString stringWithFormat:@"已领用/已使用:%ld张/%ld张", (long)model.couRecNum, (long)model.couUseNum];
    self.couponId = model.couponId;
    NSLog(@"%ld", (long)model.status);
    switch (model.status) {
            
        case 1:
            self.status.text = @"已上架";
            [self.downBtn setTitle:@"下架" forState:UIControlStateNormal];
            self.status.textColor = [UIColor colorWithHexString:kNavigationBgColor];
            break;
        case 2:
            self.status.text = @"已下架";
            [self.downBtn setTitle:@"上架" forState:UIControlStateNormal];
            self.status.textColor = [UIColor colorWithHexString:kNavigationBgColor];
            
            break;
        case 3:
            self.status.text = @"已过期";
            self.status.textColor = [UIColor redColor];
            [self.downBtn setTitle:@"过期" forState:UIControlStateNormal];
            self.downBtn.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
}


- (IBAction)downAction:(id)sender {
    if ([self.downBtn.titleLabel.text isEqualToString:@"上架"]) {
        self.buyGoods(self.couponId, @"1");
    }else {
        self.buyGoods(self.couponId, @"2");
    }
    
}

- (IBAction)changeNumAction:(id)sender {
    self.changeNumber(self.couponId);
}

- (IBAction)detailAction:(id)sender {
    self.detailAction(self.couponId);
}

- (IBAction)deleteAction:(UIButton *)sender {
    self.deleteBlock(self.couponId);
}



@end

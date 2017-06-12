//
//  TravelwithdrawalListCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelwithdrawalListCell.h"
#import "TravelBanckModel.h"
@implementation TravelwithdrawalListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)CellGetData:(TravelBanckModel*)model{
    self.amount.text =model.amount;
    self.createTime.text = model.createTime;
    /////提现状态:1-待审核，2-待打款(审核通过)，3-已打款，4-审核不通过（需要备注）
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"待审核";
    }else if ([model.status isEqualToString:@"2"]) {
        self.status.text = @"待打款";
    }else if ([model.status isEqualToString:@"3"]) {
        self.status.text = @"已打款";
    }else if ([model.status isEqualToString:@"4"]) {
        self.status.text = @"已拒绝";
    }else{
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

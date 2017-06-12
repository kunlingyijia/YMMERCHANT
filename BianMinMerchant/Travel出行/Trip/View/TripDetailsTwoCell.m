//
//  TripDetailsTwoCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/15.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TripDetailsTwoCell.h"
#import "TripModel.h"
@implementation TripDetailsTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}
-(void)CellGetData:(TripModel*)model{
    self.name.text = model.name;
    self.tel.text = [NSString stringWithFormat:@"电话:%@ ",model.tel];
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"未支付";
    }else if ([model.status isEqualToString:@"2"]) {
        self.status.text = @"待上车";
    }else if ([model.status isEqualToString:@"3"]) {
        self.status.text = @"已上车";
    }else if ([model.status isEqualToString:@"4"]) {
        self.status.text = @"已完成";
    }else if ([model.status isEqualToString:@"5"]) {
        self.status.text = @"退款中";
    }else if ([model.status isEqualToString:@"6"]) {
        self.status.text = @"已退款";
    }else if ([model.status isEqualToString:@"7"]) {
        self.status.text = @"已取消";
    }else{
        
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

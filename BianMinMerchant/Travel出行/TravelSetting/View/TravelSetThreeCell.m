//
//  TravelSetThreeCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelSetThreeCell.h"
#import "OwnerModel.h"
@implementation TravelSetThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)CellgetData:(OwnerModel*)model{
    ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
    
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"未认证";
    }else if ([model.status isEqualToString:@"2"]) {
        self.status.text = @"审核中";
    }else if ([model.status isEqualToString:@"3"]) {
        self.status.text = @"已认证";
    }else if ([model.status isEqualToString:@"4"]) {
        self.status.text = @"认证失败";
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

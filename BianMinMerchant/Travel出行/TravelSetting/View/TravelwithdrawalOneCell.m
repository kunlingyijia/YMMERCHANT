//
//  TravelwithdrawalOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelwithdrawalOneCell.h"

@implementation TravelwithdrawalOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
 self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

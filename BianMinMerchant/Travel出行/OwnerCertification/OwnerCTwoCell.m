//
//  OwnerCTwoCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OwnerCTwoCell.h"

@implementation OwnerCTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.OKLabel.textColor = [UIColor colorWithHexString:kNavigationBgColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  TravelwithdrawalThreeCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelwithdrawalThreeCell.h"

@implementation TravelwithdrawalThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0);
    self.OneBtn.layer.masksToBounds = YES;
    self.OneBtn.layer.cornerRadius = 5;
    self.OneBtn.layer.borderWidth = 1;
    self.OneBtn.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

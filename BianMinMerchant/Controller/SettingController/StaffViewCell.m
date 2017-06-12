//
//  StaffViewCell.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "StaffViewCell.h"

@implementation StaffViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetData:(RequestMerchantEmployeeListModel *)model {
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.mobile;
    self.numberLabel.text = model.no;
    self.contentLabel.text = model.content;
}


@end

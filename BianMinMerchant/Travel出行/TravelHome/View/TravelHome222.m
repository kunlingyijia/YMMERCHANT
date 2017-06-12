//
//  TravelHome22.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelHome222.h"

@implementation TravelHome222

- (void)awakeFromNib {
    [super awakeFromNib];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.AddBtn.layer.masksToBounds = YES;
    self.AddBtn.layer.cornerRadius = 5;
    self.AddBtn.layer.borderWidth = 1;
    self.AddBtn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:204.0/255 blue:102.0/255 alpha:1.0].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

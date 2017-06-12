//
//  TravelHome23.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelHome233.h"

@implementation TravelHome233

- (void)awakeFromNib {
    [super awakeFromNib];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  GroupOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "GroupOneCell.h"

@implementation GroupOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.textColor = [UIColor colorWithHexString:@"#333333"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.label.textColor = [UIColor redColor];
    }else{
        self.label.textColor = [UIColor colorWithHexString:@"#333333"];
    }
}

@end

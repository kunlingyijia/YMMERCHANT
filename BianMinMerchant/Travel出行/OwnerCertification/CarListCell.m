//
//  CarListCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "CarListCell.h"

@implementation CarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    if (selected) {
        self.choseIma.hidden = NO;
    }else
    {
       self.choseIma.hidden = YES;
        
    }
}
@end

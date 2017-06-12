//
//  TravelSetOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelSetOneCell.h"
#import "OwnerModel.h"
@implementation TravelSetOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)CellgetData:(OwnerModel*)model{
    self.carNo.text = model.carNo;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

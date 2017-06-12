//
//  COrderDetailsTwoCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "COrderDetailsTwoCell.h"
#import "RequestBminorderListModel.h"
@implementation COrderDetailsTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)setModel:(RequestBminorderListModel *)model{
    _model = model;
    self.serviceName.text = model.serviceName;
    self.price.text = model.price;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

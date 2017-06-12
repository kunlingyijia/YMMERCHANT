//
//  GDPoiCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/13.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "GDPoiCell.h"

@implementation GDPoiCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)cellGetData:(AMapPOI*)model{
    _name.text = model.name;
    _address.text = model.address;
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

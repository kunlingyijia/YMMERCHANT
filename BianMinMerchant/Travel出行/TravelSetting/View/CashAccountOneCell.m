//
//  CashAccountOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/5/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "CashAccountOneCell.h"
#import "CashAccountModel.h"
@implementation CashAccountOneCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    //self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
   // self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(CashAccountModel *)model{
    if (!model) return;
    _model = model;
    _remark.text = model.remark;
    _amount.text= model.amount;
    _createTime.text = model.createTime;
    
}
@end


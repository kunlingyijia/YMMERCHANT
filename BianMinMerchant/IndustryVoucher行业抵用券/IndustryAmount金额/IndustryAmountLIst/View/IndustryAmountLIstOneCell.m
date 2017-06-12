//
//  IndustryAmountLIstOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryAmountLIstOneCell.h"
#import "IndustryModel.h"
@implementation IndustryAmountLIstOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(IndustryModel *)model{
    if (!model) return;
    _model = model;
    _totalFaceAmount.text = [NSString stringWithFormat:@"总金额: %@元",model.totalFaceAmount];
    ///1-审核中  2-审核通过，3-审核失败(可删除) ，4-已过期
    if ([model.status isEqualToString:@"1"]) {
        _status.text  = @"审核中";
    }
    if ([model.status isEqualToString:@"2"]) {
        _status.text  = @"审核通过";
    }
    if ([model.status isEqualToString:@"3"]) {
        _status.text  = @"审核失败";
    }
    if ([model.status isEqualToString:@"4"]) {
        _status.text  = @"已过期";
    }
    _beginTime.text = [NSString stringWithFormat:@"有效期: 起%@",model.beginTime];
    _endTime.text = [NSString stringWithFormat:@"有效期: 止%@",model.endTime];
    
}
@end

//
//  IndustryListOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryListOneCell.h"
#import "IndustryModel.h"
@implementation IndustryListOneCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
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
    _faceAmount.text = model.faceAmount;
    _name.text = model.name;
    _receiveNumberAndstock.text =[NSString stringWithFormat:@"已领取%@/%@张", model.receiveNumber,model.stock];
    _limitAmount.text = model.limitAmount;
    _beginTimeAndendtime.text =[NSString stringWithFormat:@"有效期: %@至%@", model.beginTime,model.endTime];
        //status		string	1-已发放, 2-已取消, 3-已过期, 4-已结束
    if ([model.status isEqualToString:@"1"]) {
        _status.text = @"已发放";
        _LeftView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
        _symbol.textColor = [UIColor redColor];
        _faceAmount.textColor = [UIColor redColor];
        _name.textColor = [UIColor blackColor];
        _status.textColor = [UIColor orangeColor];
    }else{
        _LeftView.backgroundColor = [UIColor lightGrayColor];
        _symbol.textColor = [UIColor lightGrayColor];
        _faceAmount.textColor = [UIColor lightGrayColor];
        _name.textColor = [UIColor lightGrayColor];
        _status.textColor = [UIColor lightGrayColor];

    }
    if ([model.status isEqualToString:@"2"]) {
        _status.text = @"已取消";
    }
    if ([model.status isEqualToString:@"3"]) {
        _status.text = @"已过期";
    }
    if ([model.status isEqualToString:@"4"]) {
        _status.text = @"已结束";
    }

    
    
    
    
    
}
@end

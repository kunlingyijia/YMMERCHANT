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
    _name.text = model.name;
    _receiveNumberAndstock.text =[NSString stringWithFormat:@"已领取%@/%@张", model.receiveNumber,model.stock];
    _limitAmount.text =[NSString stringWithFormat:@"消费满%@元给予发放", model.limitAmount];
    _beginTimeAndendtime.text =[NSString stringWithFormat:@"有效期: %@至%@", model.beginTime,model.endTime];
     NSMutableAttributedString * faceAmount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", model.faceAmount] ];
    [faceAmount addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:12]
                       range:NSMakeRange(0, 1)];
    //status 1-已发放, 2-已取消, 3-已过期, 4-已结束
    if ([model.status isEqualToString:@"1"]) {
        _status.text = @"已发放";
        _LeftView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
        _symbol.textColor = [UIColor redColor];
        _faceAmount.textColor = [UIColor redColor];
        _name.textColor = [UIColor blackColor];
        _status.textColor = [UIColor orangeColor];
        [faceAmount addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:NSMakeRange(0, _model.faceAmount.length-1)];
    }else{
        _LeftView.backgroundColor = [UIColor grayColor];
        _symbol.textColor = [UIColor grayColor];
        _faceAmount.textColor = [UIColor grayColor];
        _name.textColor = [UIColor grayColor];
        _status.textColor = [UIColor grayColor];
        [faceAmount addAttribute:NSForegroundColorAttributeName
                           value:[UIColor grayColor]
                           range:NSMakeRange(0, _model.faceAmount.length-1)];
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
    _faceAmount.attributedText  =faceAmount;
}
@end

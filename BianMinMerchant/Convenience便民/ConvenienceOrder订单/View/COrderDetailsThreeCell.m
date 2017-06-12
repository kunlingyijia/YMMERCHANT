//
//  COrderDetailsThreeCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "COrderDetailsThreeCell.h"
#import "RequestBminorderListModel.h"
@implementation COrderDetailsThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(RequestBminorderListModel *)model{
    _model = model;
    self.bookingStartTime.text = model.bookingStartTime;
    self.price.text = model.price;
    self.content.text = model.content;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

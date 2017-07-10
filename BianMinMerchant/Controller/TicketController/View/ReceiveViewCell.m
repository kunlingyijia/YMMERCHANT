//
//  ReceiveViewCell.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ReceiveViewCell.h"
#import "GetCouponUserListModel.h"
@implementation ReceiveViewCell
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
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(GetCouponUserListModel *)model{
    if (!model) return;
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",model.userName, model.mobile];
    self.startTimeL.text = model.createTime;
    [DWHelper SD_WebImage:self.pictureView imageUrlStr:model.avatarUrl placeholderImage:nil];
    if (model.userTime == nil) {
        self.endTimeL.text = @"暂未使用";
    }else {
        self.endTimeL.text = model.userTime;
    }
    switch (model.status) {
        case 1:
            self.useLabel.text = @"未使用";
            break;
        case 2:
            self.useLabel.text = @"已使用";
            break;
        case 3:
            self.useLabel.text = @"已过期";
            break;
        case 4:
            self.useLabel.text = @"已删除";
            break;
        default:
            break;
    }

}
@end


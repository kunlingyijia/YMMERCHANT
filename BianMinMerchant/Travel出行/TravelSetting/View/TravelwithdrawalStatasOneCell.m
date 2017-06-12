//
//  TravelwithdrawalStatasOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelwithdrawalStatasOneCell.h"
#import "TravelBanckModel.h"
@implementation TravelwithdrawalStatasOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0);

}
-(void)setModel:(TravelBanckModel *)model{
    _model = model;
    /////1- 审核中，2-审核通过，3-审核不通过（新增）
    if ([model.status isEqualToString:@"1"]) {
        self.RightImage.image = [UIImage imageNamed:@"审核中"];
        self.label.text = @"审核中,请耐心等待";
        self.LeftImage.image = [UIImage imageNamed:@""];
    }else if ([model.status isEqualToString:@"3"]){
        self.RightImage.image = [UIImage imageNamed:@"失败-审核"];
        self.label.text = @"审核失败,请重新进行认证";
        self.LeftImage.image = [UIImage imageNamed:@"审核失败-箭头"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

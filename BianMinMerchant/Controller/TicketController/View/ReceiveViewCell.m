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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pictureView.clipsToBounds = YES;
}
- (void)cellGetData:(GetCouponUserListModel *)model withController:(BaseViewController *)VC{
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",model.userName, model.mobile];
    self.startTimeL.text = model.createTime;
    [VC loadImageWithView:self.pictureView urlStr:model.avatarUrl];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

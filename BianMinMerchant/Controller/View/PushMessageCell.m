//
//  PushMessageCell.m
//  BianMin
//
//  Created by kkk on 16/7/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PushMessageCell.h"

@implementation PushMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetDataModel:(RequestMerchantMessageListModel *)model{
    self.nameLabel.text = model.title;
    self.messageLabel.text = model.content;
    self.timeLabel.text = model.createTime;
}

@end

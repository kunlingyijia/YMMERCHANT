//
//  RecordCell.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "RecordCell.h"
#import "FlowListModel.h"
@implementation RecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)cellGetDataWithModel:(FlowListModel *)model {
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元", model.amount];
    switch (model.status) {
        case 1:
            self.resultLabel.text = @"未处理";
            break;
        case 2:
            self.resultLabel.text = @"已处理";
            break;
        default:
            break;
    }
    self.timeLabel.text = model.createTime;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

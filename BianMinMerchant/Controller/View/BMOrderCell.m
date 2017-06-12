//
//  BMOrderCell.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/18.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BMOrderCell.h"

@implementation BMOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#fc9e18"];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 4;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)sureBtn:(id)sender {
}

- (void)cellGetDataWithModel:(RequestBminorderListModel *)model {
    self.namelabel.text = model.name;
    self.phoneLabel.text = model.tel;
    NSString *statrTime = [model.bookingStartTime substringToIndex:16];
    NSString *firtEndTime = [model.bookingEndTime substringToIndex:16];
    NSString *endTime = [firtEndTime substringFromIndex:10];
    self.adressLabel.text = [NSString stringWithFormat:@"%@-%@", statrTime, endTime];
    //self.adressLabel.text = model.address;
}

@end

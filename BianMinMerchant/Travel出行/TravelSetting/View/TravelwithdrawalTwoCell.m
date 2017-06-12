//
//  TravelwithdrawalTwoCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelwithdrawalTwoCell.h"
#import "TravelBanckModel.h"
@implementation TravelwithdrawalTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0);
}
-(void)CellGetData:(TravelBanckModel*)model{
    self.name.text = model.name;
    self.bankName.text = model.bankName;
    NSString *bank_account_number = [NSString stringWithFormat:@"%@",[model.bankAccount substringFromIndex:model.bankAccount.length- 4 ]];
    self.bankAccount.text = [NSString stringWithFormat:@"****  **** **** %@" ,bank_account_number];
    //self.bankAccount.text = model.bankAccount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

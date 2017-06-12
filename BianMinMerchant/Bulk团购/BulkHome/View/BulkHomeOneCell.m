//
//  BulkHomeOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/4.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BulkHomeOneCell.h"

@implementation BulkHomeOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.logoimg.layer.masksToBounds = YES;
    self.logoimg.layer.cornerRadius = Width*0.18/2;
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)BulkHomeOneCellBlock:(BulkHomeOneCellBlock)block{
    self.bulkHomeOneCellBlock = block;
}
- (IBAction)messageBtnAction:(UIButton *)sender {
    if (self.bulkHomeOneCellBlock) {
        self.bulkHomeOneCellBlock(60);
    }
    
}
-(void)CellGetData:(RequestMerchantInfoModel*)model{
    
    self.shopNumber.text = [NSString stringWithFormat:@"商户号:%@", model.merchantNo];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f元", model.tradeMoneyDay];
   
    
     [self.logoimg sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed: @"头像男"]];
    
    
    //商户状态 1-正常 2-待补全质料,3-待审核

    if (model.status == 1) {
        [self.messageBtn setTitle:@"" forState:(UIControlStateNormal)];
        self.messageBtn.hidden = YES;
        self.rightImage.hidden = YES;
    }else if (model.status == 2) {
        //2-待补全质料
        self.messageBtn.hidden = NO;
        self.rightImage.hidden = NO;
        [self.messageBtn setTitle:@"   请补全资料>" forState:(UIControlStateNormal)];
    }else{
        [self.messageBtn setTitle:@"   审核中..." forState:(UIControlStateNormal)];
        self.messageBtn.hidden = NO;
        self.rightImage.hidden = NO;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

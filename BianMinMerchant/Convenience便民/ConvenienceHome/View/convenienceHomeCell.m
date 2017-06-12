//
//  convenienceHomeCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/4.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "convenienceHomeCell.h"

@implementation convenienceHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.OneBtn  setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];

    [self.TwoBtn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    [self.ThreeBtn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    
}
- (IBAction)BtnAction:(UIButton *)sender {
    
    for (UIButton *btn in sender.superview.subviews) {
        if ([sender isEqual:btn]) {
             [sender setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
        }
    }
   
    
    
    self.ConvenienceHomeCellBlock(sender.tag-200);
}
-(void)convenienceHomeCellBlock:(convenienceHomeCellBlock)block{
    self.ConvenienceHomeCellBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

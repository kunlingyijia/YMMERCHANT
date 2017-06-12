//
//  COrderDetailsOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "COrderDetailsOneCell.h"
#import "RequestBminorderListModel.h"
@implementation COrderDetailsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(RequestBminorderListModel *)model{
    _model = model;
    self.name.text = model.name;
    self.tel.text = model.tel;
    self.address.text = model.address;
    ///0-不支持，1-支持
    if ([model.isOpenGPSService isEqualToString:@"1"]) {
        self.locationBtn.userInteractionEnabled = YES;
        self.location.userInteractionEnabled = YES;
        [self.locationBtn  setImage:[UIImage imageNamed:@"定位－绿色"] forState:(UIControlStateNormal)];
    }else{
        self.locationBtn.userInteractionEnabled = NO;
        self.location.userInteractionEnabled = NO;
        [self.locationBtn  setImage:[UIImage imageNamed:@"定位"] forState:(UIControlStateNormal)];
    }
    
    
    
}
#pragma mark - 拨打电话
- (IBAction)BtnAction:(UIButton *)sender {
    self.COrderDetailsOneCellBlock();
}
#pragma mark - 定位地图
- (IBAction)locationBtnAction:(UIButton *)sender {
    self.COrderDetailsOneCellLocationBlock();
    
    
}




@end

//
//  AddSerViceOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/4/18.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "AddSerViceOneCell.h"
#import "RequestBminserviceListModel.h"
@implementation AddSerViceOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteBtn.backgroundColor = [UIColor clearColor];
    //Cell背景颜色
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius =5.0;
    self.price.textColor = [UIColor colorWithHexString:kNavigationBgColor];
    //cell选中时的颜色 无色
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}

-(void)setModel:(RequestBminserviceListModel *)model{
    if (!model) return;
    _model = model;
    self.serviceName.text = model.serviceName;
    self.price.text = [NSString stringWithFormat:@"¥%.2f",model.price];
    if ([model.Ischoose isEqualToString:@"0"]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else{
        self.contentView.backgroundColor = [UIColor colorWithHexString:kSubTitleColor];
    }
    
}
@end

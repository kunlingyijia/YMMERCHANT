//
//  COrderDetailsFourCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "COrderDetailsFourCell.h"
#import "RequestBminorderListModel.h"
@implementation COrderDetailsFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(RequestBminorderListModel *)model{
    _model = model;
    //0-已预约(未接单),1-已接单(未上门),2-待支付(已上门),3-已完成,4-取消订单(商家已接单可帮取消)，5-商家拒接接单（未接单时）
    if (model.status ==0) {
        self.status.text = @"已预约";
    }else if (model.status ==1){
         self.status.text = @"已接单";
    }else if (model.status ==2){
        self.status.text = @"待支付";
    }else if (model.status ==3){
        self.status.text = @"已完成";
    }else if (model.status ==4){
        self.status.text = @"取消订单";
    }else if (model.status ==5){
        self.status.text = @"取消订单";
    }
    
    
    
    self.orderNo.text = model.orderNo;
    self.createTime.text = model.createTime;
    self.payAmount.text = model.payAmount;
    self.urgeNumber.text = [NSString stringWithFormat:@"%@次",model.urgeNumber];
     self.lastUrgeTime.text = model.lastUrgeTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

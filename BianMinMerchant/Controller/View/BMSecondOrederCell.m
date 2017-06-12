//
//  BMSecondOrederCell.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/18.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BMSecondOrederCell.h"

@implementation BMSecondOrederCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellGetDataWithModel:(RequestBminorderListModel *)model {
    self.name.text = model.name;
    self.phone.text = model.tel;
    NSString *statrTime = [model.bookingStartTime substringToIndex:16];
    NSString *firtEndTime = [model.bookingEndTime substringToIndex:16];
    NSString *endTime = [firtEndTime substringFromIndex:10];
    self.adressL.text = [NSString stringWithFormat:@"%@-%@", statrTime, endTime];
    //self.adressL.text = model.address;
    //0-已预约(未接单),1-已接单(未上门),2-待支付(已上门),3-已完成,4-取消订单(商家已接单可帮取消)，5-商家拒接接单（未接单时）
    if (model.status == 0) {
        self.statusL.text = @"已预约";
    }else if (model.status == 1 ) {
        self.statusL.text = @"已接单";
    }else if (model.status == 2) {
        self.statusL.text = @"待支付";
    }if (model.status == 3) {
        self.statusL.text = @"已完成";
    }else if (model.status == 4 ) {
        self.statusL.text = @"已取消";
    }else  if (model.status == 5 ){
     self.statusL.text = @"已拒接";
    }else{
        
    }
    
}
@end

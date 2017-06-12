//
//  TravelHomeThreeCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelHomeThreeCell.h"
#import "TripModel.h"
@implementation TravelHomeThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)CellGetData:(TripModel*)model{
    
    self.startPlace.text = model.startPlace;
    self.endPlace.text = model.endPlace;
    self.timeAndSeatNumber.text = [NSString stringWithFormat:@"%@ %@   可提供%@座",model.date, model.time,model.seatNumber];
    ///行程状态：1-待发布，2-已发布 ，3-待发车,4-已发车 ，5-已结束
    if ([model.status isEqualToString:@"1"]) {
        [self.statusBtn setTitle:@"发布" forState:(UIControlStateNormal)];
        
    }else if ([model.status isEqualToString:@"2"]) {
        [self.statusBtn setTitle:@"已发布" forState:(UIControlStateNormal)];
    }else if ([model.status isEqualToString:@"3"]) {
        [self.statusBtn setTitle:@"发车" forState:(UIControlStateNormal)];
    }else if ([model.status isEqualToString:@"4"]) {
        [self.statusBtn setTitle:@"已发车" forState:(UIControlStateNormal)];
    }else if ([model.status isEqualToString:@"5"]) {
        [self.statusBtn setTitle:@"已结束" forState:(UIControlStateNormal)];
    }else{
        
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  TravelHomeThreeCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelHomeThreeCell1.h"
#import "TripModel.h"
@implementation TravelHomeThreeCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.status.layer.masksToBounds = YES;
    self.status.layer.cornerRadius = 3.0;
    
}
-(void)CellGetData:(TripModel*)model{
    self.startPlace.text = model.startPlace;
    self.endPlace.text = model.endPlace;
    self.timeAndSeatNumber.text = [NSString stringWithFormat:@"%@ %@  %@  %@",model.date, model.time,model.bookSeat,model.bookSeatDesc];
    ///行程状态：1-待发布，2-已发布 ，3-待发车,4-已发车 ，5-已结束
    if ([model.status isEqualToString:@"1"]) {
       
        self.status.text = @"发布";
        
    }else if ([model.status isEqualToString:@"2"]) {
        
        self.status.text = @"已发布";

    }else if ([model.status isEqualToString:@"3"]) {
        
        self.status.text = @"发车";

    }else if ([model.status isEqualToString:@"4"]) {
        self.status.text = @"已发车";

    }else if ([model.status isEqualToString:@"5"]) {
        
        self.status.text = @"已结束";

    }else{
        
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

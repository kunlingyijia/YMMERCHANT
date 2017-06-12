//
//  TripDetailsOneCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/15.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TripDetailsOneCell.h"
#import "TripModel.h"
@implementation TripDetailsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)CellGetData:(TripModel*)model{
    self.startPlace.text = model.startPlace;
    self.endPlace.text = model.endPlace;
    self.dateAndTime.text = [NSString stringWithFormat:@"%@ %@ 出发",model.date,model.time];
    self.seatNumber.text =[NSString stringWithFormat:@"可提供%@座 (当前%@人预定)",model.seatNumber,model.bookNumber];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)leftACtion:(UIButton *)sender {
    [sender setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:(UIControlStateNormal)];
    [self.RightBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
}
- (IBAction)RightAction:(UIButton *)sender {
    [sender setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:(UIControlStateNormal)];
    [self.LeftBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
}

@end

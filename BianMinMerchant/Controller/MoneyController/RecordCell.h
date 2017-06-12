//
//  RecordCell.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlowListModel;
@interface RecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)cellGetDataWithModel:(FlowListModel *)model;

@end

//
//  ReceiveViewCell.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseViewController;
@class GetCouponUserListModel;
@interface ReceiveViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeL;
@property (weak, nonatomic) IBOutlet UILabel *endTimeL;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;

- (void)cellGetData:(GetCouponUserListModel *)model withController:(BaseViewController *)VC;


@end

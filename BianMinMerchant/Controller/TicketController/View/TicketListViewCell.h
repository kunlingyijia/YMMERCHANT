//
//  TicketListViewCell.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CouponListModel;

@interface TicketListViewCell : UITableViewCell

@property (nonatomic, copy)void(^detailAction)(NSString *);
@property (nonatomic, copy)void(^changeNumber)(NSString *);
@property (nonatomic, copy)void(^buyGoods)(NSString *, NSString*);
@property (nonatomic, copy)void(^deleteBlock)(NSString *);
@property (weak, nonatomic) IBOutlet UILabel *goodsNameL;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeL;
@property (weak, nonatomic) IBOutlet UILabel *endTimeL;
@property (weak, nonatomic) IBOutlet UILabel *alreadyUseL;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;



@property (nonatomic, copy) NSString *couponId;
@property (weak, nonatomic) IBOutlet UILabel *status;

- (void)cellGetDataWithModel:(CouponListModel *)model;

@end

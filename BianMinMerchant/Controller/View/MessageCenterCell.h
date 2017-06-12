//
//  MessageCenterCell.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestTradeListModel;
@interface MessageCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *orderL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *payType;

@property (weak, nonatomic) IBOutlet UILabel *userNamL;
@property (weak, nonatomic) IBOutlet UILabel *isFinish;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) RequestTradeListModel *orderModel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, copy)void(^agreeBackAction)(NSString *orderNo, NSString*goodsOrderId);
@property (nonatomic, copy)void(^refuseBackAction)(NSString * orderNo,NSString * goodsOrderId);
- (void)cellGetDataModel:(RequestTradeListModel *)model;


@end

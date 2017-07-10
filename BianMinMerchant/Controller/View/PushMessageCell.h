//
//  PushMessageCell.h
//  BianMin
//
//  Created by kkk on 16/7/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestMerchantMessageListModel;
@interface PushMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
///model
@property (nonatomic, strong) RequestMerchantMessageListModel *model ;

@end

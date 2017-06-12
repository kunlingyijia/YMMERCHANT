//
//  COrderDetailsThreeCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestBminorderListModel;
@interface COrderDetailsThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *bookingStartTime;


///RequestBminorderListModel
@property (nonatomic, strong) RequestBminorderListModel  *model ;
@end

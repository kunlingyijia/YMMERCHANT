//
//  COrderDetailsOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestBminorderListModel;
@interface COrderDetailsOneCell : UITableViewCell
///
@property (nonatomic, copy) void(^COrderDetailsOneCellBlock)()  ;
///
@property (nonatomic, copy) void(^COrderDetailsOneCellLocationBlock)()  ;

@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *location;



///RequestBminorderListModel
@property (nonatomic, strong) RequestBminorderListModel  *model ;


@end

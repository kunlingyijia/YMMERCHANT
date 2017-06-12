//
//  AddSerViceOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/4/18.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestBminserviceListModel;
@interface AddSerViceOneCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet PublicBtn *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *price;

///model
@property (nonatomic, strong) RequestBminserviceListModel *model ;
@end

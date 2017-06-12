//
//  GDPoiCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/13.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDPoiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *choseIma;



-(void)cellGetData:(AMapPOI*)model;
@end

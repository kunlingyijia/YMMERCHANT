//
//  IndustryListVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class IndustryModel;
@interface IndustryListVC : BaseViewController
///faceId
//@property (nonatomic, strong) NSString  *faceId ;
@property (weak, nonatomic) IBOutlet UILabel *balanceFaceAmount;

///
@property (nonatomic, strong) IndustryModel  *model ;

@end

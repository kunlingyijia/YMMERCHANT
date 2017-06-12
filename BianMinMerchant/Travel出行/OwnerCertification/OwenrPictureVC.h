//
//  OwenrPictureVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class OwnerModel;
@interface OwenrPictureVC : BaseViewController
///titleStr
@property (nonatomic, strong) NSString  *titleStr ;

///属性传值
@property (nonatomic, strong) OwnerModel  *ownerModel ;
@end

//
//  ChangeOwnerVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class OwnerModel;
@interface ChangeOwnerVC : BaseViewController
///titleStr
@property (nonatomic, strong) NSString  *titleStr ;
@property(nonatomic,strong)OwnerModel*ownerModel;

@end

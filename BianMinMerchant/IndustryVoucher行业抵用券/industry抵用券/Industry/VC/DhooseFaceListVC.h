//
//  DhooseFaceListVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/12.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface DhooseFaceListVC : BaseViewController
@property (nonatomic, copy) void(^ DhooseFaceListVCBlock)(NSString *faceAmount,NSString *name);
@end

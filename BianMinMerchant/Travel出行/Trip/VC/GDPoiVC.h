//
//  GDPoiVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/13.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ReturnGDPoiVC)(AMapPOI*poi);

@interface GDPoiVC : BaseViewController
///Block属性 传值一
@property(nonatomic,copy) ReturnGDPoiVC returnGDPoiVC;
//block 传值 二  block 作为方法参数传值

-(void)ReturnGDPoiVCPOI:(ReturnGDPoiVC)block;
@end

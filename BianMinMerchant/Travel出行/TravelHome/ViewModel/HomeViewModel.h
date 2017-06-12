//
//  HomeViewModel.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BaseViewController;

@interface HomeViewModel : NSObject
  //获取配置信息
- (void)getConfig:(BaseViewController*)VC;

@end

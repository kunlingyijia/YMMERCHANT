//
//  RequestBminserviceListModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBminserviceListModel : NSObject

@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSString *bminServiceId;
@property (nonatomic, assign) CGFloat price;
///是否选择
@property (nonatomic, strong) NSString  *Ischoose ;



@end

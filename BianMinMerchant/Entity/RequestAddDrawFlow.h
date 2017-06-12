//
//  RequestAddDrawFlow.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestAddDrawFlow : NSObject

@property (nonatomic, assign) NSInteger bankId;

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, copy) NSString *orderProfitIds;

@end

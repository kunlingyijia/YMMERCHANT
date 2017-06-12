//
//  FlowListModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowListModel : NSObject

@property (nonatomic ,assign) CGFloat drawFlowId;
@property (nonatomic ,assign) CGFloat amount;
@property (nonatomic ,assign) NSInteger status;
@property (nonatomic ,copy) NSString *createTime;

@end

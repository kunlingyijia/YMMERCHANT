//
//  RequestBminorderList.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBminorderList : NSObject

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;
//列表类型：1-未接单列表，2-处理中列表，3-已完成列表
@property (nonatomic, assign) NSInteger orderType;

@end

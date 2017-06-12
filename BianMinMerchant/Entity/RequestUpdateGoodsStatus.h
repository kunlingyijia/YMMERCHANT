//
//  RequestUpdateGoodsStatus.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/2.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUpdateGoodsStatus : NSObject

@property (nonatomic , copy) NSString *goodsId;
@property (nonatomic, assign) NSInteger status;

@end

//
//  RequestOrderListByGoods.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestOrderListByGoods : NSObject

@property (nonatomic , copy) NSString *goodsId;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;

@end

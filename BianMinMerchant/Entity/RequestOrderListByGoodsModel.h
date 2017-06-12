//
//  RequestOrderListByGoodsModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestOrderListByGoodsModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, assign) CGFloat payAmount;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *goodsNumber;

@end

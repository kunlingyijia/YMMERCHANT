//
//  RequestUpdateGoods.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUpdateGoods : NSObject

@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* discountedPrice;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *suggestPeople;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *useRule;
@property (nonatomic, copy) NSString *startuseTime;
@property (nonatomic, copy) NSString *enduseTime;
@property (nonatomic, copy) NSString *smallUrl;
@property (nonatomic, copy) NSString *originUrl;
@property (nonatomic, copy) NSString *middleUrl;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, strong) NSArray *images;

@end

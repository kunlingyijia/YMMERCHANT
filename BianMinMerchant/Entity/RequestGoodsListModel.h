//
//  RequestGoodsListModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestGoodsListModel : NSObject

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat discountedPrice;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, copy) NSString *suggestPeople;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *useRule;
@property (nonatomic, copy) NSString *startuseTime;
@property (nonatomic, copy) NSString *enduseTime;
@property (nonatomic, copy) NSString *smallUrl;
@property (nonatomic, copy) NSString *originUrl;
@property (nonatomic, copy) NSString *middleUrl;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger sales;
///createTime
@property (nonatomic, strong) NSString  *createTime ;
///是否编辑：0-否，1-是（新增）
@property (nonatomic, strong) NSString  * isEdit;



@end

//
//  RequestCateAndBusinessarea.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/24.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestCateAndBusinessarea : NSObject

@property (nonatomic, copy) NSString *regionId;
//	行业：1-团购 2-便民 3-出行

@property(nonatomic,strong) NSString *industry;
@end

//
//  DWCacheManager.h
//  BianMinMerchant
//
//  Created by 月美 刘 on 16/7/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWCacheManager : NSObject

+ (void)setPrivateCache:(id)cache key:(NSString *)key;
+ (id)getPrivateCacheByKey:(NSString *)key;
+(void)removegetPrivateCacheByKey:(NSString *)key;

@end

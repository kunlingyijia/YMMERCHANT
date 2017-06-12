//
//  DWCacheManager.m
//  BianMinMerchant
//
//  Created by 月美 刘 on 16/7/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWCacheManager.h"

@implementation DWCacheManager

+ (void)setPrivateCache:(id)cache key:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getPrivateCacheByKey:(NSString *)key{
    NSString *cache = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return cache;
}
+(void)removegetPrivateCacheByKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}


@end

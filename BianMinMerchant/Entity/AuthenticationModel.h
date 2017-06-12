//
//  AuthenticationModel.h
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationModel : NSObject


+ (NSString *)getLoginKey;
+ (NSString *)getLoginToken;

+(NSString *)gettags;


//数据存储
+(void)setValue:(id)response forkey:(NSString*)key;
+(id)objectForKey:(NSString*)key;

@end

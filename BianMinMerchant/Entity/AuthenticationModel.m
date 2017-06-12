//
//  AuthenticationModel.m
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AuthenticationModel.h"

@implementation AuthenticationModel



+ (NSString *)getLoginKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"loginKey"];
}
+ (NSString *)getLoginToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"loginToken"];
}

+(NSString *)gettags{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"别名成功"];
}
#pragma mark -  数据存储
+(void)setValue:(id)response forkey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults]setObject:[response yy_modelToJSONString] forKey:key];
}
+(id)objectForKey:(NSString*)key{
    NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (str.length!=0) {
        NSData * data= [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSMutableDictionary * dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        return dic[@"data"];
        
    }else{
        return nil;
    }
    
    
    
}



@end

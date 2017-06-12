//
//  YanZhengOBject.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YanZhengOBject : NSObject
///身份证
+(BOOL)isIDCorrect:(NSString *)IDNumber;
//+(BOOL) IsIdentityCard:(NSString *)IDCardNumber;
///银行卡
+(BOOL)IsBankCard:(NSString *)cardNumber
;
///邮箱
+(BOOL) IsEmailAdress:(NSString *)Email;
//手机号
+(BOOL) IsPhoneNumber:(NSString *)number;
///验证邮编
+ (BOOL) isValidZipcode:(NSString*)value;

@end

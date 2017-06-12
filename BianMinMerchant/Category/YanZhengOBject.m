//
//  YanZhengOBject.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "YanZhengOBject.h"

@implementation YanZhengOBject
//手机号

+(BOOL) IsPhoneNumber:(NSString *)number
{
    NSString *phoneRegex1=@"1[34578]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:number];
}
//邮箱


+(BOOL) IsEmailAdress:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}
//身份证
+(BOOL)isIDCorrect:(NSString *)IDNumber
{
//    NSMutableArray *IDArray = [NSMutableArray array];
//    // 遍历身份证字符串,存入数组中
//    for (int i = 0; i < 18; i++) {
//        NSRange range = NSMakeRange(i, 1);
//        NSString *subString = [IDNumber substringWithRange:range];
//        [IDArray addObject:subString];
//    }
//    // 系数数组
//    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
//    // 余数数组
//    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"x", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
//    // 每一位身份证号码和对应系数相乘之后相加所得的和
//    int sum = 0;
//    for (int i = 0; i < 17; i++) {
//        int coefficient = [coefficientArray[i] intValue];
//        int ID = [IDArray[i] intValue];
//        sum += coefficient * ID;
//    }
//    // 这个和除以11的余数对应的数
//    NSString *str = remainderArray[(sum % 11)];
//    // 身份证号码最后一位
//    NSString *string = [IDNumber substringFromIndex:17];
//    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
//    if ([str isEqualToString:string]) {
//        return YES;
//    } else {
//        return NO;
//    }
    
    
    if (IDNumber.length == 15) {
        //|  地址  |   年    |   月    |   日    |
        NSString *regex = @"^(\\d{6})([3-9][0-9][01][0-9][0-3])(\\d{4})$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [identityCardPredicate evaluateWithObject:IDNumber];
    } else if (IDNumber.length == 18) {
        //|  地址  |      年       |   月    |   日    |
        NSString *regex = @"^(\\d{6})([1][9][3-9][0-9][01][0-9][0-3])(\\d{4})(\\d|[xX])$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [identityCardPredicate evaluateWithObject:IDNumber];
    } else {
        return NO;
    }
}


//+(BOOL) IsIdentityCard:(NSString *)IDCardNumber
//{
//    if (IDCardNumber.length <= 0) {
//        return NO;
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:IDCardNumber];
//}
//银行卡

+(BOOL)IsBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}
#pragma mark - 校验邮编
+ (BOOL) isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    int len = (int)value.length;
    if (len != 6) {
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}
@end

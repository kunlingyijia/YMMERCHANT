//
//  NSString+DWString.m
//  BianMin
//
//  Created by z on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "NSString+DWString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (DWString)

+ (CGFloat)getTextHight:(NSString *)text withSize:(CGFloat )wordSize withFont:(CGFloat )font {
    NSDictionary *attrinbtes = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    return [text boundingRectWithSize:CGSizeMake(wordSize, 10000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrinbtes context:nil].size.height;
}
- (CGFloat)getSingleLineTextWidthWithFont:(UIFont *)font withMaxWith:(float)maxWidth;{
    
    CGSize textSize = [self sizeWithFont:font forWidth:maxWidth lineBreakMode:NSLineBreakByWordWrapping];
    return textSize.width;
}

- (CGFloat)getTextHeightWithFont:(UIFont *)font withMaxWith:(float)maxWidth{
    
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, maxWidth, 0)];
    detailTextView.font = font;
    detailTextView.text = self;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(maxWidth,CGFLOAT_MAX)];
    return deSize.height;
}

-  (NSInteger)getUniCodeLength{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

- (BOOL)isface
{
    //形如  [微笑]
    NSString *mostRegExp = @"\\^[\u4e00-\u9fa5]+\\^";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mostRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isUrl{
    NSString *mostRegExp = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mostRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isAt{
    NSString *mostRegExp = @"@([\u4E00-\u9FA5\uF900-\uFA2D\\w\\d]+)";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mostRegExp];
    return [test evaluateWithObject:self];
}


- (NSArray *)getMagiciData{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *facePattern = @"\\^[\u4e00-\u9fa5]+\\^";
    NSString *urlPattern = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSString *atPattern = @"@([\u4E00-\u9FA5\uF900-\uFA2D\\w\\d]+)";
    
    NSRegularExpression *faceRegex = [NSRegularExpression regularExpressionWithPattern:facePattern options:0 error:nil];
    NSRegularExpression *urlRegex = [NSRegularExpression regularExpressionWithPattern:urlPattern options:0 error:nil];
    NSRegularExpression *atRegex = [NSRegularExpression regularExpressionWithPattern:atPattern options:0 error:nil];
    
    NSArray *faceMatches = [faceRegex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSArray *urlMatchs = [urlRegex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSArray *atMatchs = [atRegex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    for (NSTextCheckingResult* match in faceMatches)
    {
        
        NSRange range = match.range;
        [array addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld,%ld",range.location, range.length] forKey:[NSString stringWithFormat:@"%ld", range.location]]];
    }
    
    for (NSTextCheckingResult* match in urlMatchs)
    {
        
        NSRange range = match.range;
        [array addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld,%ld",range.location, range.length] forKey:[NSString stringWithFormat:@"%ld", range.location]]];
    }
    
    for (NSTextCheckingResult* match in atMatchs)
    {
        
        NSRange range = match.range;
        [array addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld,%ld",range.location, range.length] forKey:[NSString stringWithFormat:@"%ld", range.location]]];
    }
    
    NSLog(@"%@", array);
    
    //最后遍历
    NSArray *resultArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger:[[[obj1 allKeys] objectAtIndex:0] integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger:[[[obj2 allKeys] objectAtIndex:0] integerValue]];
        NSComparisonResult result = [number1 compare:number2];
        return result == NSOrderedDescending; // 升序
    }];
    
    NSMutableArray *finaArray = [NSMutableArray array];
    for (NSDictionary *dict in resultArray) {
        NSString *str = [[dict allValues] objectAtIndex:0];
        NSArray *title = [str componentsSeparatedByString:@","];
        NSString *locate = [title objectAtIndex:0];
        NSString *length = [title objectAtIndex:1];
        
        NSString *finalStr = [self substringWithRange:NSMakeRange([locate integerValue], [length integerValue])];
        [finaArray addObject:finalStr];
    }
    
    
    
    return [self processWithDataSource:finaArray originStr:self];
    
}

- (NSArray *)processWithDataSource:(NSArray *)fileterArray originStr:(NSString *)text {
    NSMutableArray *array = [NSMutableArray array];
    if (fileterArray.count) {
        for (int i = 0; i < fileterArray.count; i++) {
            NSString *str = [fileterArray objectAtIndex:i];
            
            NSRange range = [text rangeOfString:str];
            
            if (range.location == 0) {
                [array addObject:str];
                text = [text substringWithRange:NSMakeRange(range.location+range.length, text.length -range.length)];
            }else{
                [array addObject:[text substringWithRange:NSMakeRange(0, range.location)]];
                [array addObject:str];
                text = [text substringWithRange:NSMakeRange(range.location+range.length, text.length - range.location-range.length)];
                
            }
            if (i == fileterArray.count - 1 && text.length!=0) {
                [array addObject:text];
            }
        }
        
    }
    else{
        [array addObject:text];
    }
    return array;
}

- (NSDate*)convertDateFromString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:self];
    return date;
}

- (NSDate*)convertDateYYMMDD{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:self];
    return date;
}

- (NSString *)processMeterToKilometer{
    NSInteger meter = [self integerValue];
    if (meter < 1000) {
        return [NSString stringWithFormat:@"%ld米", meter];
    }
    else{
        return [NSString stringWithFormat:@"%.2fkm", meter / 1000.0];
    }
}

+ (NSString *) stringWithMD5OfFile:(NSString *) path{
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: path];
    if (handle == nil) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    
    BOOL done = NO;
    
    while (!done) {
        NSData *fileData = [[NSData alloc] initWithData: [handle readDataOfLength: 4096]];
        CC_MD5_Update (&md5, [fileData bytes], (CC_LONG) [fileData length]);
        
        if ([fileData length] == 0) {
            done = YES;
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
    
}

- (NSString *)MD5Hash{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output.lowercaseString;
}

- (BOOL)isMobileNumber {
    if (self.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,173,1700
     */
    NSString *CT = @"(^1(33|53|77|73|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}






- (BOOL)isPhoneNumber
{
    NSString *phoneNumRegExp = @"^(13|14|15|17|18|19)\\d{9}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumRegExp];
    return [test evaluateWithObject:self];
}

- (NSString *)getSmallIconUrl{
    NSArray *urlArary = [self componentsSeparatedByString:@"."];
    if (urlArary.count == 0) {
        return self;
    }
    NSString *str = [urlArary objectAtIndex:urlArary.count-1];
    return [NSString stringWithFormat:@"%@.155x155.%@", self, str];
}

- (NSString *)getMiddleIconUrl{
    NSArray *urlArary = [self componentsSeparatedByString:@"."];
    if (urlArary.count == 0) {
        return self;
    }
    NSString *str = [urlArary objectAtIndex:urlArary.count-1];
    return [NSString stringWithFormat:@"%@.400x400.%@", self, str];
}

- (NSString *)getImUserId{
    NSString *md5Value = [self MD5Hash];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:
                                              @"[0-9]*" options:0 error:nil];
    md5Value = [regularExpression stringByReplacingMatchesInString:md5Value options:0 range:NSMakeRange(0, md5Value.length) withTemplate:@""];
    md5Value = [NSString stringWithFormat:@"%@%@ABCDEFGHIJHLMNOPQRSDUVWSYZ", self, md5Value];
    md5Value = [md5Value substringWithRange:NSMakeRange(0, 16)];
    return md5Value;
}
///后台返回html代码 反编译
-(NSString*)HtmlToString{
    NSMutableAttributedString * attrString =[[NSMutableAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}documentAttributes:nil error:nil];
    NSString *str = [attrString string];
    
    return str;
}


+(BOOL)ComparingdateOne:(NSString*)dateOne dateTwo:(NSString*)dateTwo{
    if ([dateOne intValue]>= [dateTwo intValue]) {
        return YES;
    }else{
        return NO;
    }
}
@end

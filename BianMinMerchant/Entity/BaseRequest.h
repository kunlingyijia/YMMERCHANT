//
//  BaseRequest.h
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Plant, //明文
    RequestMD5,   //md5
    AES,    //AES
} EncryptyType;

@interface BaseRequest : NSObject

@property (nonatomic, assign) EncryptyType encryptionType;
@property (nonatomic, strong) id data;
@property (nonatomic, copy) NSString *token;
@end

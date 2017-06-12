//
//  BaseResponse.h
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    RespPlant, //明文
    RespMD5,   //md5
    RespAES,    //AES
} RespEncryptyType;

@interface BaseResponse : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, assign) RespEncryptyType encryptionType;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) NSInteger resultCode;

@end

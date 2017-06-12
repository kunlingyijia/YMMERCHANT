//
//  LoginResponse.h
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseResponse.h"

@interface LoginResponse : BaseResponse

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) NSInteger isEmployee;
@property (nonatomic, assign) NSInteger merchantType;
@end

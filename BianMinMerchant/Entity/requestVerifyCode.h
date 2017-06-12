//
//  requestVerifyCode.h
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseRequest.h"


@interface requestVerifyCode : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger type;  //0-注册，1-忘记密码 2-绑定第三方账号

@end

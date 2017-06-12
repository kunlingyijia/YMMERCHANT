//
//  RequestUpdatePassword.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUpdatePassword : NSObject

@property (nonatomic, copy) NSString *oldpassword;
@property (nonatomic, copy) NSString *newpassword;

@end

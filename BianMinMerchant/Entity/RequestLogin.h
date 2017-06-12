//
//  RequestLogin.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestLogin : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger industry;//1-团购 2-便民 3-出行
@property (nonatomic, assign) NSInteger isEmployee;//0-店主 1-店员

@end

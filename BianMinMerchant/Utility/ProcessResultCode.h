//
//  ProcessResultCode.h
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponse.h"

@interface ProcessResultCode : NSObject

+ (void)processResultCodeWithBaseRespone:(BaseResponse *)resp viewControll:(UIViewController *)VC;

@end

//
//  HomeViewModel.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "HomeViewModel.h"
@interface HomeViewModel ()
@end
@implementation HomeViewModel
#pragma mark - 获取配置信息
- (void)getConfig:(BaseViewController*)VC {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = @[];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestConfig" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@",response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        RequestConfigModel *model = [RequestConfigModel yy_modelWithJSON:baseRes.data];
        [DWHelper shareHelper].configModel = model;
        NSLog(@"%f",[[DWHelper shareHelper].configModel.openPositionTime floatValue]);
        
    } faild:^(id error) {
        
    }];
}

@end

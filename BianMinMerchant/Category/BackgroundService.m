//
//  BackgroundService.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BackgroundService.h"
#import "RequestMerchantInfoModel.h"
#import "JPUSHService.h"
@implementation BackgroundService
///获取个人资料
+(void)requestPushVC:(BaseViewController*)VC MyselfAction:(MySelf)myself{
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[[NSArray array] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    
    
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestMerchantInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"---%@",response);
        if (baseRes.resultCode == 1) {
            [AuthenticationModel setValue:response forkey:@"TGMerchantInfo"];
        RequestMerchantInfoModel*   shopModel = [RequestMerchantInfoModel yy_modelWithJSON:baseRes.data];
           
            //[JPUSHService setAlias:shopModel.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:VC];
            DWHelper *helper = [DWHelper shareHelper];
            helper.messageStatus = shopModel.status;
            helper.shopModel = shopModel;
            myself();
           
        }else {
            [VC showToast:baseRes.msg];
        }
        
    } faild:^(id error) {
        
    }];
}

#pragma mark - 车主信息
+(void)requestDriverInfoPushVC:(BaseViewController*)VC MyselfAction:(MySelf)myself{
    NSString *Token =[AuthenticationModel getLoginToken];
    ;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelDriver/requestDriverInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"获取车主信息----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSMutableDictionary *dic = response[@"data"];
               
                [DWHelper shareHelper].shopModel =[RequestMerchantInfoModel yy_modelWithJSON: dic];
                
            }else{
                [VC showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    
    
}





#pragma mark - 推送别名
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    if (iResCode == 6002) {
        [JPUSHService setAlias:self.shopModel.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    else{
        
    }
    NSLog(@"push set alias success alisa = %@", alias);
}
@end

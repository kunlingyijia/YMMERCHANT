//
//  DWHelper.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestConfigModel.h" 
#import "RequestMerchantInfoModel.h"
#import "OwnerModel.h"
@class BaseViewController;
typedef void(^SuccessCallback)(id response);
typedef void(^FaildCallback)(id error);
typedef void(^SuccessImageArr)(id response);

//枚举 请求类型
typedef enum : NSUInteger {
    POST,
    GET,
    PUT,
}RequestMethod;

@interface DWHelper : NSObject

+ (DWHelper *)shareHelper;
//网络请求
- (void)requestDataWithParm:(id)parm act:(NSString *)actName sign:(id)sign requestMethod:(RequestMethod)method success:(SuccessCallback)success faild:(FaildCallback)faild;
@property (nonatomic, assign) NSInteger isLoginType;
@property (nonatomic, assign) NSInteger shopType;
//商户状态 1-正常 2-待补全质料,3-待审核

@property (nonatomic, assign) NSInteger messageStatus;
//存储配置信息
@property (nonatomic, strong) RequestConfigModel *configModel;
//存储商户信息
@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;
///车主
@property (nonatomic, strong) OwnerModel  *ownerModel ;

///BaseViewController
@property (nonatomic, strong) BaseViewController  * BaseVC ;
//上传图片
-(void)UPImageToServer:(NSArray*)imageArr success:(SuccessImageArr)success faild:(FaildCallback)faild;
///图片展示
+(void)SD_WebImage:(UIImageView*)imageView imageUrlStr:(NSString*)urlStr placeholderImage:(NSString*)placeholder;
@end

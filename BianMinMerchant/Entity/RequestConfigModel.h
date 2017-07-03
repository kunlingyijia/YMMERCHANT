//
//  RequestConfigModel.h
//  BianMinMerchant
//
//  Created by kkk on 16/10/24.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestConfigModel : NSObject

@property (nonatomic, copy) NSString *referralCode;
@property (nonatomic, copy) NSString *referralUrl;
@property (nonatomic, copy) NSString *referralReglUrl;
@property (nonatomic, copy) NSString *waterSwitch;
@property (nonatomic, copy) NSString *waterLogo;
@property (nonatomic, copy) NSString *image_hostname;
@property (nonatomic, copy) NSString *image_account;
@property (nonatomic, copy) NSString *image_password;
///客服电话
@property (nonatomic, strong) NSString  *plat_kfmobile ;



///开启定位时间(秒)
@property (nonatomic, strong) NSString  *openPositionTime ;
///行业抵用券url
@property (nonatomic, strong) NSString  *industryCouponUrl ;
///行业抵用券添加规则
@property (nonatomic, strong) NSString  *industryCouponExplainUrl ;







@end

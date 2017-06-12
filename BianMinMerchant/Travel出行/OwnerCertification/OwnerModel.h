//
//  OwnerModel.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnerModel : NSObject
///[可选]头像地址
@property (nonatomic, strong) NSString  *avatarUrl ;

///[可选]真实名字
@property (nonatomic, strong) NSString  *realName ;
///[可选]性别 0-女 [可选]1-男

@property (nonatomic, strong) NSString  *gender ;


///[可选]品牌型号
@property (nonatomic, strong) NSString  *carBrand ;
///[可选]车牌号
@property (nonatomic, strong) NSString  *carNo ;
///[可选]身份证号码
@property (nonatomic, strong) NSString  *idCard ;

///车辆照片
@property (nonatomic, strong) NSString  *carPhotoUrl ;
///[可选]所属公司
@property (nonatomic, strong) NSString  *companyId ;
///公司名称
@property (nonatomic, strong) NSString  *companyName ;


///[可选]驾驶执照url
@property (nonatomic, strong) NSString  *driverLicenseUrl ;
///[可选]机动车行驶证件url
@property (nonatomic, strong) NSString  *carLicenseUrl ;
///[可选]车辆颜色
@property (nonatomic, strong) NSString  *carColor ;
///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
@property (nonatomic, strong) NSString  *status ;

///原因
@property (nonatomic, strong) NSString  *refuseReason ;


@end

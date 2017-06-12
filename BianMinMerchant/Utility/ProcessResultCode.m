


//
//  ProcessResultCode.m
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ProcessResultCode.h"
#import "BaseViewController.h"
#import "RequestLogin.h"
#import "LoginResponse.h"
@implementation ProcessResultCode

+ (void)processResultCodeWithBaseRespone:(BaseResponse *)resp viewControll:(BaseViewController *)VC{
    NSString *str = nil;
    switch (resp.resultCode) {
        case 1:
            str = @"成功";
            break;
        case 999:
            str = @"非法请求";
            break;
        case 3:
            str = @"用户名或密码错误";
            break;
        case 4:
            str = @"请填写正确的手机号码";
            break;
        case 5:
            str = @"密码不能为空";
            break;
        case 6:
            str = @"验证码不能为空";
            break;
        case 7:
            str = @"验证码不正确";
            break;
        case 8:
            [self loginAction];
//            str = @"请登录";
            break;
        case 9:
            str = @"短信发送失败";
            break;
        case 10:
            str = @"验证码已经过期,请重新获取";
            break;
        case 11:
            str = @"手机号已经注册";
            break;
        case 12:
            str = @"账号不存在";
            break;
        case 13:
            str = @"异常";
            break;
        case 14:
            //重复登录
            [self loginAction];
            break;
        case 15:
            str = @"异常";
            break;
        case 16:
            str = @"文件上传错误";
            break;
        case 17:
            str = @"请填写反馈内容";
            break;
        case 18:
            str = @"已经签到过";
            break;
        case 19:
            str = @"系统异常'";
            break;
        case 20:
            str = @"没有文件上传";
            break;
        case 21:
            str = @"该手机号码已经绑定过";
            break;
        case 22:
            str = @"第三方绑定异常";
            break;
        case 23:
            str = @"账号或密码不能为空";
            break;
        case 24:
            str = @"账号异常";
            break;
        case 25:
            str = @"外呼接口异常";
            break;
        case 26:
            str = @"暂无数据";
            break;
        case 27:
            str = @"邀请人不存在";
            break;
        case 28:
            str = @"商户类型错误";
            break;
        case 2000:
            str = @"该优惠券已过期";
            break;
        case 2001:
            str = @"获取参数错误";
            break;
        case 2002:
            str = @"第三方账号Type出错";
            break;
        case 2003:
            str = @"解绑失败";
            break;
        case 2004:
            str = @"按距离排序没有传经纬度";
            break;
        case 2005:
            str = @"优惠券已经下架";
            break;
        case 2006:
            str = @"该优惠券还未上架";
            break;
        case 2007:
            str = @"库存不足";
            break;
        case 2008:
            str = @"已经领取";
            break;
        case 2010:
            str = @"积分不足";
            break;
        case 2011:
            str = @"无法扣减积分";
            break;
        case 2012:
            str = @"已经收藏";
            break;
        case 2013:
            str = @"请先收藏";
            break;
        case 2015:
            str = @"输入不合法";
            break;
        case 2016:
            str = @"商品不存在";
            break;
        case 2017:
            str = @"商品已经下架";
            break;
        case 2018:
            str = @"优惠券不存在";
            break;
        case 2019:
            str = @"使用满减券金额不够";
            break;
        case 2020:
            str = @"提交订单失败";
            break;
        case 2021:
            str = @"未付款才能取消";
            break;
        case 2022:
            str = @"未完成的订单不能删除";
            break;
        case 2023:
            str = @"使用的优惠券异常";
            break;
        case 2024:
            str = @"订单已消费不能退款";
            break;
        case 2025:
            str = @"申请退款异常";
            break;
        case 2026:
            str = @"消费完才能评价";
            break;
        case 2027:
            str = @"积分商品库存不足";
            break;
        case 2028:
            str = @"不支持退款";
            break;
        case 2029:
            str = @"微信支付异常";
            break;
        case 2030:
            str = @"存在服务项目已删除";
            break;
        
        case 2031:
            str = @"当前状态不可支付";
            break;
        case 2032:
            str = @"该订单已取消";
            break;
        case 2033:
            str = @"当前金额输入不正确";
            break;
        case 2034:
            str = @"当前状态不正确";
            break;
        case 2035:
            str = @"票数超出";
            break;
        case 3000:
            str = @"商户账号或密码错误";
            break;
        case 3001:
            str = @"账号不存在";
            break;
        case 3002:
            str = @"该订单已消费或者退款中";
            break;
        case 3003:
            str = @"该团购券已经使用";
            break;
        case 3004:
            str = @"不是该商户订单";
            break;
        case 3005:
            str = @"密码长度不符";
            break;
        case 3044:
            str = @"起止时间错误";
            break;
        case 3015:
            str = @"异常";
            break;
        case 3016:
            str = @"异常";
            break;
        case 3017:
            str = @"异常";
            break;
        case 3018:
            str = @"异常";
            break;
        case 3019:
            str = @"异常";
            break;
        case 3020:
            str = @"更新/修改失败";
            break;
        case 3098:
            str = @"可提现金额不足";
            break;
        case 3099:
            str = @"异常";
            break;
        case 3101:
            str = @"已绑定银行卡";
            break;
        case 3102:
            str = @"银行卡信息未填全";
            break;
        case 3103:
            str = @"银行卡未绑定";
            break;
        case 3104:
            str = @"提现金额不足50";
            break;
        case 3244:
            str = @"数据已删除";
            break;
        case 3404:
            str = @"数据不存在";
            break;
        case 3601:
            str = @"商户已经存在";
            break;
        case 3655:
            str = @"提交信息不完整/不全";
            break;
        case 3700:
            str = @"提交失败";
            break;
        case 3701:
            str = @"当前订单不是已付款订单";
            break;
        case 3702:
            str = @"请输入整数";
            break;
        case 3703:
            str = @"拒绝理由未填";
            break;
        case 3800:
            str = @"账户禁用";
            break;
        case 3855:
            str = @"活动下架或已删除";
            break;
        case 3856:
            str = @"活动已过期";
            break;
        case 3857:
            str = @"已参与活动";
            break;
        case 3858:
            str = @"当前状态不可接单";
            break;
        case 3859:
            str = @"当前状态无法处理订单";
            break;
        case 3860:
            str = @"车次已过期";
            break;
        case 3861:
            str = @"当前状态不可退订";
            break;
        default:
            break;
    }
    [VC showToast:str];
}


+ (void)loginAction {
    NSString *name = [DWCacheManager getPrivateCacheByKey:@"name"];
    NSString *password = [DWCacheManager getPrivateCacheByKey:@"password"];
    
    RequestLogin *requestLogin = [[RequestLogin alloc] init];
    requestLogin.mobile = name;
    requestLogin.password = password;
    BaseRequest *baseRequest = [[BaseRequest alloc] init];
    baseRequest.encryptionType = RequestMD5;
    baseRequest.data = requestLogin;
    [[DWHelper shareHelper] requestDataWithParm:[baseRequest yy_modelToJSONString] act:@"act=MerApi/Merchant/requestLogin" sign:[[baseRequest.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        LoginResponse *loginRes = [LoginResponse yy_modelWithJSON:baseRes.data];
        if (baseRes.resultCode == 1) {

            DWHelper *helper = [DWHelper shareHelper];
            helper.isLoginType = loginRes.isEmployee;
            helper.shopType = loginRes.merchantType;
            
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            [userD setObject:loginRes.token forKey:@"loginToken"];
            [userD setObject:loginRes.key forKey:@"loginKey"];

        }else {
            
        }
    } faild:^(id error) {
        
    }];

}




@end

//
//  APICount.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/5/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

///act+api
extern  NSString * const ACT_API;


///请求验证码
extern  NSString * const Request_VerifyCode;
/////注册
extern  NSString * const Request_Register;
///登录
extern  NSString * const Request_Login;
///修改密码
extern  NSString * const Request_ResetPwdByVerifyCode;
///获取个人信息
extern  NSString * const Request_UserInfo;
///修改个人信息
extern  NSString * const Request_ModifyUserInfo;
///地区选择
extern  NSString * const Request_ServiceReigonList;
///添加地址
extern  NSString * const Request_AddAddress;
///获取收货地址
extern  NSString * const Request_ListAddress;
///意见反馈
extern  NSString * const Request_Feedback;
///签到接口
extern  NSString * const Request_Signin;
///签到获取列表
extern  NSString * const Request_SigninList;
///修改收货地址
extern  NSString * const Request_UpdateAddress;
///删除收获地址
extern  NSString * const Request_DeleteAddress;
///首页轮播图广告位
extern  NSString * const Request_HomePageAdList;
///请求最新的版本号
extern  NSString * const Request_LastVersion;
///第三方登录接口
extern  NSString * const Request_ThirdPartLogin;
///第三方登录，绑定手机号码
extern  NSString * const Request_BindPhoneNum;
///积分商品展示
extern  NSString * const Request_ScoreGoodsList;
///积分商品展示
extern  NSString * const Request_ScoreConf;
///积分兑换
extern  NSString * const Request_AddScoreOrder;
///获取当前积分
extern  NSString * const Request_TotalScore;
/////根据分类ID获取该分类下的商家列表搜索商家
extern  NSString * const Request_MerchantList;
///添加出行
extern  NSString * const Request_AddTripList;
///取消绑定第三方帐号
extern  NSString * const Request_UnbindSocialAccount;
///获取具体某个商家详情
extern  NSString * const Request_MerchantDetail;
///收藏/取消收藏某个商家
extern  NSString * const Request_CollectMerchant;
///获取商家的商品列表
extern  NSString * const Request_MerchantGoodsList;
///获取我的出行记录
extern  NSString * const Request_MyTripList;
///我的签到记录
extern  NSString * const Request_UserSigninList;
///领取优惠券
extern  NSString * const Request_ReceiveCoupon;
///获取商家优惠券列表
extern  NSString * const Request_MerchantCouponList;
/// 获取首页推荐商家列表
extern  NSString * const Request_RecommendMerchantList;
///获取首页活动详情
extern  NSString * const Request_ActiveInfo;
///获取首页商家活动
extern  NSString * const Request_ActiveList;
///我的收藏
extern  NSString * const Request_CollectMerchantList;
///抵用券
extern  NSString * const Request_MyCouponList;
///生成支付订单
extern  NSString * const Request_PayGoodsOrder;
///获取商家所有商品(或单个商品)评论列表
extern  NSString * const Request_MerchantCommentList;
///提交订单
extern  NSString * const Request_AddGoodsOrder;
///我的订单
extern  NSString * const Request_MyGoodsOrderList;
///获取商品详情
extern  NSString * const Request_GoodsInfo;
///订单详情
extern  NSString * const Request_MyGoodsOrderDetail;
///申请退款
extern  NSString * const Request_RefundGoodsOrder;
///取消订单
extern  NSString * const Request_CancelGoodsOrder;
///我的订单数量
extern  NSString * const Request_MyGoodsOrderNumber;
///评价
extern  NSString * const Request_AddGoodsComment;
///退款详情
extern  NSString * const Request_RefundGoodsOrderDetail;
///获取积分历史记录
extern  NSString * const Request_ScoreHistoryList;
///积分兑换记录
extern  NSString * const Request_ScoreOrderList;
///3.22 获取政务信息
extern  NSString * const Request_GovAffairsList;
///  呼叫平台
extern  NSString * const Request_CallPlatform;
///获取用户消息列表
extern  NSString * const Request_MessageList;
///获取协议links
extern  NSString * const Request_AgreementLinks;
///新商户入驻申请
extern  NSString * const Request_MerchantApply;
///获取首页菜单
extern  NSString * const Request_MenuList;
///获取首页菜单
extern  NSString * const Request_CateAndBusinessarea;
///获取首页菜单
extern  NSString * const Request_ActiveServiceReigonList;
///提交便民订单
extern  NSString * const Request__AddBminorder;
///获取便民服务项目列表
extern  NSString * const Request_BminserviceList;
///获取便民订单
extern  NSString * const Request_MyBminorderList;
///便民订单详情
extern  NSString * const Request_MyBminorderDetail;
///便民订单催单
extern  NSString * const Request_BminUrge;
///便民订单支付
extern  NSString * const Request_PayBminOrder;
///便民订单取消订单
extern  NSString * const Request_BminCancelOrder;
///获取车次列表
extern  NSString * const Request_TripList;
///获取车次列表,新 修改
extern  NSString * const Request_TravelPlanList;
///获取车次列表
extern  NSString * const Request_SearchStation;
///出行详情
extern  NSString * const Request_TripDetail;
///  预约出行
extern  NSString * const Request_AddTriporder;
///获取订单列表
extern  NSString * const Request_TripOrderList;
///我的出行订单列表
extern  NSString * const Request_MyOrderList;
///   退款详情
extern  NSString * const Request_RefundInfo;
///获取订单详情
extern  NSString * const Request_TriporderDetail;
///获取订单详情
extern  NSString * const Request_MyOrderInfo;
///支付
extern  NSString * const Request_PayTripOrder;
///出行支付
extern  NSString * const Request_PayOrder;
///取消订单
extern  NSString * const Request_OrderCancel;
///获取易民钱包信息
extern  NSString * const Request_Config;
///登录后的第三方绑定
extern  NSString * const Request_ThirdPartBind;
///退订
extern  NSString * const Request_UnsubscribeTriporder;
///车次详情
extern  NSString * const Request_TravelPlanInfo;
///预约/提交订单
extern  NSString * const Request_AddOrder;
///发送行程到手机
extern  NSString * const Request_OrderToMobile;
///申请退款
extern  NSString * const Request_ApplyRefund;
///我已到达目的地
extern  NSString * const Request_OrderComplete;
///申请退款-获取退款配置
extern  NSString * const Request_Refundconfig;
///20.13 获取行程车主位置(司机点发车了才可以)
extern  NSString * const Request_Position;
///3.10 删除领取的抵用券
extern  NSString * const Request_DeleteMyCoupon;


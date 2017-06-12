//
//  APICount.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/5/9.
//  Copyright © 2017年 bianming. All rights reserved.
//
///act+api
NSString * const ACT_API = @"act=Api";
///请求验证码
  NSString * const Request_VerifyCode =  @"/User/requestVerifyCode";
/////注册
  NSString * const Request_Register = @"/User/requestRegister";
///登录
  NSString * const Request_Login = @"/User/requestLogin";
///修改密码
  NSString * const Request_ResetPwdByVerifyCode =  @"/User/requestResetPwdByVerifyCode";
///获取个人信息
  NSString * const Request_UserInfo =  @"/User/requestUserInfo";
///修改个人信息
  NSString * const Request_ModifyUserInfo  = @"/User/requestModifyUserInfo";;
///地区选择
  NSString * const Request_ServiceReigonList =  @"/Region/requestServiceReigonList";
///添加地址
  NSString * const Request_AddAddress =   @"/User/requestAddAddress";
///获取收货地址
  NSString * const Request_ListAddress =   @"/User/requestListAddress";
///意见反馈
  NSString * const Request_Feedback =  @"/User/requestFeedback";
///签到接口
  NSString * const Request_Signin  = @"/User/requestSignin";
///签到获取列表
  NSString * const Request_SigninList  = @"/User/requestSigninList";
///修改收货地址
  NSString * const Request_UpdateAddress  = @"/User/requestUpdateAddress";
///删除收获地址
  NSString * const Request_DeleteAddress = @"/User/requestDeleteAddress";
///首页轮播图广告位
  NSString * const Request_HomePageAdList = @"/Home/requestHomePageAdList";
///请求最新的版本号
  NSString * const Request_LastVersion = @"/Version/requestLastVersion";
///第三方登录接口
  NSString * const Request_ThirdPartLogin = @"/User/requestThirdPartLogin";
///第三方登录，绑定手机号码
  NSString * const Request_BindPhoneNum = @"/User/requestBindPhoneNum";
///积分商品展示
  NSString * const Request_ScoreGoodsList  = @"/Home/requestScoreGoodsList";
///积分商品展示
  NSString * const Request_ScoreConf  = @"/Home/requestScoreConf";
///积分兑换
  NSString * const Request_AddScoreOrder = @"/User/requestAddScoreOrder";
///获取当前积分
  NSString * const Request_TotalScore = @"/User/requestTotalScore";
/////根据分类ID获取该分类下的商家列表搜索商家
  NSString * const Request_MerchantList = @"/Home/requestMerchantList";
///添加出行
  NSString * const Request_AddTripList = @"/User/requestAddTripList";
///取消绑定第三方帐号
  NSString * const Request_UnbindSocialAccount  = @"/User/requestUnbindSocialAccount";
///获取具体某个商家详情
  NSString * const Request_MerchantDetail = @"/Home/requestMerchantDetail";
///收藏/取消收藏某个商家
  NSString * const Request_CollectMerchant = @"/User/requestCollectMerchant";
///获取商家的商品列表
  NSString * const Request_MerchantGoodsList = @"/Home/requestMerchantGoodsList";
///获取我的出行记录
  NSString * const Request_MyTripList = @"/User/requestMyTripList";
///我的签到记录
  NSString * const Request_UserSigninList = @"/User/requestUserSigninList";
///领取优惠券
  NSString * const Request_ReceiveCoupon = @"/User/requestReceiveCoupon";
///获取商家优惠券列表
  NSString * const Request_MerchantCouponList = @"/Home/requestMerchantCouponList";
/// 获取首页推荐商家列表
  NSString * const Request_RecommendMerchantList = @"/Home/requestRecommendMerchantList";
///获取首页活动详情
  NSString * const Request_ActiveInfo = @"/Home/requestActiveInfo";
///获取首页商家活动
  NSString * const Request_ActiveList = @"/Home/requestActiveList";
///我的收藏
  NSString * const Request_CollectMerchantList = @"/User/requestCollectMerchantList";
///抵用券
  NSString * const Request_MyCouponList = @"/User/requestMyCouponList";
///生成支付订单
  NSString * const Request_PayGoodsOrder = @"/Order/requestPayGoodsOrder";
///获取商家所有商品(或单个商品)评论列表
  NSString * const Request_MerchantCommentList = @"/Home/requestMerchantCommentList";
///提交订单
  NSString * const Request_AddGoodsOrder = @"/Order/requestAddGoodsOrder";
///我的订单
  NSString * const Request_MyGoodsOrderList = @"/Order/requestMyGoodsOrderList";
///获取商品详情
  NSString * const Request_GoodsInfo = @"/Home/requestGoodsInfo";
///订单详情
  NSString * const Request_MyGoodsOrderDetail = @"/Order/requestMyGoodsOrderDetail";
///申请退款
  NSString * const Request_RefundGoodsOrder = @"/Order/requestRefundGoodsOrder";
///取消订单
  NSString * const Request_CancelGoodsOrder = @"/Order/requestCancelGoodsOrder";
///我的订单数量
  NSString * const Request_MyGoodsOrderNumber = @"/Order/requestMyGoodsOrderNumber";
///评价
  NSString * const Request_AddGoodsComment = @"/User/requestAddGoodsComment";
///退款详情
  NSString * const Request_RefundGoodsOrderDetail = @"/Order/requestRefundGoodsOrderDetail";
///获取积分历史记录
  NSString * const Request_ScoreHistoryList = @"/User/requestScoreHistoryList";
///积分兑换记录
  NSString * const Request_ScoreOrderList = @"/User/requestScoreOrderList";
///3.22 获取政务信息
  NSString * const Request_GovAffairsList = @"/Home/requestGovAffairsList";
///  呼叫平台
  NSString * const Request_CallPlatform = @"/Sys/requestCallPlatform";
///获取用户消息列表
  NSString * const Request_MessageList = @"/User/requestMessageList";
///获取协议links
  NSString * const Request_AgreementLinks = @"/Sys/requestAgreementLinks";
///新商户入驻申请
  NSString * const Request_MerchantApply = @"act=MerApi/Merchant/requestMerchantApply";
///获取首页菜单
  NSString * const Request_MenuList = @"/Merchant/requestMenuList";
///获取首页菜单
  NSString * const Request_CateAndBusinessarea = @"/Merchant/requestCateAndBusinessarea";;
///获取首页菜单
  NSString * const Request_ActiveServiceReigonList = @"/Region/requestActiveServiceReigonList";
///提交便民订单
  NSString * const Request_AddBminorder = @"/Order/requestAddBminorder";
///获取便民服务项目列表
  NSString * const Request_BminserviceList = @"/Bmin/requestBminserviceList";
///获取便民订单
  NSString * const Request_MyBminorderList = @"/Order/requestMyBminorderList";
///便民订单详情
  NSString * const Request_MyBminorderDetail = @"/Order/requestMyBminorderDetail";
///便民订单催单
  NSString * const Request_BminUrge = @"/Order/requestBminUrge";
///便民订单支付
  NSString * const Request_PayBminOrder = @"/Order/requestPayBminOrder";
///便民订单取消订单
  NSString * const Request_BminCancelOrder = @"/Order/requestBminCancelOrder";
///获取车次列表
  NSString * const Request_TripList = @"/Trip/requestTripList";
///获取车次列表,新 修改
  NSString * const Request_TravelPlanList = @"/TravelPlan/requestTravelPlanList";
///获取车次列表
  NSString * const Request_SearchStation = @"/Trip/requestSearchStation";
///出行详情
  NSString * const Request_TripDetail = @"/Trip/requestTripDetail";
///  预约出行
  NSString * const Request_AddTriporder = @"/Trip/requestAddTriporder";
///获取订单列表
  NSString * const Request_TripOrderList = @"/Trip/requestTripOrderList";
///我的出行订单列表
  NSString * const Request_MyOrderList  = @"/TravelOrder/requestMyOrderList";
///   退款详情
  NSString * const Request_RefundInfo = @"/TravelOrderRefund/requestRefundInfo";
///获取订单详情
  NSString * const Request_TriporderDetail = @"/Trip/requestTriporderDetail";
///获取订单详情
  NSString * const Request_MyOrderInfo = @"/TravelOrder/requestMyOrderInfo";
///支付
  NSString * const Request_PayTripOrder = @"/Trip/requestPayTripOrder";
///出行支付
  NSString * const Request_PayOrder = @"/TravelOrder/requestPayOrder";
///取消订单
  NSString * const Request_OrderCancel = @"/TravelOrder/requestOrderCancel";
///获取易民钱包信息
  NSString * const Request_Config  = @"/Sys/requestConfig";
///登录后的第三方绑定
  NSString * const Request_ThirdPartBind  = @"/User/requestThirdPartBind";
///退订
  NSString * const Request_UnsubscribeTriporder  = @"/Trip/requestUnsubscribeTriporder";
///车次详情
  NSString * const Request_TravelPlanInfo  = @"/TravelPlan/RequestTravelPlanInfo";
///预约/提交订单
  NSString * const Request_AddOrder  = @"/TravelOrder/requestAddOrder";
///发送行程到手机
  NSString * const Request_OrderToMobile  = @"/TravelOrder/requestOrderToMobile";
///申请退款
  NSString * const Request_ApplyRefund  = @"/TravelOrderRefund/requestApplyRefund";
///我已到达目的地
  NSString * const Request_OrderComplete  = @"/TravelOrder/requestOrderComplete";;
///申请退款-获取退款配置
  NSString * const Request_Refundconfig = @"/TravelOrderRefund/requestRefundconfig";
///20.13 获取行程车主位置(司机点发车了才可以)
  NSString * const Request_Position = @"/TravelDriver/requestPosition";
///3.10 删除领取的抵用券
  NSString * const Request_DeleteMyCoupon = @"/User/requestDeleteMyCoupon";

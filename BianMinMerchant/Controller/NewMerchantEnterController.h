//
//  NewMerchantEnterController.h
//  0818
//
//  Created by 月美 刘 on 16/8/22.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NewMerchantEnterController : BaseViewController


@property (nonatomic, copy)void(^backLoginAction)(NSString *phone, NSString *password);
@property (weak, nonatomic) IBOutlet UIView *carBg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIView *cornerView;

@property (weak, nonatomic) IBOutlet UIImageView *generalMerchant; //普通商户
@property (weak, nonatomic) IBOutlet UIImageView *bianminMerchant; //便民商户

@property (weak, nonatomic) IBOutlet UIImageView *carMerchant;//出行商户


@property (weak, nonatomic) IBOutlet UITextField *tel;             //手机号
@property (weak, nonatomic) IBOutlet UITextField *captcha;         //验证码
@property (weak, nonatomic) IBOutlet UIButton *btnCaptcha;         //获取验证码
@property (weak, nonatomic) IBOutlet UITextField *password;        //密码
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword; //确认密码
@property (weak, nonatomic) IBOutlet UITextField *merchantName;    //商家名称
@property (weak, nonatomic) IBOutlet UIButton *chooseArea;         //选择区域
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;   //详细地址
@property (weak, nonatomic) IBOutlet UIButton *btnApply;           //立即申请

@end

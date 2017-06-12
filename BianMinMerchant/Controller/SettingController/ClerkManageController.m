//
//  ClerkManageController.m
//  Go
//
//  Created by 月美 刘 on 16/8/29.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "ClerkManageController.h"
#import "UIColor+DWColor.h"
#import "RequestUpdatePassword.h"
@interface ClerkManageController ()

@end

@implementation ClerkManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置控件的样式
    [self setTextFiledStyle:self.oldPassword];
    [self setTextFiledStyle:self.resetPassword];
    [self setTextFiledStyle:self.confirmPassword];
    self.updateBtn.layer.masksToBounds = YES;
    self.updateBtn.layer.cornerRadius = 6;
}

#pragma mark - 设置输入框的样式及左边的View
-(void)setTextFiledStyle:(UITextField*)textFiled {
    textFiled.layer.borderWidth = 1;
    textFiled.layer.borderColor =[UIColor colorWithHexString:@"06c1ae"].CGColor;
    textFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 50)];
    textFiled.leftViewMode = UITextFieldViewModeAlways;
}

//修改按钮的触发事件
- (IBAction)UpdateBtnClick:(id)sender {
    
    if (self.oldPassword.text.length <6) {
        [self showToast:@"请输入旧密码"];
        return;
    }else if (self.resetPassword.text.length < 6 || self.resetPassword.text.length >16) {
        [self showToast:@"请输入6-16位新密码"];
        return;
    }else if (self.confirmPassword.text.length <6 ||self.confirmPassword.text.length >16) {
        [self showToast:@"请再次输入6-16位新密码"];
       
        return;
    }else if (![self.resetPassword.text isEqualToString:self.confirmPassword.text]) {
        [self showToast:@"输入的两次新密码不一致"];
        return;
    }
    if ([self.resetPassword.text isEqualToString:self.confirmPassword.text]) {
        UIButton *btn = sender;
        btn.userInteractionEnabled = NO;
        self.view.userInteractionEnabled = NO;

        RequestUpdatePassword *update = [[RequestUpdatePassword alloc] init];
        update.oldpassword = self.oldPassword.text;
        update.newpassword = self.resetPassword.text;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[update yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Password/requestUpdatePassword" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [weakSelf showToast:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    btn.userInteractionEnabled = YES;
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
            }else {
                weakSelf.view.userInteractionEnabled = YES;
                [weakSelf showToast:baseRes.msg];
                btn.userInteractionEnabled = YES;
                
               //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
            }
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;

            btn.userInteractionEnabled = YES;
        }];
    }else {
        [self showToast:@"密码不一致"];
        self.view.userInteractionEnabled = YES;

    }
    
    
}
@end

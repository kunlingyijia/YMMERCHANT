//
//  ClerkManageController.h
//  Go
//
//  Created by 月美 刘 on 16/8/29.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "BaseViewController.h"

@interface ClerkManageController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPassword;     //旧密码
@property (weak, nonatomic) IBOutlet UITextField *resetPassword;   //新密码
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword; //确认密码
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;          //修改的按钮

- (IBAction)UpdateBtnClick:(id)sender;   //修改按钮的触发事件

@end

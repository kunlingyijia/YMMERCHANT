//
//  AddStaffViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AddStaffViewController.h"
#import "RequestAddMerchantEmployee.h"
#import "RequestEditMerchantEmployee.h"
#import "RequestDelMerchantEmployee.h"
@interface AddStaffViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UITextField *noteField;

@end

@implementation AddStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView setContentSize:CGSizeMake(Width, Height)];
    [self createView];
}

- (void)createView {
    self.phoneField = [[UITextField alloc] init];
    [self.scrollView addSubview:self.phoneField];
    self.phoneField.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.phoneField.layer.borderWidth = 1;
    self.phoneField.placeholder = @" 店员手机号";
    self.phoneField.font = [UIFont systemFontOfSize:15];
    self.phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.phoneField.keyboardType = UIKeyboardTypeDecimalPad;
    self.phoneField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneField.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).with.offset(10);
        make.left.equalTo(self.view).with.offset(75);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(@(Height/16));
    }];
    
    UILabel *phoneLabel = [UILabel new];
    phoneLabel.text = @"手机号:";
    phoneLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.phoneField);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.phoneField.mas_left).with.offset(-10);
    }];
    
    
    self.passwordField = [[UITextField alloc] init];
    [self.scrollView addSubview:self.passwordField];
    self.passwordField.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.passwordField.layer.borderWidth = 1;
    self.passwordField.placeholder = @" 店员密码:6-16位";
    self. passwordField.secureTextEntry = YES;
    self.passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.font = [UIFont systemFontOfSize:15];
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneField.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(75);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(@(Height/16));
    }];
    
    UILabel *passwordLabel = [UILabel new];
    passwordLabel.text = @"密码:";
    passwordLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    passwordLabel.font = [UIFont systemFontOfSize:15];
    passwordLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.passwordField);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.passwordField.mas_left).with.offset(-10);
    }];
  
    self.nameField = [[UITextField alloc] init];
    [self.scrollView addSubview:self.nameField];
    self.nameField.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.nameField.layer.borderWidth = 1;
    self.nameField.placeholder = @" 店员姓名";
    self.nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.nameField.font = [UIFont systemFontOfSize:15];
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).with.offset(10);
        make.left.equalTo(self.scrollView).with.offset(75);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(@(Height/16));
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"姓名:";
    nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.nameField);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.nameField.mas_left).with.offset(-10);
    }];
    
    
    
    
    
    self.numberField = [[UITextField alloc] init];
    [self.scrollView addSubview:self.numberField];
    self.numberField.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.numberField.layer.borderWidth = 1;
    self.numberField.placeholder = @" 1-6位的店员工号";
    self.numberField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.numberField.leftViewMode = UITextFieldViewModeAlways;
    self.numberField.font = [UIFont systemFontOfSize:15];
    self.numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.numberField.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameField.mas_bottom).with.offset(10);
        make.left.equalTo(self.scrollView).with.offset(75);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(@(Height/16));
    }];
    
    UILabel *numberLabel = [UILabel new];
    numberLabel.text = @"工号:";
    numberLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    numberLabel.font = [UIFont systemFontOfSize:15];
    numberLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.numberField);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.numberField.mas_left).with.offset(-10);
    }];
    
    
    
    
    
    
    self.noteField = [[UITextField alloc] init];
    [self.scrollView addSubview:self.noteField];
    self.noteField.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.noteField.layer.borderWidth = 1;
    self.noteField.placeholder = @" 备注:如店长";
    self.noteField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.noteField.leftViewMode = UITextFieldViewModeAlways;
    self.noteField.font = [UIFont systemFontOfSize:15];
    self.noteField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.noteField.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.noteField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberField.mas_bottom).with.offset(10);
        make.left.equalTo(self.scrollView).with.offset(75);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(@(Height/16));
    }];
    
    UILabel *noteLabel = [UILabel new];
    noteLabel.text = @"备注:";
    noteLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    noteLabel.font = [UIFont systemFontOfSize:15];
    noteLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.noteField);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.noteField.mas_left).with.offset(-10);
    }];
    
    
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确认添加" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.scrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noteField.mas_bottom).with.offset(20);
        make.right.equalTo(self.view).with.offset(-10);
        make.left.equalTo(self.view).with.offset(10);
        make.height.mas_equalTo(@(Height/16));
        make.size.mas_equalTo(CGSizeMake(Width-20, 40));

    }];
    
    if (self.isNewC == 6) {
        self.nameField.text = self.model.name;
        self.phoneField.text = self.model.mobile;
        self.noteField.text = self.model.content;
        self.numberField.text = self.model.no;
        [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneField.mas_bottom);
            make.height.mas_equalTo(@(0));
        }];
        self.phoneField.userInteractionEnabled = NO;
        self.passwordField.hidden = YES;
        [btn setTitle:@"确定修改" forState:UIControlStateNormal];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(delegateAction:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(0, 0, 40, 40);
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)delegateAction:(UIButton *)sender {
    
    
    [self alertWithTitle:@"是否删除此员工?" message:nil OKWithTitle:@"删除" CancelWithTitle:@"再想想" withOKDefault:^(UIAlertAction *defaultaction) {
        RequestDelMerchantEmployee *loyee = [[RequestDelMerchantEmployee alloc] init];
        loyee.merchantEmployeeId= self.model.merchantEmployeeId;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[loyee yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        self.view.userInteractionEnabled = NO;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Employee/requestDelMerchantEmployee" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            NSLog(@"%@", response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [weakSelf showToast:@"删除成功"];
                weakSelf.backBlockAction(nil);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else {
                [weakSelf showToast:baseRes.msg];
                weakSelf.view.userInteractionEnabled = YES;
                
            }
            
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;
            
        }];

    } withCancel:^(UIAlertAction *cancelaction) {
        
    }];
    

}

- (void)sureAction:(UIButton *)sender {
   
    if (self.phoneField.text.length == 0) {
        [self showToast:@"请输入店员手机号"];
        return;
    }else if (![self.phoneField.text isMobileNumber]) {
        [self showToast:@"手机号错误"];
        return;
    }else if (self.passwordField.text.length <6 && self.isNewC != 6) {
        [self showToast:@"密码不能小于6位数"];
        return;
    }else if (self.passwordField.text.length >16 && self.isNewC != 6) {
        [self showToast:@"密码不能大于16位数"];
        return;
    }else if (self.nameField.text.length == 0) {
        [self showToast:@"请输入店员姓名"];
        return;
    }else if (self.numberField.text.length==0||self.numberField.text.length>6) {
        [self showToast:@"请输入1-6位的员工号"];
        return;
    }else if (self.noteField.text.length == 0) {
        [self showToast:@"请输入备注信息"];
        return;
    }
    if (self.isNewC == 6) {
        __weak typeof(self) weakSelf = self;

        self.view.userInteractionEnabled = NO;
        RequestEditMerchantEmployee *loyee = [[RequestEditMerchantEmployee alloc] init];
        loyee.name = self.nameField.text;
        loyee.mobile = self.phoneField.text;
        loyee.no = self.numberField.text;
        loyee.content = self.noteField.text;
        loyee.merchantEmployeeId= self.model.merchantEmployeeId;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[loyee yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Employee/requestEditMerchantEmployee" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [self showToast:@"修改成功"];
                self.backBlockAction(nil);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else {
               weakSelf .view.userInteractionEnabled = YES;
                [weakSelf showToast:baseRes.msg];
               
            }

        } faild:^(id error) {
            weakSelf .view.userInteractionEnabled = YES;
        }];
    }else {
        RequestAddMerchantEmployee *loyee = [[RequestAddMerchantEmployee alloc] init];
        loyee.name = self.nameField.text;
        loyee.password = self.passwordField.text;
        loyee.mobile = self.phoneField.text;
        loyee.no = self.numberField.text;
        loyee.content = self.noteField.text;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[loyee yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        
        self .view.userInteractionEnabled = NO;
        __weak typeof(self) weakSelf = self;

        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Employee/requestAddMerchantEmployee" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            NSLog(@"%@", response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [weakSelf showToast:@"添加成功"];
                weakSelf.backBlockAction(nil);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else {
               weakSelf .view.userInteractionEnabled = YES;
                [weakSelf showToast:baseRes.msg];
               
            }
        } faild:^(id error) {
            weakSelf .view.userInteractionEnabled = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

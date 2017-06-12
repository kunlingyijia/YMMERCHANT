//
//  NewMerchantEnterController.m
//  0818
//
//  Created by 月美 刘 on 16/8/22.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "NewMerchantEnterController.h"
#import "BaseViewController.h"
#import "UIColor+DWColor.h"
#import "DBRegionModel.h"
#import "RequestActiveServiceReigonList.h"
#import "CityModel.h"
#import "RequestMerchantApply.h"
#import "requestVerifyCode.h"
@interface NewMerchantEnterController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *adressArr;
@property (nonatomic, assign) NSInteger merchantType;

//地址选择
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *firstDataSource;
@property (nonatomic, strong) NSMutableArray *secondDataSource;
@property (nonatomic, strong) NSMutableArray *secondCity;
@property (nonatomic, strong) NSMutableArray *thirdDataSource;
@property (nonatomic, strong) NSMutableArray *thirdCity;
@property (nonatomic, assign) NSInteger firstRegionID;
@property (nonatomic, assign) NSInteger secondRegionID;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, assign) NSInteger firstIndex;
@property (nonatomic, assign) NSInteger secondIndex;
@property (nonatomic, assign) NSInteger thirdIndex;
@property (nonatomic, strong) CityModel *cityModel;
@property (nonatomic, strong) CityModel *provinceModel;
@property (nonatomic, strong) CityModel *secondModel;

@end

@implementation NewMerchantEnterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showBackBtn];
    //    [self setTitilColor];
    self.title = @"新商户入驻";
    self.view.backgroundColor = [UIColor whiteColor];
    self.merchantType = 1;
    [self setViewStyle];
    [self getAdressData];
    //设置可滑动区块的高度
    self.contentHeight.constant = 600;
    [self endEditingAction:self.cornerView];
}
- (void)setViewStyle {
    //设置获取验证码的button的样式
    self.btnCaptcha.layer.borderWidth = 1;
    self.btnCaptcha.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    //设置选择区域的button的样式
    self.chooseArea.layer.borderWidth = 1;
    self.chooseArea.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    
    //设置立即申请的button的圆角
    self.btnApply.layer.masksToBounds = YES;
    self.btnApply.layer.cornerRadius = 4;
    self.tel.layer.borderWidth = 1;
    self.tel.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;

    self.captcha.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    
    self.captcha.layer.borderWidth = 1;
    
    self.password.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    
    self.password.layer.borderWidth = 1;
    
    self.btnCaptcha.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.btnCaptcha.layer.borderWidth = 1;
    
    self.confirmPassword.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.confirmPassword.layer.borderWidth = 1;
    
    self.merchantName.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.merchantName.layer.borderWidth = 1;
    
    self.chooseArea.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.chooseArea.layer.borderWidth = 1;
    
    self.detailAddress.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.detailAddress.layer.borderWidth = 1;
//    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(merchantAction:)];
//    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(merchantAction:)];
    self.generalMerchant.userInteractionEnabled = YES;
    self.generalMerchant.tag = 100;
    self.bianminMerchant.userInteractionEnabled = YES;
    self.bianminMerchant.tag = 200;
//    [self.generalMerchant addGestureRecognizer:firstTap];
//    [self.bianminMerchant addGestureRecognizer:secondTap];

}


- (void)merchantAction:(UITapGestureRecognizer *)sender {
    NSInteger imageTag = sender.view.tag;
    if (imageTag == 100) {
        self.merchantType = 1;
        self.generalMerchant.image = [UIImage imageNamed:@"椭圆-2"];
        self.bianminMerchant.image = [UIImage imageNamed:@"椭圆-1"];
    }else {
         self.merchantType = 2;
        self.bianminMerchant.image = [UIImage imageNamed:@"椭圆-2"];
        self.generalMerchant.image = [UIImage imageNamed:@"椭圆-1"];
    }
}
//便民商户
- (IBAction)bmAction:(id)sender {
    self.merchantType = 2;
    self.generalMerchant.image = [UIImage imageNamed:@"椭圆-1"];
    self.bianminMerchant.image = [UIImage imageNamed:@"椭圆-2"];
    self.carMerchant.image = [UIImage imageNamed:@"椭圆-1"];
    self.carBg.hidden = NO;
    self.bgHeight.constant = 150;
}

- (IBAction)generalAction:(id)sender {
    self.merchantType = 1;
    self.generalMerchant.image = [UIImage imageNamed:@"椭圆-2"];
    self.bianminMerchant.image = [UIImage imageNamed:@"椭圆-1"];
    self.carMerchant.image = [UIImage imageNamed:@"椭圆-1"];
    self.carBg.hidden = NO;
    self.bgHeight.constant = 150;
}

//出行商户
- (IBAction)carTapAction:(id)sender {
    self.merchantType = 3;
    self.generalMerchant.image = [UIImage imageNamed:@"椭圆-1"];
    self.bianminMerchant.image = [UIImage imageNamed:@"椭圆-1"];
    self.carMerchant.image = [UIImage imageNamed:@"椭圆-2"];
    self.carBg.hidden = YES;
    self.bgHeight.constant = 0;
}
- (IBAction)getCodeNum:(id)sender {
    if ([self.tel.text isPhoneNumber]) {
        UIButton *btn = sender;
        btn.backgroundColor = [UIColor whiteColor];
        btn.userInteractionEnabled = NO;
        //    self.authCode.userInteractionEnabled = YES;
        //    self.promptLabel.text = @"接受短信大约需要60秒";
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                //倒计时结束 改变颜色
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                    btn.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 120;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [sender setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    btn.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        
        requestVerifyCode *verifyCode = [[requestVerifyCode alloc] init];
        verifyCode.mobile = self.tel.text;
        verifyCode.type = 3;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        
        baseReq.data = [verifyCode yy_modelToJSONObject];
        baseReq.encryptionType = RequestMD5;
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestVerifyCode" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
            NSNumber *resultCode = [response objectForKey:@"resultCode"];
            
            if ([resultCode integerValue] == 1) {
                [self showToast:@"获取验证码成功"];
            }
            
        } faild:^(id error) {
            
        }];
    }else {
        [self showToast:@"请输入手机号"];
    }
}

- (IBAction)sureBtnAction:(id)sender {
    if (self.tel.text.length == 0) {
        [self showToast:@"请输入手机号"];
    }else if (![self.tel.text isMobileNumber]) {
        [self showToast:@"手机号错误"];
    }else if (self.captcha.text.length == 0) {
        [self showToast:@"请输入验证码"];
    }else if (self.password.text.length == 0) {
        [self showToast:@"请输入密码"];
    }else if (self.password.text.length < 6) {
        [self showToast:@"密码不少于6位"];
    }else if (self.confirmPassword.text.length ==0) {
        [self showToast:@"请再次输入密码"];
    }else if (![self.confirmPassword.text isEqualToString:self.password.text]) {
        [self showToast:@"两次输入的密码不一致"];
    }else if (self.merchantType != 3 && self.merchantName.text.length == 0) {
        [self showToast:@"请输入商家名称"];
    }else if (self.merchantType != 3 && [self.chooseArea.titleLabel.text isEqualToString:@"点击选择所在区域"]) {
        [self showToast:@"请选择所在区域"];
    }else if (self.merchantType != 3 && self.detailAddress.text.length == 0) {
        [self showToast:@"请输入详细地址"];
    }else {
        [self showProgress];
        RequestMerchantApply *apply = [[RequestMerchantApply alloc] init];
        apply.industry = self.merchantType;
        apply.mobile = self.tel.text;
        apply.verifyCode = self.captcha.text;
       
       

        apply.provinceId = self.provinceModel.regionId;
        apply.provinceName = self.provinceModel.regionName;
        apply.regionId = self.cityModel.regionId;
        apply.regionName = self.cityModel.regionName;
        
        apply.cityId = self.secondModel.regionId;
        apply.cityName =self.secondModel.regionName;
        apply.address = self.detailAddress.text;
        apply.password = self.password.text;
        apply.merchantName = self.merchantName.text;
        apply.merchantType = self.merchantType;
        
        NSLog(@"%@",[apply yy_modelToJSONObject]);

        self.view.userInteractionEnabled = NO;

        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = RequestMD5;
        baseReq.data = apply;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Apply/requestApply" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
            [self hideProgress];
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            
            if (baseRes.resultCode == 1) {
                [self showToast:@"申请成功"];
                self.backLoginAction(self.tel.text, self.password.text);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else {
                [self showToast:baseRes.msg];
                //            [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
                self.view.userInteractionEnabled = YES;

            }
        } faild:^(id error) {
            [self hideProgress];
            self.view.userInteractionEnabled = YES;

        }];
    }
}
#pragma mark - 地址选择
- (IBAction)selectedAdress:(id)sender {
    [self.cornerView endEditing:YES];
    [self createPickerView];
}

- (void)createPickerView {
    self.bgView = [[UIView alloc] initWithFrame:Bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canaelTapAction:)];
    [self.bgView addGestureRecognizer:tap];
    
    self.bgView.alpha = 0.2;
    [self.view addSubview:self.bgView];
    self.pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, Height, Width, 300)];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerBgView];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 170)];
    self.pickerView.userInteractionEnabled = YES;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView selectRow:self.firstIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:self.secondIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:self.thirdIndex inComponent:2 animated:NO];
    [self.pickerBgView addSubview:self.pickerView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [self.pickerBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerBgView);
        make.right.equalTo(self.pickerBgView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(Width/2, 30));
        
    }];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [self.pickerBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerBgView);
        make.left.equalTo(self.pickerBgView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(Width/2, 30));
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height - 300, Width, 300);
    } completion:^(BOOL finished) {
        
    }];
}



- (void)sureAction:(UIButton *)sender {
    if (self.thirdCity.count == 0 || self.secondCity.count == 0) {
        
    }else {
        self.cityModel = self.thirdCity[self.thirdIndex];
        self.secondModel = self.secondCity[self.secondIndex];
        self.provinceModel = self.firstDataSource[self.firstIndex];
        
        CityModel *firstModel = self.firstDataSource[self.firstIndex];
        CityModel *secondModel = self.secondCity[self.secondIndex];
        
        if ([secondModel.regionName isEqualToString:@"北京市"]) {
            [self.chooseArea setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
            [self.chooseArea setTitle:[NSString stringWithFormat:@"  %@ %@", firstModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
        }else {
            [self.chooseArea setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
            [self.chooseArea setTitle:[NSString stringWithFormat:@"  %@ %@ %@", firstModel.regionName, secondModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

- (void)cancelAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}
- (void)canaelTapAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}
#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (component == 0) {
        CityModel *model = self.firstDataSource[row];
        return model.regionName;
    }else if (component == 1) {
        CityModel *model = self.secondCity[row];
        return model.regionName;
    }else {
        CityModel *model = self.thirdCity[row];
        return model.regionName;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.firstDataSource.count;
    }else if (component == 1) {
        return self.secondCity.count;
    }else {
        return self.thirdCity.count;
    }
    return 10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    return 60;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (component == 0) {
        self.firstIndex = row;
        self.secondIndex = 0;
        self.thirdIndex = 0;
        CityModel *model = self.firstDataSource[row];
        [self.secondCity removeAllObjects];
        [self.thirdCity removeAllObjects];
        if (row == 0) {
            CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
            for (CityModel *model in self.secondDataSource) {
                if (beijingModel.regionId == model.superId) {
                    [self.secondCity addObject:model];
                }
            }
            CityModel *secondModel = self.secondCity[0];
            for (CityModel *model in self.thirdDataSource) {
                if (secondModel.regionId == model.superId) {
                    [self.thirdCity addObject:model];
                }
            }
        }else {
            self.firstRegionID = model.regionId;
            for (CityModel *addressModel in self.secondDataSource) {
                if (addressModel.superId == model.regionId) {
                    [self.secondCity addObject:addressModel];
                }
            }
            CityModel *secondModel = self.secondCity[0];
            for (CityModel *thirdModel in self.thirdDataSource) {
                if (secondModel.regionId == thirdModel.superId) {
                    [self.thirdCity addObject:thirdModel];
                }
            }
//            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            
        }
        [self.pickerView reloadAllComponents];
    }else if (component == 1) {
        NSLog(@"%ld", row);
        [self.thirdCity removeAllObjects];
        self.secondIndex = row;
        CityModel *model = self.secondCity[row];
        self.secondRegionID = model.regionId;
        for (CityModel *addressModel in self.thirdDataSource) {
            if (addressModel.superId == model.regionId) {
                [self.thirdCity addObject:addressModel];
            }
        }
//        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        [self.pickerView reloadAllComponents];
    }else {
        self.thirdIndex = row;
    }
}





#pragma mark - 网络请求
- (void)getAdressData {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = [NSArray array];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Region/requestActiveServiceReigonList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            NSMutableArray * arr =baseRes.data;
            for (NSDictionary *dic in arr)
            {
                if (dic.count!=0) {
                    CityModel *model = [CityModel yy_modelWithDictionary:dic];
                    [self.adressArr addObject:model];
                }
                
            }
            if (arr.count !=0) {
                [self arrGetData];

            }

        }else {
            [self showToast: baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
    
}

- (void)arrGetData {
    for (CityModel *model in self.adressArr) {
        if (model.regionType == 1) {
            [self.firstDataSource addObject:model];
        }else if (model.regionType == 2) {
            [self.secondDataSource addObject:model];
        }else if (model.regionType == 3) {
            [self.thirdDataSource addObject:model];
        }
    }
    NSLog(@"%lu", (unsigned long)self.firstDataSource.count);
    CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
    NSLog(@"%ld", beijingModel.regionId);
    for (CityModel *model in self.secondDataSource) {
        NSLog(@"%ld", model.superId  );
        if (beijingModel.regionId == model.superId) {
            [self.secondCity addObject:model];
        }
    }
    CityModel *secondModel = self.secondCity[0];
    for (CityModel *model in self.thirdDataSource) {
        if (secondModel.regionId == model.superId) {
            [self.thirdCity addObject:model];
        }
    }
}







- (NSMutableArray *)adressArr {
    if (!_adressArr) {
        self.adressArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _adressArr;
}

- (NSMutableArray *)firstDataSource {
    if (!_firstDataSource) {
        self.firstDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _firstDataSource;
}
- (NSMutableArray *)secondDataSource {
    if (!_secondDataSource) {
        self.secondDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondDataSource;
}

- (NSMutableArray *)secondCity {
    if (!_secondCity) {
        self.secondCity = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondCity;
}

- (NSMutableArray *)thirdDataSource {
    if (!_thirdDataSource) {
        self.thirdDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _thirdDataSource;
}
- (NSMutableArray *)thirdCity {
    if (!_thirdCity) {
        self.thirdCity = [NSMutableArray arrayWithCapacity:0];
    }
    return _thirdCity;
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

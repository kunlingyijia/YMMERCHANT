//
//  AddOrederViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AddOrederViewController.h"
#import "RequestUpdateBminservice.h"
#import "RequestBminserviceListModel.h"
#import "RequestDeleteBminservice.h"
#import "RequestBminserviceListModel.h"
@interface AddOrederViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *cornerView;
@property (nonatomic, strong) NSMutableArray *orderArr;
@property (nonatomic, strong) RequestBminserviceListModel *settingModel;
@property (nonatomic, assign) NSInteger settingIndex;
@end

@implementation AddOrederViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingIndex = -1;
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"填写信息";
    [self createView];
}

- (void)createView {
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *orderMessage = [UILabel new];
    orderMessage.text = @"服务描述:";
    orderMessage.textColor = [UIColor colorWithHexString:kTitleColor];
    orderMessage.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:orderMessage];
    [orderMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    self.textView = [UITextView new];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.text = @"";
    self.textView.textColor = [UIColor colorWithHexString:kTitleColor];
    self.textView.layer.borderColor = [UIColor colorWithHexString:kSubTitleColor].CGColor;
    self.textView.layer.borderWidth = 1;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderMessage.mas_bottom).with.offset(5);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(@(100));
    }];
    
    UILabel *orderMoney = [UILabel new];
    orderMoney.text = @"服务价格:";
    orderMoney.textColor = [UIColor colorWithHexString:kTitleColor];
    orderMoney.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:orderMoney];
    [orderMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.textView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    self.textField = [UITextField new];
    self.textField.placeholder = @"输入金额(单位:元)";
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.textColor = [UIColor colorWithHexString:kTitleColor];
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.layer.borderWidth = 1;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.layer.borderColor = [UIColor colorWithHexString:kSubTitleColor].CGColor;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderMoney.mas_bottom).with.offset(5);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(@(40));
    }];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
    self.addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 4;
    self.addBtn.backgroundColor = [UIColor colorWithHexString:@"#fd9e18"];
    [self.addBtn addTarget:self action:@selector(addOrderNetworking:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).with.offset(30);
        make.right.equalTo(self.view).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addBtn.mas_bottom).with.offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@(1));
    }];
    self.scrollerView = [UIScrollView new];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.cornerView = [UIView new];
    [self.scrollerView addSubview:self.cornerView];
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollerView);
        make.width.equalTo(self.scrollerView);
    }];
    [self getOrderDataList];
}
//判断输入钱的正则表达式，可输入正负，小数点前5位，小数点后2位，位数可控
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 0) {
        NSString *stringRegex = @"(\\+)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:toString];
        if (!flag) {
            return NO;
        }
    }
    return YES;

}

- (void)createOrederList {
    CGFloat viewWidth = (Width - 50)/2;
    NSInteger count = 0;
    NSInteger arrCount = self.orderArr.count/2;
    NSInteger indexIndex = self.orderArr.count%2;
    NSInteger maxI = 0;
    if (self.orderArr.count == 0) {
        maxI = 0;
    }else if (self.orderArr.count < 3) {
        maxI = 1;
    }else if (indexIndex == 0) {
        maxI = arrCount;
    }else if (indexIndex != 0) {
        maxI = arrCount + 1;
    }
    for (int i = 0; i< maxI; i++) {
        for (int j = 0; j < 2; j++) {
            UIView *orderV = [self getOrderView:count];
            orderV.frame = CGRectMake(20 + j*(viewWidth+10), 10 + i * (viewWidth/2 + 10), viewWidth, viewWidth/2);
            count = count + 1;
            if (i == maxI-1) {
                if (indexIndex == 0 && j == 1) {
                    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(orderV.mas_bottom).with.offset(20);
                    }];
                    break;
                }else if (indexIndex != 0 && j == 0) {
                    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(orderV.mas_bottom).with.offset(20);
                    }];
                    break;
                }
                
            }
        }
    }
}
- (UIView *)getOrderView:(NSInteger)count {
    RequestBminserviceListModel *model = self.orderArr[count];
    UIView *orderV = [[UIView alloc] init];
    orderV.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    orderV.layer.borderWidth = 1;
    [self.cornerView addSubview:orderV];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"图层-59-拷贝"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(delegateOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [orderV addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(orderV).with.offset(-5);
        make.top.equalTo(orderV).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingOrderAction:)];
    [orderV addGestureRecognizer:tap];
    
    
    
    UILabel *price = [UILabel new];
    price.text = [NSString stringWithFormat:@"¥%.2f", model.price];
    price.textAlignment = NSTextAlignmentRight;
    price.font = [UIFont systemFontOfSize:15];
    price.textColor = [UIColor colorWithHexString:kNavigationBgColor];
    [orderV addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(orderV).with.offset(-5);
        make.left.bottom.equalTo(orderV);
        make.top.equalTo(cancelBtn.mas_bottom);
    }];
    UILabel *nameL = [UILabel new];
    nameL.text = model.serviceName;
    nameL.textColor = [UIColor colorWithHexString:kSubTitleColor];
    nameL.font = [UIFont systemFontOfSize:15];
    [orderV addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderV).with.offset(10);
        make.left.equalTo(orderV).with.offset(10);
        make.right.equalTo(cancelBtn.mas_left);
        make.bottom.equalTo(price.mas_top);
    }];
    
    orderV.tag = (count + 1) * 100;
    cancelBtn.tag = (count + 1) * 100 +1;
    if (self.settingIndex != -1) {
        if (self.settingIndex == count) {
            orderV.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            cancelBtn.userInteractionEnabled = NO;
        }
    }
    return orderV;
}

- (void)delegateOrderAction:(UIButton *)sender {
    NSInteger index = sender.tag / 100;
    RequestBminserviceListModel *model = self.orderArr[index-1];
    RequestDeleteBminservice *bmService = [[RequestDeleteBminservice alloc] init];
    bmService.bminServiceId = model.bminServiceId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[bmService yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestDeleteBminservice" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [weakSelf.orderArr removeObjectAtIndex:index - 1];
            [weakSelf.addBtn setTitle:@"添加" forState:UIControlStateNormal];
            weakSelf.settingIndex = -1;
            for (UIView *view in self.cornerView.subviews) {
                [view removeFromSuperview];
            }
            [weakSelf createOrederList];
        }else {
            [weakSelf showToast:baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
}

- (void)settingOrderAction:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag/100 - 1;
    RequestBminserviceListModel *model = self.orderArr[index];
    for (int i = 0; i < self.orderArr.count; i++) {
        UIView *orderView = [self.cornerView viewWithTag:(i+1)*100];
        UIButton *btn = [self.cornerView viewWithTag:(i+1)*100 + 1];
        if (index == i) {
            if (!btn.userInteractionEnabled) {
                self.settingIndex = -1;
                [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
                orderView.backgroundColor = [UIColor whiteColor];
                btn.userInteractionEnabled = YES;
                self.textView.text = @"";
                self.textField.text =@"";
            }else {
                self.settingIndex = index;
                NSLog(@"%ld", self.settingIndex);
                [self.addBtn setTitle:@"修改" forState:UIControlStateNormal];
                self.textView.text = model.serviceName;
                self.textField.text = [NSString stringWithFormat:@"%.2f", model.price];
                orderView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                btn.userInteractionEnabled = NO;
            }
        }else {
            orderView.backgroundColor = [UIColor whiteColor];
            btn.userInteractionEnabled = YES;
        }
    }
}


#pragma mark - NetWorking 
- (void)addOrderNetworking:(UIButton *)sender {
    
    if (self.textView.text.length == 0) {
        [self showToast:@"请输入服务描述"];
        return;
    }else if (self.textField.text.length ==0) {
        [self showToast:@"请输入服务价格"];
        return;
    }
    
    RequestUpdateBminservice *bminservice = [[RequestUpdateBminservice alloc] init];
    bminservice.serviceName = self.textView.text;
    bminservice.price = self.textField.text ;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if ([self.addBtn.titleLabel.text isEqualToString:@"修改"]) {
        bminservice.bminServiceId = self.settingModel.bminServiceId;
    }
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[bminservice yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;
    self.view.userInteractionEnabled = NO;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestUpdateBminservice" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            weakSelf.view.userInteractionEnabled = YES;

            weakSelf.textView.text = @"";
            weakSelf.textField.text = @"";
            RequestBminserviceListModel *model = [RequestBminserviceListModel yy_modelWithDictionary:baseRes.data];
            if ([weakSelf.addBtn.titleLabel.text isEqualToString:@"修改"]) {
                [weakSelf.orderArr replaceObjectAtIndex:weakSelf.settingIndex withObject:model];
            }else {
                [weakSelf.orderArr insertObject:model atIndex:0];
            }
            for (UIView *view in self.cornerView.subviews) {
                [view removeFromSuperview];
            }
            [self createOrederList];
        }else {
            weakSelf.view.userInteractionEnabled = YES;
            [self showToast:baseRes.msg];
        }
    } faild:^(id error) {
        weakSelf.view.userInteractionEnabled = YES;

    }];
}

- (void)getOrderDataList {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[[NSArray array] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.encryptionType = AES;
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestBminserviceList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                RequestBminserviceListModel *model = [RequestBminserviceListModel yy_modelWithDictionary:dic];
                [weakSelf.orderArr addObject:model];
            }
            [weakSelf createOrederList];
        }else {
            [weakSelf showToast:baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
}


- (NSMutableArray *)orderArr {
    if (!_orderArr) {
        self.orderArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _orderArr;
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

//
//  MoneyCenterViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MoneyCenterViewController.h"
#import "BindBankCardViewController.h"
#import "BankModel.h"
#import "MoneyModel.h"
#import "RequestAddDrawFlow.h"
#import "RecordViewController.h"
@interface MoneyCenterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCareBtn;
@property (nonatomic, copy) NSString *orderProfitIds;
@property (nonatomic, strong) BankModel *bankModel;
@end

@implementation MoneyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    [self showBackBtn];
    [self getBankCardMessage];
    [self getMoneyNumber];
}
- (void)getMoneyNumber {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestMerchantMoney" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        MoneyModel *moneyModel = [MoneyModel yy_modelWithJSON:baseRes.data];
        if (baseRes.resultCode == 1) {
            self.moneyLabel.textColor = [UIColor redColor];
            self.moneyText.text = moneyModel.money;
            self.orderProfitIds = moneyModel.orderProfitIds;
        }else {
            [self showToast: baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
    }];
}
#pragma mark - 提现记录
- (IBAction)recordAction:(id)sender {
    RecordViewController *recordC = [[RecordViewController alloc] init];
    [self.navigationController pushViewController:recordC animated:YES];
}
- (void)getBankCardMessage {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestBankInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.bankModel = [BankModel yy_modelWithJSON:baseRes.data];
            self.nameLabel.text = self.bankModel.name;
            self.bankLabel.text = self.bankModel.bankName;
            self.cardNumberLabel.text = self.bankModel.bankAccount;
            [self.addCareBtn setTitle:@"已经绑定银行卡" forState:UIControlStateNormal];
            [self.addCareBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
            self.addCareBtn.userInteractionEnabled = NO;
        }else {
            [self showToast: baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        
    } faild:^(id error) {
        
    }];
}


- (IBAction)myCardAction:(id)sender {
    OKLog(@"绑定银行卡");
    BindBankCardViewController *bindBankC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BindBankCardViewController"];
    __weak MoneyCenterViewController *weakSelf = self;
    bindBankC.backBlock = ^(NSString *str) {
        [weakSelf getBankCardMessage];
        [weakSelf getMoneyNumber];
    };
    [self.navigationController pushViewController:bindBankC animated:YES];
}

- (IBAction)myMoneyAction:(id)sender {
    if ([self.addCareBtn.titleLabel.text isEqualToString:@"请先绑定银行卡"]) {
        [self showToast:@"请先绑定银行卡"];
        return;
    }else if ([self.moneyText.text integerValue] < 50) {
        [self showToast:@"提现金额不小于50元"];
        return;
    }
    
    RequestAddDrawFlow *addDraw = [[RequestAddDrawFlow alloc] init];
    addDraw.bankId = self.bankModel.bankId;
//    if (self.moneyText.text.length == 0) {
//      addDraw.amount = 0;
//    }else {
    addDraw.amount = [self.moneyText.text floatValue];
//    }
    addDraw.orderProfitIds = self.orderProfitIds;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[addDraw yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestAddDrawFlow" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self getMoneyNumber];
            [self showToast:@"提现成功"];
        }else {
            [self showToast: baseRes.msg];
            // [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.recordBtn.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.recordBtn.layer.borderWidth = 1;
    self.recordBtn.layer.masksToBounds = YES;
    self.recordBtn.layer.cornerRadius = 3;
    
    self.moneyBtn.layer.masksToBounds = YES;
    self.moneyBtn.layer.cornerRadius = 3;
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

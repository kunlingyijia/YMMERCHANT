//
//  BindBankCardViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BindBankCardViewController.h"
#import "PickerView.h"
#import "RequestAddBank.h"
#import "AdressPickerView.h"
#import "CityModel.h"
#import "TravelBanckModel.h"
@interface BindBankCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bankAdressLabel;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *cardNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankName;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightCons;

@property (weak, nonatomic) IBOutlet UILabel *refuseReason;


@property(nonatomic,strong)AdressPickerView *adressV;
@property (weak, nonatomic) IBOutlet UIView *adressView;
@property (nonatomic, strong) CityModel *firstModel;
@property (nonatomic, strong) CityModel *secondModel;
@property (nonatomic, strong) CityModel *thirtModel;

@end

@implementation BindBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"绑定银行卡";
    
    
    
    __weak BindBankCardViewController *weakSelf = self;
    [self.adressView layoutIfNeeded];
    self. adressV = [[AdressPickerView alloc] initWithFrame:CGRectMake(0, 0, Width - 10, self.adressView.frame.size.height-2)];
    
    
    
    _adressV.selectedAdressBlock = ^(CityModel *firstModel, CityModel *secondModel, CityModel *thirdModel) {
        weakSelf.firstModel = firstModel;
        weakSelf.secondModel = secondModel;
        weakSelf.thirtModel = thirdModel;
    };
    [self.adressView addSubview:_adressV];
    
    if ([self.travelBanckModel.status isEqualToString:@"3"]||[self.travelBanckModel.status isEqualToString:@"2"]) {
        
        if ([self.travelBanckModel.status isEqualToString:@"2"]) {
            [self.sureBtn setTitle:@"重新绑定" forState:UIControlStateNormal ];
            self.HeightCons.constant =0;
            self.img.image = [UIImage imageNamed:@""];
        }else{
            [self.sureBtn setTitle:@"重新提交" forState:UIControlStateNormal ];
            self.img.image = [UIImage imageNamed:@"失败-审核"];
            
            self.refuseReason.text =self.travelBanckModel.refuseReason;
        }
        self.firstModel = [CityModel new];
        self.secondModel = [CityModel new];
        self.thirtModel = [CityModel new];
        self.cardNameLabel.text =self.travelBanckModel.name;
        [self.bankName setTitle:self.travelBanckModel.bankName forState:(UIControlStateNormal)] ;
        self.firstModel.regionId = [self.travelBanckModel.provinceId integerValue];
        self.firstModel.regionName =self.travelBanckModel.provinceName;
        self.secondModel.regionId =[self.travelBanckModel.cityId integerValue];;
        self.secondModel.regionName =self.travelBanckModel.cityName;
        self.cardNumberLabel.text = self.travelBanckModel.bankAccount;
        self.bankAdressLabel.text =self.travelBanckModel.bankBranch ;
        [self.bankName setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
       self.adressV.titleLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        self.adressV.titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.travelBanckModel.provinceName,self.travelBanckModel.cityName];
        
    }else if( [self.travelBanckModel.status isEqualToString:@"1"]){
        
    }else{
        self.HeightCons.constant =0;
        self.img.image = [UIImage imageNamed:@""];
 
    }
    

    
}
- (IBAction)addCardAction:(id)sender {
    if ([self.bankName.titleLabel.text isEqualToString:@"点击选择银行卡"]) {
        [self showToast:@"请选择银行卡"];
    }else if (self.firstModel.regionName == nil) {
        [self showToast:@"请选择地区"];
    }else if (self.bankAdressLabel.text.length == 0) {
        [self showToast:@"请输入支行名称"];
    }else if (self.cardNumberLabel.text.length == 0) {
        [self showToast:@"请输入银行卡号"];
    }else if (self.cardNameLabel.text.length ==0) {
        [self showToast:@"请输入持卡人姓名"];
    }else {
        RequestAddBank *request = [[RequestAddBank alloc] init];
        request.name = self.cardNameLabel.text;
        request.bankName = [NSString stringWithFormat:@"%@", self.bankName.titleLabel.text];
        request.provinceId = self.firstModel.regionId;
        request.provinceName = self.firstModel.regionName;
        request.cityId = self.secondModel.regionId;
        request.cityName = self.secondModel.regionName;
        request.regionId = self.thirtModel.regionId;
        
        request.bankAccount = self.cardNumberLabel.text;
        request.bankBranch = self.bankAdressLabel.text;
        BaseRequest *baseReq = [[BaseRequest alloc]init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[request yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        self.view.userInteractionEnabled = NO;
        __weak typeof(self) weakSelf = self;
        NSString * act = self.travelBanckModel.name.length>0 ?@"act=MerApi/Bank/requestUpdataBank":@"act=MerApi/Bank/requestAddBank";
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:act sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [weakSelf showToast:@"添加成功"];
                weakSelf.backBlock(nil);
                weakSelf.view.userInteractionEnabled = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                
            }else{
                weakSelf.view.userInteractionEnabled = YES;
                [weakSelf showToast:baseRes.msg];
            }
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectedBank:(id)sender {
    NSArray *options = @[@"中国银行",@"中国建设银行",@"中国工商银行", @"中国农业银行", @"交通银行", @"中信银行", @"中国光大银行", @"华夏银行", @"中国民生银行", @"招商银行", @"兴业银行", @"广发银行",@"平安银行",@"中国邮政储蓄银行"];
    __weak BindBankCardViewController *weakSelf = self;
    [PickerView showPickerWithOptions:options title:@"选择银行卡" selectionBlock:^(NSString *selectedOption) {
        [weakSelf.bankName setTitle:selectedOption forState:UIControlStateNormal];
        [weakSelf.bankName setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
    }];
}

- (IBAction)selectedAdress:(id)sender {
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 3;
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

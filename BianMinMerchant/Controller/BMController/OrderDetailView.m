//
//  OrderDetailView.m
//  0816
//
//  Created by 月美 刘 on 16/8/15.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "OrderDetailView.h"
#import "RequestMyBminorderDetail.h"
#import "RequestMyBminorderDetailModel.h"
#import "RequestBminDeelOrder.h"
@interface OrderDetailView ()
@property (nonatomic, strong) RequestMyBminorderDetailModel *orderModel;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@end

@implementation OrderDetailView


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 导航
    self.title = @"订单详情";
    [self showBackBtn];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 4;
    [self createView];
    [self ShowNodataView];
}

- (void)createView {
    self.firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.firstBtn.backgroundColor = [UIColor redColor];
    [self.firstBtn setTitle:@"接订单" forState:UIControlStateNormal];
    [self.firstBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
    [self.view addSubview:self.firstBtn];
    self.firstBtn.backgroundColor = [UIColor whiteColor];
    self.firstBtn.layer.borderColor = [UIColor colorWithHexString:kSubTitleColor].CGColor;
    self.firstBtn.layer.borderWidth = 1;
    [self.firstBtn addTarget:self action:@selector(firstAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom);
        make.left.equalTo(self.view).with.offset(-1);
        make.size.mas_equalTo(CGSizeMake(Width/2.0+2, 40));
    }];
//    self.firstBtn.frame = CGRectMake(-1, CGRectGetMaxY(self.bgView.frame), Width/2, 40);
    
    self.secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondBtn setTitle:@"拒绝订单" forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
    [self.view addSubview:self.secondBtn];
    self.secondBtn.backgroundColor = [UIColor whiteColor];
    self.secondBtn.layer.borderColor = [UIColor colorWithHexString:kSubTitleColor].CGColor;
    self.secondBtn.layer.borderWidth = 1;
    [self.secondBtn addTarget:self action:@selector(secondAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom);
        make.left.equalTo(self.firstBtn.mas_right).with.offset(-1);
        make.size.mas_equalTo(CGSizeMake(Width/2.0+2, 40));
    }];
    [self getOrderMessage];
}

- (void)firstAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"接订单"]) {
        [self handleOrderWithType:1];
    }else if ([sender.titleLabel.text isEqualToString:@"上门"]) {
        [self handleOrderWithType:2];
    }
}

- (void)secondAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"拒绝订单"]) {
        [self handleOrderWithType:5];
    }else if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [self handleOrderWithType:4];
    }
}

#pragma mark - networking
- (void)getOrderMessage {
    RequestMyBminorderDetail *detail = [[RequestMyBminorderDetail alloc] init];
    detail.orderNo = self.orderNo;
    detail.bminOrderId =self.bminOrderId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[detail yy_modelToJSONString] password:
    [AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestMyBminorderDetail" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            weakSelf.orderModel = [RequestMyBminorderDetailModel yy_modelWithJSON:baseRes.data];
             [self HiddenNodataView];
            [weakSelf viewGetData];
        }else {
            
            [weakSelf showToast:baseRes.msg];
           
        }
    } faild:^(id error) {
    }];
}

- (void)viewGetData {
    self.name.text = self.orderModel.name;
    self.tel.text = self.orderModel.tel;
    self.address.text = self.orderModel.address;
    NSString *statrTime = [self.orderModel.bookingStartTime substringToIndex:16];
    NSString *firtEndTime = [self.orderModel.bookingEndTime substringToIndex:16];
    NSString *endTime = [firtEndTime substringFromIndex:10];
    self.comeTime.text = [NSString stringWithFormat:@"%@-%@", statrTime, endTime];
    NSLog(@"%@",self.orderModel.content);
    self.detail.text = self.orderModel.content;
    if (self.orderModel.status == 3) {
        [self.firstBtn setTitle:@"已完成" forState:UIControlStateNormal];
        self.firstBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        self.firstBtn.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame), Width, 40);
        self.secondBtn.hidden = YES;
    }else if (self.orderModel.status == 5) {
        [self.firstBtn setTitle:@"已拒单" forState:UIControlStateNormal];
        self.firstBtn.backgroundColor = [UIColor colorWithHexString:kViewBg];
        self.firstBtn.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame), Width, 40);
        self.secondBtn.hidden = YES;
    }else if (self.orderModel.status == 2) {
        [self.firstBtn setTitle:@"已上门" forState:UIControlStateNormal];
        self.firstBtn.backgroundColor = [UIColor colorWithHexString:kViewBg];
        self.firstBtn.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame), Width, 40);
        self.secondBtn.hidden = YES;
    }else if(self.orderModel.status == 4) {
        self.firstBtn.hidden=YES;
        self.secondBtn.hidden = YES;
    }
    //0-已预约(未接单),1-已接单(未上门),2-待支付(已上门),3-已完成,4-取消订单

    switch (self.orderModel.status) {
        case 0:
            [self.firstBtn setTitle:@"接订单" forState:UIControlStateNormal];
            [self.secondBtn setTitle:@"拒绝订单" forState:UIControlStateNormal];
            break;
        case 1:
            [self.firstBtn setTitle:@"上门" forState:UIControlStateNormal];
            [self.secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

//声明一个订单处理的方法
- (IBAction)orderProcessing:(id)sender {
    UIButton *btn = sender;
    if ([btn.titleLabel.text isEqualToString:@"接单"]) {
        [self handleOrderWithType:1];
    }else if ([btn.titleLabel.text isEqualToString:@"订单处理中"]) {
        [self handleOrderWithType:2];
    }
}


- (void)handleOrderWithType:(NSInteger)type {
    self.view.userInteractionEnabled = NO;
    RequestBminDeelOrder *order = [[RequestBminDeelOrder alloc] init];
    order.status = type;
    order.orderNo = self.orderModel.orderNo;
    order.bminOrderId = self.orderModel.bminOrderId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[order yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestBminDeelOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
                self.backBlockAction(nil);
            if (type == 1) {
                [self showToast:@"接单成功"];
            }else if (type == 5) {
                [self showToast:@"拒单成功"];
            }else if(type == 2) {
                [self showToast:@"请尽快出发"];
            }else if(type == 4) {
                [self showToast:@"取消成功"];
            }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            
        }else {
            self.view.userInteractionEnabled = YES;
            [self showToast:baseRes.msg];
        }
    } faild:^(id error) {
        self.view.userInteractionEnabled = YES;
    }];
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

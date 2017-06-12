//
//  TicketMessageController.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "TicketMessageController.h"
#import "RequestGetCouponInfo.h"
#import "CouponInfoModel.h"
#import "AddTicketViewController.h"
@interface TicketMessageController ()
@property (nonatomic, strong) CouponInfoModel *model;
@end

@implementation TicketMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"卡券信息";
    [self selfShowBackBtn];
    [self getDataMessage];
}
- (void)selfShowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"btn_common_zhaohuimima_left_jiantou-拷贝"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(selfDoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)selfDoBack:(id)sender{
    self.balkTicket(nil);
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)createNavigationLeftBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)settingAction:(UIButton *)sender {
    AddTicketViewController *addticket = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddTicketViewController"];
    __weak TicketMessageController *weakSelf = self;
    addticket.settingBlock = ^(NSString *str) {
        [weakSelf getDataMessage];
    };
    addticket.isAddMessage = NO;
    addticket.model = self.model;
    addticket.ticketKind = self.model.couponType - 1;
    addticket.coundID = self.couponId;
    [self.navigationController pushViewController:addticket animated:YES];
}

- (void)getDataMessage {
    RequestGetCouponInfo *requestGet = [[RequestGetCouponInfo alloc] init];
    requestGet.couponId = self.couponId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[requestGet yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper]requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestGetCouponInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
             CouponInfoModel *model = [CouponInfoModel yy_modelWithJSON:baseRes.data];
            weakSelf.model = model;
            //是否编辑：0-否，1-是（新增）
            if ([weakSelf.model.isEdit isEqualToString:@"1"]){
                [weakSelf createNavigationLeftBtn];

                
            }
            switch (model.couponType) {
                case 1:
                    self.nameLabel.text = model.couponName;
                    self.messageLabel.text = [NSString stringWithFormat:@"满%.2f元,立减%.2f元", [model.mPrice floatValue],[model.mVaule floatValue]];
                    break;
                case 2:
                    self.nameLabel.text = model.couponName;
                     self.messageLabel.text = [NSString stringWithFormat:@"下单立减%.2f元", [model.lValue floatValue]];
                    break;
                case 3:
                    self.nameLabel.text = model.couponName;
                     //NSString * dValue1 =[NSString stringWithFormat:@"%ld", (long)(model.dValue)];
                    self.messageLabel.text = [NSString stringWithFormat:@"本商品打%.2f折", [[NSString stringWithFormat:@"%ld", (long)(model.dValue)] floatValue]/100.0];
                    
                    
                   
                    
                    
                    
                    
                    break;
                default:
                    break;
            }
       
        self.startTimeL.text = [NSString stringWithFormat:@"券有效期:%@", model.beginTime];
        self.endTimeL.text = [NSString stringWithFormat:@"发放期至:%@", model.endTime];
            self.storeNum.text = [NSString stringWithFormat:@"库存%ld件", (long)model.storeAmount];
        }
       
    } faild:^(id error) {
        
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

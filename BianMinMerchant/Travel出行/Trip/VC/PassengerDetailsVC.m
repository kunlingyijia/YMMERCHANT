//
//  PassengerDetailsVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "PassengerDetailsVC.h"
#import "TripModel.h"
@interface PassengerDetailsVC ()
///tripModel
@property (nonatomic, strong) TripModel  *tripModel;
@end

@implementation PassengerDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    [self ShowNodataView];
    self.title = @"订单详情";
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.tripModel = [TripModel new];
    [self requestAction];
    
}
#pragma mark - 乘客订单详情
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    ;
    TripModel *model = [TripModel new];
    model.orderId = self.orderIdStr;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelOrder/requestTravelOrderInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"乘客订单详情----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
                weakself.tripModel =[TripModel yy_modelWithJSON: response[@"data"]];
                
                [weakself kongjianfuzhi];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    
    
}

-(void)kongjianfuzhi{
    self.name.text = self.tripModel.name;
    self.tel.text =self.tripModel.tel;
    self.startPlace.text =self.tripModel.startPlace;
    self.endPlace.text =self.tripModel.endPlace;
    self.date.text = [NSString stringWithFormat:@"%@ %@ 出发",self.tripModel.date,self.tripModel.time];
    self.orderNo.text =[NSString stringWithFormat:@"订单号:%@", self.tripModel.orderNo];
    self.price.text =[NSString stringWithFormat:@"支付金额:%@", self.tripModel.price];
    self.createTime.text =[NSString stringWithFormat:@"下单时间:%@", self.tripModel.createTime];
    //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
    if ([self.tripModel.status isEqualToString:@"1"]) {
        self.status.text = @"未支付";
    }else if ([self.tripModel.status isEqualToString:@"2"]) {
        self.status.text = @"已支付";
    }else if ([self.tripModel.status isEqualToString:@"3"]) {
        self.status.text = @"已上车";
    }else if ([self.tripModel.status isEqualToString:@"4"]) {
        self.status.text = @"已完成";
    }else if ([self.tripModel.status isEqualToString:@"5"]) {
        self.status.text = @"退款中";
    }else if ([self.tripModel.status isEqualToString:@"6"]) {
        self.status.text = @"已退款";
    }else if ([self.tripModel.status isEqualToString:@"7"]) {
        self.status.text = @"已取消";
    }else{
        
    }
    
    self.remark.text = self.tripModel.remark;
    [self HiddenNodataView];

}



#pragma mark - 拨打电话
- (IBAction)CallAction:(id)sender {
    __weak typeof(self) weakSelf = self;

    [self alertWithTitle:@"呼叫乘客电话?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"稍后" withOKDefault:^(UIAlertAction *defaultaction) {
        NSLog(@"---%@",weakSelf.tripModel.tel);
        

        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",weakSelf.tripModel.tel];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

        
    } withCancel:^(UIAlertAction *cancelaction) {
        
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

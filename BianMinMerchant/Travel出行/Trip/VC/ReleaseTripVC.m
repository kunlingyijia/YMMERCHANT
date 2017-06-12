//
//  ReleaseTripVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/15.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ReleaseTripVC.h"
#import "TripModel.h"
#import "AddTripVC1.h"
#import "TravelHomeVC.h"
@interface ReleaseTripVC ()
@property(nonatomic,strong)AMapPOI *startpoi;
@property(nonatomic,strong)AMapPOI *endpoi;
@property(nonatomic,strong)NSString *seatNumberStr;
@property(nonatomic,strong)NSString *priceStr;
@end

@implementation ReleaseTripVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    NSLog(@"%@",[self.tripModel yy_modelToJSONObject]);
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.title = @"发布行程";
    //[self showBackBtn];
   [self showBackBtn:^{
       for (UIViewController *tempVC in self.navigationController.viewControllers) {
           if ([tempVC isKindOfClass:[TravelHomeVC class]]) {
               [self.navigationController popToViewController:tempVC animated:YES];
           }
       }
   }];
    [self AddRightBtn];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    //[self requestPlanInfoAction];
    //控件赋值
    [self kongjianFuZhi];
    
    
}
#pragma mark - 控件赋值
-(void)kongjianFuZhi{
    self.date.text = self.tripModel.date;
    self.time.text = self.tripModel.time;
    self.startPlace.text = self.tripModel.startPlace;
    self.startpoi.name = self.tripModel.startPlace;
    self.startpoi.location.latitude = [self.tripModel.startPlaceLat doubleValue];
    self.startpoi.location.longitude = [self.tripModel.startPlaceLng doubleValue];
    self.endpoi.name = self.tripModel.endPlace;
    self.endpoi.location.latitude = [self.tripModel.endPlaceLat doubleValue];
    self.endpoi.location.longitude = [self.tripModel.endPlaceLng doubleValue];
    self.endPlace.text = self.tripModel.endPlace;
    self.seatNumber.text = [NSString stringWithFormat:@"可提供%@座", self.tripModel.seatNumber];
    self.seatNumberStr = self.tripModel.seatNumber;
    self.priceStr =self. tripModel.price;
    self.price.text = [NSString stringWithFormat:@"%@元", self.tripModel.price];;
    self.AllPrice.text =[NSString stringWithFormat:@"%.2f元", [self.tripModel.seatNumber intValue]*[self.tripModel.price floatValue]];
    

    
}
#pragma mark - 添加保存
-(void)AddRightBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [backBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    
}
#pragma mark - 编辑
-(void)save:(UIButton*)sender{
    
    //Push 跳转
    AddTripVC1 * VC = [[AddTripVC1 alloc]initWithNibName:@"AddTripVC1" bundle:nil];
    VC.titleStr = @"编辑路线";
    VC.tripModel = self.tripModel;
    
    NSLog(@"%@",[VC.tripModel yy_modelToJSONObject]);

    
    
    
    __weak typeof(self) weakSelf = self;
    [VC ReturnAddTripVC1:^(TripModel *tripModel) {

        weakSelf.date.text = tripModel.date;
        weakSelf.time.text = tripModel.time;
        weakSelf.startPlace.text = tripModel.startPlace;
        weakSelf.startpoi.name = tripModel.startPlace;
        weakSelf.startpoi.location.latitude = [tripModel.startPlaceLat doubleValue];
        weakSelf.startpoi.location.longitude = [tripModel.startPlaceLng doubleValue];
        weakSelf.endpoi.name = tripModel.endPlace;
        weakSelf.endpoi.location.latitude = [tripModel.endPlaceLat doubleValue];
        weakSelf.endpoi.location.longitude = [tripModel.endPlaceLng doubleValue];
        weakSelf.endPlace.text = tripModel.endPlace;
        weakSelf.seatNumber.text = [NSString stringWithFormat:@"可提供%@座", tripModel.seatNumber];
        weakSelf.seatNumberStr = tripModel.seatNumber;
        weakSelf.priceStr = tripModel.price;
        weakSelf.price.text = [NSString stringWithFormat:@"%@元", tripModel.price];;
        weakSelf.AllPrice.text =[NSString stringWithFormat:@"%.2f元", [tripModel.seatNumber intValue]*[tripModel.price floatValue]];

    }];
    [self.navigationController  pushViewController:VC animated:YES];

    
    
    
    
}
- (IBAction)releaseAction:(PublicBtn *)sender {
    
    if (self.date.text.length==0) {
        [self showToast:@"请设置日期"];
        return;
    }
    if (self.time.text.length==0) {
        [self showToast:@"请设置时间"];
        return;
    }
    
    if (self.seatNumber.text.length==0) {
        [self showToast:@"请输入座位数"];
        return;
    }
    if (self.startPlace.text.length==0) {
        [self showToast:@"请设置上车地点"];
        return;
    }
    if (self.date.text.length==0) {
        [self showToast:@"请设置下车地点"];
        return;
    }
    if (self.date.text.length==0) {
        [self showToast:@"请输入座位价格"];
        return;
    }
    
    
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    TripModel *model = [[TripModel alloc]init];
//    model.date = self.date.text;
//    model.time = self.time.text;
//    model.seatNumber = self.seatNumberStr;
//    model.startPlace = self.startpoi.name;
//    model.startPlaceLat =[NSString stringWithFormat:@"%f", self.startpoi.location.latitude];
//    model.startPlaceLng = [NSString stringWithFormat:@"%f", self.startpoi.location.longitude];;
//    model.endPlace = self.endpoi.name;
//    model.endPlaceLat = [NSString stringWithFormat:@"%f", self.endpoi.location.latitude];
//    model.endPlaceLng = [NSString stringWithFormat:@"%f", self.endpoi.location.latitude];
//    model.price = self.priceStr;
    
    model.planId = self.tripModel.planId;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelPlan/requestPublishPlan" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@"发布行程----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
                                        //
                
                for (UIViewController * tempVC in self.navigationController.viewControllers) {
                    if ([tempVC isKindOfClass:[TravelHomeVC class]]) {
                        [weakself.navigationController popToViewController:tempVC animated:YES];
                    }
                }
                
                
                
                
                
            }else{
                weakself.view.userInteractionEnabled = YES;
                
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            weakself.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }else{
        
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

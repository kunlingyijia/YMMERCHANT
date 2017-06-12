//
//  AddTripVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/12.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "AddTripVC1.h"
#import "XFDaterView.h"
#import "GDPoiVC.h"
#import "AddTirpinfoVC.h"
#import "TripModel.h"
#import "ReleaseTripVC.h"
@interface AddTripVC1 ()<XFDaterViewDelegate>{
    XFDaterView*dater;
    XFDaterView*timer;
}
@property(nonatomic,strong)AMapPOI *startpoi;
@property(nonatomic,strong)AMapPOI *endpoi;
@property(nonatomic,strong)AMapGeoPoint *startGeoPoint;
@property(nonatomic,strong)AMapGeoPoint *endGeoPoint;

@property(nonatomic,strong)NSString *seatNumberStr;
@property(nonatomic,strong)NSString *priceStr;





@end

@implementation AddTripVC1

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
    self.title = self.titleStr;
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.startpoi = [AMapPOI new];
    self.endpoi = [AMapPOI new];
    self.startGeoPoint = [AMapGeoPoint new];
    self.endGeoPoint = [AMapGeoPoint new];
    if ([self.titleStr isEqualToString:@"编辑路线"]) {
        //控件赋值
        [self kongjianFuZhi];
    }
    

    
}
#pragma mark - 控件赋值
-(void)kongjianFuZhi{
    
    self.date.text = self.tripModel.date;
    self.time.text = self.tripModel.time;
    self.startPlace.text = self.tripModel.startPlace;
    self.startpoi.name = self.tripModel.startPlace;
    self.startGeoPoint.latitude =[self.tripModel.startPlaceLat doubleValue];
    self.startGeoPoint.longitude =[self.tripModel.startPlaceLng doubleValue];

    self.endpoi.name = self.tripModel.endPlace;
    self.endGeoPoint.latitude =[self.tripModel.endPlaceLat doubleValue];
    self.endGeoPoint.longitude =[self.tripModel.endPlaceLng doubleValue];
    self.endPlace.text = self.tripModel.endPlace;
    self.seatNumber.text = [NSString stringWithFormat:@"可提供%@座", self.tripModel.seatNumber];
    self.seatNumberStr = self.tripModel.seatNumber;
    self.priceStr = self.tripModel.price;
    self.price.text = [NSString stringWithFormat:@"%@元", self.tripModel.price];;
    NSLog(@"%@",[self.startpoi.location yy_modelToJSONObject]);
    
    
}

#pragma mark - 日期
- (IBAction)DateAction:(UIButton *)sender {
    
    if (!dater) {
        dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
        dater.delegate=self;
        [dater showInView:self.view animated:YES];
        dater.dateViewType=XFDateViewTypeDate;
    }else{
        [dater showInView:self.view animated:YES];
    }
    
}
#pragma mark - 时间
- (IBAction)TimeAction:(UIButton *)sender {
    
    
    if (!timer) {
        timer=[[XFDaterView alloc]initWithFrame:CGRectZero];
        timer.delegate=self;
        [timer showInView:self.view animated:YES];
        timer.dateViewType=XFDateViewTypeTime;
    }else{
        [timer showInView:self.view animated:YES];
    }
}

#pragma mark -
- (void)daterViewDidClicked:(XFDaterView *)daterView{
    if ([daterView isEqual:dater]) {
      self.date.text =daterView.dateString;
        
    }
    if ([daterView isEqual:timer]) {
         self.time.text = [NSString stringWithFormat:@"%@",[daterView.timeString substringToIndex:5]] ;
    }
    
    
}
#pragma mark -  日历取消
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    
    
    
    
}
#pragma mark - 可提供座位数量
- (IBAction)seatNumberAction:(UIButton *)sender {
    //Push 跳转
    AddTirpinfoVC * VC = [[AddTirpinfoVC alloc]initWithNibName:@"AddTirpinfoVC" bundle:nil];
    VC.titleStr = @"座位数量";
    __weak typeof(self) weakSelf = self;
    if (self.tripModel.seatNumber.length!=0) {
         VC.RightTFStr = self.tripModel.seatNumber;
    }
   
    [VC ReturnAddTirpinfoVC:^(NSString *str) {
        sender.titleLabel.text = str;
        weakSelf.seatNumber.text = [NSString stringWithFormat:@"可提供%@座",str];
        weakSelf.seatNumberStr = str;
    }];
    [self.navigationController  pushViewController:VC animated:YES];

}
#pragma mark - 出发地
- (IBAction)startPlaceAction:(UIButton *)sender {
    //Push 跳转
    GDPoiVC * VC = [[GDPoiVC alloc]initWithNibName:@"GDPoiVC" bundle:nil];
    __weak typeof(self) weakSelf = self;

    [VC ReturnGDPoiVCPOI:^(AMapPOI *poi) {
       
        weakSelf.startPlace.text = poi.name;
        weakSelf.startpoi = poi;
        
        if ([self.titleStr isEqualToString:@"编辑路线"]) {
            self.startGeoPoint.latitude =poi.location.latitude ;
            self.startGeoPoint.longitude =poi.location.longitude;
            
        }
        
        
        
    }];
    [self.navigationController  pushViewController:VC animated:YES];

}
#pragma mark - 目的地
- (IBAction)endPlaceAction:(UIButton *)sender {
    //Push 跳转
    GDPoiVC * VC = [[GDPoiVC alloc]initWithNibName:@"GDPoiVC" bundle:nil];
    __weak typeof(self) weakSelf = self;

    [VC ReturnGDPoiVCPOI:^(AMapPOI *poi) {
        weakSelf.endPlace.text = poi.name;
        weakSelf.endpoi = poi;
        if ([self.titleStr isEqualToString:@"编辑路线"]) {
            self.endGeoPoint.latitude =poi.location.latitude ;
            self.endGeoPoint.longitude =poi.location.longitude;
            
        }
    }];
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - 每座价格
- (IBAction)priceAction:(UIButton *)sender {
    //Push 跳转
    AddTirpinfoVC * VC = [[AddTirpinfoVC alloc]initWithNibName:@"AddTirpinfoVC" bundle:nil];
    VC.titleStr = @"座位价格";
    __weak typeof(self) weakSelf = self;
    if (self.tripModel.price.length!=0) {
        VC.RightTFStr = self.tripModel.price;
    }
    

    [VC ReturnAddTirpinfoVC:^(NSString *str) {
    
    weakSelf.price.text = [NSString stringWithFormat:@"%@元/座",str];
        weakSelf.priceStr = str;
    }];
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - 保存路线
-(IBAction)saveAction:(PublicBtn *)sender {
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
    model.date = self.date.text;
    model.time = self.time.text;
    model.seatNumber = self.seatNumberStr;
    model.startPlace = self.startpoi.name;
    model.endPlace = self.endpoi.name;
    model.price = self.priceStr;

    if ([self.titleStr isEqualToString:@"编辑路线"]) {
        model.startPlaceLat =[NSString stringWithFormat:@"%f", self.startGeoPoint.latitude];
        model.startPlaceLng = [NSString stringWithFormat:@"%f", self.startGeoPoint.longitude];;
        model.endPlaceLat = [NSString stringWithFormat:@"%f", self.endGeoPoint.latitude];
        model.endPlaceLng = [NSString stringWithFormat:@"%f", self.endGeoPoint.longitude];
    }else{
        model.startPlaceLat =[NSString stringWithFormat:@"%f", self.startpoi.location.latitude];
        model.startPlaceLng = [NSString stringWithFormat:@"%f", self.startpoi.location.longitude];;
               model.endPlaceLat = [NSString stringWithFormat:@"%f", self.endpoi.location.latitude];
        model.endPlaceLng = [NSString stringWithFormat:@"%f", self.endpoi.location.longitude];
    }
    
    NSLog(@"%@",[model yy_modelToJSONObject]);
    
    
    NSString * act;
    if ([self.titleStr isEqualToString:@"编辑路线"]) {
         model.planId = self.tripModel.planId;
        act = @"act=MerApi/TravelPlan/requestUpdatePlan";
    }else{
        act = @"act=MerApi/TravelPlan/requestAddPlan";

    }
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:act sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@"添加路线----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                weakself.view.userInteractionEnabled = YES;
                if ([self.titleStr isEqualToString:@"编辑路线"]) {
                    
                    
                    weakself.returnAddTripVC1(model);
                    [weakself.navigationController popViewControllerAnimated:YES];
                }else{
                    //Push 跳转
                    ReleaseTripVC * VC = [[ReleaseTripVC alloc]initWithNibName:@"ReleaseTripVC" bundle:nil];
                   
                    model.planId =response[@"data"][@"planId"];
                    VC.tripModel = model;
                    [weakself.navigationController  pushViewController:VC animated:YES];
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

-(void)ReturnAddTripVC1:(ReturnAddTripVC1)block{
    self.returnAddTripVC1= block;
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

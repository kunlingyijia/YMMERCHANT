//
//  COrderDetails.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "COrderDetails.h"
#import "COrderDetailsOneCell.h"
#import "COrderDetailsTwoCell.h"
#import "COrderDetailsThreeCell.h"
#import "COrderDetailsFourCell.h"
#import "RequestMyBminorderDetail.h"
#import "RequestMyBminorderDetailModel.h"
#import "RequestBminorderListModel.h"
#import "RequestBminDeelOrder.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface COrderDetails ()<AMapLocationManagerDelegate>
@property(nonatomic,strong)RequestBminorderListModel*orderModel ;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
//定位
@property (nonatomic ,strong) AMapLocationManager *locationManager;
@property(nonatomic,assign)   CLLocationCoordinate2D startLocation ;
@end

@implementation COrderDetails
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}
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
    self.title = @"订单详情";
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self ShowNodataView];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [self.tableView tableViewregisterNibArray:@[@"COrderDetailsOneCell",@"COrderDetailsTwoCell",@"COrderDetailsThreeCell",@"COrderDetailsFourCell"]];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    [self getOrderMessage];
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
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestBminorderDetail" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            weakSelf.orderModel = [RequestBminorderListModel yy_modelWithJSON:baseRes.data];
            //0-已预约(未接单),1-已接单(未上门),2-待支付(已上门),3-已完成,4-取消订单(商家已接单可帮取消)，5-商家拒接接单（未接单时）
            if (weakSelf.orderModel.status ==0) {
                self.BtnConstraintHeight.constant =40;
                [weakSelf.LeftBtn setTitle:@"接单" forState:(UIControlStateNormal)];
                [weakSelf.RightBtn setTitle:@"拒绝接单" forState:(UIControlStateNormal)];
            }else if (weakSelf.orderModel.status ==1){
                weakSelf.LeftBtn.hidden = NO;
                weakSelf.RightBtn.hidden = NO;
                 self.BtnConstraintHeight.constant =40;
                [weakSelf.LeftBtn setTitle:@"上门服务" forState:(UIControlStateNormal)];
                [weakSelf.RightBtn setTitle:@"取消订单" forState:(UIControlStateNormal)];
            }else{
                 self.BtnConstraintHeight.constant =0;
                weakSelf.LeftBtn.hidden = YES;
                weakSelf.RightBtn.hidden = YES;
            }
            [weakSelf.dataArray removeAllObjects];
            for (NSDictionary* dic in weakSelf.orderModel.bminServiceList) {
                RequestBminorderListModel* orderModel = [RequestBminorderListModel yy_modelWithJSON:dic];
                [weakSelf.dataArray addObject:orderModel];
            }
            [weakSelf.tableView reloadData];
            [self HiddenNodataView];
        }else {
            [weakSelf showToast:baseRes.msg];
        }
    } faild:^(id error) {
    }];
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 4;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 1;
            break;
        }
        case 1:
        {
            return self.dataArray.count;
            break;
        }
        case 2:
        {
            return 1;
            break;
        }
        case 3:
        {
            return 1;
            break;
        }
        default:{
            return 0;
            break;
        }
    }
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            COrderDetailsOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"COrderDetailsOneCell" forIndexPath:indexPath];
            cell.model = self.orderModel;
            __weak typeof(self) weakSelf = self;
            cell.COrderDetailsOneCellBlock =^(){
                __weak typeof(self) weakSelf = self;
                [weakSelf alertWithTitle:@"呼叫?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"稍后" withOKDefault:^(UIAlertAction *defaultaction) {
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",weakSelf.orderModel.tel];
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    
                    
                } withCancel:^(UIAlertAction *cancelaction) {
                    
                }];
            };
            //选择地图
            cell.COrderDetailsOneCellLocationBlock =^(){
//                [weakSelf alertActionSheetWithTitle:nil message:nil OKWithTitleOne:@"百度地图" OKWithTitleTwo:@"高德地图" CancelWithTitle:@"取消" withOKDefaultOne:^(UIAlertAction *defaultaction) {
//                    [weakSelf  BaiDuMap];
//                   
//                } withOKDefaultTwo:^(UIAlertAction *defaultaction) {
//                    [weakSelf  GaoDeMap];
//                    
//                   
//                    
//                    
//                    
//                } withCancel:^(UIAlertAction *cancelaction) {
//              }];
                
                [weakSelf alertActionSheetWithTitle:nil message:nil OKWithTitleOne:@"苹果地图" OKWithTitleTwo:@"百度地图" OKWithTitleThree:@"高德地图" CancelWithTitle:@"取消" withOKDefaultOne:^(UIAlertAction *defaultaction) {
                    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(weakSelf.orderModel.lat , weakSelf.orderModel.lng );
                    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                    currentLocation.name =@"我的位置";
                    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
                    toLocation.name =weakSelf.orderModel.address;
                    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
                } withOKDefaultTwo:^(UIAlertAction *defaultaction) {
                     [weakSelf  BaiDuMap];
                } withOKDefaultThree:^(UIAlertAction *defaultaction) {
                    [weakSelf  GaoDeMap];
                } withCancel:^(UIAlertAction *cancelaction) {
                    
                }];
                
            };
             return cell;
            break;
        }
        case 1:
        {
            COrderDetailsTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"COrderDetailsTwoCell" forIndexPath:indexPath];
            
            cell.model = indexPath.row>= self.dataArray.count ? nil :self.dataArray[indexPath.row];
                       return cell;
            break;
        }
        case 2:
        {
            COrderDetailsThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"COrderDetailsThreeCell" forIndexPath:indexPath];
            
             cell.model = self.orderModel;
            return cell;
            break;
        }
            
        case 3:
        {
            COrderDetailsFourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"COrderDetailsFourCell" forIndexPath:indexPath];
            
             cell.model = self.orderModel;
            return cell;
            break;
        }

        default:{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            
                       return cell;
            break;
            
        }
    }

   
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            //return Width*4/9+13;
            //用storyboard 进行自适应布局
            self.tableView.estimatedRowHeight = 300;
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            return self.tableView.rowHeight;

            break;
        }
            
        case 1:
        {
            //用storyboard 进行自适应布局
            self.tableView.estimatedRowHeight = 300;
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            return self.tableView.rowHeight;
            break;
        }
        case 2:
        {
             return Width*6/9;
            break;
        }
            
        case 3:
        {
            return Width*6/9+10;

            break;
        }
            
        default:{
            
            break;
            
        }
    }
    return 80;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 左侧按钮
- (IBAction)LeftBtnAction:(UIButton *)sender {
    //0-已预约(未接单),1-已接单(未上门),2-待支付(已上门),3-已完成,4-取消订单(商家已接单可帮取消)，5-商家拒接接单（未接单时）
    if (self.orderModel.status ==0) {
        [self handleOrderWithType:1];
    }else if (self.orderModel.status ==1){
        [self handleOrderWithType:2];
    }
}

#pragma mark - 右侧按钮
- (IBAction)RightBtnAction:(UIButton *)sender {
    
    if (self.orderModel.status ==0) {
        [self handleOrderWithType:5];
    }else if (self.orderModel.status ==1){
       [self handleOrderWithType:4];
    }
}
#pragma mark - 订单处理
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
#pragma mark - 百度地图
-(void)BaiDuMap{
    NSString *name = self.orderModel.address;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
            CLLocationCoordinate2D Coordinate ;
            Coordinate.latitude = self.orderModel.lat;
            Coordinate.longitude = self.orderModel.lng;
            CLLocationCoordinate2D Coordinate2D = [self BD09FromGCJ02:Coordinate];
            NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",_startLocation.latitude, _startLocation.longitude,  Coordinate2D.latitude, Coordinate2D.longitude, name];
            [self openMap:urlString];
        }else {
            [self sheetAction:@"百度地图"];
        }
}
#pragma mark - 高德地图
-(void)GaoDeMap{
    
    
    NSString *name = self.orderModel.address;
    CLLocationCoordinate2D Coordinate ;
    Coordinate.latitude = self.orderModel.lat;
    Coordinate.longitude = self.orderModel.lng;
     //style  导航方式(0 速度快; 1 费用少; 2 路程短; 3 不走高速；4 躲避拥堵；5 不走高速且避免收费；6 不走高速且躲避拥堵；7 躲避收费和拥堵；8 不走高速躲避收费和拥堵)
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=2",name, Coordinate.latitude , Coordinate.longitude ];
        [self openMap:urlString];
    }else {
        [self sheetAction:@"高德地图"];
    }
}
- (void)openMap:(NSString *)urlString {
    NSString *string = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    [[UIApplication sharedApplication] openURL:url];
}
// 高德坐标转百度坐标
- (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude, y = coor.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}
- (void)sheetAction:(NSString *)title {
    UIAlertView *alertController = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您还未安装%@客户端,请安装", title] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertController show];
    
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    self.startLocation = location.coordinate;
    
    [self.locationManager stopUpdatingLocation];
    
}

@end

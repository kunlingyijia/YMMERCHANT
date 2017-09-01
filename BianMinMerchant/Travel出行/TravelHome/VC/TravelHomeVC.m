//
//  TravelHomeVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelHomeVC.h"
#import "LBXScanWrapper.h"
#import "LBXScanViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXViewController.h"
#import "TravelSettingVC.h"
#import "OwnerModel.h"
#import "TravelHomeOneCell1.h"
#import "TravelHome21.h"
#import "TravelHome222.h"
#import "TravelHome233.h"
#import "TravelHome244.h"
#import "TravelHomeThreeCell1.h"
#import "TripModel.h"
#import "TravelHomeHeaderView.h"
#import "AddTripVC1.h"
#import "TripDetailsVC.h"
#import "ReleaseTripVC.h"
#import "OwnerCertificationVC.h"
#import "LocationModel.h"
#import "HomeViewModel.h"
#import "JPUSHService.h"
#import "PublicMessageVC.h"
#import "TraveHomeTwoHeader.h"
@interface TravelHomeVC ()<UITableViewDelegate,UITableViewDataSource,LBXscanViewDelegate,AMapLocationManagerDelegate>{
    dispatch_source_t _timer;
    HomeViewModel *homeVM;
    TravelHomeHeaderView * headerView;
}
//定位
@property (nonatomic ,strong) AMapLocationManager *locationManager;
@property(nonatomic,strong)LocationModel *locationModel;
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  TravelHomeHeaderView *navigationView;
@property(nonatomic,strong)OwnerModel*ownerModel;
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSString * dateString;
@end
@implementation TravelHomeVC
//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //获取车主信息
    [self requestAction];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    homeVM = [HomeViewModel new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PublicMessageVC) name:@"出行消息列表" object:nil];
//    homeVM.HomeVC = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 推送跳转到消息列表
-(void)PublicMessageVC{
      // 否则，跳转到我的消息
    PublicMessageVC *message = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
    UIViewController * viewControllerNow = [self currentViewController];
    if ([viewControllerNow  isKindOfClass:[PublicMessageVC class]]) {   //如果是页面XXX，则执行下面语句
        [message getDataList];
    }else{
          [viewControllerNow.navigationController pushViewController:message animated:YES];
    }
}


#pragma mark - 关于UI
-(void)SET_UI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+20) style:(UITableViewStylePlain)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.navigationView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView tableViewregisterNibArray:@[@"TravelHomeOneCell1",@"TravelHome21",@"TravelHome222",@"TravelHome233",@"TravelHome244",@"TravelHomeThreeCell1"]];
    self.tableView.tableFooterView = [UIView new];
    self.navigationView = [[TravelHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    [self.navigationView.leftBtn addTarget:self action:@selector(ScanAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navigationView.RightTwoBtn addTarget:self action:@selector(Message:) forControlEvents:(UIControlEventTouchUpInside)];
     [self.navigationView.RightBtn addTarget:self action:@selector(MoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_navigationView];
    headerView =[[TravelHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    [headerView.leftBtn addTarget:self action:@selector(ScanAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView.RightBtn addTarget:self action:@selector(MoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView.RightTwoBtn addTarget:self action:@selector(Message:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tableView.tableHeaderView = headerView;
   
}
#pragma mark - 扫一扫
-(void)ScanAction:(UIButton*)sender{
    

    //设置扫码区域参数设置
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"icon_saoyisao_saomiaoxian"];
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    LBXViewController *vc = [[LBXViewController alloc] init];
    vc.title = @"扫一扫";
    vc.delegate = self;
    vc.style = style;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)backAction:(LBXScanResult *)result {
     NSString *  strone = [result.strScanned substringToIndex:4];
    if (![strone isEqualToString:@"dwbm"]) {
       [self alertWithTitle:@"温馨提示" message:@"目前在不支持" OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
       }];
        return;
    }else{
        NSString *str = [result.strScanned substringFromIndex:7];
        NSArray * Arr = [str componentsSeparatedByString:@":"];
        __weak typeof(self) weakSelf = self;
        [self alertWithTitle:@"是否上车?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            TripModel *orderUse = [[TripModel alloc] init];
            orderUse.orderNo = Arr[0];
            orderUse.orderId = Arr[1];
            BaseRequest *request = [[BaseRequest alloc] init];
            request.encryptionType = AES;
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            request.token = [userD objectForKey:@"loginToken"];
            request.data = [AESCrypt encrypt:[orderUse yy_modelToJSONString] password:[userD objectForKey:@"loginKey"]];
            [[DWHelper shareHelper] requestDataWithParm:[request yy_modelToJSONString] act:@"act=MerApi/TravelOrder/requestTravelOrderScan" sign:[request.data MD5Hash] requestMethod:GET success:^(id response) {
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                if (baseRes.resultCode == 1) {
                    [weakSelf hideProgress];
                    [weakSelf showToast:@"消费成功"];
                }else {
                    
                    [weakSelf showToast:baseRes.msg];
                }
                [weakSelf hideProgress];
            } faild:^(id error) {
                
            }];
            
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }
}

- (void)useOrderNo:(LBXScanResult *)sender{
    
}

#pragma mark - 消息中心
-(void)Message:(UIButton*)sender{
    //Push 跳转
    PublicMessageVC * VC = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - 设置
-(void)MoreAction:(UIButton*)sender{
    //Push 跳转
    TravelSettingVC * VC = [[TravelSettingVC alloc]initWithNibName:@"TravelSettingVC" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex = 1;
    //获取配置信息
    [homeVM getConfig:self];
    [self Refresh];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    self. dateString = [dateFormatter stringFromDate:currentDate];
    [self  LocalData];
    
}
- (void)getConfig {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = @[];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestConfig" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@",response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        RequestConfigModel *model = [RequestConfigModel yy_modelWithJSON:baseRes.data];
        [DWHelper shareHelper].configModel = model;
        NSLog(@"%f",[[DWHelper shareHelper].configModel.openPositionTime floatValue]);
    } faild:^(id error) {
        
    }];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.navigationView.hidden = YES;
        weakself.pageIndex =1 ;
        //获取车主信息
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        [weakself requestPlanList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 本地
-(void)LocalData{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
    NSMutableDictionary * DriverInfo = [AuthenticationModel objectForKey:@"DriverInfo"];
    if (DriverInfo.count!=0) {
        self.ownerModel = [OwnerModel
                               yy_modelWithJSON:DriverInfo];
    //NSLog(@"*****%@",[self.ownerModel yy_modelToJSONObject]);
    NSMutableArray * PlanList = [AuthenticationModel objectForKey:@"PlanList"];
        if (PlanList.count!=0) {
            if (self.pageIndex==1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dicdata in PlanList) {
                TripModel *model = [TripModel yy_modelWithJSON:dicdata];
                [self.dataArray addObject:model];
            }
            //刷新
            [self.tableView reloadData];
        }
    }
  }
}
#pragma mark - 车主信息
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    ;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelDriver/requestDriverInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"获取车主信息----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSMutableDictionary *dic = response[@"data"];
                [AuthenticationModel setValue:response forkey:@"DriverInfo"];
                weakself.ownerModel = [OwnerModel
                                   yy_modelWithJSON:dic];
                weakself.navigationView.title.text = weakself.ownerModel.realName;
                headerView.title.text = weakself.ownerModel.realName;
                [DWHelper shareHelper].shopModel =[RequestMerchantInfoModel yy_modelWithJSON: dic];
                
                [weakself.tableView reloadData];
                [weakself requestPlanList];
                
                ///是否开启时时定位，1-开启，0-否
                if ([weakself.ownerModel.isOpenPosition isEqualToString:@"0"]) {
                    //关ཽ闭ཽ定ཽ位ཽ
                    [weakself stopSerialLocation];
                    //停用计时器
                    if (_timer) {
                         dispatch_cancel(_timer);
                    }
                }else{
                    //打ཽ开ཽ定ཽ位ཽ
                    [weakself startSerialLocation];
                }
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}
#pragma mark - 行程列表
-(void)requestPlanList{
    NSString *Token =[AuthenticationModel getLoginToken];
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelPlan/requestPlanList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"行程列表----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                if (weakself.pageIndex == 1) {
                    [weakself.dataArray removeAllObjects];
                     [AuthenticationModel setValue:response forkey:@"PlanList"];
                }
                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                    TripModel *model = [TripModel yy_modelWithJSON:dicdata];
                    [weakself.dataArray addObject:model];
                }
                //刷新
                [weakself.tableView reloadData];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }

}

#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 2;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ( self.ownerModel.status.length==0
        ) {
        [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:0];
        return 0;
    }else{
    [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:1];
    switch (section) {
        case 0:
        {
           return 2;
            break;
        }
        case 1:
        {  if([self.ownerModel.status isEqualToString:@"3"]){
             return self.dataArray.count;
        }else{
            return 0;
        }
            break;
        }
        default:{
             return 10;
            break;
        }
      }
    }
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ownerModel.status.length==0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
        return cell;
    }else{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
            TravelHomeOneCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHomeOneCell1" forIndexPath:indexPath];
                //cell.dateTime.text =[NSString stringWithFormat:@"今日交易(%@)", self.dateString];
                cell.dateTime.text =[NSString stringWithFormat:@"今日交易额"];
                cell.tradeMoneyDay.text =[NSString stringWithFormat:@"%@元", self.ownerModel.tradeMoneyDay];
                 NSLog(@"*****%@",[self.ownerModel yy_modelToJSONObject]);
                if ([self.ownerModel.status isEqualToString:@"3"]) {
                    cell.carNo.text =self.ownerModel.carNo;
                }else{
                    cell.carNo.text =@"";
                }
                return cell;
            }else if (indexPath.row==1) {
                ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
                if ([self.ownerModel.status isEqualToString:@"3"]) {
                    if (self.dataArray.count==0) {
                        TravelHome233 * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHome233" forIndexPath:indexPath];
                        [cell.OneBtn addTarget:self action:@selector(AddBtnTrip:) forControlEvents:(UIControlEventTouchUpInside)];
                        return cell;
                    }else{
                        TravelHome222 * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHome222" forIndexPath:indexPath];
                        [cell.AddBtn addTarget:self action:@selector(AddBtnTrip:) forControlEvents:(UIControlEventTouchUpInside)];
                        return cell;
                    }
                }else if(![self.ownerModel.status isEqualToString:@"3"]){
                    NSLog(@"%@",self.ownerModel.status);
                    TravelHome244 * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHome244" forIndexPath:indexPath];
                    [cell.OneBtn addTarget:self action:@selector(OneBtnOwnerCertification:) forControlEvents:(UIControlEventTouchUpInside)];
                    [cell.TwoBtn addTarget:self action:@selector(OneBtnOwnerCertification:) forControlEvents:(UIControlEventTouchUpInside)];
                    return cell;
                }else{
                    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                    return cell;
                }
            }else{
                return nil;
            }
            break;
        }
            
        case 1:
        {
        TravelHomeThreeCell1
            * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHomeThreeCell1" forIndexPath:indexPath];
            
            [cell CellGetData:self.dataArray[indexPath.row]];
            return cell;

            break;
        }
         default:{
            
        return nil;

            break;
            
        }
    }
  }
}

#pragma mark - 跳转到添加路线
-(void)AddBtnTrip:(UIButton*)sender{
    //Push 跳转
    AddTripVC1 * VC = [[AddTripVC1 alloc]initWithNibName:@"AddTripVC1" bundle:nil];
    VC.titleStr = @"添加路线";
    [self.navigationController  pushViewController:VC animated:YES];
}

#pragma mark - 车主认证
-(void)OneBtnOwnerCertification:(UIButton*)sender{
    if ([self.ownerModel.status isEqualToString:@"2"]) {
        [self showToast:@"审核中.."];
    }else{
        //Push 跳转--车主认证
        OwnerCertificationVC * VC = [[OwnerCertificationVC alloc]initWithNibName:@"OwnerCertificationVC" bundle:nil];
        __weak typeof(self) weakSelf = self;

        VC.OwnerCertificationVCBlock =^(){
            [weakSelf requestAction];
        };
        [self.navigationController  pushViewController:VC animated:YES];
    }

}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        TripModel *model= self.dataArray[indexPath.row];
        if ([model.status isEqualToString:@"1"]) {
            // @"发布";
            ReleaseTripVC * VC = [[ReleaseTripVC alloc]initWithNibName:@"ReleaseTripVC" bundle:nil];
            VC.tripModel = model;
            [self.navigationController  pushViewController:VC animated:YES];
            }else {
            //行程状态：1-待发布，2-已发布 ，3-待发车,4-已发车 ，5-已结束
                TripDetailsVC * VC = [[TripDetailsVC alloc]initWithNibName:@"TripDetailsVC" bundle:nil];
                VC.beforeTripModel= (TripModel*)self.dataArray[indexPath.row];
                [self.navigationController  pushViewController:VC animated:YES];
        }
    }
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                return Width*0.4;
            }else{
                ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
                if ([self.ownerModel.status isEqualToString:@"3"]) {
                    if (self.dataArray.count==0) {
                      return Height- Width*0.4-64;
                    }else{
                        return 88;
                    }
                }else{
                   return Height-Width*0.4-64;
                }
            }
            break;
        }
        case 1:
        {
            return 0.3*Width;
            break;
        }
            default:{
            return 0;
            break;
        }
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==1 ?YES :NO;
}
//iOS 8.0 后才有的方法
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        TripModel *model= self.dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf alertWithTitle:@"是否删除?" message:nil OKWithTitle:@"删除" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            NSString *Token =[AuthenticationModel getLoginToken];
            __weak typeof(self) weakself = self;
            if (Token.length!= 0) {
                BaseRequest *baseReq = [[BaseRequest alloc] init];
                baseReq.token = [AuthenticationModel getLoginToken];
                baseReq.encryptionType = AES;
                baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
                [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelPlan/requestDeletePlan" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                    NSLog(@"删除行程(新增)----%@",response);
                    if ([response[@"resultCode"] isEqualToString:@"1"]) {
                        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                        [weakSelf.tableView reloadData];
                    }else{
                        [weakSelf.tableView reloadData];
                        [weakself showToast:response[@"msg"]];
                    }
                } faild:^(id error) {
                    NSLog(@"%@", error);
                }];
            }
        } withCancel:^(UIAlertAction *cancelaction) {
        }];
           }];
    return @[delete];
    }else{
        return @[];
    }
 }
#pragma mark -  只要拖拽就会触发(scrollView 的偏移量发生改变)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<-20) {
        self.navigationView.hidden = YES;
    }else if(scrollView.contentOffset.y>-19){
        self.navigationView.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 更新行程车主位置
-(void)requestUpdatePosition{
    __weak typeof(self) weakSelf = self;
    //GCD定时器
    NSTimeInterval period ;
    if ([[DWHelper shareHelper].configModel.openPositionTime floatValue] !=0) {
       period = [[DWHelper shareHelper].configModel.openPositionTime floatValue]; //设置时间间隔
    }else{
        period = 10; //设置时间间隔
    }
        NSLog(@"%f",[[DWHelper shareHelper].configModel.openPositionTime floatValue]);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        NSLog(@"每秒执行test");
        LocationModel *model = [LocationModel new];
        NSString *Token =[AuthenticationModel getLoginToken];
        model.lat = weakSelf.locationModel.lat;
        model.lng = weakSelf.locationModel.lng;
        if (Token.length!= 0) {
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = AES;
            baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelDriver/requestUpdatePosition" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                if ([response[@"resultCode"] isEqualToString:@"1"]) {
                    // [weakSelf showToast:@"行程发送成功"];
                }else{
                    [weakSelf showToast:response[@"msg"]];
                }
            } faild:^(id error) {
                NSLog(@"%@", error);
            }];
        }else {
        }
    });
    
    dispatch_resume(_timer);
}
- (void)startSerialLocation
{
    if (!_locationManager) {
        //开始定位
        self.locationManager = [[AMapLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        [self.locationManager startUpdatingLocation];
        
    }
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     [weakSelf requestUpdatePosition];
    });
}
- (void)stopSerialLocation
{
    if (!_locationManager) {
        //停止定位
        [self.locationManager stopUpdatingLocation];
    }
}
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (!_locationModel) {
         self.locationModel = [[LocationModel alloc]init];
         _locationModel.lat =[NSString stringWithFormat:@"%f",location.coordinate.latitude];
         _locationModel.lng =[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    }else{
        _locationModel.lat =[NSString stringWithFormat:@"%f",location.coordinate.latitude];
        _locationModel.lng =[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    }
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
-(UIViewController*) findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
-(UIViewController*) currentViewController {
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
    
}
@end

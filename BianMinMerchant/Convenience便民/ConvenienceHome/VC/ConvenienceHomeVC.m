//
//  ConvenienceHomeVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/4.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ConvenienceHomeVC.h"
#import "TravelHomeHeaderView.h"
#import "BMOrderCell.h"
#import "BulkHomeOneCell.h"
#import "convenienceHomeCell.h"
#import "BMSecondOrederCell.h"
#import "SettingViewController.h"
#import "OrderDetailView.h"
#import "RequestMerchantInfoModel.h"
#import "LBXScanWrapper.h"
#import "LBXScanWrapper.h"
#import "LBXScanViewController.h"
#import "LBXScanView.h"
#import "LBXScanWrapper.h"
#import "LBXViewController.h"
#import "WriteMessageViewController.h"
#import "CompletionDataVC.h"
#import "RequestBminorderList.h"
#import "RequestBminorderListModel.h"
#import "JPUSHService.h"
#import "COrderDetails.h"
#import "PublicMessageVC.h"
#import "NewCompleonDataVC.h"
@interface ConvenienceHomeVC ()
{
    TravelHomeHeaderView * headerView;
}
@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;

@property (strong, nonatomic)  TravelHomeHeaderView *navigationView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger btnIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation ConvenienceHomeVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //获取店主信息
    [self getShopData];
    self.pageIndex = 1;
    [self getDataListWithType:self.btnIndex+1];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PublicMessageVC) name:@"便民消息列表" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataOrderData) name:@"修改商户资料" object:nil];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
- (void)updataOrderData {
    
    [self getShopData];
    self.pageIndex = 1;
    [self getDataListWithType:self.btnIndex+1];
}


#pragma mark - 关于UI
-(void)SET_UI{
    self.navigationView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [self.tableView tableViewregisterNibArray:@[@"BulkHomeOneCell",@"BMOrderCell",@"BMSecondOrederCell",@"convenienceHomeCell"]];
    self.tableView.tableFooterView = [UIView new];
    self.navigationView = [[TravelHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    self.navigationView.leftBtn.hidden = YES;
    
    [self.navigationView.RightBtn addTarget:self action:@selector(MoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
     [self.navigationView.RightTwoBtn addTarget:self action:@selector(Message:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_navigationView];
    headerView=[[TravelHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    headerView.leftBtn.hidden = YES;
    [headerView.RightTwoBtn addTarget:self action:@selector(MoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView.RightBtn addTarget:self action:@selector(Message:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - 消息中心
-(void)Message:(UIButton*)sender{
    //Push 跳转
    PublicMessageVC * VC = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
    
    
    
}
#pragma mark - 更多
-(void)MoreAction:(UIButton*)sender{
    SettingViewController *settingC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
    settingC.shopModel = self.shopModel;
    [self.navigationController pushViewController:settingC animated:YES];
    
    
}

-(void)SET_DATA{
    self.btnIndex = 0;
    self.pageIndex = 1;
    self.shopModel = [RequestMerchantInfoModel new];
    [self Refresh];
    [self LocalData];
    [self getShopData];
    //获取配置信息
    [self getConfig];    
}

-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.navigationView.hidden = YES;
        self.pageIndex = 1;
        [self getDataListWithType:self.btnIndex+1];
        [weakself  getShopData];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        [self getDataListWithType:self.btnIndex+1];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
- (void)getConfig {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = @[];
    
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestConfig" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        RequestConfigModel *model = [RequestConfigModel yy_modelWithJSON:baseRes.data];
        [DWHelper shareHelper].configModel = model;
        
    } faild:^(id error) {
        
    }];
}

#pragma mark - 本地存储
-(void)LocalData{
    
    NSMutableDictionary * DriverInfo = [AuthenticationModel objectForKey:@"BMMerchantInfo"];
    NSLog(@"%@",DriverInfo);
    if (DriverInfo.count!=0) {
        self.shopModel = [RequestMerchantInfoModel
                          yy_modelWithJSON:DriverInfo];
        self.navigationView.title.text = self.shopModel.merchantName;
        headerView.title.text =self.shopModel.merchantName;
        
        DWHelper *helper = [DWHelper shareHelper];
        helper.messageStatus = self.shopModel.status;
        helper.shopModel = self.shopModel;
        [self.tableView reloadData];
    }
}

- (void)getShopData {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[[NSArray array] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;
    
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestMerchantInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            weakSelf.shopModel = [RequestMerchantInfoModel yy_modelWithJSON:baseRes.data];
            [AuthenticationModel setValue:response forkey:@"BMMerchantInfo"];
            weakSelf.navigationView.title.text = weakSelf.shopModel.merchantName;
            headerView.title.text =weakSelf.shopModel.merchantName;
           
            DWHelper *helper = [DWHelper shareHelper];
            helper.messageStatus = weakSelf.shopModel.status;
            helper.shopModel = weakSelf.shopModel;
            
            [weakSelf.tableView reloadData];
        }else {
        }
        
    } faild:^(id error) {
        
    }];
}
- (void)getDataListWithType:(NSInteger)type {
    RequestBminorderList *list = [[RequestBminorderList alloc] init];
    list.pageCount = 10;
    list.pageIndex = self.pageIndex;
    list.orderType = type;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[list yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestBminorderList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestBminorderListModel *model = [RequestBminorderListModel yy_modelWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];

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
    return 2;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            
            return 2;
            
            break;
        }
            
        case 1:
        {
            return self.dataArray.count;
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
   //tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                BulkHomeOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BulkHomeOneCell" forIndexPath:indexPath];
                cell.barcodeImage.image = [LBXScanWrapper createQRWithString:self.shopModel.merchantNo size:cell.barcodeImage.frame.size];
                [cell CellGetData:self.shopModel];
                __weak typeof(self) weakSelf = self;

                [cell BulkHomeOneCellBlock:^(NSInteger tag ) {
                    [weakSelf btnAction:tag];
                }];
                return cell;
            }else{
                convenienceHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"convenienceHomeCell" forIndexPath:indexPath];
                __weak typeof(self) weakSelf = self;

                [cell convenienceHomeCellBlock:^(NSInteger tag) {
                    weakSelf.btnIndex = tag;
                    weakSelf.pageIndex = 1;
                    [weakSelf getDataListWithType:tag+1];
                    //[weakSelf btnAction:tag];
                }];
                return cell;
            }
            
            
            break;
        }
            
        case 1:
        {
            RequestBminorderListModel *model = self.dataArray[indexPath.row];
            if (self.btnIndex != 0) {
                BMSecondOrederCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BMSecondOrederCell" forIndexPath:indexPath];
                [cell cellGetDataWithModel:model];
                return cell;
            }else{
            BMOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BMOrderCell" forIndexPath:indexPath];
            [cell cellGetDataWithModel:model];
                
            return cell;
            }
            break;
        }
            
            
            
        default:{
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            
            return cell;
            
            break;
            
        }
    }
}



- (void)btnAction:(NSInteger )tag {
    DWHelper *helper = [DWHelper shareHelper];
    if (helper.messageStatus == 0) {
        [self showToast:@"禁用"];
    }else if (helper.messageStatus == 1) {
        [self pushController:tag];
    }else if (helper.messageStatus == 2) {
//        WriteMessageViewController *writeMessage = [[WriteMessageViewController alloc] init];
//        writeMessage.shopModel = self.shopModel;
//        __weak typeof(self) weakSelf = self;
//        
//        writeMessage.backAction =^(NSString *str){
//            [weakSelf getShopData];
//        };
//
//        [self.navigationController pushViewController:writeMessage animated:YES];
        
//        //Push 跳转
//        CompletionDataVC * VC = [[CompletionDataVC alloc]initWithNibName:@"CompletionDataVC" bundle:nil];
//        VC.shopModel = self.shopModel;
//        __weak typeof(self) weakSelf = self;
//        
//        VC.backAction =^(NSString *str){
//            [weakSelf getShopData];
//        };
//        [self.navigationController  pushViewController:VC animated:YES];
        
        
        //Push 跳转
        NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
        
        VC.shopModel = self.shopModel;
        VC.regionId = self.shopModel.regionId;
        __weak typeof(self) weakSelf = self;
        
        VC.backAction =^(NSString *str){
            [weakSelf getShopData];
        };
        [self.navigationController  pushViewController:VC animated:YES];

        
    }else if (helper.messageStatus == 3) {
        [self showToast:@"审核中"];
    }
}
- (void)pushController:(NSInteger)tag {
    
//        WriteMessageViewController *writeMessage = [[WriteMessageViewController alloc] init];
//    __weak typeof(self) weakSelf = self;
//
//    writeMessage.backAction =^(NSString *str){
//        [weakSelf getShopData];
//    };
//        writeMessage.shopModel = self.shopModel;
//        [self.navigationController pushViewController:writeMessage animated:YES];
    //Push 跳转
    NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
    
    VC.shopModel = self.shopModel;
    VC.regionId = self.shopModel.regionId;
    __weak typeof(self) weakSelf = self;
    
    VC.backAction =^(NSString *str){
        [weakSelf getShopData];
    };
    [self.navigationController  pushViewController:VC animated:YES];
}

#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1) {
        RequestBminorderListModel *model = self.dataArray[indexPath.row];
        //Push 跳转
        COrderDetails * orderC= [[COrderDetails alloc]initWithNibName:@"COrderDetails" bundle:nil];
       

//        OrderDetailView *orderC = [[OrderDetailView alloc] init];
        orderC.orderNo = model.orderNo;
        orderC.bminOrderId = model.bminOrderId;
        __weak typeof(self) weakSelf = self;

        orderC.backBlockAction = ^(NSString *str) {
            [weakSelf.dataArray removeAllObjects];
            weakSelf.pageIndex = 1;
            [weakSelf getDataListWithType:self.btnIndex+1];
        };
        [self.navigationController pushViewController:orderC animated:YES];

    }
    
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            
            
            if (indexPath.row==0) {
                return 0.5*Width;
            }else{
                return 0.1*Width;
            }
            
            
            break;
        }
            
        case 1:
        {
             return 0.2*Width;;
            break;
        }
            
            
            
        default:{
            return 0;
            break;
            
        }
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


#pragma mark -  只要拖拽就会触发(scrollView 的偏移量发生改变)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<-20) {
        self.navigationView.hidden = YES;
    }else if(scrollView.contentOffset.y>-19){
        self.navigationView.hidden = NO;
        
    }
}

#pragma mark - 推送跳转到消息中心
-(void)PublicMessageVC{
    // 否则，跳转到我的消息
    PublicMessageVC *message = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
    UIViewController * viewControllerNow = [self currentViewController];
    if ([viewControllerNow  isKindOfClass:[PublicMessageVC class]]) {
        //如果是页面XXX，则执行下面语句
        [message getDataList];
    }else{
        [viewControllerNow.navigationController pushViewController:message animated:YES];
    }
    
    
    
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

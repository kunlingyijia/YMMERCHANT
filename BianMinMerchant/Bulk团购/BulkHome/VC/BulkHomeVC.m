//
//  BulkHomeVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/4.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BulkHomeVC.h"
#import "TravelHomeHeaderView.h"
#import "BulkHomeOneCell.h"
#import "BulkHomeTwoCell.h"
#import "LBXScanWrapper.h"
#import "LBXScanViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXViewController.h"
#import "TardeViewController.h"
#import "MoneyCenterViewController.h"
#import "TicketViewController.h"
#import "ShopCenterViewController.h"
#import "SettingViewController.h"
#import "MerchantModel.h"
#import "JPUSHService.h"
#import "RequestGoodsOrderUser.h"
#import "RequestMerchantInfoModel.h"
#import "WriteMessageViewController.h"
//#import "CompletionDataVC.h"
#import "TravelwithdrawalVC.h"
#import "BulkHomeVC.h"
//#import "CompletionDataVC.h"
#import "NewCompleonDataVC.h"
#import "RequestMerchantCompleteInfo.h"
#import "PublicMessageVC.h"
#import "IndustryCertificationVC.h"
#import "IndustryAmountLIstVC.h"

@interface BulkHomeVC ()<LBXscanViewDelegate>{
    TravelHomeHeaderView * headerView;
}
@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;
@property(nonatomic,strong)MerchantModel *merchantModel;
@property(nonatomic,strong)RequestMerchantCompleteInfo *completeInfo;

@property (strong, nonatomic)  TravelHomeHeaderView *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BulkHomeVC

//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //获取店主信息
    [self getShopData];

    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopData) name:@"修改商户资料" object:nil];
   
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService removeNotification:nil];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PublicMessageVC) name:@"团购消息列表" object:nil];
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
    self.navigationView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell",@"BulkHomeTwoCell"]];
    [self.tableView tableViewregisterNibArray:@[@"BulkHomeOneCell"]];
    self.tableView.tableFooterView = [UIView new];
    self.navigationView = [[TravelHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    self.navigationView.leftBtn.hidden = YES;
    self.navigationView.RightTwoBtn.hidden = YES;
    [self.navigationView.RightBtn addTarget:self action:@selector(MoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_navigationView];
     headerView=[[TravelHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    headerView.leftBtn.hidden = YES;
    headerView.RightTwoBtn.hidden = YES;
    [headerView.RightBtn addTarget:self action:@selector(MoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tableView.tableHeaderView = headerView;
}

-(void)MoreAction:(UIButton*)sender{
    SettingViewController *settingC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
        settingC.shopModel = self.shopModel;
    NSLog(@"%@",[settingC.shopModel yy_modelToJSONObject]);
        [self.navigationController pushViewController:settingC animated:YES];
}
-(void)SET_DATA{
    [self Refresh];
    [self getShopData];
    self.completeInfo = [RequestMerchantCompleteInfo new];
    self.shopModel = [RequestMerchantInfoModel new];
    [self LocalData];
    //获取配置信息
    [self getConfig];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.navigationView.hidden = YES;
       [weakself  getShopData];;
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)updataOrderData {
    // 否则，跳转到我的消息
    PublicMessageVC *message = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
    UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:message];
    CATransition *  ansition =[CATransition animation];
    [ansition setDuration:0.3];
    [ansition setType:kCAGravityRight];
    [[[[UIApplication sharedApplication]keyWindow ]layer] addAnimation:ansition forKey:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:Nav animated:YES completion:nil];
    [self getShopData];
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
- (void)backAction:(LBXScanResult *)result {
    NSString *  strone = [result.strScanned substringToIndex:4];
    if (![strone isEqualToString:@"dwbm"]) {
        [self alertWithTitle:@"温馨提示" message:@"目前在不支持" OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
            
        }];
        return;
    }else{
        //注意：元素本身就是字符。
        NSString *str = [result.strScanned substringFromIndex:7];
        NSArray * Arr = [str componentsSeparatedByString:@":"];
        __weak typeof(self) weakSelf = self;
        [self alertWithTitle:@"是否消费?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            [weakSelf showProgress];
            RequestGoodsOrderUser *orderUse = [[RequestGoodsOrderUser alloc] init];
            orderUse.orderNo = Arr[0];
            orderUse.couponNo = Arr[1];
            orderUse.goodsOrderId = Arr[2];;
            orderUse.goodsOrderCouponId = Arr[3];;
                  BaseRequest *request = [[BaseRequest alloc] init];
            request.encryptionType = AES;
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            request.token = [userD objectForKey:@"loginToken"];
            request.data = [AESCrypt encrypt:[orderUse yy_modelToJSONString] password:[userD objectForKey:@"loginKey"]];
            [[DWHelper shareHelper] requestDataWithParm:[request yy_modelToJSONString] act:@"act=MerApi/GoodsOrder/requestGoodsOrderScan" sign:[request.data MD5Hash] requestMethod:GET success:^(id response) {
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                if (baseRes.resultCode == 1) {
                    [weakSelf hideProgress];
                    [weakSelf showToast:@"消费成功"];
                }else {
                    [weakSelf showToast:baseRes.msg];
                }
                [weakSelf hideProgress];
            } faild:^(id error) {
                [weakSelf hideProgress];
            }];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }
}

- (void)useOrderNo:(LBXScanResult *)sender{
    
}
#pragma mark - 本地存储
-(void)LocalData{
    NSMutableDictionary * DriverInfo = [AuthenticationModel objectForKey:@"TGMerchantInfo"];
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
        NSLog(@"---%@",response);
        if (baseRes.resultCode == 1) {
            [AuthenticationModel setValue:response forkey:@"TGMerchantInfo"];
            weakSelf.shopModel = [RequestMerchantInfoModel yy_modelWithJSON:baseRes.data];
            weakSelf.navigationView.title.text = weakSelf.shopModel.merchantName;
            headerView.title.text =weakSelf.shopModel.merchantName;
            DWHelper *helper = [DWHelper shareHelper];
            helper.messageStatus = weakSelf.shopModel.status;
            helper.shopModel = weakSelf.shopModel;

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
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    switch (indexPath.row) {
        case 0:
        {
            BulkHomeOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BulkHomeOneCell" forIndexPath:indexPath];
            cell.barcodeImage.image = [LBXScanWrapper createQRWithString:self.shopModel.merchantNo size:cell.barcodeImage.frame.size];
            [cell CellGetData:self.shopModel];
            __weak typeof(self) weakSelf = self;

            [cell BulkHomeOneCellBlock:^(NSInteger tag ) {
               [weakSelf btnAction:tag];
            }];
            return cell;
            
            break;
        }
            
        case 1:
        {
            
            BulkHomeTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BulkHomeTwoCell" forIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;

            [cell BulkHomeTwoCellBlock:^(NSInteger tag) {
                NSLog(@"%ld",(long)tag);
                [weakSelf btnAction:tag];
            }];
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

- (void)btnAction:(NSInteger )tag {
    DWHelper *helper = [DWHelper shareHelper];
    if (helper.messageStatus == 0) {
        [self showToast:@"禁用"];
    }else if (helper.messageStatus == 1) {
        [self pushController:tag];
    }else if (helper.messageStatus == 2) {
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
    if (tag == 0) {
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
    }else if (tag == 1) {
        //Push 跳转
        PublicMessageVC * VC = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
    }else if (tag == 2) {
        TardeViewController *tarde = [[TardeViewController alloc] init];
        [self.navigationController pushViewController:tarde animated:YES];
    }else if (tag == 3) {
        TicketViewController *ticketController = [[TicketViewController alloc] init];
        [self.navigationController pushViewController:ticketController animated:YES];
    }else if (tag == 4) {
    //Push 跳转--行业抵用券认证
      DWHelper* helper = [DWHelper shareHelper];
      IndustryCertificationVC * industryCertificationVC = [[IndustryCertificationVC alloc]initWithNibName:@"IndustryCertificationVC" bundle:nil];
        //Push 跳转--行业抵用券列表
       IndustryAmountLIstVC * VC = [[IndustryAmountLIstVC alloc]initWithNibName:@"IndustryAmountLIstVC" bundle:nil];
        ///开通行业抵用券  1-未开通, 2-开通中,3-开通失败, 4-已开通, 5-暂停业务
        [self.navigationController  pushViewController:[helper.shopModel.industryCouponStatus isEqualToString:@"1"]||[helper.shopModel.industryCouponStatus isEqualToString:@"2"]||[helper.shopModel.industryCouponStatus isEqualToString:@"3"] ?  industryCertificationVC :VC animated:YES];
    }else if (tag == 5) {
        ShopCenterViewController *shopCenterC = [[ShopCenterViewController alloc] init];
        [self.navigationController pushViewController:shopCenterC animated:YES];
    }else if (tag == 60) {
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
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            return 0.5*Width;
            
            break;
        }
            
        case 1:
        {
            return Height-64- 0.5*Width;
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
#pragma mark - 推送别名
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    if (iResCode == 0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"别名成功" forKey:@"别名成功"];
    }

    if (iResCode == 6002) {
        [JPUSHService setAlias:self.shopModel.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    NSLog(@"push set alias success alisa = %@", alias);
}

#pragma mark -  只要拖拽就会触发(scrollView 的偏移量发生改变)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<-20) {
        self.navigationView.hidden = YES;
    }else if(scrollView.contentOffset.y>-19){
        self.navigationView.hidden = NO;
        
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

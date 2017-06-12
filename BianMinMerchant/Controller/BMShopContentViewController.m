//
//  BMShopContentViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/18.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BMShopContentViewController.h"
#import "BMOrderCell.h"
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
#import "ConvenienceHomeVC.h"
#import "NewCompleonDataVC.h"
#import "PublicMessageVC.h"
@interface BMShopContentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *shopNumber;
@property (nonatomic, strong) UIImageView *logoImg;
@property (nonatomic, strong) UIImageView *shopImage;
@property (nonatomic, strong) NSMutableArray *btnTitleArr;
@property (nonatomic, assign) NSInteger btnIndex;
@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UIButton *messageBtn;

@end

@implementation BMShopContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnIndex = 0;
    self.pageIndex = 1;
    [self newShowBackBtn];
    [self naviagtionRightView];
    [self createTableView];
    //获取系统配置信息
    [self getConfig];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0]; 
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataOrderData) name:@"刷新订单" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataOrderData) name:@"修改商户资料" object:nil];
}

- (void)updataOrderData {
    [self getShopData];
    self.pageIndex = 1;
    [self getDataListWithType:self.btnIndex+1];
    
    
   
    
}

- (void)newShowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
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


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BMOrderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BMOrderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BMSecondOrederCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BMSecondOrederCell"];
    self.tableView.tableHeaderView = [self creeateHeaderView];
    self.tableView.tableFooterView = nil;
    [self.view addSubview:self.tableView];
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0)];
    self.tableView.tableFooterView = footV;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getDataListWithType:self.btnIndex+1];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getDataListWithType:self.btnIndex + 1];
        [self getShopData];
    }];
//    [self getShopData];
    [self getDataListWithType:1];
}

- (UIView *)creeateHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Width*0.6)];
    headerView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    
    self.logoImg = [[UIImageView alloc] init];
//    self.logoImg.image = [UIImage imageNamed:@""];
    [headerView addSubview:self.logoImg];
    self.logoImg.layer.masksToBounds = YES;
    self.logoImg.layer.cornerRadius = (Width*0.2)/2;
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(headerView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(Width*0.2, Width*0.2));
    }];
    
    self.todayLabel = [UILabel new];
    self.todayLabel.textColor = [UIColor whiteColor];
    self.todayLabel.text = @"今日交易(05月10号)";
    self.todayLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.todayLabel];
    [self.todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(self.logoImg.mas_bottom).with.offset(5);
        make.height.mas_equalTo(30);
    }];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    NSString *monthly = [locationString substringToIndex:2];
    if ([[monthly substringToIndex:1] isEqualToString:@"0"]) {
        monthly = [monthly substringFromIndex:1];
    }
    
    NSString *day = [locationString substringFromIndex:2];
    if ([[day substringToIndex:1] isEqualToString:@"0"]) {
        day = [day substringFromIndex:1];
    }
    //self.todayLabel.text = [NSString stringWithFormat:@"今日交易(%@月%@号)", monthly,day];
    self.todayLabel.text = @"今日交易额";
    self.moneyLabel = [UILabel new];
    self.moneyLabel.textColor = [UIColor whiteColor];
    self.moneyLabel.text = @"";
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(self.todayLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(30);
    }];
    
    self.shopNumber = [UILabel new];
    self.shopNumber.textColor = [UIColor whiteColor];
    self.shopNumber.text = @"";
    self.shopNumber.font = [UIFont systemFontOfSize:14];
    self.shopNumber.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.shopNumber];
    [self.shopNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(headerView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    self.shopImage = [UIImageView new];
    [headerView addSubview:self.shopImage];
    [self.shopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.shopNumber.mas_left);
    }];
    
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.messageBtn setTitle:@"请补全资料 >" forState:UIControlStateNormal];
    self.messageBtn.hidden = YES;
    [self.messageBtn addTarget:self action:@selector(addMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:self.messageBtn];
    [self.messageBtn                                                                                                                                                                                                                                                                                                                                                                                                                          mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView).with.offset(-10);
        make.left.equalTo(headerView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    return headerView;
}

- (void)addMessageAction:(UIButton *)sender {
    DWHelper *helper = [DWHelper shareHelper];
    if (helper.messageStatus == 0) {
        [self showToast:@"禁用"];
    }else if (helper.messageStatus == 2) {
//        WriteMessageViewController *messgeC = [[WriteMessageViewController alloc] init];
//        messgeC.shopModel = self.shopModel;
//        __weak typeof(self) weakSelf = self;
//
//        messgeC.backAction =^(NSString *str){
//            [weakSelf getShopData];
//        };
//        [self.navigationController pushViewController:messgeC animated:YES];
//        //Push 跳转
//        CompletionDataVC * VC = [[CompletionDataVC alloc]initWithNibName:@"CompletionDataVC" bundle:nil];
//        VC.shopModel = self.shopModel;
//        __weak typeof(self) weakSelf = self;
//        
//        VC.backAction =^(NSString *str){
//            [weakSelf getShopData];
//        };
       // [self.navigationController  pushViewController:VC animated:YES];

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

- (void)naviagtionRightView {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"icon_my_shezhi"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}
- (void)settingAction:(UIButton *)sender {
    
    
    
//    SettingViewController *settingC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
//    settingC.shopModel = self.shopModel;
//    [self.navigationController pushViewController:settingC animated:YES];
    
    //Push 跳转
    ConvenienceHomeVC * VC = [[ConvenienceHomeVC alloc]initWithNibName:@"ConvenienceHomeVC" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestBminorderListModel *model = self.dataSource[indexPath.row];
    OrderDetailView *orderC = [[OrderDetailView alloc] init];
    orderC.orderNo = model.orderNo;
    orderC.bminOrderId = model.bminOrderId;
    __weak BMShopContentViewController *weakSelf = self;
    orderC.backBlockAction = ^(NSString *str) {
        [weakSelf.dataSource removeAllObjects];
        weakSelf.pageIndex = 1;
        [weakSelf getDataListWithType:self.btnIndex+1];
    };
    [self.navigationController pushViewController:orderC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Width*0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = [[UIView alloc] init];
    sectionHeader.backgroundColor = [UIColor colorWithHexString:kLineColor];
    CGFloat btnW = (Width - 2)/3;
    NSArray *titleArr = @[@"未接单",@"处理中",@"已完成"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.btnIndex == i) {
            [btn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
        }
        btn.frame = CGRectMake(i*(btnW+1), 0, btnW, Width*0.1-1);
        [self.btnTitleArr addObject:btn];
        btn.tag = 100+i;
        [sectionHeader addSubview:btn];
    }
    return sectionHeader;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)btnAction:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    self.btnIndex = index;
    self.pageIndex = 1;
    [self getDataListWithType:index+1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestBminorderListModel *model = self.dataSource[indexPath.row];
    if (self.btnIndex != 0) {
        BMSecondOrederCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BMSecondOrederCell" forIndexPath:indexPath];
        [cell cellGetDataWithModel:model];
        return cell;
    }
    BMOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BMOrderCell" forIndexPath:indexPath];
    [cell cellGetDataWithModel:model];
    return cell;
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
            //[JPUSHService setAlias:weakSelf.shopModel.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:weakSelf];
            weakSelf.title = weakSelf.shopModel.merchantName;
            
            [weakSelf.logoImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.shopModel.iconUrl] placeholderImage:[UIImage imageNamed:@"头像男"]];
            weakSelf.shopImage.image = [LBXScanWrapper createQRWithString:weakSelf.shopModel.merchantNo size:weakSelf.shopImage.frame.size];
            weakSelf.shopNumber.text = [NSString stringWithFormat:@"商户号:%@", weakSelf.shopModel.merchantNo];
            weakSelf.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f元", weakSelf.shopModel.tradeMoneyDay];
            
            DWHelper *helper = [DWHelper shareHelper];
            helper.shopModel = weakSelf.shopModel;
            helper.messageStatus = weakSelf.shopModel.status;
            if (weakSelf.shopModel.status == 1) {
                weakSelf.messageBtn.hidden = YES;
            }else {
                weakSelf.messageBtn.hidden = NO;
            }
        }else {
            
            [weakSelf showToast:baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
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
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestBminorderList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestBminorderListModel *model = [RequestBminorderListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }else {
            
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getShopData];
}

- (NSMutableArray *)btnTitleArr {
    if (!_btnTitleArr) {
        self.btnTitleArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnTitleArr;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    if (iResCode == 6002) {
        [JPUSHService setAlias:self.shopModel.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
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

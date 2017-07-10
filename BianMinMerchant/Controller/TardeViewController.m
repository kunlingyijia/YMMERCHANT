//
//  TardeViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "TardeViewController.h"
#import "MessageCenterCell.h"
#import "RequestGoodsList.h"
#import "RequestTradeListModel.h"
#import "RequestRefundOrderStatus.h"
@interface TardeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation TardeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交易记录";
    self.pageIndex = 1;
    [self showBackBtn];
    [self createTableView];
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 200;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor =[UIColor colorWithHexString:kViewBg];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCenterCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MessageCenterCell"];
    [self.view addSubview:self.tableView];
    [self getDataList];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getDataList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex +1;
        [self getDataList];
    }];
}

- (void)getDataList {
    RequestGoodsList *goodsL = [[RequestGoodsList alloc] init];
    goodsL.pageIndex = self.pageIndex;
    goodsL.pageCount = 10;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[goodsL yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestTradeList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestTradeListModel *model = [RequestTradeListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}


#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestTradeListModel *model = self.dataSource[indexPath.section];
    if (model.status == 2) {
        return 240+20;
    }else {
        return 200+20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCenterCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RequestTradeListModel *model = self.dataSource[indexPath.section];
    [cell cellGetDataModel:model];
    __weak TardeViewController *weakSelf = self;
    cell.agreeBackAction = ^(NSString *orderNo ,NSString* goodsOrderId			) {
        [weakSelf agreeOrRefuseWithOrderNo:orderNo goodsOrderId:goodsOrderId WithType:1];
    };
    cell.refuseBackAction = ^(NSString *orderNo, NSString* goodsOrderId			) {
        [weakSelf agreeOrRefuseWithOrderNo:orderNo goodsOrderId:goodsOrderId WithType:2];
    };
    return cell;
}

- (void)agreeOrRefuseWithOrderNo:(NSString *)orderNo goodsOrderId:(NSString*)goodsOrderId WithType:(NSInteger)type {
    if (type == 2) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入退款理由" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        UITextField *textField = alertC.textFields[0];
        
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            RequestRefundOrderStatus *status = [[RequestRefundOrderStatus alloc] init];
            status.orderNo = orderNo;
            status.status = type;
            status.goodsOrderId =goodsOrderId;
            if (textField.text.length == 0) {
                [self showToast:@"请输入退款理由"];
            }else {
                status.refuseReason = textField.text;
            }
            [self selectedagreeOrRefuseWithRequest:status];
        }]];
        [self presentViewController:alertC animated:YES completion:nil];
    }else {
        RequestRefundOrderStatus *status = [[RequestRefundOrderStatus alloc] init];
        status.orderNo = orderNo;
        status.status = type;
        status.goodsOrderId = goodsOrderId;
        [self selectedagreeOrRefuseWithRequest:status];
    }
}
- (void)selectedagreeOrRefuseWithRequest:(RequestRefundOrderStatus *)request {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[request yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Order/requestRefundOrderStatus" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self showToast:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.dataSource removeAllObjects];
                [self getDataList];
            });
        }else {
            [self showToast: baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    
    return self.dataSource.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

@end

//
//  Receive ViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ReceiveViewController.h"
#import "ReceiveViewCell.h"
#import "RequestGetCouponUserList.h"
#import "GetCouponUserListModel.h"
@interface ReceiveViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//记录加载分页
@property (nonatomic, assign) NSInteger count;
@end

@implementation ReceiveViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"领用详情";
    self.count = 1;
    [self showBackBtn];
    [self createTableView];
}

- (void)getDataList{
    RequestGetCouponUserList *requestList = [[RequestGetCouponUserList alloc] init];
    requestList.couponId = self.couponId;
    
    requestList.pageCount = 10;
    requestList.pageIndex = self.count;
    
    BaseRequest *baseRequest = [[BaseRequest alloc] init];
    baseRequest.token = [AuthenticationModel getLoginToken];
    baseRequest.encryptionType = AES;
    baseRequest.data = [AESCrypt encrypt:[requestList yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper]requestDataWithParm:[baseRequest yy_modelToJSONString] act:@"act=MerApi/Merchant/requestGetCouponUserList" sign:[baseRequest.data MD5Hash] requestMethod:GET success:^(id response) {
        
        NSLog(@"%@", response);
        if (self.count == 1) {
            [self.dataSource removeAllObjects];
        }
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                GetCouponUserListModel *model = [GetCouponUserListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
    }];
    
}


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ReceiveViewCell"];
    [self.view addSubview:self.tableView];
    self.tableView .tableFooterView = [UIView new];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.count = 1;
        [self getDataList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.count = self.count+1;
        [self getDataList];
    }];
    [self getDataList];
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveViewCell" forIndexPath:indexPath];
    GetCouponUserListModel *model = self.dataSource[indexPath.row];
    [cell cellGetData:model withController:self];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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

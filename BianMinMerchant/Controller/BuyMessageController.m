//
//  BuyMessageController.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BuyMessageController.h"
#import "BuyMessageCell.h"
#import "RequestOrderListByGoods.h"
#import "RequestOrderListByGoodsModel.h"
@interface BuyMessageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation BuyMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"购买详情";
    self.pageIndex = 1;
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 165;
    [self.tableView registerNib:[UINib nibWithNibName:@"BuyMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BuyMessageCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getDataList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getDataList];
    }];
    [self getDataList];
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyMessageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RequestOrderListByGoodsModel *model = self.dataSource[indexPath.row];
    [cell cellGetDataModel:model withVC:self];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - 网络请求
- (void)getDataList {
    RequestOrderListByGoods *goods = [[RequestOrderListByGoods alloc] init];
    goods.pageCount = 10;
    goods.pageIndex = self.pageIndex;
    goods.goodsId = self.goodsId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[goods yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Order/requestOrderListByGoods" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *bareRes = [BaseResponse yy_modelWithJSON:response];
        if (bareRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in bareRes.data) {
                RequestOrderListByGoodsModel *model = [RequestOrderListByGoodsModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {

    }];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  StaffViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "StaffViewController.h"
#import "AddStaffViewController.h"
#import "StaffViewCell.h"
#import "RequestMerchantEmployeeListModel.h"
#import "RequestMerchantEmployeeList.h"
@interface StaffViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation StaffViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店员管理";
    self.pageIndex = 1;
    [self showBackBtn];
    [self navigationItemView];
    [self createTableView];
    [self Refresh];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
      
        self.pageIndex = 1;
       
        [weakself  getDataList];;
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        self.pageIndex = 1;
        
        [weakself  getDataList];;

        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = Width/5;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.tableView registerNib:[UINib nibWithNibName:@"StaffViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StaffViewCell"];
    [self.view addSubview:self.tableView];
    [self getDataList];
}

- (void)navigationItemView {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(addStaffAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"新增" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 网络请求
- (void)getDataList {
    RequestMerchantEmployeeList *list = [[RequestMerchantEmployeeList alloc] init];
    list.pageCount = 10;
    list.pageIndex = self.pageIndex;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[list yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Employee/requestMerchantEmployeeList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (weakSelf.pageIndex==1) {
                [weakSelf.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantEmployeeListModel *model = [RequestMerchantEmployeeListModel yy_modelWithDictionary:dic];
                [weakSelf.dataSource addObject:model];
            }
            
        }else {
            [weakSelf showToast:baseRes.msg];
        }
        
        [self.tableView reloadData];
    } faild:^(id error) {

    }];
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestMerchantEmployeeListModel *model = self.dataSource[indexPath.row];
    AddStaffViewController *addC = [[AddStaffViewController alloc] init];
    addC.title = @"店员详情";
    addC.isNewC = 6;
    addC.model = model;
    __weak StaffViewController *weakSelf = self;
    addC.backBlockAction = ^(NSString *str) {
        [self.dataSource removeAllObjects];
        weakSelf.pageIndex = 1;
        [weakSelf getDataList];
    };
    [self.navigationController pushViewController:addC animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StaffViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StaffViewCell" forIndexPath:indexPath];
    RequestMerchantEmployeeListModel *model = self.dataSource[indexPath.row];
    [cell cellGetData:model];
    return cell;
}



- (void)addStaffAction:(UIButton *)sender {
    AddStaffViewController *addStaff = [[AddStaffViewController alloc] init];
    addStaff.title = @"新增店员";
    __weak StaffViewController *weakSelf = self;
    addStaff.backBlockAction = ^(NSString *str) {
        [self.dataSource removeAllObjects];
        weakSelf.pageIndex = 1;
        [weakSelf getDataList];
    };
    [self.navigationController pushViewController:addStaff animated:YES];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
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

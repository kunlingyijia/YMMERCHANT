//
//  RecordViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordCell.h"
#import "RequestDrawFlowList.h"
#import "FlowListModel.h"
@interface RecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//记录加载分页
@property (nonatomic, assign) NSInteger count;
@end

@implementation RecordViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.count = 1;
    [self createTableView];
    [self showBackBtn];
    self.title = @"提现记录";
    [self getDataList:1];
}

- (void)getDataList:(NSInteger)count {
    RequestDrawFlowList *reqDraw = [[RequestDrawFlowList alloc] init];
    reqDraw.pageCount = 10;
    reqDraw.pageIndex = count;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[reqDraw yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestDrawFlowList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.count == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                FlowListModel *model = [FlowListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }else {
            [self showToast: baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}

- (void)createTableView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 30)];
    headerView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:headerView];
    UILabel *secondL = [UILabel new];
    secondL.text = @"状态";
    secondL.textColor = [UIColor colorWithHexString:kSubTitleColor];
    secondL.textAlignment = NSTextAlignmentCenter;
    secondL.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:secondL];
    [secondL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    UILabel *firstL = [UILabel new];
    firstL.text = @"提现金额";
    firstL.textColor = [UIColor colorWithHexString:kSubTitleColor];
    firstL.textAlignment = NSTextAlignmentLeft;
    firstL.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:firstL];
    [firstL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(20);
        make.right.equalTo(secondL.mas_left);
        make.top.equalTo(headerView);
        make.height.mas_equalTo(@(30));
    }];
    
    UILabel *thirdL = [UILabel new];
    thirdL.text = @"时间";
    thirdL.textColor = [UIColor colorWithHexString:kSubTitleColor];
    thirdL.textAlignment = NSTextAlignmentRight;
    thirdL.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:thirdL];
    [thirdL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondL.mas_right);
        make.right.equalTo(headerView).with.offset(-20);
        make.top.equalTo(headerView);
        make.height.mas_equalTo(@(30));
    }];
    
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 30, Width, Height-64-30) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RecordCell"];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.count = 1;
        [self getDataList:self.count];
        
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.count = self.count+1;
        [self getDataList:self.count];
    }];
    
    
}

#pragma mark - UITableViewDelegate
#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell" forIndexPath:indexPath];
//    FlowListModel *model = self.dataSource[indexPath.row];
//    [cell cellGetDataWithModel:model];
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

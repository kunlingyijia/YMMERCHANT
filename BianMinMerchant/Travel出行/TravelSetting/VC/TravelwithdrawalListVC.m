//
//  TravelwithdrawalListVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelwithdrawalListVC.h"
#import "TravelwithdrawalListCell.h"
#import "TravelBanckModel.h"
@interface TravelwithdrawalListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation TravelwithdrawalListVC
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
    self.title = @"提现列表";
    self.tableView.tableFooterView = [UIView new];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [self.tableView tableViewregisterNibArray:@[@"TravelwithdrawalListCell"]];
    __weak typeof(self) weakSelf = self;

//    [BackgroundService requestPushVC:self MyselfAction:^{
//    }];
    
    [BackgroundService requestDriverInfoPushVC:self MyselfAction:^{
        weakSelf.TravelwithdrawalListVCBlock();

    }];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.pageIndex = 1;
    [self requestDrawFlowList];
    [self Refresh];
    
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.pageIndex =1 ;
        [weakself requestDrawFlowList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        // weakself.navigationView.hidden = NO;
        
        [weakself requestDrawFlowList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark -提现记录
-(void)requestDrawFlowList{

           NSString *Token =[AuthenticationModel getLoginToken];
        NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),}mutableCopy];
        __weak typeof(self) weakself = self;
        if (Token.length!= 0) {
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = AES;
            baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/DrawFlow/requestDrawFlowList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                
                NSLog(@"提现记录----%@",response);
                if ([response[@"resultCode"] isEqualToString:@"1"]) {
                    if (weakself.pageIndex == 1) {
                        [weakself.dataArray removeAllObjects];
                    }
                    NSArray *arr = response[@"data"];
                    for (NSDictionary *dicdata in arr) {
                        TravelBanckModel *model = [TravelBanckModel yy_modelWithJSON:dicdata];
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
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TravelwithdrawalListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelwithdrawalListCell" forIndexPath:indexPath];
    
    //cell 赋值
    
    [cell CellGetData:self.dataArray[indexPath.row]];
    // cell 其他配置
       return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0.2*Width;
    
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

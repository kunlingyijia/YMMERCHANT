//
//  TravelHomeVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelHomeVC.h"
#import "TravelSettingVC.h"
#import "OwnerModel.h"
#import "TravelHomeOneCell.h"
#import "TravelHome21.h"
#import "TravelHome22.h"
#import "TravelHome23.h"
#import "TravelHome24.h"
#import "TravelHomeThreeCell.h"
#import "TripModel.h"
#import "TravelHomeHeaderView.h"
#import "AddTripVC.h"
@interface TravelHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  TravelHomeHeaderView *navigationView;
@property(nonatomic,strong)OwnerModel*ownerModel;
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation TravelHomeVC
//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}

#pragma mark - 关于UI
-(void)SET_UI{
    self.navigationView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView tableViewregisterNibArray:@[@"TravelHomeOneCell",@"TravelHome21",@"TravelHome22",@"TravelHome23",@"TravelHome24",@"TravelHomeThreeCell"]];
    self.navigationView = [[TravelHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    [self.navigationView.leftBtn addTarget:self action:@selector(ScanAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navigationView.RightBtn addTarget:self action:@selector(MoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_navigationView];
   TravelHomeHeaderView * headerView=[[TravelHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    [headerView.leftBtn addTarget:self action:@selector(ScanAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView.RightBtn addTarget:self action:@selector(MoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tableView.tableHeaderView = headerView;
}
#pragma mark - 扫一扫
-(void)ScanAction:(UIButton*)sender{
    
    //Push 跳转
    AddTripVC * VC = [[AddTripVC alloc]initWithNibName:@"AddTripVC" bundle:nil];
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
    //self.ownerModel = [[OwnerModel alloc]init];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex = 1;
    //获取配置信息
    [self getConfig];
    [self Refresh];
    //获取车主信息
    [self requestAction];
    
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.navigationView.hidden = YES;
        weakself.pageIndex =1 ;
        [weakself requestPlanList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        // weakself.navigationView.hidden = NO;
        
        [weakself requestPlanList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 获取配置信息
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
                weakself.ownerModel = [OwnerModel
                                   yy_modelWithJSON:dic];
                [weakself requestPlanList];
                
////                //刷新
//                [weakself.tableView reloadData];
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
             return 10;
            break;
            
        }
    }

   
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ownerModel.status.length==0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        
       
        return cell;
    }else{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                
            TravelHomeOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHomeOneCell" forIndexPath:indexPath];
                return cell;
            }else if (indexPath.row==1) {
                ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
                if ([self.ownerModel.status isEqualToString:@"3"]) {
                    
                    
                    if (self.dataArray.count==0) {
                        TravelHome23 * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHome23" forIndexPath:indexPath];
                        return cell;
                    }else{
                        TravelHome22 * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHome22" forIndexPath:indexPath];
                        return cell;
                    }
                    
                }else if(![self.ownerModel.status isEqualToString:@"3"]){
                    NSLog(@"%@",self.ownerModel.status);
                    TravelHome24 * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHome24" forIndexPath:indexPath];
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
        TravelHomeThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelHomeThreeCell" forIndexPath:indexPath];
            
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
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   

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
                      return Height- Width*0.4;
                    }else{
                        return 88;
                    }
                    
                }else{
                   return Height- Width*0.4;
                }

            }
            
            break;
        }
            
        case 1:
        {
            return 0.2*Width;
            break;
        }
            
            
        default:{
            return 0;

            break;
            
        }
    }

    
}

//只要拖拽就会触发(scrollView 的偏移量发生改变)
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

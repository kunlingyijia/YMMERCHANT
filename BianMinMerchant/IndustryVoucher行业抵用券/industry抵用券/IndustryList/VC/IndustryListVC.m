//
//  IndustryListVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryListVC.h"
#import "IndustryListOneCell.h"
#import "AddIndustryVC.h"
#import "IndustryDetailVC.h"
#import "IndustryModel.h"
@interface IndustryListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation IndustryListVC
#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.model.balanceFaceAmount = self.balanceFaceAmount.text;
}
#pragma mark -  载入完成
- (void)viewDidLoad {
    [super viewDidLoad];
    //关于UI
    [self SET_UI];
    //关于数据
    [self  SET_DATA];
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.view.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.title =[NSString stringWithFormat:@"%@",self.model.no];
    [self showBackBtn];
    __weak typeof(self) weakSelf = self;
    DWHelper* helper = [DWHelper shareHelper];
    if ([self.model.status isEqualToString:@"3"]) {
        [self showRightBtnTitle:@"添加" Image:nil RightBtn:^{
            if ( [helper.shopModel.industryCouponStatus isEqualToString:@"5"]) {
                [weakSelf alertWithTitle:@"该业务被暂停,请联系客服" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",helper.configModel.plat_kfmobile];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                } withCancel:^(UIAlertAction *cancelaction) {
                    
                }];
            }else{
                //Push 跳转
                AddIndustryVC * VC = [[AddIndustryVC alloc]initWithNibName:@"AddIndustryVC" bundle:nil];
                VC.balanceFaceAmount = weakSelf.balanceFaceAmount.text;
                VC.faceId = weakSelf.model.faceId;
                VC.BagendTime =weakSelf.model.endTime;
                VC.AddIndustryVCBlock =^(NSString*balanceFaceAmount){
                    weakSelf.balanceFaceAmount.text = balanceFaceAmount;
                    weakSelf.pageIndex = 1;
                    [weakSelf requestAction];
                };
                [weakSelf.navigationController  pushViewController:VC animated:YES];
            }

            
            
        }];
  
    }
       [self setUpTableView];
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Width*0.25, Width, Height-64-Width*0.25) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    _tableView.tableFooterView = [UIView new];
    _tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"IndustryListOneCell"]];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex =1;
    self.model.balanceFaceAmount = @"0.00";
    self.balanceFaceAmount.text = self.model.balanceFaceAmount;

    [self requestAction];
    //上拉刷新下拉加载
    [self Refresh];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - 网络请求
-(void)requestAction{
        NSString *Token =[AuthenticationModel getLoginToken];
        NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"faceId":self.model.faceId}mutableCopy];
        __weak typeof(self) weakself = self;
        if (Token.length!= 0) {
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = AES;
            baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/IndustryCoupon/requestIndustryCouponList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];            if (weakself.pageIndex == 1) {
                    [weakself.dataArray removeAllObjects];
                }
                if (baseRes.resultCode ==1) {
                    NSMutableArray *arr = baseRes.data[@"list"];
                    weakself.balanceFaceAmount.text = [NSString stringWithFormat:@"%@",baseRes.data[@"balanceFaceAmount"]];
                    for (NSDictionary *dicData in arr) {
                        IndustryModel *model = [IndustryModel yy_modelWithJSON:dicData];
                        [weakself.dataArray addObject:model];
                    }
                    //刷新
                    [weakself.tableView reloadData];
                }else{
                    [weakself showToast:baseRes.msg];
                }
            } faild:^(id error) {
                NSLog(@"%@", error);
            }];
        }else {
    
        }
}
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [tableView tableViewDisplayWitimage:@"列表为空-1" ifNecessaryForRowCount:self.dataArray.count];
    //分区个数
    return self.dataArray.count;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section>self.dataArray.count-1||self.dataArray.count==0) {
        return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    }else{
        IndustryListOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndustryListOneCell" forIndexPath:indexPath];
        //cell 赋值
         cell.model = indexPath.section >= self.dataArray.count ? nil :self.dataArray[indexPath.section];
        // cell 其他配置
        return cell;
        
    }
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //Push 跳转
//    IndustryDetailVC * VC = [[IndustryDetailVC alloc]initWithNibName:@"IndustryDetailVC" bundle:nil];
//    [self.navigationController  pushViewController:VC animated:YES];
//
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    IndustryModel*   model = indexPath.section >= self.dataArray.count ? nil :self.dataArray[indexPath.section];
	//1-已发放, 2-已取消, 3-已过期, 4-已结束
    return [model.status isEqualToString:@"1"] ?  YES:NO;
}
//iOS 8.0 后才有的方法
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    IndustryModel*   model = indexPath.section >= self.dataArray.count ? nil :self.dataArray[indexPath.section];
    UITableViewRowAction *cancel = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"取消发布" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf alertWithTitle:@"是否取消发布?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            NSString *Token =[AuthenticationModel getLoginToken];
            __weak typeof(self) weakself = self;
            if (Token.length!= 0) {
                BaseRequest *baseReq = [[BaseRequest alloc] init];
                baseReq.token = [AuthenticationModel getLoginToken];
                baseReq.encryptionType = AES;
                baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
                [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/IndustryCoupon/requestCancelIndustryCoupon" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                    NSLog(@"取消发布----%@",response);
                    if ([response[@"resultCode"] isEqualToString:@"1"]) {
                        model.status = [NSString stringWithFormat:@"%@",response[@"data"][@"status"]];
                        weakSelf.balanceFaceAmount.text = response[@"data"][@"balanceFaceAmount"];
                        [weakSelf.tableView reloadData];
                    }else{
                        //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.tableView reloadData];
                        [weakself showToast:response[@"msg"]];
                    }
                    
                } faild:^(id error) {
                    NSLog(@"%@", error);
                }];
            }
        } withCancel:^(UIAlertAction *cancelaction) {
        }];
    }];
//    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//        [weakSelf alertWithTitle:@"是否删除?" message:nil OKWithTitle:@"删除" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
//            NSString *Token =[AuthenticationModel getLoginToken];
//            __weak typeof(self) weakself = self;
//            if (Token.length!= 0) {
//                BaseRequest *baseReq = [[BaseRequest alloc] init];
//                baseReq.token = [AuthenticationModel getLoginToken];
//                baseReq.encryptionType = AES;
//                baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
//                [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelPlan/requestDeletePlan" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
//                    NSLog(@"删除行业抵用券----%@",response);
//                    if ([response[@"resultCode"] isEqualToString:@"1"]) {
//                        weakSelf.balanceFaceAmount.text = response[@"data"][@"balanceFaceAmount"];
//                        [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
//                        [weakSelf.tableView reloadData];
//                    }else{
//                        [weakSelf.tableView reloadData];
//                        [weakself showToast:response[@"msg"]];
//                    }
//                    
//                } faild:^(id error) {
//                    NSLog(@"%@", error);
//                }];
//            }
//        } withCancel:^(UIAlertAction *cancelaction) {
//            
//        }];
//    }];
    return @[cancel];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}

@end

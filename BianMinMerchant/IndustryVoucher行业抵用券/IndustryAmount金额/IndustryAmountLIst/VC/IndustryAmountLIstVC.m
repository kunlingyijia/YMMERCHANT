//
//  IndustryAmountLIstVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryAmountLIstVC.h"
#import "IndustryAmountLIstOneCell.h"
#import "IndustryAmountDetailVC.h"
#import "AddIndustryAmountVC.h"
#import "IndustryListVC.h"
#import "IndustryModel.h"
@interface IndustryAmountLIstVC ()<UITableViewDelegate,UITableViewDataSource>
///警示View
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UILabel *industryCouponRefuseReason;
@property(nonatomic,weak) IBOutlet UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation IndustryAmountLIstVC
#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
    self.title = @"行业抵用券";
    [self showBackBtn];
    __weak typeof(self) weakSelf = self;
    ///开通行业抵用券  1-未开通, 2-开通中,3-已开通, 4-开通失败, 5-暂停业务
    DWHelper* helper = [DWHelper shareHelper];
    [self showRightBtnTitle:@"添加" Image:nil RightBtn:^{
    if ( [helper.shopModel.industryCouponStatus isEqualToString:@"5"]) {
    [weakSelf alertWithTitle:@"该业务被暂停,请联系客服" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",helper.configModel.plat_kfmobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } withCancel:^(UIAlertAction *cancelaction) {
                
            }];
        }else{
            //Push 跳转
            AddIndustryAmountVC * VC = [[AddIndustryAmountVC alloc]initWithNibName:@"AddIndustryAmountVC" bundle:nil];
            VC.AddIndustryAmountVCBlock =^(){
                weakSelf.pageIndex = 1;
                [weakSelf requestAction];
            };
            [weakSelf.navigationController  pushViewController:VC animated:YES];
        }
        
        
    }];
    [self setUpTableView];
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    //[self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"IndustryAmountLIstOneCell"]];
    ///开通行业抵用券  1-未开通, 2-开通中,3-已开通, 4-开通失败, 5-暂停业务
    DWHelper* helper = [DWHelper shareHelper];
    if ( [helper.shopModel.industryCouponStatus isEqualToString:@"5"]) {
        _warningView.hidden = NO;
        _industryCouponRefuseReason.text = helper.shopModel.industryCouponRefuseReason;
    }else{
        _warningView.hidden = YES;
        _industryCouponRefuseReason.text = @"";
    }
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex =1;
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
        NSLog(@"%ld",(long)weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 网络请求
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10)}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/IndustryCouponFace/requestIndustryCouponFaceList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            NSLog(@"%@",response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            if (baseRes.resultCode ==1) {
                NSMutableArray *arr = baseRes.data;
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
#pragma tableView 代理方法
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
                IndustryAmountLIstOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndustryAmountLIstOneCell" forIndexPath:indexPath];
                //cell 赋值
                cell.model = indexPath.row >= self.dataArray.count ? nil :self.dataArray[indexPath.section];
                // cell 其他配置
                return cell;
    }
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  IndustryModel*  model = indexPath.section >= self.dataArray.count ? nil :self.dataArray[indexPath.section];
    //1-待审核 , 2-审核失败(可删除)，3-审核通过 ，4-已过期
    DWHelper* helper = [DWHelper shareHelper];
    __weak typeof(self) weakSelf = self;
    if ([model.status isEqualToString:@"1"]) {
        DWHelper* helper = [DWHelper shareHelper];

        if ( [helper.shopModel.industryCouponStatus isEqualToString:@"5"]) {
            [weakSelf alertWithTitle:@"该业务被暂停,请联系客服" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",helper.configModel.plat_kfmobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } withCancel:^(UIAlertAction *cancelaction) {
                
            }];
        }else{
            [self showToast:@"审核中"];
        }
    }
    if ([model.status isEqualToString:@"3"]||[model.status isEqualToString:@"4"]) {
        //Push 跳转
        IndustryListVC * VC = [[IndustryListVC alloc]initWithNibName:@"IndustryListVC" bundle:nil];
        VC.model  = model;
        [self.navigationController  pushViewController:VC animated:YES];
    }
    if ([model.status isEqualToString:@"2"]) {
        
        
        if ( [helper.shopModel.industryCouponStatus isEqualToString:@"5"]) {
            [weakSelf alertWithTitle:@"该业务被暂停,请联系客服" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",helper.configModel.plat_kfmobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } withCancel:^(UIAlertAction *cancelaction) {
                
            }];
        }else{
            //Push 跳转
            AddIndustryAmountVC * VC = [[AddIndustryAmountVC alloc]initWithNibName:@"AddIndustryAmountVC" bundle:nil];
            VC.AddIndustryAmountVCBlock =^(){
                //             self.pageIndex = 1;
                //            [self requestAction];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            };
            VC.model=model;
            [self.navigationController  pushViewController:VC animated:YES];
        }
        
   
    }
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Width*2.8/10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//UIView * header= ;
//    header.backgroundColor = [UIColor redColor];
        return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//iOS 8.0 后才有的方法
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    IndustryModel* model = indexPath.section >= self.dataArray.count ? nil :self.dataArray[indexPath.section];
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf alertWithTitle:@"是否删除?" message:nil OKWithTitle:@"删除" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            NSString *Token =[AuthenticationModel getLoginToken];
            __weak typeof(self) weakself = self;
        if (Token.length!= 0) {
                            BaseRequest *baseReq = [[BaseRequest alloc] init];
                            baseReq.token = [AuthenticationModel getLoginToken];
                            baseReq.encryptionType = AES;
                            baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
                            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/IndustryCouponFace/requestDelIndustryCouponFace" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                                NSLog(@"删除面额----%@",response);
                                if ([response[@"resultCode"] isEqualToString:@"1"]) {
                                    [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
                                    [weakSelf.tableView reloadData];
                                }else{
                                    //NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
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
    return @[delete];
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

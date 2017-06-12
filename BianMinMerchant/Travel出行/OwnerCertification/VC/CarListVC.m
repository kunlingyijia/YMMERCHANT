//
//  CarListVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "CarListVC.h"
#import "CarListCell.h"
#import "CarListModel.h"
#import "OwnerModel.h"
@interface CarListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation CarListVC

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
    [self AddRightBtn];
    self.title = @"所属车行";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    
    [self.tableView tableViewregisterNibArray:@[@"CarListCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
     self.pageIndex =1 ;
    [self Refresh];
        //网络请求
    [self requestAction];
    
}
#pragma mark - 添加保存
-(void)AddRightBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [backBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    
}
#pragma mark - 保存
-(void)save:(UIButton*)sender{
    if (self.UpdateStr.length==0) {
        [self showToast:@"请选择所属车行"];
        return;
    }
    //更新车主信息
    [self requestUpdateDriverInfo];
    
}
#pragma mark - 更新车主信息
-(void)requestUpdateDriverInfo{
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    OwnerModel *model = [[OwnerModel alloc]init];
    model.companyId = self.UpdateStr;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelDriver/requestUpdateDriverInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
           
            NSLog(@"更新车主信息----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [weakself.navigationController popViewControllerAnimated:YES];
                
            }else{
                weakself.view.userInteractionEnabled = YES;

                [weakself showToast:response[@"msg"]];
            }
            
        } faild:^(id error) {
            weakself.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }else{
        
    }

    
    
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
        NSLog(@"%d",weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/ThirdCompany/requestThirdCompanyList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"获取第三方公司----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                if (weakself.pageIndex == 1) {
                    [weakself.dataArray removeAllObjects];
                }

                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                    CarListModel *model = [CarListModel yy_modelWithJSON:dicdata];
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
    
    CarListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CarListCell" forIndexPath:indexPath];
    
    //cell 赋值
    cell.companyName.text = ((CarListModel*)self.dataArray[indexPath.row]).companyName;
    
    // cell 其他配置
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.UpdateStr =  ((CarListModel*)self.dataArray[indexPath.row]).companyId;
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Width*0.1;
    
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

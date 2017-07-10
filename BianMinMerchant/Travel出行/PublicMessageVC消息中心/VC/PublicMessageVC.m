//
//  PublicMessageVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/4/1.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "PublicMessageVC.h"
#import "MessageCenterCell.h"
#import "PushMessageCell.h"
#import "RequestMerchantMessageList.h"
#import "RequestMerchantMessageListModel.h"
@interface PublicMessageVC  ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageIndex;



@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PublicMessageVC
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
     self.title = @"消息中心";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterNibArray:@[@"PushMessageCell"]];
    
    [self showBackBtn];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
   
    self.pageIndex = 1;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf getDataList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex = weakSelf.pageIndex + 1;
        [weakSelf getDataList];
    }];
    [self getDataList];
    
}

- (void)getDataList {
    RequestMerchantMessageList *list = [[RequestMerchantMessageList alloc] init];
    list.pageIndex = self.pageIndex;
    list.pageCount = 10;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[list yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Message/requestMessageList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantMessageListModel *model = [RequestMerchantMessageListModel yy_modelWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];

        }else {
            [weakSelf showToast: baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
           } faild:^(id error) {
        
    }];
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
    
    PushMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PushMessageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RequestMerchantMessageListModel *model = self.dataArray[indexPath.row];
    cell.model =model;
    return cell;
   
    
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
    
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
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end

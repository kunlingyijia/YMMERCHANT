//
//  TripDetailsVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/15.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TripDetailsVC.h"
#import "TripDetailsOneCell.h"
#import "TripDetailsTwoCell.h"
#import "TripModel.h"
#import "PassengerDetailsVC.h"
#import "NODataCell.h"
@interface TripDetailsVC (){
    UIButton *backBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)TripModel*tripModel;
@property(nonatomic,strong)NSString* orderStatus;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation TripDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //数据
    [self  SET_DATA];

    //UI
    [self SET_UI];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    if ([self.tripModel.status isEqualToString:@"1"]||[self.tripModel.status isEqualToString:@"5"]) {
        
    }else{
        [self AddRightBtn];

    }
   
    self.title = @"行程信息";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterNibArray:@[@"TripDetailsOneCell",@"TripDetailsTwoCell",@"NODataCell"]];
    
}
#pragma mark - 添加保存
-(void)AddRightBtn{
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}
#pragma mark - 保存
-(void)save:(UIButton*)sender{
   // 1-待发布，2-已发布 ，3-待发车,4-已发车 ，5-已结束
    __weak typeof(self) weakSelf = self;
    if ([self.tripModel.status isEqualToString:@"1"]) {
        
    }else if ([self.tripModel.status isEqualToString:@"2"]) {
        [self alertActionSheetWithTitle:nil message:nil OKWithTitle:@"满员/停止接单" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            [weakSelf requestPlanSeatNumberFull];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }else if([self.tripModel.status isEqualToString:@"3"]){
        NSString * title = [self.tripModel.notAboardNumber isEqualToString:@"0"]? @"确认发车?":[NSString stringWithFormat:@"还有%@人未上车，确认发车？",self.tripModel.notAboardNumber];
        [self alertActionSheetWithTitle:nil message:nil OKWithTitleOne:@"发车" OKWithTitleTwo:@"取消行程" CancelWithTitle:@"取消" withOKDefaultOne:^(UIAlertAction *defaultaction) {
            
            [weakSelf alertWithTitle:title message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                 [weakSelf requestPlanStart];
            } withCancel:^(UIAlertAction *cancelaction) {
                
            }];
            
            
            
            
        } withOKDefaultTwo:^(UIAlertAction *defaultaction) {
             [weakSelf requestPlanCancel];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
        


    }
    else if([self.tripModel.status isEqualToString:@"4"]){
        [self alertActionSheetWithTitle:nil message:nil OKWithTitle:@"行程结束" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            [weakSelf requestPlanComplete];

        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }
    
}

#pragma mark - 关于数据
-(void)SET_DATA{
    self.tripModel = [TripModel new];
    self.tripModel = self.beforeTripModel;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.orderStatus = @"1";
    [self requestTravelOrderListAction];
    [self Refresh];

}

-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself requestPlanInfoAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark - 行程详情
-(void)requestPlanInfoAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    TripModel *model = [[TripModel alloc]init];
        model.planId = self.beforeTripModel.planId;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelPlan/requestPlanInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@"行程详情----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                weakself.tripModel = [TripModel yy_modelWithJSON:response[@"data"]];
               //  [weakself showToast:response[@"msg"]];
                if ([weakself.tripModel.status isEqualToString:@"1"]||[weakself.tripModel.status isEqualToString:@"5"]) {
                    backBtn.hidden =YES;
                }
                [weakself.tableView reloadData];
                [weakself requestTravelOrderListAction];
            }else{
                
                
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            
            NSLog(@"%@", error);
        }];
        
    }else{
        
    }

    
    
}
#pragma mark - 行程-订单列表
-(void)requestTravelOrderListAction{
    
    NSString *Token =[AuthenticationModel getLoginToken];
    TripModel *model = [[TripModel alloc]init];
     model.planId = self.beforeTripModel.planId;
    model.orderStatus = self.orderStatus;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelOrder/requestTravelOrderList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"行程-订单列表----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [weakself.dataArray removeAllObjects];
                NSMutableArray * arr = response[@"data"];
                for (NSDictionary* dic in arr) {
                    TripModel *model = [TripModel yy_modelWithJSON:dic];
                    [weakself.dataArray addObject:model];
                }
                
//                //一个section刷新
//                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                [weakself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
                  [weakself.tableView reloadData];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            
            NSLog(@"%@", error);
        }];
        
    }else{
        
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
    if (section==0) {
        return 1;
    }else{
        if (self.dataArray.count==0) {
            return 1;
        }else{
            return self.dataArray.count;
        }
        
    }
    
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        TripDetailsOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TripDetailsOneCell" forIndexPath:indexPath];
        //cell 赋值
        [cell CellGetData:self.tripModel];
        // cell 其他配置
        [cell.LeftBtn addTarget:self action:@selector(LeftBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.RightBtn addTarget:self action:@selector(RightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
         
        return cell;
    }else{
        if (self.dataArray.count==0) {
           
            NODataCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NODataCell" forIndexPath:indexPath];
            //cell 其他配置
            return cell;

        }else{
         TripDetailsTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TripDetailsTwoCell" forIndexPath:indexPath];
         
         //cell 赋值
        [cell CellGetData:self.dataArray[indexPath.row]];
         //cell 其他配置
        return cell;
        }

    }
  
}
#pragma mark - 待上车
-(void)LeftBtn:(UIButton*)sender{
    self.orderStatus = @"1";
    [self requestTravelOrderListAction];
    
}
#pragma mark - 已上车
-(void)RightBtn:(UIButton*)sender{
    self.orderStatus = @"2";
    [self requestTravelOrderListAction];

    
    
}


#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1) {
        if (self.dataArray.count!=0) {
            TripModel* model = self.dataArray[indexPath.row];
            //Push 跳转
            PassengerDetailsVC * VC = [[PassengerDetailsVC alloc]initWithNibName:@"PassengerDetailsVC" bundle:nil];
            VC.orderIdStr = model.orderId;
            [self.navigationController  pushViewController:VC animated:YES];
        }


    }
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return Width/9*5+20+Width/8;
    }else{
        if (self.dataArray.count==0) {
            return Width*0.8;
        }else{
         return Width*0.125;
        }
    }
   
    
}


#pragma mark - 乘客已满,停止接单
-(void)requestPlanSeatNumberFull{
    NSString *Token =[AuthenticationModel getLoginToken];
    TripModel *model = [[TripModel alloc]init];
    model.planId = self.tripModel.planId;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelPlan/requestPlanSeatNumberFull" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"乘客已满,停止接单----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [weakself showToast:@"乘客已满,停止接单"];
                [weakself requestPlanInfoAction];
            }else{
                
                
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            
            NSLog(@"%@", error);
        }];
        
    }else{
        
    }
    
    
    
}

#pragma mark - 发车
-(void)requestPlanStart{
    NSString *Token =[AuthenticationModel getLoginToken];
    TripModel *model = [[TripModel alloc]init];
    model.planId = self.tripModel.planId;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelPlan/requestPlanStart" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@"行程-发车----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [weakself showToast:@"发车成功"];
                [weakself requestPlanInfoAction];
            }else{
                
                
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            
            NSLog(@"%@", error);
        }];
        
    }else{
        
    }
    
    
    
}
#pragma mark - 行程-取消行程
-(void)requestPlanCancel{
    NSString *Token =[AuthenticationModel getLoginToken];
    TripModel *model = [[TripModel alloc]init];
    model.planId = self.tripModel.planId;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelPlan/requestPlanCancel" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@"行程-取消行程车----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [weakself showToast:@"取消行程"];
                [weakself requestPlanInfoAction];
            }else{
                
                
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            
            NSLog(@"%@", error);
        }];
        
    }else{
        
    }
    
    
    
}
#pragma mark - 行-程结束
-(void)requestPlanComplete{
    NSString *Token =[AuthenticationModel getLoginToken];
    TripModel *model = [[TripModel alloc]init];
    model.planId = self.tripModel.planId;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelPlan/requestPlanComplete" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@"行-程结束----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [weakself showToast:@"行程结束"];
                [weakself requestPlanInfoAction];
            }else{
                
                
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            
            NSLog(@"%@", error);
        }];
        
    }else{
        
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

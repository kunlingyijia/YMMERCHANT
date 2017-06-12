//
//  TravelwithdrawalVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelwithdrawalVC.h"
#import "TravelwithdrawalOneCell.h"
#import "TravelwithdrawalTwoCell.h"
#import "TravelwithdrawalThreeCell.h"
#import "TravelwithdrawalFourCell.h"
#import "TravelwithdrawalStatasOneCell.h"
#import "TravelSetFourCell.h"

#import "TravelBanckModel.h"
#import "BindBankCardViewController.h"
#import "TravelwithdrawalListVC.h"

@interface TravelwithdrawalVC (){
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSString*resultCode;
@property(nonatomic,strong)TravelBanckModel* travelBanckModel;

@end

@implementation TravelwithdrawalVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    NSLog(@"--------%@",[[DWHelper shareHelper].shopModel yy_modelToJSONObject]);
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    [self ShowNodataView];
    self.title = @"提现申请";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [self.tableView tableViewregisterNibArray:@[@"TravelwithdrawalOneCell",@"TravelwithdrawalTwoCell",@"TravelwithdrawalThreeCell",@"TravelSetFourCell",@"TravelwithdrawalFourCell",@"TravelwithdrawalStatasOneCell"]];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    [self requestBankInfo];
}

#pragma mark -  获取银行卡信息（新）
-(void)requestBankInfo{
    NSString *Token =[AuthenticationModel getLoginToken];
    ;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bank/requestBankInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"获取银行卡信息----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSMutableDictionary *dic = response[@"data"];
               self. travelBanckModel = [TravelBanckModel yy_modelWithJSON:dic];
               weakself.resultCode = @"1";
                //刷新
                [weakself.tableView reloadData];
                if ([weakself.travelBanckModel.status isEqualToString:@"2"]) {
                    [weakself addChongZhiAndTiXianBtn];
                }else{
                    weakself.navigationItem.rightBarButtonItem =nil;
                }
                [weakself HiddenNodataView];
            }else if([response[@"resultCode"] isEqualToString:@"3103"]){
                //刷新
                weakself.resultCode = @"3103";
                [weakself.tableView reloadData];
                [weakself HiddenNodataView];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
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
    
    return 4;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            if ([self.resultCode isEqualToString:@"3103"]) {
                TravelwithdrawalOneCell   * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelwithdrawalOneCell" forIndexPath:indexPath];
                //cell 赋值
                return cell;

            }
            //1-待审核，2-待打款(审核通过)，3-已打款，4-审核不通过（需要备注）
          else  if([self.travelBanckModel.status isEqualToString:@"1"]){
                TravelwithdrawalStatasOneCell   * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelwithdrawalStatasOneCell" forIndexPath:indexPath];
              cell.model = self.travelBanckModel;
                //cell 赋值
                return cell;
  
            }
           else if([self.travelBanckModel.status isEqualToString:@"3"]){
                TravelwithdrawalStatasOneCell   * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelwithdrawalStatasOneCell" forIndexPath:indexPath];
               cell.model = self.travelBanckModel;

                            //cell 赋值
                return cell;
               
            }
            else{
            TravelwithdrawalTwoCell   * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelwithdrawalTwoCell" forIndexPath:indexPath];
                [cell CellGetData: _travelBanckModel];
            //cell 赋值
            return cell;
            }
        
            break;
        }
            
        case 1:
        {
            TravelwithdrawalThreeCell   * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelwithdrawalThreeCell" forIndexPath:indexPath];
            
            
            cell.account.text = [DWHelper shareHelper].shopModel.account;
            
            cell.onlineAccount.text =[DWHelper shareHelper].shopModel.onlineAccount;
            cell.serviceFeeAccount.text =[DWHelper shareHelper].shopModel.serviceFeeAccount;
            if ([self.resultCode isEqualToString:@"3103"]||[self.travelBanckModel.status isEqualToString:@"1"]||[self.travelBanckModel.status isEqualToString:@"3"]) {
                cell.OneBtn.hidden = YES;
            }else{
                cell.OneBtn.hidden = NO;
            }
            [cell.OneBtn addTarget:self action:@selector(recordAction:) forControlEvents:(UIControlEventTouchUpInside)];
            //cell 赋值
            return cell;
            
            break;
        }
        case 2:
        {
            if ([[DWHelper shareHelper].shopModel.industry isEqualToString:@"2"]) {
                TravelwithdrawalFourCell   * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelwithdrawalFourCell" forIndexPath:indexPath];
                cell.offlineAccount.text = [DWHelper shareHelper].shopModel.offlineAccount;
                //cell 赋值
                
                return cell;
            }else{
                UITableViewCell   * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                
                
                return cell;
            }
            
            break;
        }
  
        case 3:
        {
            TravelSetFourCell   * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelSetFourCell" forIndexPath:indexPath];
            if ([self.resultCode isEqualToString:@"3103"]||[self.travelBanckModel.status isEqualToString:@"1"]||[self.travelBanckModel.status isEqualToString:@"3"]) {
                cell.LoginOutBtn.backgroundColor = [UIColor grayColor];
                cell.LoginOutBtn.userInteractionEnabled = NO;
            }else{
            cell.LoginOutBtn.userInteractionEnabled = YES;
               [cell.LoginOutBtn addTarget:self action:@selector(LoginOutBtn:) forControlEvents:(UIControlEventTouchUpInside)];
                cell.LoginOutBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
            }
            
            [cell.LoginOutBtn setTitle:@"申请提现" forState:(UIControlStateNormal)];
            //cell 赋值
            
            return cell;
            break;
        }
            
            
            
        default:{
            TravelwithdrawalThreeCell   * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelwithdrawalThreeCell" forIndexPath:indexPath];
            
            //cell 赋值
            
            
            return cell;
            break;
            
        }
    }

    
    
}
#pragma mark - 提现记录
-(void)recordAction:(UIButton*)sender{
    
    //Push 跳转
    TravelwithdrawalListVC * VC = [[TravelwithdrawalListVC alloc]initWithNibName:@"TravelwithdrawalListVC" bundle:nil];
    __weak typeof(self) weakSelf = self;
    VC.TravelwithdrawalListVCBlock =^(){
        //[weakSelf requestBankInfo];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController  pushViewController:VC animated:YES];

    
}
//提现(新)
#pragma mark - 申请提现
-(void)LoginOutBtn:(UIButton*)sender{
//    if ([self.account floatValue] < 50 ||[self.account floatValue] == 50) {
//        [self showToast:@"每笔提现金额大于或等于50"];
//        return;
//    }
    if ([self.account floatValue] == 0) {
        [self showToast:@"每笔提现金额大于0"];
        return;
    }

    NSString *Token =[AuthenticationModel getLoginToken];
    ;
    TravelBanckModel *model = [TravelBanckModel new];
    model.bankId = _travelBanckModel.bankId;
    model.amount = self.account;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/DrawFlow/requestAddDrawFlow" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"提现(新)----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                //NSMutableDictionary *dic = response[@"data"];
                weakself.TravelwithdrawalVCBlock();
                //Push 跳转
                TravelwithdrawalListVC * VC = [[TravelwithdrawalListVC alloc]initWithNibName:@"TravelwithdrawalListVC" bundle:nil];
                VC.TravelwithdrawalListVCBlock =^(){
                 [weakself.tableView reloadData];
                   //[weakself requestBankInfo];

                };
                [weakself.navigationController  pushViewController:VC animated:YES];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    
    
    
}

#pragma mark -
-(void)addChongZhiAndTiXianBtn{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 80, 40);
    
    [backBtn setTitle:@"重新绑定" forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    // [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(TopUp:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    
}

-(void)TopUp:(UIButton*)sender{
    BindBankCardViewController *bindBankC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BindBankCardViewController"];
    __weak typeof(self) weakSelf = self;
        bindBankC.travelBanckModel=   self.travelBanckModel;
    bindBankC.backBlock = ^(NSString *str) {
        //                [BackgroundService requestPushVC:weakSelf MyselfAction:^{
        //
        [weakSelf requestBankInfo];
        // }];
    };
    [self.navigationController pushViewController:bindBankC animated:YES];
    

    
}


#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        if ([self.resultCode isEqualToString:@"3103"]||[self.travelBanckModel.status isEqualToString:@"3"]) {
            BindBankCardViewController *bindBankC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BindBankCardViewController"];
            __weak typeof(self) weakSelf = self;
            if ([self.travelBanckModel.status isEqualToString:@"3"]) {
                bindBankC.travelBanckModel=   self.travelBanckModel;
            }
            bindBankC.backBlock = ^(NSString *str) {
                     [weakSelf requestBankInfo];
            };
            [self.navigationController pushViewController:bindBankC animated:YES];

        }
    }
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            if ([self.resultCode isEqualToString:@"3103"]||[self.travelBanckModel.status isEqualToString:@"1"]||[self.travelBanckModel.status isEqualToString:@"3"]) {
                return Width*0.11;
            }else {
                return Width*0.3;
            }
            break;
        }
        case 1:
        {
            return Width*0.4+10;
            break;
        }
        case 2:
        {
            return[[DWHelper shareHelper].shopModel.industry isEqualToString:@"2"] ?   Width*0.11+10 :0;
            break;
        }
            
            
        case 3:
        {
             return 88+60;
            break;
        }
            
        default:{
            
            break;
            
        }
    }

    return 80;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  TravelSettingVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelSettingVC.h"
#import "TravelSetHeaderView.h"
#import "TravelSetOneCell.h"
#import "TravelSetTwoCell.h"
#import "TravelSetThreeCell.h"
#import "TravelSetFourCell.h"
#import "OwnerCertificationVC.h"
#import "OwnerModel.h"
#import "ClerkManageController.h"
#import "AboutUSVC.h"
#import "Imageupload.h"
#import "TravelwithdrawalVC.h"
#import "Feedback.h"
#import "ImageChooseVC.h"
#import "CashAccountVC.h"
@interface TravelSettingVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)  TravelSetHeaderView *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong) OwnerModel *ownerModel;
///更新车主信息公共参数
@property(nonatomic,strong)NSString *UpdateStr;
@end

@implementation TravelSettingVC
//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
    //[self showBackBtn];
   // self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    self.title = @"更多";
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [self.tableView tableViewregisterNibArray:@[@"TravelSetOneCell",@"TravelSetTwoCell",@"TravelSetThreeCell",@"TravelSetFourCell"]];
    
    self.navigationView = [[TravelSetHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    [self.navigationView.leftBtn addTarget:self action:@selector(doBack:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_navigationView];
    TravelSetHeaderView * headerView=[[TravelSetHeaderView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    [headerView.leftBtn addTarget:self action:@selector(doBack:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tableView.tableHeaderView = headerView;
    
}
- (void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray= [@[@[@"头部",@"修改密码",@"车主认证",@"提现",@"现金账户明细"],@[@"意见反馈",@"关于我们"],@[@"退出登录"]]mutableCopy];
    self.ownerModel = [[OwnerModel alloc]init];
    [self LocalData];
    //获取车主信息
    [self requestAction];
    
}
-(void)LocalData{
    NSMutableDictionary * DriverInfo = [AuthenticationModel objectForKey:@"DriverInfo"];
    if (DriverInfo.count!=0) {
        self.ownerModel = [OwnerModel
                           yy_modelWithJSON:DriverInfo];
        [self.tableView reloadData];
    }
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
               [DWHelper shareHelper].shopModel =[RequestMerchantInfoModel yy_modelWithJSON: dic];
                //刷新
                [weakself.tableView reloadData];
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
    return self.dataArray.count;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr =self.dataArray[section];
    return arr.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                TravelSetOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelSetOneCell" forIndexPath:indexPath];
                [cell CellgetData:self.ownerModel];
                //创建轻拍手势
                UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [cell.avatarUrl addGestureRecognizer:tapGR];
                
                return cell;
            }else if (indexPath.row==2){
                TravelSetThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelSetThreeCell" forIndexPath:indexPath];
                 cell.label.text = self.dataArray[indexPath.section][indexPath.row];
                [cell CellgetData:self.ownerModel];
                     return cell;
            }else{
                TravelSetTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelSetTwoCell" forIndexPath:indexPath];
                cell.label.text = self.dataArray[indexPath.section][indexPath.row];
                 
                return cell;
            }
            
            
            break;
        }
            
        case 1:
        {
            TravelSetTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelSetTwoCell" forIndexPath:indexPath];
             cell.label.text = self.dataArray[indexPath.section][indexPath.row];
            
            return cell;


            break;
        }
            
        case 2:
        {
            TravelSetFourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelSetFourCell" forIndexPath:indexPath];
            cell.LoginOutBtn.backgroundColor = [UIColor redColor];
             [cell.LoginOutBtn addTarget:self action:@selector(LoginOutBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;


            break;
        }
            
            
            
        default:{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            
            return cell;

            break;
            
        }
    }

    
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = self.dataArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"修改密码"]) {
        //Push 跳转 --修改密码
        ClerkManageController * VC = [[ClerkManageController alloc]initWithNibName:@"ClerkManageController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
    }
    
    if ([title isEqualToString:@"车主认证"]) {
        if ([self.ownerModel.status isEqualToString:@"2"]) {
            [self showToast:@"审核中.."];
        }else{
            //Push 跳转--车主认证
            OwnerCertificationVC * VC = [[OwnerCertificationVC alloc]initWithNibName:@"OwnerCertificationVC" bundle:nil];
            __weak typeof(self) weakSelf = self;
            VC.OwnerCertificationVCBlock =^(){
                [weakSelf requestAction];
            };
            [self.navigationController  pushViewController:VC animated:YES];
        }

    }
    if ([title isEqualToString:@"提现"]) {
        ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
        if ([self.ownerModel.status isEqualToString:@"2"]) {
            [self showToast:@"审核中.."];
        }else if([self.ownerModel.status isEqualToString:@"3"]){
            //Push 跳转--提现
            TravelwithdrawalVC * VC = [[TravelwithdrawalVC alloc]initWithNibName:@"TravelwithdrawalVC" bundle:nil];
            VC.account = self.ownerModel.account;
            __weak typeof(self) weakSelf = self;
            VC.TravelwithdrawalVCBlock =^(){
                [weakSelf requestAction];
            };
            [self.navigationController  pushViewController:VC animated:YES];
        }else{
            //Push 跳转--车主认证
            OwnerCertificationVC * VC = [[OwnerCertificationVC alloc]initWithNibName:@"OwnerCertificationVC" bundle:nil];
            __weak typeof(self) weakSelf = self;
            VC.OwnerCertificationVCBlock =^(){
                [weakSelf requestAction];
            };
            [self.navigationController  pushViewController:VC animated:YES];
        }
    }
    if ([title isEqualToString:@"现金账户明细"]) {
        ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
        if ([self.ownerModel.status isEqualToString:@"2"]) {
            [self showToast:@"审核中.."];
        }else if([self.ownerModel.status isEqualToString:@"3"]){
            //Push 跳转--现金账户明细
            CashAccountVC * VC = [[CashAccountVC alloc]initWithNibName:@"CashAccountVC" bundle:nil];
            [self.navigationController  pushViewController:VC animated:YES];
        }else{
            //Push 跳转--车主认证
            OwnerCertificationVC * VC = [[OwnerCertificationVC alloc]initWithNibName:@"OwnerCertificationVC" bundle:nil];
            __weak typeof(self) weakSelf = self;
            VC.OwnerCertificationVCBlock =^(){
                [weakSelf requestAction];
            };
            [self.navigationController  pushViewController:VC animated:YES];
        }
    }
    if ([title isEqualToString:@"意见反馈"]) {
     //Push 跳转 --问题反馈
        [self.navigationController pushViewController:[Feedback new] animated:YES];
    }
    if ([title isEqualToString:@"关于我们"]) {
        //Push 跳转--关于我们
        AboutUSVC * VC = [[AboutUSVC alloc]initWithNibName:@"AboutUSVC" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
    }
    


}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString * title = self.dataArray[indexPath.section][indexPath.row];

      if ([title isEqualToString:@"头部"]) {
        return Width*0.4;
      }
    if ([title isEqualToString:@"修改密码"]||[title isEqualToString:@"车主认证"]||[title isEqualToString:@"提现"]||[title isEqualToString:@"现金账户明细"]||[title isEqualToString:@"意见反馈"]||[title isEqualToString:@"关于我们"]) {
         return Width*0.125;
      }
     if ([title isEqualToString:@"退出登录"]) {
           return 88+60;
     }
      return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 0;
    }
}
#pragma mark - 退出
-(void)LoginOutBtn:(UIButton*)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"退出账号" object:@"退出账号" userInfo:@{}];
    //设置别名
    [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"pushAlias"]];
    NSArray *controllers = self.navigationController.childViewControllers;
    [self.navigationController popToViewController:controllers[1] animated:YES];
}

#pragma mark - 头像
-(void)tapAction:(UITapGestureRecognizer*)sender{
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    VC.zoom = 1;
    __weak typeof(self) weakSelf = self;
    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        [[DWHelper shareHelper]UPImageToServer:@[image] success:^(id response) {
            NSDictionary * dic = response[0];
            weakSelf.UpdateStr =dic[@"originUrl"];
            //更新车主信息
            [weakSelf requestUpdateDriverInfo];
        } faild:^(id error) {
            
        }];
    };
    [self presentViewController:VC animated:NO completion:^{
    }];

}


#pragma mark - 更新车主信息
-(void)requestUpdateDriverInfo{
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    OwnerModel *model = [[OwnerModel alloc]init];
    model.avatarUrl = self.UpdateStr;
        __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelDriver/requestUpdateDriverInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"更新车主信息----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                weakself.view.userInteractionEnabled = YES;
                weakself.ownerModel.avatarUrl =weakself.UpdateStr;
                [weakself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
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
//只要拖拽就会触发(scrollView 的偏移量发生改变)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%f",scrollView.contentOffset.y);
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

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end

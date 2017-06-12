//
//  SettingViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutUSVC.h"
#import "Feedback.h"
#import "LBXScanWrapper.h"
#import "StaffViewController.h"
#import "AddOrederViewController.h"
#import "ClerkManageController.h"
#import "MoneyCenterViewController.h"
#import "SettingShopMessageController.h"
#import "WriteMessageViewController.h"
#import "CompletionDataVC.h"
#import "TravelwithdrawalVC.h"
#import "ChangeMerchantsDataVC.h"
#import "NewCompleonDataVC.h"
#import "AddServiceVC.h"
#import "CashAccountVC.h"
@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *nameCode;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end


@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"更多";
    [self showBackBtn];
    DWHelper *helper = [DWHelper shareHelper];
    
    if (helper.isLoginType == 0) {
        if (helper.shopType == 2) {
            self.dataSource = @[@[@"收费标准",@"店员管理",@"修改密码", @"修改商户信息",@"提现",@"现金账户明细"],@[@"意见反馈",@"关于我们"]];
        }else {
            self.dataSource = @[@[@"店员管理",@"修改密码",@"修改商户信息",@"提现",@"现金账户明细"],@[@"意见反馈",@"关于我们"]];
        }
    }else {
        if (helper.shopType == 2) {
            self.dataSource = @[@[@"收费标准",@"修改密码",@"修改商户信息",@"现金账户明细"],@[@"意见反馈",@"关于我们"]];
        }else {
            self.dataSource = @[@[@"修改密码",@"修改商户信息",@"现金账户明细"],@[@"意见反馈",@"关于我们"]];
        }
    }
   
    self.shopImage.image = [LBXScanWrapper createQRWithString:self.shopModel.merchantNo size:self.shopImage.frame.size];
    self.nameCode.text = [NSString stringWithFormat:@"商户号:%@", self.shopModel.merchantNo];
    self.nameLabel.text = self.shopModel.merchantName;
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8*Width/15, Width, Height - 64 - 8*Width/15) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"settingCell"];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 60)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    btn.frame = CGRectMake(10, 0, Width-20, 40);
    [footView addSubview:btn];
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];

}

#pragma mark - UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

#pragma mark - UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 NSString * title =   self.dataSource[indexPath.section][indexPath.row];
    __weak typeof(self) weakSelf = self;

        if ([title isEqualToString:@"收费标准"]) {
                       //商户状态 1-正常 2-待补全质料,3-待审核
            
            DWHelper *helper = [DWHelper shareHelper];
            if (helper.messageStatus == 0) {
                [self showToast:@"禁用"];
            }else if (helper.messageStatus == 1) {
//                AddOrederViewController *addOrderC = [[AddOrederViewController alloc] init];
//                [self.navigationController pushViewController:addOrderC animated:YES];
                //Push 跳转
                AddServiceVC * VC = [[AddServiceVC alloc]initWithNibName:@"AddServiceVC" bundle:nil];
                [self.navigationController  pushViewController:VC animated:YES];

            }else if (helper.messageStatus == 2) {
                //Push 跳转
                NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
                
                VC.shopModel = self.shopModel;
                VC.regionId = self.shopModel.regionId;
                __weak typeof(self) weakSelf = self;
                
                VC.backAction =^(NSString *str){
                    [ BackgroundService  requestPushVC:weakSelf MyselfAction:^{
                        
                    }];              };
                [self.navigationController  pushViewController:VC animated:YES];
            }else if (helper.messageStatus == 3) {
                [self showToast:@"审核中"];
            }

        }
    
      if ([title isEqualToString:@"帮助中心"]) {
        
      }
      if ([title isEqualToString:@"店员管理"]) {
          //商户状态 1-正常 2-待补全质料,3-待审核
          
          DWHelper *helper = [DWHelper shareHelper];
          if (helper.messageStatus == 0) {
              [self showToast:@"禁用"];
          }else if (helper.messageStatus == 1) {
              //店员管理
              StaffViewController *staffC = [[StaffViewController alloc] init];
              [self.navigationController pushViewController:staffC animated:YES];
          }else if (helper.messageStatus == 2) {
                            //Push 跳转
              NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
              
              VC.shopModel = self.shopModel;
              VC.regionId = self.shopModel.regionId;
              __weak typeof(self) weakSelf = self;
              
              VC.backAction =^(NSString *str){
                  [ BackgroundService  requestPushVC:weakSelf MyselfAction:^{
                      
                  }];              };
              [self.navigationController  pushViewController:VC animated:YES];
          }else if (helper.messageStatus == 3) {
              [self showToast:@"审核中"];
          }
      }
    if ([title isEqualToString:@"修改密码"]) {
        ClerkManageController *controller = [[ClerkManageController alloc] initWithNibName:@"ClerkManageController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if ([title isEqualToString:@"修改商户信息"]) {
        
        
        
        DWHelper *helper = [DWHelper shareHelper];
        if (helper.messageStatus == 0) {
            [self showToast:@"禁用"];
        }else if (helper.messageStatus == 1) {
            //Push 跳转
            ChangeMerchantsDataVC * VC = [[ChangeMerchantsDataVC alloc]initWithNibName:@"ChangeMerchantsDataVC" bundle:nil];
            VC.backAction = ^(NSString * str){
                [ BackgroundService  requestPushVC:weakSelf MyselfAction:^{
                    
                }];
            };
            [self.navigationController  pushViewController:VC animated:YES];
        }else if (helper.messageStatus == 2) {
            
            //Push 跳转
            NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
            
            VC.shopModel = self.shopModel;
            VC.regionId = self.shopModel.regionId;
            __weak typeof(self) weakSelf = self;
            
            VC.backAction =^(NSString *str){
                //[weakSelf getShopData];
                [ BackgroundService  requestPushVC:weakSelf MyselfAction:^{
                    
                }];
                
            };
            [self.navigationController  pushViewController:VC animated:YES];
            
        }else if (helper.messageStatus == 3) {
            [self showToast:@"审核中"];
        }

       
       
        //SettingShopMessageController *shopMessageC = [[SettingShopMessageController alloc] init];
                                   // [self.navigationController pushViewController:shopMessageC animated:YES];

    }

    if ([title isEqualToString:@"提现"]) {
        DWHelper *helper = [DWHelper shareHelper];
        if (helper.messageStatus == 0) {
            [self showToast:@"禁用"];
        }else if (helper.messageStatus == 1) {
            //Push 跳转--提现
            TravelwithdrawalVC * VC = [[TravelwithdrawalVC alloc]initWithNibName:@"TravelwithdrawalVC" bundle:nil];
            VC.account = self.shopModel.account;
            [self.navigationController  pushViewController:VC animated:YES];
        }else if (helper.messageStatus == 2) {
            
            //Push 跳转
            NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
            
            VC.shopModel = self.shopModel;
            VC.regionId = self.shopModel.regionId;
            __weak typeof(self) weakSelf = self;
            
            VC.backAction =^(NSString *str){
                //[weakSelf getShopData];
               [ BackgroundService  requestPushVC:weakSelf MyselfAction:^{
                   
               }];
                
            };
            [self.navigationController  pushViewController:VC animated:YES];
            
        }else if (helper.messageStatus == 3) {
            [self showToast:@"审核中"];
        }
        
        
    
    }

    
    if ([title isEqualToString:@"现金账户明细"]) {
        //商户状态 1-正常 2-待补全质料,3-待审核
        
        DWHelper *helper = [DWHelper shareHelper];
        if (helper.messageStatus == 0) {
            [self showToast:@"禁用"];
        }else if (helper.messageStatus == 1) {
           
            //Push 跳转
            CashAccountVC * VC = [[CashAccountVC alloc]initWithNibName:@"CashAccountVC" bundle:nil];
            [self.navigationController  pushViewController:VC animated:YES];
            
        }else if (helper.messageStatus == 2) {
            //Push 跳转
            NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
            
            VC.shopModel = self.shopModel;
            VC.regionId = self.shopModel.regionId;
            __weak typeof(self) weakSelf = self;
            
            VC.backAction =^(NSString *str){
                [ BackgroundService  requestPushVC:weakSelf MyselfAction:^{
                    
                }];              };
            [self.navigationController  pushViewController:VC animated:YES];
        }else if (helper.messageStatus == 3) {
            [self showToast:@"审核中"];
        }
        
    }
    
    
    
    if ([title isEqualToString:@"意见反馈"]) {
         [self.navigationController pushViewController:[Feedback new] animated:YES];
    }

    if ([title isEqualToString:@"关于我们"]) {
         //[self.navigationController pushViewController:[AboutUS new] animated:YES];
        //Push 跳转
        AboutUSVC * VC = [[AboutUSVC alloc]initWithNibName:@"AboutUSVC" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];

       
        
        
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
   // if (indexPath.section == 1) {
////        if (indexPath.row == 0) {
////            [self.navigationController pushViewController:[Feedback new] animated:YES];
////        }else if (indexPath.row == 1) {
////            [self.navigationController pushViewController:[AboutUS new] animated:YES];
////        }
//    }else if (indexPath.section == 0) {
//        DWHelper *helper = [DWHelper shareHelper];
////        if (helper.shopType == 2) {
////            if (indexPath.row == 2) {
////                StaffViewController *staffC = [[StaffViewController alloc] init];
////                [self.navigationController pushViewController:staffC animated:YES];
////            }else if(indexPath.row == 0) {
////                AddOrederViewController *addOrderC = [[AddOrederViewController alloc] init];
////                [self.navigationController pushViewController:addOrderC animated:YES];
////            }
////        }else {
//            if (helper.isLoginType == 0) {
//                if (helper.shopType == 2) {
//                    if (indexPath.row == 2) {
//                        //商户状态 1-正常 2-待补全质料,3-待审核
//
//                        DWHelper *helper = [DWHelper shareHelper];
//                        if (helper.messageStatus == 0) {
//                            [self showToast:@"禁用"];
//                        }else if (helper.messageStatus == 1) {
//                            //店员管理
//                            StaffViewController *staffC = [[StaffViewController alloc] init];
//                            [self.navigationController pushViewController:staffC animated:YES];
//                        }else if (helper.messageStatus == 2) {
////                            WriteMessageViewController *messgeC = [[WriteMessageViewController alloc] init];
////                            messgeC.shopModel = self.shopModel;
////                            __weak typeof(self) weakSelf = self;
////                            
////                            
////
////                            [self.navigationController pushViewController:messgeC animated:YES];
//                        
////                            //Push 跳转
////                            CompletionDataVC * VC = [[CompletionDataVC alloc]initWithNibName:@"CompletionDataVC" bundle:nil];
////                            VC.shopModel = self.shopModel;
////                            __weak typeof(self) weakSelf = self;
////                            
//////                            VC.backAction =^(NSString *str){
//////                                [weakSelf getShopData];
//////                            };
////                            [self.navigationController  pushViewController:VC animated:YES];
//                            //Push 跳转
//                            NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
//                            
//                            VC.shopModel = self.shopModel;
//                            VC.regionId = self.shopModel.regionId;
//                            __weak typeof(self) weakSelf = self;
//                            
//                            VC.backAction =^(NSString *str){
//                                //[weakSelf getShopData];
//                            };
//                            [self.navigationController  pushViewController:VC animated:YES];
//                        }else if (helper.messageStatus == 3) {
//                            [self showToast:@"审核中"];
//                        }
//
//                    }else if(indexPath.row == 0) {
////                        AddOrederViewController *addOrderC = [[AddOrederViewController alloc] init];
////                        
////                        [self.navigationController pushViewController:addOrderC animated:YES];
//                    }else if (indexPath.row == 1) {
//                        NSLog(@"帮助中心");
//                    }else if (indexPath.row == 3) {
//                        NSLog(@"修改密码");
//                        ClerkManageController *controller = [[ClerkManageController alloc] initWithNibName:@"ClerkManageController" bundle:nil];
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }else if (indexPath.row == 4) {
//                        
//                        DWHelper *helper = [DWHelper shareHelper];
//                        if (helper.messageStatus == 0) {
//                            [self showToast:@"禁用"];
//                        }else if (helper.messageStatus == 1) {
////                            //修改商户信息
////                            SettingShopMessageController *shopMessageC = [[SettingShopMessageController alloc] init];
////                            [self.navigationController pushViewController:shopMessageC animated:YES];
//
//
//                            //Push 跳转
//                            ChangeMerchantsDataVC * VC = [[ChangeMerchantsDataVC alloc]initWithNibName:@"ChangeMerchantsDataVC" bundle:nil];
//                            [self.navigationController  pushViewController:VC animated:YES];
//
//                            
//                            
//                            
//                        }else if (helper.messageStatus == 2) {
////                            WriteMessageViewController *messgeC = [[WriteMessageViewController alloc] init];
////                            messgeC.shopModel = self.shopModel;
////                            __weak typeof(self) weakSelf = self;
////                            
////                            
////
////                            [self.navigationController pushViewController:messgeC animated:YES];
//                            
//                            
//                            
////                            //Push 跳转
////                            CompletionDataVC * VC = [[CompletionDataVC alloc]initWithNibName:@"CompletionDataVC" bundle:nil];
////                            VC.shopModel = self.shopModel;
////                            __weak typeof(self) weakSelf = self;
////                            
//////                            VC.backAction =^(NSString *str){
//////                                [weakSelf getShopData];
//////                            };
////                            [self.navigationController  pushViewController:VC animated:YES];
//                            
//                            
//                            //Push 跳转
//                            NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
//                            
//                            VC.shopModel = self.shopModel;
//                            VC.regionId = self.shopModel.regionId;
//                            __weak typeof(self) weakSelf = self;
//                            
//                            VC.backAction =^(NSString *str){
//                                //[weakSelf getShopData];
//                            };
//                            [self.navigationController  pushViewController:VC animated:YES];
//                        }else if (helper.messageStatus == 3) {
//                            [self showToast:@"审核中"];
//                        }
//
//                        
//
//                    }else if (indexPath.row == 5) {
//                        NSLog(@"商户提现");
////                        MoneyCenterViewController *moneyC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyCenterViewController"];
////                        [self.navigationController pushViewController:moneyC animated:YES];
//                        DWHelper *helper = [DWHelper shareHelper];
//                        if (helper.messageStatus == 0) {
//                            [self showToast:@"禁用"];
//                        }else if (helper.messageStatus == 1) {
//                            //Push 跳转--提现
//                            TravelwithdrawalVC * VC = [[TravelwithdrawalVC alloc]initWithNibName:@"TravelwithdrawalVC" bundle:nil];
//                            VC.account = self.shopModel.account;
//                            [self.navigationController  pushViewController:VC animated:YES];
//                        }else if (helper.messageStatus == 2) {
////                            WriteMessageViewController *messgeC = [[WriteMessageViewController alloc] init];
////                            messgeC.shopModel = self.shopModel;
////                            
////                            [self.navigationController pushViewController:messgeC animated:YES];
//                            
//                            //Push 跳转
////                            CompletionDataVC * VC = [[CompletionDataVC alloc]initWithNibName:@"CompletionDataVC" bundle:nil];
////                            VC.shopModel = self.shopModel;
////                            __weak typeof(self) weakSelf = self;
////                            
//////                            VC.backAction =^(NSString *str){
//////                                [weakSelf getShopData];
//////                            };
////                            [self.navigationController  pushViewController:VC animated:YES];
//                            //Push 跳转
//                            NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
//                            
//                            VC.shopModel = self.shopModel;
//                            VC.regionId = self.shopModel.regionId;
//                            __weak typeof(self) weakSelf = self;
//                            
//                            VC.backAction =^(NSString *str){
//                                //[weakSelf getShopData];
//                            };
//                            [self.navigationController  pushViewController:VC animated:YES];
//                            
//                        }else if (helper.messageStatus == 3) {
//                            [self showToast:@"审核中"];
//                        }
//
//                        
//                    }
//                }else {
//                    self.dataSource = @[@[@"帮助中心",@"店员管理",@"修改密码"],@[@"意见反馈",@"关于我们"]];
//                    if (indexPath.row == 1) {
//                        
//                        
//                        
//                        DWHelper *helper = [DWHelper shareHelper];
//                        if (helper.messageStatus == 0) {
//                            [self showToast:@"禁用"];
//                        }else if (helper.messageStatus == 1) {
//                            //店员管理
//                            StaffViewController *staffC = [[StaffViewController alloc] init];
//                            [self.navigationController pushViewController:staffC animated:YES];
//                        }else if (helper.messageStatus == 2) {
////                            WriteMessageViewController *messgeC = [[WriteMessageViewController alloc] init];
////                            messgeC.shopModel = self.shopModel;
////                            [self.navigationController pushViewController:messgeC animated:YES];
//                            
//                            
////                            //Push 跳转
////                            CompletionDataVC * VC = [[CompletionDataVC alloc]initWithNibName:@"CompletionDataVC" bundle:nil];
////                            VC.shopModel = self.shopModel;
////                            __weak typeof(self) weakSelf = self;
////                            
//////                            VC.backAction =^(NSString *str){
//////                                [weakSelf getShopData];
//////                            };
////                            [self.navigationController  pushViewController:VC animated:YES];
//                            
//                            
//                            //Push 跳转
//                            NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
//                            
//                            VC.shopModel = self.shopModel;
//                            VC.regionId = self.shopModel.regionId;
//                            __weak typeof(self) weakSelf = self;
//                            
//                            VC.backAction =^(NSString *str){
//                                //[weakSelf getShopData];
//                            };
//                            [self.navigationController  pushViewController:VC animated:YES];
//                            
//                        }else if (helper.messageStatus == 3) {
//                            [self showToast:@"审核中"];
//                        }
//
//                        
//                        
//                        
//                    }else if(indexPath.row == 0) {
//                        NSLog(@"帮助中心");
//                    }else if (indexPath.row == 2) {
//                        NSLog(@"修改密码");
//                        ClerkManageController *controller = [[ClerkManageController alloc] initWithNibName:@"ClerkManageController" bundle:nil];
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }else if (indexPath.row == 3) {
//                        
//                        
//                        
//                        
//                        
//                        DWHelper *helper = [DWHelper shareHelper];
//                        if (helper.messageStatus == 0) {
//                            [self showToast:@"禁用"];
//                        }else if (helper.messageStatus == 1) {
////                            //修改商户信息
////                            SettingShopMessageController *shopMessageC = [[SettingShopMessageController alloc] init];
////                            [self.navigationController pushViewController:shopMessageC animated:YES];
//                            //Push 跳转
//                            ChangeMerchantsDataVC * VC = [[ChangeMerchantsDataVC alloc]initWithNibName:@"ChangeMerchantsDataVC" bundle:nil];
//                            [self.navigationController  pushViewController:VC animated:YES];
//
//                        }else if (helper.messageStatus == 2) {
////                            WriteMessageViewController *messgeC = [[WriteMessageViewController alloc] init];
////                            messgeC.shopModel = self.shopModel;
////                            [self.navigationController pushViewController:messgeC animated:YES];
//                            
//                            
//                            //Push 跳转
////                            CompletionDataVC * VC = [[CompletionDataVC alloc]initWithNibName:@"CompletionDataVC" bundle:nil];
////                            VC.shopModel = self.shopModel;
////                            __weak typeof(self) weakSelf = self;
////                            
//////                            VC.backAction =^(NSString *str){
//////                                [weakSelf getShopData];
//////                            };
////                            [self.navigationController  pushViewController:VC animated:YES];
//                            //Push 跳转
//                            NewCompleonDataVC * VC = [[NewCompleonDataVC alloc]initWithNibName:@"NewCompleonDataVC" bundle:nil];
//                            
//                            VC.shopModel = self.shopModel;
//                            VC.regionId = self.shopModel.regionId;
//                            __weak typeof(self) weakSelf = self;
//                            
//                            VC.backAction =^(NSString *str){
//                                //[weakSelf getShopData];
//                            };
//                            [self.navigationController  pushViewController:VC animated:YES];
//                        }else if (helper.messageStatus == 3) {
//                            [self showToast:@"审核中"];
//                        }
//
//                    }
//                }
//            }else {
//                if (helper.shopType == 2) {
//                    self.dataSource = @[@[@"收费标准",@"帮助中心",@"修改密码",@"商户提现"],@[@"意见反馈",@"关于我们"]];
//                    if(indexPath.row == 0) {
//                        AddOrederViewController *addOrderC = [[AddOrederViewController alloc] init];
//                        [self.navigationController pushViewController:addOrderC animated:YES];
//                    }else if (indexPath.row == 1) {
//                        NSLog(@"帮助中心");
//                    }else if (indexPath.row == 2) {
//                        NSLog(@"修改密码");
//                        ClerkManageController *controller = [[ClerkManageController alloc] initWithNibName:@"ClerkManageController" bundle:nil];
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }else if (indexPath.row == 3) {
////                        //修改商户信息
////                        SettingShopMessageController *shopMessageC = [[SettingShopMessageController alloc] init];
////                        [self.navigationController pushViewController:shopMessageC animated:YES];
//                        //Push 跳转
//                        ChangeMerchantsDataVC * VC = [[ChangeMerchantsDataVC alloc]initWithNibName:@"ChangeMerchantsDataVC" bundle:nil];
//                        [self.navigationController  pushViewController:VC animated:YES];
//
//                    }
////                    else if (indexPath.row == 4) {
////                        NSLog(@"商户提现");
////                        MoneyCenterViewController *moneyC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyCenterViewController"];
////                        [self.navigationController pushViewController:moneyC animated:YES];
////                    }
//                }else {
//                   if (indexPath.row == 0) {
//                        NSLog(@"帮助中心");
//                    }else if (indexPath.row == 1) {
//                        NSLog(@"修改密码");
//                        ClerkManageController *controller = [[ClerkManageController alloc] initWithNibName:@"ClerkManageController" bundle:nil];
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }else if (indexPath.row == 2) {
////                        //修改商户信息
////                        SettingShopMessageController *shopMessageC = [[SettingShopMessageController alloc] init];
////                        [self.navigationController pushViewController:shopMessageC animated:YES];
//                        //Push 跳转
//                        ChangeMerchantsDataVC * VC = [[ChangeMerchantsDataVC alloc]initWithNibName:@"ChangeMerchantsDataVC" bundle:nil];
//                        [self.navigationController  pushViewController:VC animated:YES];
//
//                    }
//            }
//        }
//    }
}


- (void)refundAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"退出账号" object:@"退出账号" userInfo:@{}];
    //设置别名
    [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"pushAlias"]];
     //[JPUSHService setAlias:@"0" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    NSArray *controllers = self.navigationController.childViewControllers;
    [self.navigationController popToViewController:controllers[1] animated:NO];
    
}
#pragma mark - 推送别名
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    if (iResCode == 6002) {
        [JPUSHService setAlias:@"0" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    NSLog(@"push set alias success alisa = %@", alias);
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

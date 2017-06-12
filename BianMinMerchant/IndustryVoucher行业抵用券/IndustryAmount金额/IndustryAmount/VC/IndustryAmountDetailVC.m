//
//  IndustryAmountDetailVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryAmountDetailVC.h"
#import "AddIndustryAmountVC.h"
#import "IndustryModel.h"
@interface IndustryAmountDetailVC ()

@end

@implementation IndustryAmountDetailVC

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
    self.title = @"详情";
//    __weak typeof(self) weakSelf = self;
//    [self showRightBtnTitle:@"编辑" Image:nil RightBtn:^{
//        //Push 跳转
//        AddIndustryAmountVC * VC = [[AddIndustryAmountVC alloc]initWithNibName:@"AddIndustryAmountVC" bundle:nil];
//        [weakSelf.navigationController  pushViewController:VC animated:YES];
//
//    }];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
//    _refuseReason.text = self.industryModel.refuseReason;
    
    
    
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end

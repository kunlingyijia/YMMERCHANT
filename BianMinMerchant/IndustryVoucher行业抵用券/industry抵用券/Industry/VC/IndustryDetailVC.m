//
//  IndustryDetailVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryDetailVC.h"
#import "AddIndustryVC.h"
@interface IndustryDetailVC ()

@end

@implementation IndustryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    
    self.title = @"详情";
    [self showBackBtn];
    [self showRightBtnTitle:@"编辑" Image:nil RightBtn:^{
        //Push 跳转
        AddIndustryVC * VC = [[AddIndustryVC alloc]initWithNibName:@"AddIndustryVC" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];

    }];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end

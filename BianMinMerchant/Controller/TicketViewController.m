//
//  TicketViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "TicketViewController.h"

@interface TicketViewController ()

@end

@implementation TicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self showBackBtn];
}

- (void)createView {
    NSInteger btnW = (Width - 40)/3;
    NSArray *arr = @[@"满减券",@"立减券",@"折扣券"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(10 + i *(btnW + 10), 10, btnW, 30);
        btn.backgroundColor = [UIColor colorWithHexString:kSubTitleColor];
        [self.view addSubview:btn];
    }
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"添加优惠券" forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor colorWithHexString:kSubTitleColor];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(-10);
        make.left.equalTo(self.view).with.offset(10);
        make.height.mas_equalTo(@(30));
    }];
    
}

- (void)btnAction:(UIButton *)sender {
    OKLog(@"优惠券");
}
- (void)addAction:(UIButton *)sender {
    OKLog(@"添加优惠券");
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

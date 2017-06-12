//
//  RegisterController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *adressText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商户入驻";
    [self showBackBtn];
}
- (IBAction)sureAction:(id)sender {
    OKLog(@"立即申请");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 3;
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

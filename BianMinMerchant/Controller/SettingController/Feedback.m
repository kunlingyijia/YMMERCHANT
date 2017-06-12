//
//  Feedback.m
//  BianMin
//
//  Created by z on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "Feedback.h"
#import "RequestMerchantFeedback.h"
@interface Feedback()

@property (nonatomic, strong) EZTextView *contentView;

@end

@implementation Feedback

- (void)viewDidLoad{
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"意见反馈";
    
    [self initWithCumstomView];
}

- (void)initWithCumstomView{
    UIView *feedBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 80-64, Width - 20, 160)];
    feedBackView.layer.cornerRadius = 10;
    feedBackView.layer.masksToBounds = YES;
    feedBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:feedBackView];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setBackgroundColor:[UIColor colorWithHexString:kNavigationBgColor]];
    [submit addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    submit.frame = CGRectMake(10, feedBackView.frame.origin.y + feedBackView.frame.size.height + 20, Width - 20, 40);
    submit.layer.cornerRadius = 5;
    submit.layer.masksToBounds = YES;
    [submit setTitle:@"发送" forState:UIControlStateNormal];
    [self.view addSubview:submit];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[EZTextView alloc] initWithFrame:CGRectMake(10, 10, Width - 40, 140)];
    self.contentView.placeholder = @"请留下您的意见或建议";
    self.contentView.font = [UIFont systemFontOfSize:15];
    self.contentView.textColor = [UIColor colorWithHexString:kTitleColor];

    [feedBackView addSubview:self.contentView];
}

- (void)commitAction:(UIButton *)sender {
    RequestMerchantFeedback *feedback = [[RequestMerchantFeedback alloc] init];
    feedback.content = self.contentView.text;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[feedback yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper]requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Feedback/requestAddFeedback" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            
            [weakSelf showToast:@"提交成功"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            

            
        }else {
            [weakSelf showToast:baseRes.msg];
            weakSelf.view.userInteractionEnabled = YES;

            
        }
        NSLog(@"%@", response);
    } faild:^(id error) {
        weakSelf.view.userInteractionEnabled = YES;

    }];
}


@end

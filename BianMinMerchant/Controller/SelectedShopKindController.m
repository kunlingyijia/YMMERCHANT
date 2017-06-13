//
//  SelectedShopKindController.m
//  BianMinMerchant
//
//  Created by kkk on 17/2/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "SelectedShopKindController.h"
#import "LoginController.h"
#import "NewMerchantEnterController.h"
#import "VerisonModel.h"
@interface SelectedShopKindController ()

@end

@implementation SelectedShopKindController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"易民商户";
    [self  updateVerison];

    // Do any additional setup after loading the view from its nib.
}

#pragma mark - priveFun
//团购入口
- (IBAction)bmAction:(id)sender {
    
    LoginController *loginC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginController"];
    loginC.shopKind = @"团购商户";
    loginC.industry = 1;
    [self.navigationController pushViewController:loginC animated:YES];
    
}
//便民入口
- (IBAction)groupAction:(id)sender {
    LoginController *loginC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginController"];
    loginC.shopKind = @"便民商户";
    loginC.industry = 2;
    [self.navigationController pushViewController:loginC animated:YES];
    
}
//出行入口
- (IBAction)carAction:(id)sender {
    LoginController *loginC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginController"];
    loginC.shopKind = @"出行车主";
    loginC.industry = 3;
    [self.navigationController pushViewController:loginC animated:YES];
    
}
//新商户入驻
- (IBAction)newShopAction:(id)sender {
    NewMerchantEnterController *eneterC = [[NewMerchantEnterController alloc] initWithNibName:@"NewMerchantEnterController" bundle:nil];
    __weak SelectedShopKindController *weadSelf = self;
    eneterC.backLoginAction = ^(NSString *phone, NSString *password) {
//        weadSelf.passwordText.text = password;
//        weadSelf.nameText.text = phone;
//        [weadSelf loginAction:nil];
    };
    //    RegisterController *registerC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterController"];
    [self.navigationController pushViewController:eneterC animated:YES];
}


#pragma mark - 版本更新
-(void)updateVerison{
    //获得build号：
    NSString *buildStr =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    
    int build= [buildStr intValue];
    NSLog(@"build=====%d",build);
    //代码实现获得应用的Verison号：
    NSString *oldVerison =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    int oldOne=  [[oldVerison substringWithRange:NSMakeRange(0,1)]intValue];
    int oldTwo = [[oldVerison substringWithRange:NSMakeRange(2,1)]intValue];
    int oldThree = [[oldVerison  substringWithRange:NSMakeRange(4,1)]intValue];
    
    //NSLog(@"oldOne----%d\noldTwo----%d\noldThree----%d",oldOne ,oldTwo,oldThree);
    VerisonModel *model = [[VerisonModel alloc]init];
    model.os = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data  = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Version/requestLastVersion" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET  success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
         NSLog(@"检测----%@",response);
        if (baseRes.resultCode == 1) {
            NSDictionary * dic = response[@"data"];
            VerisonModel *model = [VerisonModel yy_modelWithJSON:dic];
            int newOne=  [[model.versionName substringWithRange:NSMakeRange(0,1)]intValue];
            int newTwo = [[model.versionName  substringWithRange:NSMakeRange(2,1)]intValue];
            int newThree = [[model.versionName  substringWithRange:NSMakeRange(4,1)]intValue];
            NSString *newbuildStr;
            if (model.versionName.length>6) {
                newbuildStr =[model.versionName substringFromIndex:6];
                
            }
            int newbuild = [newbuildStr intValue];
            NSLog(@"NewOne----%d\nNewTwo----%d\nNewThree----%d\nnewbuild----%d ",newOne ,newTwo,newThree,newbuild);
            if ([model.isMustUpdate isEqualToString:@"1"]) {
                if (oldOne<newOne) {
                    //强制跟新
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo<newTwo){
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo==newTwo&&oldThree<newThree){
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }
                else if(oldOne==newOne&&oldTwo==newTwo&&oldThree==newThree&&build < newbuild){
                    [weakself addMandatoryAlertAction:model];
                    return;
                }
                else{
                    NSLog(@"休息休息");
                }
                
            }else{
                
                if (oldOne<newOne) {
                    [weakself addAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo<newTwo){
                    [weakself addAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo==newTwo&&oldThree<newThree){
                    [weakself addAlertAction:model];
                    return ;
                }
                else
                    if(oldOne==newOne&&oldTwo==newTwo&&oldThree==newThree && build < newbuild){
                        [weakself addAlertAction:model];
                        return;
                    }
                    else
                    {
                        NSLog(@"不用强制更新");
                        
                    }
                
            }
        }else{
            [weakself showToast:response[@"msg"]];
            
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - 强制更新
-(void)addMandatoryAlertAction:(VerisonModel*)model{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"发现新版本\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, 65, 210, 180)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.text = model.content;
    [alertC.view addSubview:textView];
    __weak typeof(self) weakSelf = self;
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"我要去升级" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //Push 跳转
//        VersionUpViewController * VC = [[VersionUpViewController alloc]init];
//        VC.url = model.url;
        // NSLog(@"我要去升级--%@",VC.url);
       // [weakSelf presentViewController:VC animated:YES completion:nil];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.downloadUrl]];
        [weakSelf addMandatoryAlertAction:model];
        
    }];
    [alertC addAction:OK];
    [self presentViewController:alertC animated:NO completion:nil];
}
#pragma mark - 不强制更新
-(void)addAlertAction:(VerisonModel*)model{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"发现新版本\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, 65, 210, 180)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.text = model.content;
    [alertC.view addSubview:textView];
    __weak typeof(self) weakSelf = self;
    UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"我要去升级" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //Push 跳转
//        VersionUpViewController * VC = [[VersionUpViewController alloc]init];
//        VC.url = model.url;
//        // NSLog(@"我要去升级--%@",VC.url);
//        [weakSelf presentViewController:VC animated:YES completion:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.downloadUrl]];
        
    }];
    [alertC addAction:cancel];
    [alertC addAction:OK];
    [self presentViewController:alertC animated:YES completion:nil];
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

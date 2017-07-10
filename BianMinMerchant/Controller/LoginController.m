//
//  LoginController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"
#import "RequestLogin.h"
#import "LoginResponse.h"
#import "BMShopContentViewController.h"
#import "NewMerchantEnterController.h"
#import <AVFoundation/AVFoundation.h>
#import "TravelHomeVC.h"
#import "BulkHomeVC.h"
#import "ConvenienceHomeVC.h"
@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *selfLoginBtn;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBgHeight;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property(nonatomic,strong)NSString * pushAlias;

//店主店员
@property (nonatomic, assign) NSInteger isEmployee;//0-店主 1-店员

@property (nonatomic, strong) AVAudioPlayer *audioPlay;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation LoginController
//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"登录";
    self.isEmployee = 0;
    self.pushAlias = @"0";
    [self navigationTitleColor:@"#FFFFFF"];
    self.kindLabel.text = self.shopKind;
    if ([self.shopKind isEqualToString:@"出行车主"]) {
        self.viewBgHeight.constant = 0;
        self.viewBg.hidden = YES;
    }
//    NSString *userName = [DWCacheManager getPrivateCacheByKey:kUserName];
//    NSString *password = [DWCacheManager getPrivateCacheByKey:kPassword];
//    if (userName != nil) {
//        self.nameText.text = userName;
//    }
//    
//    if (password != nil) {
//        self.passwordText.text = password;
//    }
    self.selfLoginBtn.selected = NO;
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSNumber *selfLogin = [userD objectForKey:@"selfLogin"];

    if ([self.shopKind isEqualToString:@"团购商户"]) {
        
        
        switch (self.isEmployee) {
            case 0:
            {
                if ([[userD objectForKey:@"TGD"]isEqualToString:@"登录"]) {
                    self.nameText.text = [userD objectForKey:@"TGname"];
                    self.passwordText.text = [userD objectForKey:@"TGpassword"];
                    if (self.nameText.text.length>0) {
                        self.selfLoginBtn.selected = YES;
                       // [self loginAction:nil];

                    }
//                    [self loginAction:nil];
                    
                   
                }else {
                    self.nameText.text = [userD objectForKey:@"TGname"];
                    self.selfLoginBtn.selected = NO;
                }

                
                
                break;
            }
                
            case 1:
            {
                if ([[userD objectForKey:@"TGSD"]isEqualToString:@"登录"]) {
                    self.nameText.text = [userD objectForKey:@"TGSname"];
                    self.passwordText.text = [userD objectForKey:@"TGSpassword"];
                    if (self.nameText.text.length>0) {
                        self.selfLoginBtn.selected = YES;
                        //[self loginAction:nil];

                    }
                }else {
                    self.nameText.text = [userD objectForKey:@"TGSname"];
                    self.selfLoginBtn.selected = NO;
                }
                

                break;
            }
                
            default:{
                
                break;
                
            }
        }

        
        
        
    }else if([self.shopKind isEqualToString:@"便民商户"]){
        
        switch (self.isEmployee) {
            case 0:
            {
                
                if ([[userD objectForKey:@"BMD"]isEqualToString:@"登录"]) {
                    self.nameText.text = [userD objectForKey:@"BMname"];
                    self.passwordText.text = [userD objectForKey:@"BMpassword"];
                    if (self.nameText.text.length>0) {
                        self.selfLoginBtn.selected = YES;
                        //[self loginAction:nil];

                    }
//                    [self loginAction:nil];
                }else {
                    self.nameText.text = [userD objectForKey:@"BMname"];
                    self.selfLoginBtn.selected = NO;
                }
 
                
                break;
            }
                
            case 1:
            {
                if ([[userD objectForKey:@"BMSD"]isEqualToString:@"登录"]) {
                    self.nameText.text = [userD objectForKey:@"BMSname"];
                    self.passwordText.text = [userD objectForKey:@"BMSpassword"];
                    if (self.nameText.text.length>0) {
                        self.selfLoginBtn.selected = YES;
                        //[self loginAction:nil];

                    }
                    //[self loginAction:nil];
                }else {
                    self.nameText.text = [userD objectForKey:@"BMSname"];
                    self.selfLoginBtn.selected = NO;
                }

                break;
            }
                
           
            default:{
                
                break;
                
            }
        }

        
        
        
    }else if([self.shopKind isEqualToString:@"出行车主"]){
        if ([[userD objectForKey:@"CXD"]isEqualToString:@"登录"]) {
            self.nameText.text = [userD objectForKey:@"CXname"];
            self.passwordText.text = [userD objectForKey:@"CXpassword"];
            if (self.nameText.text.length>0) {
                self.selfLoginBtn.selected = YES;
                //[self loginAction:nil];

            }
        }else {
            self.nameText.text = [userD objectForKey:@"CXname"];
            self.selfLoginBtn.selected = NO;
        }

    }else{
        
    }
    
    
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refundAction:) name:@"退出账号" object:nil];
}

- (void)refundAction:(NSNotification *)sender {
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
     //[JPUSHService setAlias:self.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    if ([self.shopKind isEqualToString:@"团购商户"]) {
        switch (self.isEmployee) {
            case 0:
            {
                
               self.nameText.text = [userD objectForKey:@"TGname"];
                self.passwordText.text = [userD objectForKey:@"TGpassword"];
                //[DWCacheManager removegetPrivateCacheByKey:@"TGpassword"];
               // [DWCacheManager setPrivateCache:@"非登录" key:@"TGD"];
                break;
            }
                
            case 1:
            {
                self.nameText.text = [userD objectForKey:@"TGSname"];
                self.passwordText.text = [userD objectForKey:@"TGSpassword"];

//                [DWCacheManager removegetPrivateCacheByKey:@"TGSpassword"];
//                [DWCacheManager setPrivateCache:@"非登录" key:@"TGSD"];
                break;
            }
                
            
            default:{
                
                break;
                
            }
        }

        
    }else if([self.shopKind isEqualToString:@"便民商户"]){
        
        switch (self.isEmployee) {
            case 0:
            {
                
               self.nameText.text = [userD objectForKey:@"BMname"];
                self.passwordText.text = [userD objectForKey:@"BMpassword"];
                //self.selfLoginBtn.selected = NO;
//               [DWCacheManager removegetPrivateCacheByKey:@"BMpassword"];
//                [DWCacheManager setPrivateCache:@"非登录" key:@"BMD"];
                break;
            }
                
            case 1:
            {
                self.nameText.text = [userD objectForKey:@"BMSname"];
                self.passwordText.text = [userD objectForKey:@"BMSpassword"];

//                [DWCacheManager removegetPrivateCacheByKey:@"BMSpassword"];
//                [DWCacheManager setPrivateCache:@"非登录" key:@"BMSD"];
                break;
            }
                
                
            default:{
                
                break;
                
            }
        }

    }else if([self.shopKind isEqualToString:@"出行车主"]){
         self.nameText.text = [userD objectForKey:@"CXname"];
        self.passwordText.text = [userD objectForKey:@"CXpassword"];

//        [DWCacheManager setPrivateCache:@"非登录" key:@"CXD"];
//        [DWCacheManager removegetPrivateCacheByKey:@"CXpassword"];
    }else{
        
    }
    
}

- (IBAction)loginAction:(id)sender {
    
//    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"p_foot3" ofType:@"m4a"];
//    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
//    self.player = [[AVPlayer alloc] initWithURL:audioUrl];
//    [_player setVolume:1];
//    [_player play];
//    
    if (![self.nameText.text isPhoneNumber]) {
        [self  showToast:@"请输入正确的手机号"];
        return;
    }
    if (self.passwordText.text.length<6||self.passwordText.text.length>16) {
        [self  showToast:@"请输入正确的密码"];
        return;
    }
    RequestLogin *requestLogin = [[RequestLogin alloc] init];
    requestLogin.mobile = self.nameText.text;
    requestLogin.password = self.passwordText.text;
    requestLogin.industry = self.industry;
    requestLogin.isEmployee = self.isEmployee;
    
    BaseRequest *baseRequest = [[BaseRequest alloc] init];
    baseRequest.encryptionType = RequestMD5;
    baseRequest.data = requestLogin;
    self.view.userInteractionEnabled= NO;
    [self showProgress];

    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseRequest yy_modelToJSONString] act:@"act=MerApi/Login/requestLogin" sign:[[baseRequest.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        LoginResponse *loginRes = [LoginResponse yy_modelWithJSON:baseRes.data];
        if (baseRes.resultCode == 1) {
            NSString *pushAlias
            =baseRes.data[@"pushAlias"];
            if (pushAlias.length>0) {
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:baseRes.data[@"pushAlias"] forKey:@"pushAlias"]];
            }
           
            
            //weakSelf. pushAlias =baseRes.data[@"pushAlias"];
            
            
            NSLog(@"登录---%@",response);
            [weakSelf.view endEditing:YES];
            weakSelf.view.userInteractionEnabled= YES;

            if (!weakSelf.selfLoginBtn.selected) {
                weakSelf.selfLoginBtn.selected = NO;
                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                [userD setObject:@(0) forKey:@"selfLogin"];
            }else {
                weakSelf.selfLoginBtn.selected = YES;
                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                [userD setObject:@(1) forKey:@"selfLogin"];
            }
            DWHelper *helper = [DWHelper shareHelper];
            helper.isLoginType = loginRes.isEmployee;
            
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            [userD setObject:loginRes.token forKey:@"loginToken"];
            [userD setObject:loginRes.key forKey:@"loginKey"];
            
            if ([weakSelf.shopKind isEqualToString:@"团购商户"]) {
                
                switch (weakSelf.isEmployee) {
                    case 0:
                    {
                        
                        [DWCacheManager setPrivateCache:weakSelf.nameText.text key:@"TGname"];
                        
                        if ([[userD objectForKey:@"TGD"]isEqualToString:@"登录"]) {
                        [DWCacheManager setPrivateCache:weakSelf.passwordText.text key:@"TGpassword"];
                        }else{
                            [DWCacheManager setPrivateCache:@"" key:@"TGpassword"];
                        }
                        
                        
                        
                        break;
                    }
                        
                    case 1:
                    {
                        [DWCacheManager setPrivateCache:weakSelf.nameText.text key:@"TGSname"];
                        if ([[userD objectForKey:@"TGSD"]isEqualToString:@"登录"]) {
                            [DWCacheManager setPrivateCache:weakSelf.passwordText.text key:@"TGSpassword"];
                        }else{
                                                        [DWCacheManager setPrivateCache:@"" key:@"TGSpassword"];
                        }

                       
                        break;
                    }
                        
                    
                        
                    default:{
                        
                        break;
                        
                    }
                }

                
                
            }else if([weakSelf.shopKind isEqualToString:@"便民商户"]){
                switch (weakSelf.isEmployee) {
                    case 0:
                    {
                        
                        [DWCacheManager setPrivateCache:weakSelf.nameText.text key:@"BMname"];
                        if ([[userD objectForKey:@"BMD"]isEqualToString:@"登录"]) {
                           [DWCacheManager setPrivateCache:weakSelf.passwordText.text key:@"BMpassword"];
                        }else{
                             [DWCacheManager setPrivateCache:@"" key:@"BMpassword"];
                        }
                        
                        
                        
                        break;
                    }
                        
                    case 1:
                    {
                        [DWCacheManager setPrivateCache:weakSelf.nameText.text key:@"BMSname"];
                        
                        if ([[userD objectForKey:@"BMSD"]isEqualToString:@"登录"]) {
                           [DWCacheManager setPrivateCache:weakSelf.passwordText.text key:@"BMSpassword"];
                        }else{
                            [DWCacheManager setPrivateCache:@"" key:@"BMSpassword"];
                        }
                        break;
                    }
                        
                        
                        
                    default:{
                        
                        break;
                        
                    }
                }

               
            }else if([weakSelf.shopKind isEqualToString:@"出行车主"]){
                [DWCacheManager setPrivateCache:weakSelf.nameText.text key:@"CXname"];
                if ([[userD objectForKey:@"CXD"]isEqualToString:@"登录"]) {
                    [DWCacheManager setPrivateCache:weakSelf.passwordText.text key:@"CXpassword"];

                }else{
                    [DWCacheManager setPrivateCache:@""key:@"CXpassword"];
                }
                
            }else{
                
            }

            
            [weakSelf hideProgress];
            helper.shopType = loginRes.merchantType;
            if (loginRes.merchantType == 2) {
//                BMShopContentViewController *BMShop = [[BMShopContentViewController alloc] init];
//                [self.navigationController pushViewController:BMShop animated:YES];
                //Push 跳转
                ConvenienceHomeVC * VC = [[ConvenienceHomeVC alloc]initWithNibName:@"ConvenienceHomeVC" bundle:nil];
                [weakSelf.navigationController  pushViewController:VC animated:YES];

                
            }else if(loginRes.merchantType == 1) {
//                ShopViewController *shopC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShopViewController"];
//                [self.navigationController pushViewController:shopC animated:YES];
                //Push 跳转
                BulkHomeVC * VC = [[BulkHomeVC alloc]initWithNibName:@"BulkHomeVC" bundle:nil];
                [weakSelf.navigationController  pushViewController:VC animated:YES];

            }else if(loginRes.merchantType == 3) {
                //Push 跳转
                TravelHomeVC * VC = [[TravelHomeVC alloc]initWithNibName:@"TravelHomeVC" bundle:nil];
                [weakSelf.navigationController  pushViewController:VC animated:YES];
            }
        }else {
            [weakSelf hideProgress];
            weakSelf.view.userInteractionEnabled= YES;
            [weakSelf showToast:baseRes.msg];
//            [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        weakSelf.view.userInteractionEnabled= YES;
        [weakSelf hideProgress];
    }];
}


- (IBAction)selfLoginAction:(id)sender {
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    UIButton *btn = sender;
    if (btn.selected) {
        btn.selected = NO;
        
        if ([self.shopKind isEqualToString:@"团购商户"]) {
            
            switch (self.isEmployee) {
                case 0:
                {
                    
                    [DWCacheManager setPrivateCache:@"非登录" key:@"TGD"];
//                    [DWCacheManager removegetPrivateCacheByKey:@"TGpassword"];
                     //self.passwordText.text = [userD objectForKey:@"TGpassword"];
                    
                    
                    break;
                }
                    
                case 1:
                {
                    [DWCacheManager setPrivateCache:@"非登录" key:@"TGSD"];
//                    [DWCacheManager removegetPrivateCacheByKey:@"TGSpassword"];
                    //self.passwordText.text = [userD objectForKey:@"TGSpassword"];
                    break;
                }
                    
                    
                    
                default:{
                    
                    break;
                    
                }
            }
            
            
            
        }else if([self.shopKind isEqualToString:@"便民商户"]){
            switch (self.isEmployee) {
                case 0:
                {
                    
                    [DWCacheManager setPrivateCache:@"非登录" key:@"BMD"];
//                    [DWCacheManager removegetPrivateCacheByKey:@"BMpassword"];

                   //self.passwordText.text = [userD objectForKey:@"BMpassword"];
                    
                    break;
                }
                    
                case 1:
                {
                    [DWCacheManager setPrivateCache:@"非登录" key:@"BMSD"];
//                    [DWCacheManager removegetPrivateCacheByKey:@"BMSpassword"];

                    //self.passwordText.text = [userD objectForKey:@"BMSpassword"];
                    break;
                }
                    
                    
                    
                default:{
                    
                    break;
                    
                }
            }
            
            
        }else if([self.shopKind isEqualToString:@"出行车主"]){
            
            [DWCacheManager setPrivateCache:@"非登录" key:@"CXD"];
//            [DWCacheManager removegetPrivateCacheByKey:@"CXpassword"];
            //self.passwordText.text = [userD objectForKey:@"CXpassword"];

            
            
            
        }else{
            
        }

        
        
    }else {
        btn.selected = YES;
        
       
        
        
        if ([self.shopKind isEqualToString:@"团购商户"]) {
            
            switch (self.isEmployee) {
                case 0:
                {
                    
                    [DWCacheManager setPrivateCache:@"登录" key:@"TGD"];
                    
                   // self.passwordText.text = [userD objectForKey:@"TGpassword"];
                    
                    break;
                }
                    
                case 1:
                {
                    
                    [DWCacheManager setPrivateCache:@"登录" key:@"TGSD"];
                    //self.passwordText.text = [userD objectForKey:@"TGSpassword"];
                    break;
                }
                    
                    
                    
                default:{
                    
                    break;
                    
                }
            }
            
            
            
        }else if([self.shopKind isEqualToString:@"便民商户"]){
            switch (self.isEmployee) {
                case 0:
                {
                    
                    [DWCacheManager setPrivateCache:@"登录" key:@"BMD"];
                    
                    //self.passwordText.text = [userD objectForKey:@"BMpassword"];
                    
                    break;
                }
                    
                case 1:
                {
                    
                    [DWCacheManager setPrivateCache:@"登录" key:@"BMSD"];
                    //self.passwordText.text = [userD objectForKey:@"BMSpassword"];
                    break;
                }
                    
                    
                    
                default:{
                    
                    break;
                    
                }
            }
            
            
        }else if([self.shopKind isEqualToString:@"出行车主"]){
            
            [DWCacheManager setPrivateCache:@"登录" key:@"CXD"];
            //self.passwordText.text = [userD objectForKey:@"CXpassword"];
            
            
            
            
        }else{
            
        }

    }
    

}
- (IBAction)registerAction:(id)sender {
    NewMerchantEnterController *eneterC = [[NewMerchantEnterController alloc] initWithNibName:@"NewMerchantEnterController" bundle:nil];
    __weak LoginController *weadSelf = self;
    eneterC.backLoginAction = ^(NSString *phone, NSString *password) {
        weadSelf.passwordText.text = password;
        weadSelf.nameText.text = phone;
        [weadSelf loginAction:nil];
    };
//    RegisterController *registerC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterController"];
    [self.navigationController pushViewController:eneterC animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.registerBtn.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.registerBtn.layer.borderWidth = 1;
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 3;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//店主
- (IBAction)firstShop:(id)sender {
    self.isEmployee = 0;
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    if ([self.shopKind isEqualToString:@"团购商户"]) {
    self.nameText.text = [userD objectForKey:@"TGname"];
        
        if ([[userD objectForKey:@"TGD"] isEqualToString:@"非登录"]) {
            self.selfLoginBtn.selected = NO;
            self.passwordText.text = @"";
            

        }else if ([[userD objectForKey:@"TGD"] isEqualToString:@"登录"]){
            self.selfLoginBtn.selected = YES;
            self.passwordText.text = [userD objectForKey:@"TGpassword"];
            

        }else{
            self.passwordText.text =@"";
            self.selfLoginBtn.selected = NO;

        }
       
        
    }else if([self.shopKind isEqualToString:@"便民商户"]){
      self.nameText.text = [userD objectForKey:@"BMname"];
        if ([[userD objectForKey:@"BMD"] isEqualToString:@"非登录"]) {
            self.selfLoginBtn.selected = NO;
            self.passwordText.text = @"";
            

        }else  if ([[userD objectForKey:@"BMD"] isEqualToString:@"登录"]){
            self.selfLoginBtn.selected = YES;
            self.passwordText.text = [userD objectForKey:@"BMpassword"];
            

        }else{
            self.passwordText.text =@"";
            self.selfLoginBtn.selected = NO;
            
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake(0, 49, Width/2, 1);
    }];
}
//店员
- (IBAction)secondShop:(id)sender {
    self.isEmployee = 1;
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    if ([self.shopKind isEqualToString:@"团购商户"]) {
        self.nameText.text = [userD objectForKey:@"TGSname"];
        if ([[userD objectForKey:@"TGSD"] isEqualToString:@"非登录"]) {
            self.selfLoginBtn.selected = NO;
            self.passwordText.text = @"";
        }else if ([[userD objectForKey:@"TGSD"] isEqualToString:@"登录"]) {
            self.selfLoginBtn.selected = YES;
            self.passwordText.text = [userD objectForKey:@"TGSpassword"];
        }else{
            self.passwordText.text =@"";
            self.selfLoginBtn.selected = NO;
        }
    }else if([self.shopKind isEqualToString:@"便民商户"]){
        self.nameText.text = [userD objectForKey:@"BMSname"];
        if ([[userD objectForKey:@"BMSD"] isEqualToString:@"非登录"]) {
            self.selfLoginBtn.selected = NO;
            self.passwordText.text = @"";
        }else  if([[userD objectForKey:@"BMSD"] isEqualToString:@"登录"]) {
            self.selfLoginBtn.selected = YES;
            self.passwordText.text = [userD objectForKey:@"BMSpassword"];
        }else{
            self.passwordText.text =@"";
            self.selfLoginBtn.selected = NO;

        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake(Width/2, 49, Width/2, 1);
    }];
}


#pragma mark - 推送别名
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    
    if (iResCode == 0) {
    
    }
    if (iResCode == 6002) {
        [JPUSHService setAlias:self.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    NSLog(@"push set alias success alisa = %@", alias);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}


@end

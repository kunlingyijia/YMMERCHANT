//
//  BaseViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
@interface BaseViewController ()
@property(nonatomic,strong)UIView * baseBottomView;
@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.view.userInteractionEnabled = YES;
    //去掉底部黑线
    UIImageView *navBarHairlineImageView;
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
   // [self.view endEditing:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.navigationController.navigationBar.tintColor  = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kNavigationBgColor];
    //设置导航条标题为白色
    [self navigationTitleColor:@"ffffff"];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}
- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"btn_common_zhaohuimima_left_jiantou-拷贝"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showBackBtn:(ObjectBack)Back{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"btn_common_zhaohuimima_left_jiantou-拷贝"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBlockBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
#pragma mark ----- 屏幕边缘平移手势
    
//    //屏幕边缘移动手势
//    //创建屏幕边缘平移手势
//    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(doBlockBack:)];
//    
//    //设置平移的屏幕边界
//    
//    screenEdgePanGesture.edges = UIRectEdgeLeft;
//    //添加到视图
//    
//    [self.view addGestureRecognizer:screenEdgePanGesture];
    self.Back = Back;
}


- (void)doBlockBack:(id)sender{
    self.Back();
}
- (void)showRightBtnTitle:(NSString*)title Image:(NSString*)Image RightBtn:(ObjectBack)RightBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];

    [backBtn setImage:Image ==nil ?nil :[UIImage imageNamed:Image] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn setTitle:title forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(doBlockRightBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    //self.navigationController.navigationBar.translucent = NO;
#pragma mark ----- 屏幕边缘平移手势
    
    //    //屏幕边缘移动手势
    //    //创建屏幕边缘平移手势
    //    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(doBlockBack:)];
    //
    //    //设置平移的屏幕边界
    //
    //    screenEdgePanGesture.edges = UIRectEdgeLeft;
    //    //添加到视图
    //
    //    [self.view addGestureRecognizer:screenEdgePanGesture];
    self.RightBack = RightBtn;

    
}
- (void)doBlockRightBack:(id)sender{
    self.RightBack();
}

//回收键盘
- (void)endEditingAction:(UIView *)endView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endtapAction:)];
    [endView addGestureRecognizer:tap];
}

- (void)endtapAction:(UITapGestureRecognizer *)sender {
    UIView *endV = sender.view;
    [endV endEditing:YES];
}

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self.textName resignFirstResponder];
    //[self.textSummary resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)navigationTitleColor:(NSString *)colorStr {
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:colorStr], NSFontAttributeName:[UIFont systemFontOfSize:18]};
}

- (void)showSuccessWith:(NSString *)str {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showToast:str];
    });
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
//加载网络图片
- (void)loadImageWithView:(UIImageView *)imageV urlStr:(NSString *)urlStr {

    [imageV sd_setImageWithURL:[NSURL URLWithString:urlStr]];

    
}

- (void)initWithDefaultProgressHub{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

- (void)showProgress{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //加载时不允许 用户交互
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)showProgressWithText:(NSString *)text{
    [SVProgressHUD showWithStatus:text];
}

- (void)hideProgress{
    [SVProgressHUD dismiss];
}

- (void)showSucessProgress{
    [SVProgressHUD showInfoWithStatus:@"成功！"];
}

- (void)showSucessProgressWithText:(NSString *)text{
    [SVProgressHUD showInfoWithStatus:text];
}

- (void)showErrorProgress{
    [SVProgressHUD showErrorWithStatus:@"失败"];
}

- (void)showErrorProgressWithText:(NSString *)text{
    [SVProgressHUD showErrorWithStatus:text];
}

- (void)showToast:(NSString *)text{
    [self.view hideToastActivity];
    [self.view makeToast:text duration:1.5 position:CSToastPositionCenter];
}
#pragma mark - 显示
-(void)ShowNodataView{
    if (!_baseBottomView) {
        __weak typeof(self) weakSelf = self;
        self.baseBottomView = [[UIView alloc]initWithFrame:CGRectZero];
        [UIView animateWithDuration:0.0000001 animations:^{
            weakSelf.baseBottomView.frame =  CGRectMake(0, 0, Width, Height);
            self.baseBottomView.backgroundColor = [UIColor colorWithHexString:kViewBg];
            [self.view addSubview:_baseBottomView];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
            imageView.image = [UIImage imageNamed:@"暂无数据"];
            imageView.contentMode =  UIViewContentModeCenter;
            imageView.clipsToBounds  = YES;
            [_baseBottomView addSubview:imageView];
        } ];
        
        
    }
}
#pragma mark - 移除
-(void)HiddenNodataView{
    
    if (_baseBottomView) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            [_baseBottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            weakSelf.baseBottomView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            [weakSelf.baseBottomView removeFromSuperview];
            weakSelf.baseBottomView = nil;
            
        }];
        
    }
    
}




#pragma mark - 取消确定 --居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultaction (action);
        
        
    }];
    // [OK setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        cancelaction (action);
    }];
     //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    [alertC addAction:OK];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
}
#pragma mark - 单个确定 居下
-(void)alertSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle   withOKDefault:(OKDefault)defaultaction{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        defaultaction (action);
    }];
     //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark -  单个确定 居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle   withOKDefault:(OKDefault)defaultaction{
    
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        defaultaction (action);
    }];
    //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark - 取消-确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultaction (action);
        
        
    }];
    //[OK setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        cancelaction (action);
    }];
    //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];

    [alertC addAction:OK];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark - 取消-确定-确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitleOne:(NSString*)OKtitleOne OKWithTitleTwo:(NSString*)OKtitleTwo  CancelWithTitle:(NSString*)Canceltitle withOKDefaultOne:(OKDefault)defaultactionOne withOKDefaultTwo:(OKDefault)defaultactionTwo withCancel:(Cancel)cancelaction{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * OKOne = [UIAlertAction actionWithTitle:OKtitleOne style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionOne (action);
        
        
    }];
    //[OKOne setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction * OKTwo = [UIAlertAction actionWithTitle:OKtitleTwo style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionTwo (action);
        
        
    }];
    //[OKTwo setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        cancelaction (action);
    }];
    //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    [alertC addAction:OKOne];
    [alertC addAction:OKTwo];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}


#pragma mark - 取消-确定-确定 -确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitleOne:(NSString*)OKtitleOne OKWithTitleTwo:(NSString*)OKtitleTwo OKWithTitleThree:(NSString*)OKtitleThree  CancelWithTitle:(NSString*)Canceltitle withOKDefaultOne:(OKDefault)defaultactionOne withOKDefaultTwo:(OKDefault)defaultactionTwo withOKDefaultThree:(OKDefault)defaultactionThree withCancel:(Cancel)cancelaction{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * OKOne = [UIAlertAction actionWithTitle:OKtitleOne style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionOne (action);
        
        
    }];
    //[OKOne setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction * OKTwo = [UIAlertAction actionWithTitle:OKtitleTwo style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionTwo (action);
        
        
    }];
    //[OKTwo setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    UIAlertAction * OKThree = [UIAlertAction actionWithTitle:OKtitleThree style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionThree (action);
        
        
    }];
    //[OKThree setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        cancelaction (action);
    }];
    //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    [alertC addAction:OKOne];
    [alertC addAction:OKTwo];
    [alertC addAction:OKThree];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}



@end

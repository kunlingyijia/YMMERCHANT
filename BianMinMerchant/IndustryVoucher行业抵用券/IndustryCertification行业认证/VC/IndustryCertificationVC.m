//
//  IndustryCertificationVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryCertificationVC.h"
@interface IndustryCertificationVC ()<UIWebViewDelegate>
///警示View
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BtnViewConstraint;
@end
@implementation IndustryCertificationVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    [self SET_DATA];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"行业抵用券";
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
}
#pragma mark - 关于数据
-(void)SET_DATA{
     DWHelper* helper = [DWHelper shareHelper];
    ///开通行业抵用券  1-未开通, 2-开通中,3-已开通, 4-开通失败, 5-暂停业务
    if ([helper.shopModel.industryCouponStatus isEqualToString:@"1"]) {
         _BtnViewConstraint.constant = Width*0.2;
        _warningView.hidden = YES;
         [_submitBtn setTitle:@"立即开通" forState:0];
    }else if ([helper.shopModel.industryCouponStatus isEqualToString:@"3"]) {
        _BtnViewConstraint.constant = Width*0.2;
        _warningView.hidden = NO;
        _imageView.image = [UIImage imageNamed:@"失败-审核"];
        _industryCouponRefuseReason.text = helper.shopModel.industryCouponRefuseReason;
        [_submitBtn setTitle:@"重新开通" forState:0];
    } else if ([helper.shopModel.industryCouponStatus isEqualToString:@"2"]) {
        _imageView.image = [UIImage imageNamed:@"审核中"];
        _industryCouponRefuseReason.text = @"资料审核中,请耐心等待";
        _BtnViewConstraint.constant = 0.00;
        _warningView.hidden = NO;
        [_submitBtn setTitle:@"立即开通" forState:0];
    }
    NSLog(@"helper.configModel.industryCouponUrl--%@",helper.configModel.industryCouponUrl);
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:helper.configModel.industryCouponUrl]]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
   // [[LoadWaitSingle shareManager] hideLoadWaitView];
    // 将商品详情界面图片等比例缩小至屏幕 JS
//    NSString *smallImagesJS = @"var count = document.images.length;\
//    for (var i = 0; i < count; i++) {\
//    var image = document.images[i];\
//    image.style.width='100%%';\
//    image.style.height = 'auto';\
//    };";
//    [webView stringByEvaluatingJavaScriptFromString:smallImagesJS];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
     NSString *js=@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = %f;"
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = %f;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);";
     js=[NSString stringWithFormat:js,Width,Width];
     [webView stringByEvaluatingJavaScriptFromString:js];
     [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [SVProgressHUD showErrorWithStatus:@"网络无法连接"];
//    [[LoadWaitSingle shareManager] hideLoadWaitView];
}
#pragma mark - 提交
- (IBAction)submitBtn:(PublicBtn *)sender {
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/IndustryCouponApply/requestApplyIndustryCoupon" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@" 发布行业抵用券----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                DWHelper* helper = [DWHelper shareHelper];
                ///开通行业抵用券  1-未开通, 2-开通中,3-已开通, 4-开通失败, 5-暂停业务
                NSString * industryCouponStatus = [NSString stringWithFormat:@"%@", response[@"data"][@"industryCouponStatus"]];
                helper.shopModel.industryCouponStatus =industryCouponStatus
                ;
                helper.shopModel.industryCouponRefuseReason =response[@"data"][@"industryCouponRefuseReason"];
                ;
                ///开通行业抵用券  1-未开通, 2-开通中,3-已开通, 4-开通失败, 5-暂停业务
                if ([helper.shopModel.industryCouponStatus isEqualToString:@"1"]) {
                    _BtnViewConstraint.constant = Width*0.2;
                    _warningView.hidden = YES;
                    [_submitBtn setTitle:@"立即开通" forState:0];
                }else if ([helper.shopModel.industryCouponStatus isEqualToString:@"3"]) {
                    _BtnViewConstraint.constant = Width*0.2;
                    _warningView.hidden = NO;
                    _imageView.image = [UIImage imageNamed:@"失败-审核"];
                    _industryCouponRefuseReason.text = helper.shopModel.industryCouponRefuseReason;
                    [_submitBtn setTitle:@"重新开通" forState:0];
                } else if ([helper.shopModel.industryCouponStatus isEqualToString:@"2"]) {
                    _imageView.image = [UIImage imageNamed:@"审核中"];
                    _industryCouponRefuseReason.text = @"资料审核中,请耐心等待";
                    _BtnViewConstraint.constant = 0.00;
                    _warningView.hidden = NO;
                    [_submitBtn setTitle:@"立即开通" forState:0];
                }
                weakself.view.userInteractionEnabled = YES;
            }else{
                weakself.view.userInteractionEnabled = YES;
                [weakself showToast:response[@"msg"]];
            }
        } faild:^(id error) {
            weakself.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{  [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@销毁了", [self class]);
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

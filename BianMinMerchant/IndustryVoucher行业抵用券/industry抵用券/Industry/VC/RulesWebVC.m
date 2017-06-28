//
//  RulesWebVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "RulesWebVC.h"

@interface RulesWebVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation RulesWebVC

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
    self.title = @"规则";
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    DWHelper* helper = [DWHelper shareHelper];
     [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:helper.configModel.industryCouponExplainUrl]]];
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
    //[SVProgressHUD showErrorWithStatus:@"网络无法连接"];
    //    [[LoadWaitSingle shareManager] hideLoadWaitView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

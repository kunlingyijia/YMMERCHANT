//
//  WelcomePageViewController.m
//  BianMinMerchant
//
//  Created by 月美 刘 on 16/7/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "WelcomePageViewController.h"
#import "LoginController.h"


@interface WelcomePageViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation WelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*3, self.view.bounds.size.height);
    [self.view addSubview:self.scrollView];
    
    for (int i = 0;i < 3 ; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.frame.size.height)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"WelcomePage%d.jpg",i+1]];
        [self.scrollView addSubview:iv];
    }
}

//欢迎页跳转至登录页面
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"%f", offset.x);
//    
//    if (Bounds.size.width==2) {
//        
//
//        WelcomePageViewController *welcomeC = [[[UIViewController alloc] init];
//        
//        WelcomePageViewController *welcomeC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WelcomePageViewController"];
//        
//        
//        [self.navigationController pushViewController:welcomeC animated:YES];
//        [welcomeC release];
//    }
    
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

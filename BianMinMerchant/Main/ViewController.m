//
//  ViewController.m
//  BianMinMerchant
//
//  Created by 月美 刘 on 16/7/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


//
//  AboutUS.m
//  BianMin
//
//  Created by z on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AboutUS.h"
#import "DWTools.h"
#import "NSString+DWString.h"
@implementation AboutUS

- (void)viewDidLoad{
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"关于我们";
    [self initCustomView];
}

- (void)initCustomView{
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width/5, Width/5)];
    logoView.center = CGPointMake(Bounds.size.width / 2, 144);
    logoView.image = [UIImage imageNamed:@"512商户"];
    [self.view addSubview:logoView];
    
    UILabel *verionInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoView.frame.size.height + logoView.frame.origin.y+20, Bounds.size.width, 30)];
    verionInfoLabel.backgroundColor = [UIColor clearColor];
    
    //代码实现获得应用的Verison号：
    NSString *oldVerison =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //获得build号：
    NSString *build =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    NSLog(@"build=====%@",build);
    verionInfoLabel.text =[NSString stringWithFormat: @"For iPhone V%@ bulid%@",oldVerison,build];
    
    
    
    
    
    
    //verionInfoLabel.text = [NSString stringWithFormat:@"v%@版本", [DWTools getXKVersion]];
    verionInfoLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    verionInfoLabel.textAlignment = NSTextAlignmentCenter;
    verionInfoLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:verionInfoLabel];

    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, verionInfoLabel.frame.size.height + verionInfoLabel.frame.origin.y + 30, Bounds.size.width, 30)];
    companyTitle.backgroundColor = [UIColor clearColor];
    companyTitle.text = @"";
    companyTitle.textColor = [UIColor blackColor];
    companyTitle.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:companyTitle];
    
    
    float textWidth = Bounds.size.width - 40;
    UILabel *companyInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, companyTitle.frame.size.height + companyTitle.frame.origin.y, textWidth, 0)];
    companyInfo.backgroundColor = [UIColor clearColor];
    UIFont *font = [UIFont systemFontOfSize:12];
    NSString *text = @"";
    float height = [text getTextHeightWithFont:font withMaxWith:textWidth];
    companyInfo.text = text;
    companyInfo.frame = CGRectMake(20, companyTitle.frame.size.height + companyTitle.frame.origin.y, textWidth, height);
    companyInfo.numberOfLines = 0;
    companyInfo.textColor = [UIColor colorWithHexString:kSubTitleColor];
    companyInfo.font = font;
    [self.view addSubview:companyInfo];
    
    UITextView *copyRightLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, Bounds.size.height - 40, Bounds.size.width, 30)];
    copyRightLabel.backgroundColor = [UIColor clearColor];
    copyRightLabel.text = @"@2016 bmin.wang All Rights Reserved";
    copyRightLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    copyRightLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:copyRightLabel];
}

@end

//
//  TraveHomeTwoHeader.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/4/18.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TraveHomeTwoHeader.h"

@implementation TraveHomeTwoHeader

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubviews];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubviews];
        
        
    }
    return self;
}
-(void)addSubviews{
    self.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.userInteractionEnabled = YES;
    UIButton* leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftBtn.frame = CGRectMake(1, 1, (Width-4)/3, Width*0.12-2);
    leftBtn.backgroundColor = [UIColor whiteColor];
    [leftBtn setTitle:@"未发布" forState:(UIControlStateNormal)];
    
[leftBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(BtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    leftBtn.tag = 280;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:leftBtn];
    
    
    
    UIButton* middleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    middleBtn.frame = CGRectMake(CGRectGetMaxX(leftBtn.frame)+1, 1, (Width-4)/3, Width*0.12-2);
    middleBtn.backgroundColor = [UIColor whiteColor];
    [middleBtn setTitle:@"进行中" forState:(UIControlStateNormal)];
    
  [middleBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [middleBtn addTarget:self action:@selector(BtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:middleBtn];
    
    middleBtn.tag =281;
    middleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:middleBtn];
    UIButton* rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBtn.backgroundColor = [UIColor whiteColor];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(middleBtn.frame)+1, 1, (Width-4)/3, Width*0.12-2);    //
    [rightBtn setTitle:@"已完成" forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(BtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    rightBtn.tag =282;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:rightBtn];
    

}

-(void)BtnAction:(UIButton*)sender{
    for (UIButton *btn in sender.superview.subviews) {
        if (btn.tag ==sender.tag) {
          [btn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:(UIControlStateNormal)];
        }else{
          [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        }
    }
    //self.TraveHomeTwoHeaderBlock(280-sender.tag);
    
    
}

@end

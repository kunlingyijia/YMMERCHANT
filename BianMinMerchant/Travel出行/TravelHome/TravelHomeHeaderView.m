//
//  TravelHomeHeaderView.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelHomeHeaderView.h"

@implementation TravelHomeHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=  [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        self.contentView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}
-(void)addSubviews{
    self.leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _leftBtn.frame = CGRectMake(10, 20, 40, 40);
    _leftBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_leftBtn];
    
     self.title = [[UILabel alloc]initWithFrame:CGRectMake((Width-200)/2, 20, 200, 40)];
    self.title.text = @"出行";
    self.title.font = [UIFont systemFontOfSize:17];
    self.title.textColor = [UIColor whiteColor];
    self.title.textAlignment =NSTextAlignmentCenter;
     [self.contentView addSubview:_title];
    self.RightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _RightBtn.frame = CGRectMake(Width-50, 20, 40, 40);
    _RightBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_RightBtn];

}
@end

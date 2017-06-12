//
//  TravelHomeHeaderView.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelHomeHeaderView.h"

@implementation TravelHomeHeaderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
        self.userInteractionEnabled = YES;
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
    self.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.userInteractionEnabled = YES;

    self.leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _leftBtn.frame = CGRectMake(10, 20, 40, 40);
    //_leftBtn.backgroundColor = [UIColor redColor];
    
    [_leftBtn setImage:[UIImage imageNamed:@"二维码扫描"] forState:(UIControlStateNormal)];
    [self addSubview:_leftBtn];
    
    self.title = [[UILabel alloc]initWithFrame:CGRectMake((Width-200)/2, 20, 200, 40)];
    self.title.text = @"";
    self.title.font = [UIFont systemFontOfSize:17];
    self.title.textColor = [UIColor whiteColor];
    self.title.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.title.textAlignment =NSTextAlignmentCenter;
    [self addSubview:_title];
    
    
    
    self.RightTwoBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    // self.RightTwoBtn.backgroundColor = [UIColor yellowColor];
    _RightTwoBtn.frame = CGRectMake(Width-80, 20, 30, 40);
    _RightTwoBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_RightTwoBtn setImageEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
    [_RightTwoBtn setImage:[UIImage imageNamed:@"易民-消息"] forState:(UIControlStateNormal)];
    [self addSubview:_RightTwoBtn];

    
    self.RightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _RightBtn.frame = CGRectMake(Width-40, 20, 30, 40);
   // self.RightBtn.backgroundColor = [UIColor redColor];
    _RightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_RightBtn setImageEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
    [_RightBtn setImage:[UIImage imageNamed:@"icon_my_shezhi"] forState:(UIControlStateNormal)];
    [self addSubview:_RightBtn];
    
}
//- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self=  [super initWithCoder:aDecoder];
//    if (self) {
//        [self addSubviews];
//        self.contentView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
//        self.userInteractionEnabled = YES;
//        
//    }
//    return self;
//
//}
//-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
//    self=  [super initWithReuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self addSubviews];
//        self.contentView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
//        self.userInteractionEnabled = YES;
//        
//    }
//    return self;
//}
//-(void)addSubviews{
//    self.leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _leftBtn.frame = CGRectMake(10, 20, 40, 40);
//    //_leftBtn.backgroundColor = [UIColor redColor];
//    
//    [_leftBtn setImage:[UIImage imageNamed:@"二维码扫描"] forState:(UIControlStateNormal)];
//    [self.contentView addSubview:_leftBtn];
//    
//     self.title = [[UILabel alloc]initWithFrame:CGRectMake((Width-200)/2, 20, 200, 40)];
//    self.title.text = @"";
//    self.title.font = [UIFont systemFontOfSize:17];
//    self.title.textColor = [UIColor whiteColor];
//    self.title.textAlignment =NSTextAlignmentCenter;
//     [self.contentView addSubview:_title];
//    self.RightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _RightBtn.frame = CGRectMake(Width-50, 20, 40, 40);
//    _RightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [_RightBtn setImageEdgeInsets:UIEdgeInsetsMake(0,20, 0, 0)];
//    [_RightBtn setImage:[UIImage imageNamed:@"icon_my_shezhi"] forState:(UIControlStateNormal)];
//    [self.contentView addSubview:_RightBtn];
//
//}
@end

//
//  TravelSetHeaderView.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/19.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelSetHeaderView.h"

@implementation TravelSetHeaderView
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
        self.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}
-(void)addSubviews{
    self.leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _leftBtn.frame = CGRectMake(15, 20, 40, 40);
    //_leftBtn.backgroundColor = [UIColor redColor];
    [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [_leftBtn setImage:[UIImage imageNamed:@"btn_common_zhaohuimima_left_jiantou-拷贝"] forState:UIControlStateNormal];
    _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_leftBtn];
    
    self.title = [[UILabel alloc]initWithFrame:CGRectMake((Width-200)/2, 20, 200, 40)];
    self.title.text = @"更多";
    self.title.font = [UIFont systemFontOfSize:17];
    self.title.textColor = [UIColor whiteColor];
    self.title.textAlignment =NSTextAlignmentCenter;
    [self addSubview:_title];
    self.RightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _RightBtn.frame = CGRectMake(Width-50, 20, 40, 40);
    [_RightBtn setImage:[UIImage imageNamed:@"消息"] forState:(UIControlStateNormal)];
    //[self.contentView addSubview:_RightBtn];
    
}

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
//    _leftBtn.frame = CGRectMake(15, 20, 40, 40);
//    //_leftBtn.backgroundColor = [UIColor redColor];
//    [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
//    [_leftBtn setImage:[UIImage imageNamed:@"btn_common_zhaohuimima_left_jiantou-拷贝"] forState:UIControlStateNormal];
//    _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_leftBtn];
//    
//    self.title = [[UILabel alloc]initWithFrame:CGRectMake((Width-200)/2, 20, 200, 40)];
//    self.title.text = @"更多";
//    self.title.font = [UIFont systemFontOfSize:17];
//    self.title.textColor = [UIColor whiteColor];
//    self.title.textAlignment =NSTextAlignmentCenter;
//    [self.contentView addSubview:_title];
//    self.RightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _RightBtn.frame = CGRectMake(Width-50, 20, 40, 40);
//    [_RightBtn setImage:[UIImage imageNamed:@"消息"] forState:(UIControlStateNormal)];
//    //[self.contentView addSubview:_RightBtn];
//    
//}

@end

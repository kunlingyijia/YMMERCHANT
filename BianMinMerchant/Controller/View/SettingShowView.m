//
//  SettingShowView.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/24.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SettingShowView.h"
#import "UIButton+LXMImagePosition.h"
@implementation SettingShowView

- (id)initWithIsBM:(NSInteger)isBm {
    self = [super init];
    if (self) {
        [self createView:isBm];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withIsBm:(NSInteger)isBm {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView:isBm];
    }
    return self;
}


- (void)createView:(NSInteger)isBm {
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self).with.offset(10);
        make.height.mas_equalTo(@(1));
    }];
    
    if (isBm == 1) {
        NSArray *arr = @[@"是否有WIFI",@"是否有无烟房",@"是否有空调",@"是否有停车场",@"是否有24小时热水"];
        for (int i = 2; i < 7; i++) {
            UILabel *settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10+(i-2)*30, 120, 30)];
            settingLabel.text = arr[i-2];
            settingLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            settingLabel.font = [UIFont systemFontOfSize:14];
            settingLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:settingLabel];
            UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [firstBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            firstBtn.tag = i*100;
            firstBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [firstBtn setTitle:@"否" forState:UIControlStateNormal];
            firstBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [firstBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [firstBtn setImage:[UIImage imageNamed:@"椭圆-2"] forState:UIControlStateNormal];
            [firstBtn setImagePosition:LXMImagePositionLeft spacing:5];
            [self addSubview:firstBtn];
            [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(settingLabel);
                make.left.equalTo(settingLabel.mas_right).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            
            UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [secondBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            secondBtn.tag = i*100 + 1;
            secondBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [secondBtn setTitle:@"是" forState:UIControlStateNormal];
            secondBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [secondBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [secondBtn setImage:[UIImage imageNamed:@"椭圆-1"] forState:UIControlStateNormal];
            [secondBtn setImagePosition:LXMImagePositionLeft spacing:5];
            [self addSubview:secondBtn];
            [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(settingLabel);
                make.left.equalTo(firstBtn.mas_right).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
    }
}

- (void)btnAction:(UIButton *)sender {
    NSInteger btnTag = sender.tag;
    [sender setImage:[UIImage imageNamed:@"椭圆-2"] forState:UIControlStateNormal];
    NSInteger index = btnTag%100;
    if (index == 0) {
        UIButton *btn = [self viewWithTag:btnTag+1];
        [btn setImage:[UIImage imageNamed:@"椭圆-1"] forState:UIControlStateNormal];
    }else {
        UIButton *btn = [self viewWithTag:btnTag-1];
        [btn setImage:[UIImage imageNamed:@"椭圆-1"] forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"商家设置" object:@"商家设置" userInfo:@{@"商家设置":[NSNumber numberWithInteger:btnTag]}];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

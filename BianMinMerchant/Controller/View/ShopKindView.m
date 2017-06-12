//
//  ShopKindView.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ShopKindView.h"
#import "RequestCateAndBusinessareaModel.h"
@interface ShopKindView()
@property (nonatomic, strong) NSArray *kindArr;
@end

@implementation ShopKindView

- (id)initWithKindArr:(NSMutableArray *)kindArr {
    self = [super init];
    if (self) {
        self.kindArr = kindArr;
        [self createViewWithKindArr:kindArr];
    }
    return self;
}

- (void)createViewWithKindArr:(NSMutableArray *)arr {
    CGFloat kindW = (Width - 70 )/3;
    NSInteger maxI = 0;
    NSInteger arrCount = arr.count/3;
    NSInteger indexCount = arr.count%3;
    if (arr.count == 0) {
        maxI = 0;
    }else if (arr.count < 4) {
        maxI = 1;
    }else if (indexCount != 0) {
        maxI = arrCount + 1;
    }else if (indexCount == 0) {
        maxI = arrCount;
    }
    NSLog(@"%ld", arr.count);
    NSInteger count = 0;
    for (int i = 0; i < maxI; i ++) {
        for (int j = 0; j < 3; j++) {
            RequestCateAndBusinessareaModel *model = arr[count];
            UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [secondBtn addTarget:self action:@selector(shopKindAction:) forControlEvents:UIControlEventTouchUpInside];
            secondBtn.frame = CGRectMake(j*(kindW), i*30, kindW, 30);
            secondBtn.tag = 100+count;
            secondBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [secondBtn setTitle:model.categoryName forState:UIControlStateNormal];
            secondBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [secondBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            if (count == 0) {
                [secondBtn setImage:[UIImage imageNamed:@"椭圆-2"] forState:UIControlStateNormal];
            }else {
                     [secondBtn setImage:[UIImage imageNamed:@"椭圆-1"] forState:UIControlStateNormal];
            }
            [secondBtn setImagePosition:LXMImagePositionLeft spacing:5];
            [self addSubview:secondBtn];
            count = count + 1;
            if (i==arrCount && j == indexCount-1) {
                break;
            }
        }
    }
}

- (void)shopKindAction:(UIButton *)sender {
    NSInteger btnTag = sender.tag - 100;
    for (int i = 0; i <self.kindArr.count; i++) {
        UIButton *btn = [self viewWithTag:i+100];
        if (i == btnTag) {
            [btn setImage:[UIImage imageNamed:@"椭圆-2"] forState:UIControlStateNormal];
        }else {
            [btn setImage:[UIImage imageNamed:@"椭圆-1"] forState:UIControlStateNormal];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"商户类型" object:@"商户类型" userInfo:@{@"商户类型":[NSNumber numberWithInteger:btnTag]}];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

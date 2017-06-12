//
//  ShopGroupView.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ShopGroupView.h"
#import "BusinessareaModel.h"

@interface ShopGroupView ()
@property (nonatomic, strong) NSArray *arr;
@end

@implementation ShopGroupView


- (id)initWithGroupArr:(NSMutableArray *)groupArr {
    self = [super init];
    if (self) {
        self.arr = groupArr;
        [self createView:groupArr];
    }
    return self;
}

- (void)createView:(NSMutableArray *)arr {
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
    NSInteger count = 0;
    for (int i = 0; i < maxI; i ++) {
        for (int j = 0; j < 3; j++) {
            BusinessareaModel *model = arr[count];
            UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [secondBtn addTarget:self action:@selector(shopKindAction:) forControlEvents:UIControlEventTouchUpInside];
            secondBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            secondBtn.frame = CGRectMake(j*kindW, i*30, kindW, 30);
            secondBtn.tag = 100+count;
            secondBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [secondBtn setTitle:model.name forState:UIControlStateNormal];
            secondBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [secondBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [secondBtn setImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
            secondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
    for (int i = 0; i < self.arr.count; i++) {
        UIButton *btn = [self viewWithTag:i+100];
        if (i == btnTag) {
            if ([btn.imageView.image isEqual:[UIImage imageNamed:@"图层-1"]]) {
                [btn setImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
            }else {
                [btn setImage:[UIImage imageNamed:@"图层-1"] forState:UIControlStateNormal];
            }
        }else {
            [btn setImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"商圈" object:@"商圈" userInfo:@{@"商圈":[NSNumber numberWithInteger:btnTag]}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

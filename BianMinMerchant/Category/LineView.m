//
//  LineView.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview];

    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview];

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview];
    }
    return self;
}
-(void)addSubview{
    self.backgroundColor = [UIColor colorWithHexString:kViewBg];

    
    
}
-(void)layoutSubviews{
    CGRect  Frame= self.frame;
    Frame.size.height =1.0;
    self.frame= Frame;
}


@end

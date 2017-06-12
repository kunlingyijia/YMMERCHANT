//
//  KindView.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "KindView.h"

@implementation KindView

-(void)layoutSubviews{
//    CGRect  Frame= self.frame;
//    Frame.size.height =0.3*Width;
//    self.frame= Frame;
   
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.OneBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
    [self.TwoBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
    
    self.backgroundColor = [UIColor colorWithHexString:kViewBg];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)BtnAction:(UIButton *)sender {
    self.KindViewBlock(sender.tag-1500);
}

@end

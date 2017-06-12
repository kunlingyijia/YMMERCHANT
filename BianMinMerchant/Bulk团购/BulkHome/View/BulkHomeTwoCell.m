//
//  BulkHomeTwoCell.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/4.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BulkHomeTwoCell.h"
#define Space 40
#define ImageW (Width - (Space * 4))/3

@implementation BulkHomeTwoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        //cell选中时的颜色 无色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //[self createView];
}
- (void)createView {
    NSArray *nameArr = @[@"扫一扫",@"消息中心",@"交易记录",@"卡券管理",@"提现",@"商品管理"];
    NSArray *pictureArr = @[@"btn_zhuye_saoyisao",@"btn_zhuye_xiaoxizhongxin",@"btn_zhuye_jiaoyijilu",@"btn_zhuye_kaquanguanli",@"btn_denglu_tixian",@"btn_zhuye_guanli"];
    NSInteger count = 0;
    for (int i = 0; i<2; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(Space + j * (ImageW+Space), Space + i * (ImageW + 1.5*Space), ImageW, ImageW);
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn setImage:[UIImage imageNamed:pictureArr[count]] forState:UIControlStateNormal];
            btn.tag = 1000+count;
            btn.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:btn];
            
            UILabel *numLabel = [UILabel new];
            numLabel.hidden = YES;
            numLabel.textColor = [UIColor colorWithHexString:kNavigationBgColor];
            numLabel.text = @"10";
            numLabel.backgroundColor = [UIColor clearColor];
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.font = [UIFont systemFontOfSize:15];
            [self.contentView addSubview:numLabel];
            [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(btn.mas_top);
                make.right.equalTo(btn.mas_right).with.offset(5);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
            
            UILabel *nameLabel = [UILabel new];
            
            nameLabel.text = nameArr[count];
            nameLabel.font = [UIFont systemFontOfSize:12];
             nameLabel.tag = 2000+count;
            [self.contentView addSubview:nameLabel];
            nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn.mas_bottom).with.offset(5);
                make.centerX.equalTo(btn);
                make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
            
            count = count+1;
        }
    }
    DWHelper *helper = [DWHelper shareHelper];
    UIButton * btn = (UIButton*)[self.contentView viewWithTag:1004 ];
    UILabel *label = (UILabel*)[self.contentView viewWithTag:2004];
    if (helper.isLoginType==0) {
        btn.hidden = NO;
        label.hidden = NO;
    
    }else{
        btn.hidden = YES;
       label.hidden = YES;
    }

}
- (void)btnAction:(UIButton *)sender {

   
        self.bulkHomeTwoCellBlock(sender.tag-1000);
   
    

}


-(void)BulkHomeTwoCellBlock:(BulkHomeTwoCellBlock)block{
    self.bulkHomeTwoCellBlock =block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

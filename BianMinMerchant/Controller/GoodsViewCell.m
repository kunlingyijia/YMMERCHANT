//
//  GoodsViewCell.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoodsViewCell.h"
#import "RequestGoodsListModel.h"
@implementation GoodsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.originUrl.clipsToBounds = YES;
    self.originUrl.contentMode = UIViewContentModeScaleAspectFill;
//    self.buyMessageBtn.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
//    self.buyMessageBtn.layer.borderWidth = 1;
//    self.changeNumBtn.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
//    self.changeNumBtn.layer.borderWidth = 1;
//    self.upOrDownBtn.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
//    self.upOrDownBtn.layer.borderWidth = 1;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)buyAction:(id)sender {
    self.buyBackAction(self.goodsModel.goodsId);
}

- (IBAction)changeAction:(id)sender {
    self.changeBackAction(self.goodsModel.goodsId);
}

- (IBAction)upOrDownAction:(id)sender {
    UIButton *btn = sender;
    self.upOrdownBackAction(self.goodsModel.goodsId, btn.titleLabel.text);
}

- (IBAction)deleteBtnAction:(UIButton *)sender {
    self.deleteBtnBlock(self.goodsModel.goodsId);
}



- (void)cellGetDataWithModel:(RequestGoodsListModel *)model {
    self.goodsModel = model;
    self.goodsName.text = model.goodsName;
    self.price.text = [NSString stringWithFormat:@"市场价:%.2f", model.price];
    self.discountedPrice.text = [NSString stringWithFormat:@"现价:%.2f", model.discountedPrice];
    if (model.status == 1) {
        [self.upOrDownBtn setTitle:@"下架" forState:UIControlStateNormal];
    }else {
        [self.upOrDownBtn setTitle:@"上架" forState:UIControlStateNormal];
    }
    self.content.text = [NSString stringWithFormat:@"描述:%@", model.content];
    self.stock.text = [NSString stringWithFormat:@"销量:%ld", model.sales];
    self.goodsNum.text = [NSString stringWithFormat:@"库存:%ld", model.stock];
    self.suggestPeople.text = [NSString stringWithFormat:@"建议%@人使用", model.suggestPeople];
    self.startTime.text = [NSString stringWithFormat:@"上架时间:%@", model.startTime];
    self.endTime.text = [NSString stringWithFormat:@"下架时间:%@", model.endTime];
    self.useRule.text = model.useRule;
    self.userTime.text = [NSString stringWithFormat:@"使用时间:%@ - %@", model.startuseTime, model.enduseTime];
    [self.originUrl sd_setImageWithURL:[NSURL URLWithString:model.originUrl]];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in model.images) {
        [images addObject:dic[@"originUrl"]];
    }
    
    
    
    self.createTime.text =[NSString stringWithFormat:@"创建时间:%@", model.createTime];
}

- (void)createImageView:(NSArray *)images {
    CGFloat Space = (Width - 300)/4;
    if(images.count < 4 && images > 0) {
        for (int i = 0; i < images.count; i++) {
            NSDictionary *dic = images[i];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(Space+i * (100 + Space), 10, 100, 100)];
            imageV.clipsToBounds = YES;
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            [imageV sd_setImageWithURL:dic[@"originUrl"]];
            [self.bgView addSubview:imageV];
        }
    }else if (images.count > 3 && images.count < 7) {
        for (int i = 0; i < images.count; i++) {
            NSDictionary *dic = images[i];
            UIImageView *imageV = [UIImageView new];
            imageV.clipsToBounds = YES;
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            [self.bgView addSubview:imageV];
            if (i < 3) {
                imageV.frame = CGRectMake(Space +i* (Space + 100), 10, 100, 100);
                [imageV sd_setImageWithURL:dic[@"originUrl"]];
            }else {
                imageV.frame = CGRectMake(Space +(i-3)* (Space + 100), 10+100 + 10, 100, 100);
                [imageV sd_setImageWithURL:dic[@"originUrl"]];
            }
        }
    }else if (images.count > 6 && images.count < 10) {
        for (int i = 0; i < images.count; i++) {
            NSLog(@"%lu", (unsigned long)images.count);
            NSDictionary *dic = images[i];
            UIImageView *imageV = [UIImageView new];
            imageV.clipsToBounds = YES;
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            [self.bgView addSubview:imageV];
            if (i < 3) {
                imageV.frame = CGRectMake(Space +i* (Space + 100), 10, 100, 100);
                [imageV sd_setImageWithURL:dic[@"originUrl"]];
            }else if(i > 2 && i < 6) {
                imageV.frame = CGRectMake(Space +(i-3)* (Space + 100), 10+100 + 10, 100, 100);
                [imageV sd_setImageWithURL:dic[@"originUrl"]];
            }else {
                imageV.frame = CGRectMake(Space +(i-6)* (Space + 100), 10+200 + 20, 100, 100);
                [imageV sd_setImageWithURL:dic[@"originUrl"]];
            }
        }
    }
}


@end

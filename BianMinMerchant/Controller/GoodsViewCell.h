//
//  GoodsViewCell.h
//  BianMinMerchant
//
//  Created by kkk on 16/6/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestGoodsListModel;
@interface GoodsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *originUrl;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *discountedPrice;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *useRule;
@property (weak, nonatomic) IBOutlet UILabel *stock;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *suggestPeople;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *buyMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *upOrDownBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UILabel *goodsNum;
@property (weak, nonatomic) IBOutlet UILabel *createTime;


@property (nonatomic, copy)void(^buyBackAction)(NSString *);
@property (nonatomic, copy)void(^changeBackAction)(NSString *);
@property (nonatomic, copy)void(^upOrdownBackAction)(NSString *, NSString *);
///deleteBtn
@property (nonatomic, copy) void(^deleteBtnBlock)(NSString*)  ;


@property (nonatomic, strong) RequestGoodsListModel *goodsModel;
- (void)cellGetDataWithModel:(RequestGoodsListModel *)model;
- (void)createImageView:(NSArray *)images;
@end

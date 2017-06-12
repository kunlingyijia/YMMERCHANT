//
//  OrderDetailView.h
//  0816
//
//  Created by 月美 刘 on 16/8/15.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailView : BaseViewController

@property (nonatomic, copy)void(^backBlockAction)(NSString *str);

@property (weak, nonatomic) IBOutlet UILabel *name;      //姓名
@property (weak, nonatomic) IBOutlet UILabel *tel;       //电话
@property (weak, nonatomic) IBOutlet UILabel *address;   //地址
@property (weak, nonatomic) IBOutlet UILabel *comeTime;  //上门时间
@property (weak, nonatomic) IBOutlet UILabel *detail; //详情
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, copy) NSString *orderNo;
///bminOrderId
@property (nonatomic, strong) NSString  *bminOrderId			 ;


@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

//
//  UpdateSexController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class OwnerModel;
@protocol UpdateSexControllerDelegate <NSObject>

-(void)changesex:(int)inter;

@end


@interface UpdateSexController : BaseViewController
///代理
@property (nonatomic, assign) id<UpdateSexControllerDelegate> delegate;

@property(nonatomic ,strong)NSString * gender;

@property (weak, nonatomic) IBOutlet UIButton *chooseManBtn;      //选择"男"按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseWomanBtn;    //选择"女"按钮


@property (weak, nonatomic) IBOutlet UIView *chooseManView;      //选择"男"的View
@property (weak, nonatomic) IBOutlet UIView *chooseWomanView;    //选择"女"的View

@property (weak, nonatomic) IBOutlet UILabel *ManLabel;
@property (weak, nonatomic) IBOutlet UILabel *WomanLabel;
///titleStr
@property (nonatomic, strong) NSString  *titleStr ;
///属性传值
@property (nonatomic, strong) OwnerModel  *ownerModel ;


@end

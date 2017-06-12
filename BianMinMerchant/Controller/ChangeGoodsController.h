//
//  ChangeGoodsController.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LQPhotoPickerViewController.h"
#import "KMDatePicker.h"
#import "RequestGoodsListModel.h"
@interface ChangeGoodsController : LQPhotoPickerViewController
@property (nonatomic, strong) UITextField *txtFCurrent;
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *container;

@property (nonatomic, assign) NSInteger isNewC;
@property (nonatomic, strong) RequestGoodsListModel *model;

@property (nonatomic, copy)void(^backBlackAction)(NSString *);
- (void)hideProgress;
- (void)showToast:(NSString *)text;
@end

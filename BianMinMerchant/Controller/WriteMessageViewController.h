//
//  WriteMessageViewController.h
//  BianMinMerchant
//
//  Created by kkk on 16/8/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LQPhotoPickerViewController.h"
#import "RequestMerchantInfoModel.h"
@interface WriteMessageViewController : LQPhotoPickerViewController
@property (nonatomic, copy)void(^backAction)(NSString *str);
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;

@end

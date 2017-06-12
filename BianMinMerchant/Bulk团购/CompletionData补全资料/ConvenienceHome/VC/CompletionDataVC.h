//
//  CompletionDataVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "LQPhotoPickerViewController.h"
@class RequestMerchantInfoModel;
@interface CompletionDataVC : LQPhotoPickerViewController
@property (nonatomic, copy)void(^backAction)(NSString *str);
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;

@end

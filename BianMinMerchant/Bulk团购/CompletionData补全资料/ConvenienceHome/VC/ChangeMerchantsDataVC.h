//
//  ChangeMerchantsDataVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/31.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangeMerchantsDataVC : BaseViewController
@property (nonatomic, copy)void(^backAction)(NSString *str);
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *iconUrl;
@property (weak, nonatomic) IBOutlet UITextField *area;

@property (weak, nonatomic) IBOutlet UITextField *address;


@property (weak, nonatomic) IBOutlet UITextField *lng;
@property (weak, nonatomic) IBOutlet UITextField *lat;
@property (weak, nonatomic) IBOutlet UIButton *startTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UIButton *DingWeiBtn;


@property (weak, nonatomic) IBOutlet PublicBtn *submitBtn;


@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;
@end

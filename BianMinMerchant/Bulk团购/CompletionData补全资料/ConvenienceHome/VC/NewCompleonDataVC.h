//
//  NewCompleonDataVC.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/25.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class RequestMerchantInfoModel;
@class RequestMerchantCompleteInfo;
@interface NewCompleonDataVC : BaseViewController

@property (nonatomic, copy)void(^backAction)(NSString *str);

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *merchantCategory;
@property (weak, nonatomic) IBOutlet UIButton *businessArea;

@property (weak, nonatomic) IBOutlet UIImageView *iconUrl;
@property (weak, nonatomic) IBOutlet UIButton *haveWifiNO;
@property (weak, nonatomic) IBOutlet UIButton *haveWifiYES;
@property (weak, nonatomic) IBOutlet UIButton *havaNoSmokingRoomNO;
@property (weak, nonatomic) IBOutlet UIButton *havaNoSmokingRoomYES;
@property (weak, nonatomic) IBOutlet UIButton *havaAirConditionNO;
@property (weak, nonatomic) IBOutlet UIButton *havaAirConditionYES;
@property (weak, nonatomic) IBOutlet UIButton *haveParkingNO;
@property (weak, nonatomic) IBOutlet UIButton *haveParkingYES;
@property (weak, nonatomic) IBOutlet UIButton *have24hourWaterNO;
@property (weak, nonatomic) IBOutlet UIButton *have24hourWaterYES;
@property (weak, nonatomic) IBOutlet UITextField *lng;
@property (weak, nonatomic) IBOutlet UITextField *lat;
@property (weak, nonatomic) IBOutlet EZTextView *content;
@property (weak, nonatomic) IBOutlet UIButton *startTime;

@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UIButton *DingWeiBtn;


@property (weak, nonatomic) IBOutlet PublicBtn *submitBtn;

@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;
///regionId
@property (nonatomic, strong) NSString  *regionId ;




@end

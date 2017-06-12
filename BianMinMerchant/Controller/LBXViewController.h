//
//  LBXViewController.h
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LBXScanViewController.h"

@protocol LBXscanViewDelegate <NSObject>

- (void)backAction:(LBXScanResult *)result;

@end


@interface LBXViewController : LBXScanViewController
@property (nonatomic, copy)void(^backAction)(LBXScanResult *result);
@property (nonatomic, weak) id<LBXscanViewDelegate>delegate;

@end

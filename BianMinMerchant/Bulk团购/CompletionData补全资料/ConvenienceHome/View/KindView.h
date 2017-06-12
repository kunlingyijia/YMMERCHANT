//
//  KindView.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KindView : UIView

///KindViewBlock
@property (nonatomic, copy) void(^KindViewBlock)(NSInteger tag) ;


@property (weak, nonatomic) IBOutlet UIButton *OneBtn;
@property (weak, nonatomic) IBOutlet UIButton *TwoBtn;

@end

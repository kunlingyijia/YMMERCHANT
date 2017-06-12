//
//  convenienceHomeCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/4.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^convenienceHomeCellBlock)( NSInteger tag);
@interface convenienceHomeCell : UITableViewCell
///BulkHomeOneCellBlock
@property (nonatomic, copy) convenienceHomeCellBlock
      ConvenienceHomeCellBlock ;
-(void)convenienceHomeCellBlock:(convenienceHomeCellBlock)block;
@property (weak, nonatomic) IBOutlet UIButton *OneBtn;

@property (weak, nonatomic) IBOutlet UIButton *TwoBtn;

@property (weak, nonatomic) IBOutlet UIButton *ThreeBtn;


@end

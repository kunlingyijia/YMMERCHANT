//
//  BulkHomeOneCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/4.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestMerchantInfoModel;

typedef void(^BulkHomeOneCellBlock)( NSInteger tag);
@interface BulkHomeOneCell : UITableViewCell
///BulkHomeOneCellBlock
@property (nonatomic, copy) BulkHomeOneCellBlock  bulkHomeOneCellBlock ;
-(void)BulkHomeOneCellBlock:(BulkHomeOneCellBlock)block;
@property (weak, nonatomic) IBOutlet UIImageView *logoimg;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNumber;
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImage;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

-(void)CellGetData:(RequestMerchantInfoModel*)model;


@end

//
//  BulkHomeTwoCell.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/4.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BulkHomeTwoCellBlock)( NSInteger tag);
@interface BulkHomeTwoCell : UITableViewCell
@property (nonatomic, copy) BulkHomeTwoCellBlock  bulkHomeTwoCellBlock ;
-(void)BulkHomeTwoCellBlock:(BulkHomeTwoCellBlock)block;
@end

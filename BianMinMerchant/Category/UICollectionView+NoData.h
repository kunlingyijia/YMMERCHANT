//
//  UICollectionView+NoData.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (NoData)
///没数据
- (void)collectionViewDisplayWitimage:(NSString *)image ifNecessaryForRowCount:(NSUInteger) rowCount;
///Cell nib 注册
-(void)collectionViewregisterNibArray:(NSArray*)cellArrary;
///Cell Class 注册
-(void)collectionViewregisterClassArray:(NSArray*)cellArrary;
@end

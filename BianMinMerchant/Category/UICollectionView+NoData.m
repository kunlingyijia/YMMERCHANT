//
//  UICollectionView+NoData.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "UICollectionView+NoData.h"

@implementation UICollectionView (NoData)
- (void)collectionViewDisplayWitimage:(NSString *)image ifNecessaryForRowCount:(NSUInteger) rowCount
{
    if (rowCount == 0) {
        UIImageView * imageV= [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:@"暂无数据"];
        imageV.contentMode =  UIViewContentModeCenter;
        //imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageV.clipsToBounds  = YES;
        self.backgroundView= imageV;
        NSLog(@"数据");
    }else{
        self.backgroundView = nil;
    }
    
}


-(void)collectionViewregisterNibArray:(NSArray*)cellArrary{
    if (cellArrary.count !=0) {
        for (NSString *cellStr in cellArrary) {
            [self registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:cellStr];
            
            
            
        }
        
        
    }
}
-(void)collectionViewregisterClassArray:(NSArray*)cellArrary{
    if (cellArrary.count !=0) {
        for (NSString *cellStr in cellArrary) {
            [self registerClass:[NSClassFromString(cellStr) class] forCellWithReuseIdentifier:cellStr];
        }
    }
}


@end

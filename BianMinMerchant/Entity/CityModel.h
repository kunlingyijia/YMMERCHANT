//
//  CityModel.h
//  AdressSelected
//
//  Created by kkk on 16/7/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, copy) NSString *regionCd;
@property (nonatomic, assign) NSInteger regionId;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, assign) NSInteger regionType;
@property (nonatomic, assign) NSInteger superId;
@property (nonatomic, assign) NSInteger treeLevel;
@end

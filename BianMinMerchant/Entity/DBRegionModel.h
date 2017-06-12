//
//  RegionModel.h
//  BianMin
//
//  Created by z on 16/6/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBRegionModel : NSObject

@property (nonatomic, assign) NSUInteger reigonId;
@property (nonatomic, strong) NSString *regionCode; //高德地图编码
@property (nonatomic, strong) NSString *reigonName;
@property (nonatomic, strong) NSString *superId;
@property (nonatomic, assign) NSUInteger regionType; //0国家  1省， 2市 ， 3区，县，地级市

@end

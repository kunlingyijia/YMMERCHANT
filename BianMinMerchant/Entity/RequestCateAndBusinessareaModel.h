//
//  RequestCateAndBusinessareaModel.h
//  BianMin
//
//  Created by kkk on 16/8/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestCateAndBusinessareaModel : NSObject

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger isHome;
@property (nonatomic, copy) NSString* merchantCategoryId;
@property (nonatomic, assign) NSInteger isBmin;
@property (nonatomic, strong) NSArray *_child;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString* businessAreaId;
@end

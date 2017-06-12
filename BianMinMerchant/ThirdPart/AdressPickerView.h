//
//  AdressPickerView.h
//  AdressPickerView
//
//  Created by kkk on 16/11/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityModel;

@interface AdressPickerView : UIView
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy)void(^selectedAdressBlock)(CityModel *provinceModel,CityModel *cityModel, CityModel *areaModel);

@end

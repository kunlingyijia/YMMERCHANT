//
//  AdressPickerView.m
//  AdressPickerView
//
//  Created by kkk on 16/11/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AdressPickerView.h"
#import "CityModel.h"
#import "YYModel.h"
#define PickerHeight [UIScreen mainScreen].bounds.size.height
#define PickerWidth [UIScreen mainScreen].bounds.size.width
@interface AdressPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *firstDataSource;
@property (nonatomic, strong) NSMutableArray *secondDataSource;
@property (nonatomic, strong) NSMutableArray *secondCity;
@property (nonatomic, strong) NSMutableArray *thirdDataSource;
@property (nonatomic, strong) NSMutableArray *thirdCity;
@property (nonatomic, assign) NSInteger firstRegionID;
@property (nonatomic, assign) NSInteger secondRegionID;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, assign) NSInteger firstIndex;
@property (nonatomic, assign) NSInteger secondIndex;
@property (nonatomic, assign) NSInteger thirdIndex;
@property (nonatomic, strong) CityModel *cityModel;
@property (nonatomic, strong) CityModel *provinceModel;
@property (nonatomic, strong) CityModel *secondModel;
@property (nonatomic, strong) UIButton *imageBtn;

@end

@implementation AdressPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView:frame];
    }
    return self;
}

- (void)createView:(CGRect)frame {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTapAction:)];
    [self addGestureRecognizer:tap];
    //标题 可修改 文字大小 颜色
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cbcbcb"];
    self.titleLabel.text = @"点击选择地区";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(self);
      
    }];
    
    //初始化本地值
    self.firstIndex = 0;
    self.secondIndex = 0;
    self.thirdIndex = 0;
    for (NSDictionary *dic in [self getCityData]) {
        CityModel *model = [CityModel yy_modelWithDictionary:dic];
        if (model.regionType == 1) {
            [self.firstDataSource addObject:model];
        }else if (model.regionType == 2) {
            [self.secondDataSource addObject:model];
        }else if (model.regionType == 3||model.regionType == 4) {
            [self.thirdDataSource addObject:model];
        }
    }
    CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
    for (CityModel *model in self.secondDataSource) {
        if (beijingModel.regionId == model.superId) {
            [self.secondCity addObject:model];
        }
    }
    
    CityModel *secondModel = self.secondCity[0];
    for (CityModel *model in self.thirdDataSource) {
        if (secondModel.regionId == model.superId) {
            [self.thirdCity addObject:model];
        }
    }
}

- (void)addTapAction:(UITapGestureRecognizer *)sender {
    [self createPickerView];
}

- (void)createPickerView {
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
    [self.bgView addGestureRecognizer:tap];
    
    self.bgView.alpha = 0.2;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.bgView];
    
    self.pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.pickerBgView];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 170)];
    self.pickerView.userInteractionEnabled = YES;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView selectRow:self.firstIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:self.secondIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:self.thirdIndex inComponent:2 animated:NO];
    [self.pickerBgView addSubview:self.pickerView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 10, [UIScreen mainScreen].bounds.size.width/2-20, 30);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [self.pickerBgView addSubview:btn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(20, 10, PickerWidth/2-40, 30);
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [self.pickerBgView addSubview:cancelBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancelAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, PickerHeight, PickerWidth, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}
- (void)sureAction:(UITapGestureRecognizer *)sender {
    if (self.thirdCity.count == 0 || self.secondCity.count == 0) {
        
    }else {
        self.cityModel = self.thirdCity[self.thirdIndex];
        self.secondModel = self.secondCity[self.secondIndex];
        self.provinceModel = self.firstDataSource[self.firstIndex];
        
        CityModel *firstModel = self.firstDataSource[self.firstIndex];
        CityModel *secondModel = self.secondCity[self.secondIndex];
        
        if ([secondModel.regionName isEqualToString:@"北京市"]) {
            self.selectedAdressBlock(self.provinceModel, self.secondModel, self.cityModel);
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", firstModel.regionName, self.cityModel.regionName];
            self.titleLabel.textColor = [UIColor colorWithHexString:kTitleColor];
            
        }else {
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@", firstModel.regionName, secondModel.regionName, self.cityModel.regionName];
             self.selectedAdressBlock(self.provinceModel, self.secondModel, self.cityModel);
            self.titleLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, PickerHeight, PickerWidth, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];

}
#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (component == 0) {
        CityModel *model = self.firstDataSource[row];
        return model.regionName;
    }else if (component == 1) {
        CityModel *model = self.secondCity[row];
        return model.regionName;
    }else {
        CityModel *model = self.thirdCity[row];
        return model.regionName;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //    if (self.thirdCity.count == 0 && self.secondCity.count != 0) {
    //        return 2;
    //    }
    //    if (self.secondCity.count == 0) {
    //        return 1;
    //    }
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        NSLog(@"%ld", self.firstDataSource.count);
        return self.firstDataSource.count;
    }else if (component == 1) {
        return self.secondCity.count;
    }else {
        return self.thirdCity.count;
    }
    return 10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    return 60;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (component == 0) {
        self.firstIndex = row;
        CityModel *model = self.firstDataSource[row];
        [self.secondCity removeAllObjects];
        [self.thirdCity removeAllObjects];
        
        if (row == 0) {
            CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
            for (CityModel *model in self.secondDataSource) {
                if (beijingModel.regionId == model.superId) {
                    [self.secondCity addObject:model];
                }
            }
            CityModel *secondModel = self.secondCity[0];
            for (CityModel *model in self.thirdDataSource) {
                if (secondModel.regionId == model.superId) {
                    [self.thirdCity addObject:model];
                }
            }
        }else {
            self.firstRegionID = model.regionId;
            for (CityModel *addressModel in self.secondDataSource) {
                if (addressModel.superId == model.regionId) {
                    [self.secondCity addObject:addressModel];
                }
            }
            CityModel *secondModel = self.secondCity[0];
            for (CityModel *thirdModel in self.thirdDataSource) {
                if (secondModel.regionId == thirdModel.superId) {
                    [self.thirdCity addObject:thirdModel];
                }
            }
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            
        }
        [self.pickerView reloadAllComponents];
    }else if (component == 1) {
        [self.thirdCity removeAllObjects];
        self.secondIndex = row;
        CityModel *model = self.secondCity[row];
        self.secondRegionID = model.regionId;
        for (CityModel *addressModel in self.thirdDataSource) {
            if (addressModel.superId == model.regionId) {
                [self.thirdCity addObject:addressModel];
            }
        }
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        [self.pickerView reloadAllComponents];
    }else {
        self.thirdIndex = row;
    }
}

- (NSMutableArray *)firstDataSource {
    if (!_firstDataSource) {
        self.firstDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _firstDataSource;
}
- (NSMutableArray *)secondDataSource {
    if (!_secondDataSource) {
        self.secondDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondDataSource;
}
- (NSMutableArray *)thirdDataSource {
    if (!_thirdDataSource) {
        self.thirdDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _thirdDataSource;
}
- (NSMutableArray *)secondCity {
    if (!_secondCity) {
        self.secondCity = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondCity;
}
- (NSMutableArray *)thirdCity {
    if (!_thirdCity) {
        self.thirdCity = [NSMutableArray arrayWithCapacity:0];
    }
    return _thirdCity;
}


//获取本地json
- (NSMutableArray *)getCityData
{
    NSArray *jsonArray = [[NSArray alloc]init];
    NSData *fileData = [[NSData alloc]init];
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    if ([UD objectForKey:@"city"] == nil) {
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"];
        fileData = [NSData dataWithContentsOfFile:path];
        
        [UD setObject:fileData forKey:@"city"];
        [UD synchronize];
    }
    else {
        fileData = [UD objectForKey:@"city"];
    }
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    for (NSDictionary *dict in jsonArray) {
        [array addObject:dict];
    }
    return array;
}


@end

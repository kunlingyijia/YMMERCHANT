//
//  SettingShopMessageController.m
//  BianMinMerchant
//
//  Created by kkk on 16/12/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SettingShopMessageController.h"
#import "AdressPickerView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "RequestMerchantInfoModel.h"
#import "LQPhotoViewCell.h"
#import "Imageupload.h"
#import "RequestMerchantCompleteInfo.h"
#import "CityModel.h"
#define LQHeight [self LQPhotoPicker_getPickerViewFrame].size.height
#define LQFrameY [self LQPhotoPicker_getPickerViewFrame].origin.y
@interface SettingShopMessageController ()<LQPhotoPickerViewDelegate, AMapLocationManagerDelegate,LQImgPickerActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIView *viewBg;
@property (nonatomic, strong) UIView *adressNum;
//定位
@property (nonatomic ,strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UITextField *adressField;
@property (nonatomic, strong) UITextField *latField;
@property (nonatomic, strong) UITextField *lngField;
//修改的图片
@property (nonatomic, strong) NSMutableArray *changeImages;
@property (nonatomic, strong) CityModel *firstModel;
@property (nonatomic, strong) CityModel *secondModel;
@property (nonatomic, strong) CityModel *thirdModel;
@property (nonatomic, strong) NSMutableArray *imageArr;
@end

@implementation SettingShopMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.title = @"修改商户信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollerView = [UIScrollView new];
    self.scrollerView.backgroundColor = [UIColor whiteColor];
    self.scrollerView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollerView];
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    
    [self addImageUrl];
    self.container = [UIView new];
    self.container.userInteractionEnabled = YES;
    [self.scrollerView addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollerView);
        make.width.equalTo(self.scrollerView);
    }];
    
    [self createView];
}

- (void)addImageUrl {
    DWHelper *helper = [DWHelper shareHelper];
    for (NSDictionary *dic in helper.shopModel.images) {
        [self.changeImages addObject:dic];
    }
    [self.pickerCollectionView reloadData];
}

-(void)createView {
    DWHelper *helper = [DWHelper shareHelper];
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 5)];
    firstLine.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.container addSubview:firstLine];
    
    UILabel *shopLogo = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 80, 30)];
    shopLogo.text = @"店铺logo";
    shopLogo.font = [UIFont systemFontOfSize:15];
    shopLogo.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.container addSubview:shopLogo];
    
    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shopLogo.frame), 25, 80, 80)];
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:helper.shopModel.iconUrl] placeholderImage:[UIImage imageNamed:@"plus"]];
    
    self.logoImage.userInteractionEnabled = YES;
    self.logoImage.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedShopLogo:)];
    [self.logoImage addGestureRecognizer:tap];
    [self.container addSubview:self.logoImage];
    
    UILabel *shopImg = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.logoImage.frame)+16, 80, 30)];
    shopImg.text = @"店铺相册";
    shopImg.font = [UIFont systemFontOfSize:15];
    shopImg.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.container addSubview:shopImg];
    
    self.LQPhotoPicker_superView = self.scrollerView;
    self.LQPhotoPicker_imgMaxCount = 9;
    [self LQPhotoPicker_initPickerView];
    self.LQPhotoPicker_delegate = self;
    [self lLQPhotoPicker_updatePickerViewFrameY:CGRectGetMaxY(self.logoImage.frame)];
    
    self.viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, LQFrameY+LQHeight, Width, 400)];
    self.viewBg.backgroundColor = [UIColor whiteColor];
    [self.container addSubview:self.viewBg];
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
    secondLine.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.viewBg addSubview:secondLine];
    
    UILabel *shopAdress = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    shopAdress.text = @"商铺地址";
    shopAdress.font = [UIFont systemFontOfSize:15];
    shopAdress.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.viewBg addSubview:shopAdress];
    
    __weak SettingShopMessageController *weakSelf = self;
    AdressPickerView *adressPicker = [[AdressPickerView alloc] init];
    adressPicker.userInteractionEnabled = NO;
    adressPicker.tag = 1010;
    adressPicker.selectedAdressBlock = ^(CityModel *firstModel, CityModel *secondModel, CityModel *thirdModel) {
        weakSelf.firstModel = firstModel;
        weakSelf.secondModel = secondModel;
        weakSelf.thirdModel = thirdModel;
    };
    adressPicker.titleLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    adressPicker.titleLabel.text = helper.shopModel.area;
    adressPicker.layer.masksToBounds = YES;
    adressPicker.layer.borderWidth = 1;
    adressPicker.layer.borderColor = [UIColor colorWithHexString:kBorderColor].CGColor;
    [self.viewBg addSubview:adressPicker];
    [adressPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopAdress.mas_bottom);
        make.left.equalTo(self.viewBg).with.offset(10);
        make.right.equalTo(self.viewBg).with.offset(-10);
        make.height.mas_equalTo(@(40));
    }];
    
    self.adressField = [UITextField new];
    self.adressField.placeholder = @"请输入详细地址";
    self.adressField.text = helper.shopModel.address;
    self.adressField.textColor = [UIColor colorWithHexString:kTitleColor];
    self.adressField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.adressField.leftViewMode = UITextFieldViewModeAlways;
    self.adressField.font = [UIFont systemFontOfSize:15];
    self.adressField.layer.borderColor = [UIColor colorWithHexString:kBorderColor].CGColor;
    self.adressField.layer.borderWidth = 1;
    
    
    [self.viewBg addSubview:self.adressField];
    [self.adressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adressPicker.mas_bottom).with.offset(20);
        make.right.equalTo(self.viewBg).with.offset(-10);
        make.left.equalTo(self.viewBg).with.offset(10);
        make.height.mas_equalTo(@(40));
    }];
    
    UIView *thirdLine = [UIView new];
    thirdLine.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.viewBg addSubview:thirdLine];
    [thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adressField.mas_bottom).with.offset(20);
        make.right.left.equalTo(self.viewBg);
        make.height.mas_equalTo(@(10));
    }];
    
    UIButton *getAdressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getAdressBtn setTitle:@"点击自动获取经纬度" forState:UIControlStateNormal];
    getAdressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [getAdressBtn addTarget:self action:@selector(getAdressAction:) forControlEvents:UIControlEventTouchUpInside];
    getAdressBtn.backgroundColor = [UIColor colorWithHexString:@"#fc9e18"];
    getAdressBtn.layer.cornerRadius = 4;
    getAdressBtn.layer.masksToBounds = YES;
    [getAdressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.viewBg addSubview:getAdressBtn];
    [getAdressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdLine.mas_bottom).with.offset(15);
        make.left.equalTo(self.viewBg).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    UILabel *latLabel = [UILabel new];
    latLabel.text = @"经度";
    latLabel.font = [UIFont systemFontOfSize:15];
    latLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.viewBg addSubview:latLabel];
    [latLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getAdressBtn.mas_bottom).with.offset(20);
        make.left.equalTo(self.viewBg).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    UILabel *lngLabel = [UILabel new];
    lngLabel.text = @"纬度";
    lngLabel.font = [UIFont systemFontOfSize:15];
    lngLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.viewBg addSubview:lngLabel];
    [lngLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(latLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.viewBg).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    self.latField = [UITextField new];
    self.latField.placeholder = @"经度,例:125.333,必须含小数";
    self.latField.text = helper.shopModel.lat;
    
    self.latField.layer.borderColor = [UIColor colorWithHexString:kBorderColor].CGColor;
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.latField.leftView = right;
    self.latField.leftViewMode = UITextFieldViewModeAlways;
    self.latField.layer.borderWidth = 1;
    self.latField.font = [UIFont systemFontOfSize:15];
    self.latField.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.viewBg addSubview:self.latField];
    [self.latField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(latLabel);
        make.left.equalTo(latLabel.mas_right);
        make.right.equalTo(self.viewBg).with.offset(-10);;
        make.height.mas_equalTo(@(40));
    }];
    
    self.lngField = [UITextField new];
    self.lngField.placeholder = @"经度,例:125.333,必须含小数";
    self.lngField.text = helper.shopModel.lng;
    self.lngField.layer.borderColor = [UIColor colorWithHexString:kBorderColor].CGColor;
    self.lngField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.lngField.leftViewMode = UITextFieldViewModeAlways;
    self.lngField.layer.borderWidth = 1;
    self.lngField.font = [UIFont systemFontOfSize:15];
    self.lngField.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.viewBg addSubview:self.lngField];
    [self.lngField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lngLabel);
        make.left.equalTo(lngLabel.mas_right);
        make.right.equalTo(self.viewBg).with.offset(-10);
        make.height.mas_equalTo(@(40));
    }];
    
    UIView *sureBg = [UIView new];
    sureBg.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.viewBg addSubview:sureBg];
    [sureBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lngField.mas_bottom).with.offset(20);
        make.right.left.equalTo(self.viewBg);
        make.height.mas_equalTo(@(80));
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [sureBg addSubview:btn];
    btn.frame = CGRectMake(20, 20, Width-40, 40);
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.viewBg);
    }];
}

#pragma mark - 改变view，collectionView高度
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.LQPhotoPicker_smallImageArray.count+1 + self.changeImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
    UINib *nib = [UINib nibWithNibName:@"LQPhotoViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"LQPhotoViewCell"];
    LQPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"LQPhotoViewCell" forIndexPath:indexPath];
    //    [cell.profilePhoto sd_setImageWithURL:self.changeImages[2]];
    
    if (indexPath.row == self.LQPhotoPicker_smallImageArray.count + self.changeImages.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:@"图层-2"]];
        cell.closeButton.hidden = YES;
        //没有任何图片
        if (self.LQPhotoPicker_smallImageArray.count == 0) {
            //            addImgStrLabel.hidden = NO;
        }
        else{
            //            addImgStrLabel.hidden = YES;
        }
    }else{
        if (indexPath.row < self.changeImages.count) {
            NSDictionary *dic = self.changeImages[indexPath.item];
            [cell.profilePhoto sd_setImageWithURL:dic[@"originUrl"]];
        }else if(indexPath.row < self.changeImages.count + self.LQPhotoPicker_smallImageArray.count) {
            NSLog(@"%lu", (unsigned long)self.LQPhotoPicker_smallImageArray.count);
            [cell.profilePhoto setImage:self.LQPhotoPicker_smallImageArray[indexPath.item - self.changeImages.count]];
        }
        cell.profilePhoto.contentMode = UIViewContentModeScaleAspectFill;
        cell.profilePhoto.clipsToBounds = YES;
        cell.closeButton.hidden = NO;
    }
    
    [cell setBigImgViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.LQPhotoPicker_smallImageArray.count+self.changeImages.count == 0) {
        self.addImgStrLabel.hidden = NO;
    }else{
        self.addImgStrLabel.hidden = YES;
    }
    [self changeCollectionViewHeight];
    return cell;
    
}
#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender{
    if (sender.tag < self.changeImages.count) {
        [self.changeImages removeObjectAtIndex:sender.tag];
    }else {
        [self.LQPhotoPicker_smallImageArray removeObjectAtIndex:sender.tag-self.changeImages.count];
        [self.LQPhotoPicker_selectedAssetArray removeObjectAtIndex:sender.tag-self.changeImages.count];
        
    }
    
    
    [self.pickerCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
    
    for (NSInteger item = sender.tag; item <= self.LQPhotoPicker_smallImageArray.count+self.changeImages.count; item++) {
        LQPhotoViewCell *cell = (LQPhotoViewCell*)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.closeButton.tag--;
        cell.profilePhoto.tag--;
    }
    //没有任何图片
    if (self.LQPhotoPicker_smallImageArray.count+self.changeImages.count == 0) {
        self.addImgStrLabel.hidden = NO;
    }else{
        self.addImgStrLabel.hidden = YES;
    }
    [self changeCollectionViewHeight];
}



- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    
    if (index == (self.LQPhotoPicker_smallImageArray.count+self.changeImages.count)) {
        [self.view endEditing:YES];
        //添加新图片
        [self addNewImg];
    }
    //    else{
    //        //点击放大查看
    //        LQPhotoViewCell *cell = (LQPhotoViewCell*)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    //        if (!cell.BigImgView || !cell.BigImgView.image) {
    //
    //            [cell setBigImgViewWithImage:[self getBigIamgeWithALAsset:_LQPhotoPicker_selectedAssetArray[index]]];
    //        }
    //
    //        JJPhotoManeger *mg = [JJPhotoManeger maneger];
    //        mg.delegate = self;
    //        [mg showLocalPhotoViewer:@[cell.BigImgView] selecImageindex:0];
    //    }
}

- (void)addNewImg{
    if (self.LQPhotoPicker_smallImageArray.count == self.LQPhotoPicker_imgMaxCount) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                             
                                                      message:@"选择图片数量已达上限"
                             
                                                     delegate:nil
                             
                                            cancelButtonTitle:@"知道了"
                             
                                            otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    if (!self.imgPickerActionSheet) {
        self.imgPickerActionSheet = [[LQImgPickerActionSheet alloc] init];
        self.imgPickerActionSheet.delegate = self;
    }
    if (self.LQPhotoPicker_selectedAssetArray) {
        self.imgPickerActionSheet.arrSelected = self.LQPhotoPicker_selectedAssetArray;
    }
    self.imgPickerActionSheet.maxCount = self.LQPhotoPicker_imgMaxCount;
    [self.imgPickerActionSheet showImgPickerActionSheetInView:self.showActionSheetViewController];
}

- (void)getSelectImgWithALAssetArray:(NSArray*)ALAssetArray thumbnailImgImageArray:(NSArray*)thumbnailImgArray {
    //（ALAsset）类型 Array
    self.LQPhotoPicker_selectedAssetArray = [NSMutableArray arrayWithArray:ALAssetArray];
    //正方形缩略图 Array
    self.LQPhotoPicker_smallImageArray = [NSMutableArray arrayWithArray:thumbnailImgArray] ;
    
    [self.pickerCollectionView reloadData];
}


- (void)changeCollectionViewHeight{
    if (self.collectionFrameY) {
        self.pickerCollectionView.frame = CGRectMake(80, self.collectionFrameY, [UIScreen mainScreen].bounds.size.width-80, (((float)[UIScreen mainScreen].bounds.size.width-64.0-80) /3.0 +20.0)* ((int)(self.LQPhotoPicker_selectedAssetArray.count + self.changeImages.count)/3 +1)+20.0);
    }
    else{
        self.pickerCollectionView.frame = CGRectMake(80, 0, [UIScreen mainScreen].bounds.size.width-80, (((float)[UIScreen mainScreen].bounds.size.width-64.0-80) /3.0 +20.0)* ((int)(self.LQPhotoPicker_selectedAssetArray.count + self.changeImages.count)/3 +1)+20.0);
    }
    //    if (self.LQPhotoPicker_delegate && [self.LQPhotoPicker_delegate respondsToSelector:@selector(LQPhotoPicker_pickerViewFrameChanged)]) {
    //        [self.LQPhotoPicker_delegate LQPhotoPicker_pickerViewFrameChanged];
    //    }
    [self LQPhotoPicker_pickerViewFrameChanged];
}
- (void)LQPhotoPicker_pickerViewFrameChanged  {
    self.viewBg.frame = CGRectMake(0, LQFrameY+LQHeight, Width, 435);
}


- (void)lLQPhotoPicker_updatePickerViewFrameY:(CGFloat)Y{
    self.collectionFrameY = Y;
    self.pickerCollectionView.frame = CGRectMake(80, self.collectionFrameY, [UIScreen mainScreen].bounds.size.width-80, (((float)[UIScreen mainScreen].bounds.size.width-45-80) /3.0 +20.0)* ((int)(self.LQPhotoPicker_selectedAssetArray.count)/3 +1)+20.0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-45- 80) /3 ,([UIScreen mainScreen].bounds.size.width-45 - 80) /3);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"btn_common_zhaohuimima_left_jiantou-拷贝"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//定位
- (void)getAdressAction:(UIButton *)sender {
    [self.locationManager startUpdatingLocation];
    [self showAdressProgress];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    self.lngField.text = [NSString stringWithFormat:@"%.6f", location.coordinate.longitude];
    self.latField.text = [NSString stringWithFormat:@"%.6f", location.coordinate.latitude];
    [self hideProgress];
    [self.locationManager stopUpdatingLocation];
}

- (NSMutableArray *)changeImages {
    if (!_changeImages) {
        self.changeImages = [NSMutableArray arrayWithCapacity:0];
    }
    return _changeImages;
}
#pragma makr - 选择商户logo
- (void)selectedShopLogo:(UITapGestureRecognizer *)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectedImgWithType:UIImagePickerControllerSourceTypeCamera];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectedImgWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)selectedImgWithType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.sourceType = type;
    pickerC.allowsEditing = YES;
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.logoImage.image = image;
}

//确定
-(void)sureAction:(UIButton *)sender {
    if ([self.logoImage.image isEqual:[UIImage imageNamed:@"plus"]]) {
        [self showToast:@"请选择商户logo"];
    }
//    else if (self.firstModel == nil || self.secondModel == nil || self.thirdModel == nil) {
//        [self showToast:@"请选择地区"];
//    }
    else if (self.adressField.text.length == 0) {
        [self showToast:@"请输入详细地址"];
    }else if (self.latField.text.length == 0) {
        [self showToast:@"请输入经度"];
    }else if (self.lngField.text.length == 0) {
        [self showToast:@"请输入纬度"];
    }else {
        [self comitImage];
    }
}

- (void)comitImage {
     [self showProgress];
 
    self.imageArr = [self LQPhotoPicker_getSmallImageArray];
    DWHelper *helper = [DWHelper shareHelper];
    Imageupload *upload = [[Imageupload alloc] init];
    upload.isThumb = @"1";
    upload.image_account = helper.configModel.image_account;
    upload.image_password = [[NSString stringWithFormat:@"%@%@%@",helper.configModel.image_account, helper.configModel.image_hostname,helper.configModel.image_password] MD5Hash];
    upload.waterSwitch = helper.configModel.waterSwitch;
    upload.waterLogo = helper.configModel.waterLogo;
    upload.isWater = @"1";
    //头像上传
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.imageArr addObject:self.logoImage.image];
    
    [manager POST:helper.configModel.image_hostname parameters:[upload yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < self.imageArr.count; i++) {
            UIImage * image =  [UIImage scaleImageAtPixel:self.imageArr [i] pixel:1024];
            //1.把图片转换成二进制流
            NSData *imageData= [ UIImage scaleImage:image toKb:70];
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d", i] fileName:[NSString stringWithFormat:@"curr%d.png", i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:responseObject];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:baseRes.data];
        [self comitShopDataWithArr:arr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgress];
    }];
}

- (void)comitShopDataWithArr:(NSMutableArray *)imgArr {
    
    RequestMerchantCompleteInfo *infoM = [[RequestMerchantCompleteInfo alloc] init];
    infoM.iconUrl = [imgArr lastObject];
    [imgArr removeLastObject];
    for (NSDictionary *dic in self.changeImages) {
        [imgArr insertObject:dic atIndex:0];
    }
    infoM.lat = [self.latField.text doubleValue];
    infoM.lng = [self.lngField.text doubleValue];
    if (self.firstModel == nil || self.secondModel == nil || self.thirdModel == nil) {
        
    }
//    infoM.provinceId = self.firstModel.regionId;
//    infoM.cityId = self.secondModel.regionId;
//    infoM.regionId = self.thirdModel.regionId;
    
    //AdressPickerView *adressPickerC = [self.view viewWithTag:1010];
    infoM.address =self.adressField.text;
    
//    for (NSString *url in self.imageArr) {
//        [infoM.images addObject:url];
//    }
//    for (NSString *url in imgArr) {
//        [infoM.images addObject:url];
//    }
    
    infoM.images = imgArr;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[infoM yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestEditMerchantInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self showToast:@"修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"修改商户资料" object:@"修改商户资料" userInfo:@{}];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [self showToast:baseRes.msg];
        }
        [self hideProgress];
    } faild:^(id error) {
        [self hideProgress];
    }];
    
    
}



- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        self.imageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArr;
}

- (void)showToast:(NSString *)text{
    [self.view hideToastActivity];
    [self.view makeToast:text duration:1.5 position:CSToastPositionCenter];
}
- (void)hideProgress{
    [SVProgressHUD dismiss];
}
- (void)showAdressProgress {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"定位中..."];
}
- (void)showProgress{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"加载中..."];
}
@end

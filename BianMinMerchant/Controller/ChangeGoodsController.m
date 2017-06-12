//
//  ChangeGoodsController.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ChangeGoodsController.h"
#import "DateHelper.h"
#import "NSDate+CalculateDay.h"
#import "Imageupload.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "RequestAddGoods.h"
#import "LQPhotoViewCell.h"
#import "RequestUpdateGoods.h"
#import "XFDaterView.h"
#import "ImageChooseVC.h"
#define LQHeight [self LQPhotoPicker_getPickerViewFrame].size.height
#define LQFrameY [self LQPhotoPicker_getPickerViewFrame].origin.y
#define Space 10
@interface ChangeGoodsController ()<LQPhotoPickerViewDelegate,UITextFieldDelegate, KMDatePickerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate, UITextFieldDelegate, LQImgPickerActionSheetDelegate,XFDaterViewDelegate>{
    XFDaterView*dater;
    XFDaterView*timer;
}

@property (nonatomic, strong) UIImageView *logoBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *priceText;
@property (nonatomic, strong) UITextField *newpriceText;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *startTime;
@property (nonatomic, strong) UITextField *endTime;
@property (nonatomic, strong) UITextField *useStartTime;
@property (nonatomic, strong) UITextField *useEndTime;
@property (nonatomic, strong) UIButton *startTimeBtn;
@property (nonatomic, strong) UIButton *endTimeBtn;
@property (nonatomic, strong) UIButton *useStartTimeBtn;
@property (nonatomic, strong) UIButton *useEndTimeBtn;
@property (nonatomic, strong) NSString * dateStr;
@property (nonatomic, strong) NSString * timeStr;

@property (nonatomic, strong) UITextField *useNumber;
@property (nonatomic, strong) UITextField *goodsNum;
@property (nonatomic, strong) UITextView *useTextView;
@property (nonatomic, strong) UITextField *goodsName;
//存储选中的图片
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) NSMutableArray *changeImages;


@end

@implementation ChangeGoodsController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    self.title = @"商品信息修改";
    [self addImageUrl];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    
    self.scrollerView = [UIScrollView new];
    self.scrollerView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.scrollerView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollerView];
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    
    self.container = [UIView new];
    self.container.backgroundColor = [UIColor whiteColor];
    self.container.userInteractionEnabled = YES;
    [self.scrollerView addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollerView);
        make.width.equalTo(self.scrollerView);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hhhhh)];
    [self.container addGestureRecognizer:tap];
    [self createView];
    
}

- (void)addImageUrl {
    for (NSDictionary *dic in self.model.images) {
        [self.changeImages addObject:dic];
    }
    [self.pickerCollectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.LQPhotoPicker_smallImageArray.count+1 + self.changeImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  {
    UINib *nib = [UINib nibWithNibName:@"LQPhotoViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"LQPhotoViewCell"];
     LQPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"LQPhotoViewCell" forIndexPath:indexPath];
//    [cell.profilePhoto sd_setImageWithURL:self.changeImages[2]];
    
    if (indexPath.row == self.LQPhotoPicker_smallImageArray.count + self.changeImages.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:@"plus.png"]];
        cell.closeButton.hidden = YES;
        //没有任何图片
        if (self.LQPhotoPicker_smallImageArray.count == 0) {
            
        }
        else{
            
        }
    }else{
        
        if (indexPath.row < self.changeImages.count) {
            NSDictionary *dic = self.changeImages[indexPath.item];
        [cell.profilePhoto sd_setImageWithURL:dic[@"originUrl"]];
        }else if(indexPath.row < self.changeImages.count + self.LQPhotoPicker_smallImageArray.count) {
            [cell.profilePhoto setImage:self.LQPhotoPicker_smallImageArray[indexPath.item - self.changeImages.count]];
        }else{
            
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
    NSLog(@"%ld", [indexPath item]);
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





- (void)changeCollectionViewHeight{
    if (self.collectionFrameY) {
        self.pickerCollectionView.frame = CGRectMake(0, self.collectionFrameY, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /3.0 +20.0)* ((int)(self.LQPhotoPicker_selectedAssetArray.count + self.changeImages.count)/3 +1)+20.0);
    }
    else{
        self.pickerCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /3.0 +20.0)* ((int)(self.LQPhotoPicker_selectedAssetArray.count + self.changeImages.count)/3 +1)+20.0);
    }
//    if (self.LQPhotoPicker_delegate && [self.LQPhotoPicker_delegate respondsToSelector:@selector(LQPhotoPicker_pickerViewFrameChanged)]) {
//        [self.LQPhotoPicker_delegate LQPhotoPicker_pickerViewFrameChanged];
//    }
    [self LQPhotoPicker_pickerViewFrameChanged];
}

- (void)getSelectImgWithALAssetArray:(NSArray*)ALAssetArray thumbnailImgImageArray:(NSArray*)thumbnailImgArray {
    //（ALAsset）类型 Array
    self.LQPhotoPicker_selectedAssetArray = [NSMutableArray arrayWithArray:ALAssetArray];
    //正方形缩略图 Array
    self.LQPhotoPicker_smallImageArray = [NSMutableArray arrayWithArray:thumbnailImgArray] ;
    
    [self.pickerCollectionView reloadData];
}

#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender{
    NSLog(@"%ld", sender.tag);
    if (sender.tag < self.changeImages.count) {
        [self.changeImages removeObjectAtIndex:sender.tag];
    }else {
        NSLog(@"%ld=====%ld", sender.tag , self.changeImages.count);
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
    self.LQPhotoPicker_imgMaxCount = 9-self.changeImages.count;
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
- (void)hhhhh {
    self.bgView.frame = CGRectMake(0, LQFrameY+LQHeight, Width, 700);
    [self.view endEditing:YES];
}

- (void)createView {
    NSInteger textFieldHeight = Width*0.1;
    
    
    self.logoBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_shangpingguanli_zutu_jiahao-拷贝"]];
    [self.logoBtn sd_setImageWithURL:[NSURL URLWithString:self.model.originUrl]];
    [self.container addSubview:self.logoBtn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedLogoAction:)];
    self.logoBtn.userInteractionEnabled = YES;
    
    [self.logoBtn addGestureRecognizer:tap];
    self.logoBtn.contentMode = UIViewContentModeScaleAspectFill;
    self.logoBtn.clipsToBounds = YES;
    //    self.logoBtn.backgroundColor = [UIColor clearColor];
    [self.logoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container);
        make.top.equalTo(self.container).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(200, 100));
    }];
    
    UILabel *promptLabel = [UILabel new];
    promptLabel.text = @"上传logo照片";
    promptLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:12];
    [self.container addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoBtn.mas_bottom).with.offset(Space);
        make.centerX.equalTo(self.container);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *lineV = [UILabel new];
    lineV.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.container addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (promptLabel.mas_bottom).with.offset(2);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(@(1));
    }];
    self.LQPhotoPicker_superView = self.scrollerView;
    self.LQPhotoPicker_imgMaxCount = 9-self.changeImages.count;
    [self LQPhotoPicker_initPickerView];
    self.LQPhotoPicker_delegate = self;
    [self LQPhotoPicker_updatePickerViewFrameY:150];   
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, LQFrameY+LQHeight, Width, 200)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.container addSubview:self.bgView];
    
    
    UILabel *goodsL = [UILabel new];
    goodsL.text = @"商品名称";
    goodsL.textColor = [UIColor colorWithHexString:kTitleColor];
    goodsL.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:goodsL];
    [goodsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).with.offset(Space);
        make.left.equalTo(self.bgView).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(80, textFieldHeight));
    }];
    self.goodsName = [[UITextField alloc] init];
    self.goodsName.delegate = self;
    self.goodsName.borderStyle = UITextBorderStyleLine;
    self.goodsName.font = [UIFont systemFontOfSize:kFirstFont];
    self.goodsName.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.goodsName.layer.borderWidth = 1.0;
    self.goodsName.text = self.model.goodsName;
    self.goodsName.placeholder = @"如:***10元超值套餐";
    self.goodsName.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.bgView addSubview:self.goodsName];
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodsL);
        make.left.equalTo(goodsL.mas_right).with.offset(Space/2);
        make.right.equalTo(self.bgView).with.offset(-20);
        make.height.mas_equalTo(@(textFieldHeight));
    }];
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.text = @"门市价:";
    priceLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    priceLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsName.mas_bottom).with.offset(Space);
        make.left.equalTo(self.bgView).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(80, textFieldHeight));
    }];
    
    
    
    self.priceText = [[UITextField alloc] init];
    self.priceText.delegate = self;
    self.priceText.borderStyle = UITextBorderStyleLine;
    self.priceText.font = [UIFont systemFontOfSize:kFirstFont];
    self.priceText.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.priceText.text = [NSString stringWithFormat:@"%.2f", self.model.price];
    self.priceText.placeholder = @"如:100元";
    self.priceText.layer.borderWidth = 1.0;
    self.priceText.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.bgView addSubview:self.priceText];
    [self.priceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel);
        make.left.equalTo(priceLabel.mas_right).with.offset(Space/2);
        make.right.equalTo(self.bgView).with.offset(-20);
        make.height.mas_equalTo(@(textFieldHeight));
    }];
    
    UILabel *newPriceLabel = [UILabel new];
    newPriceLabel.text = @"现价:";
    newPriceLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    newPriceLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:newPriceLabel];
    [newPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceText.mas_bottom).with.offset(Space);
        make.left.equalTo(self.bgView).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(80, textFieldHeight));
    }];
    self.newpriceText = [[UITextField alloc] init];
    self.newpriceText.delegate = self;
    self.newpriceText.placeholder = @"如:98元";
    self.newpriceText.text = [NSString stringWithFormat:@"%.2f", self.model.discountedPrice];
    self.newpriceText.font = [UIFont systemFontOfSize:kFirstFont];
    self.newpriceText.borderStyle = UITextBorderStyleLine;
    self.newpriceText.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.newpriceText.layer.borderWidth = 1.0;
    self.newpriceText.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.bgView addSubview:self.newpriceText];
    [self.newpriceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newPriceLabel);
        make.left.equalTo(newPriceLabel.mas_right).with.offset(Space/2);
        make.right.equalTo(self.bgView).with.offset(-20);
        make.height.mas_equalTo(@(textFieldHeight));
    }];
    
    
    UILabel *messageL = [UILabel new];
    messageL.text = @"商品描述:";
    messageL.textColor = [UIColor colorWithHexString:kTitleColor];
    messageL.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:messageL];
    [messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newpriceText.mas_bottom).with.offset(Space);
        make.left.equalTo(self.bgView).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(80, textFieldHeight));
    }];
    
    
    self.textView = [UITextView new];
    self.textView.delegate = self;
    self.textView.textColor = [UIColor colorWithHexString:kTitleColor];
    self.textView.text = self.model.content;
    self.textView.layer.borderWidth = 1.0;
    self.textView.font = [UIFont systemFontOfSize:kFirstFont];
    self.textView.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    [self.bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageL.mas_bottom).with.offset(Space/2);
        make.left.equalTo(self.view).with.offset(Space);
        make.right.equalTo(self.view).with.offset(-Space);
        make.height.mas_equalTo(@(80));
    }];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.text = @"有效期:";
    timeLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    timeLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).with.offset(Space);
        make.left.equalTo(self.bgView).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(80, textFieldHeight));
    }];
    
    self.startTime = [UITextField new];
    self.startTime.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.startTime.placeholder = @"如:2016-08-04";
    self.startTime .text = [self.model.startTime substringToIndex:10];
    self.startTime.font = [UIFont systemFontOfSize:kFirstFont];
    self.startTime.textColor = [UIColor colorWithHexString:kTitleColor];
    self.startTime.layer.borderWidth = 1.0;
    
    [self.bgView addSubview:self.startTime];
    
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(timeLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(Width*0.3, textFieldHeight));
    }];
    
    UILabel *toTimeLabel = [UILabel new];
    toTimeLabel.text = @"到";
    toTimeLabel.textAlignment = NSTextAlignmentCenter;
    toTimeLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    toTimeLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:toTimeLabel];
    [toTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(self.startTime.mas_right).with.offset(Space/2);
        make.size.mas_equalTo(CGSizeMake(20, textFieldHeight));
    }];
    
    self.endTime = [UITextField new];
    self.endTime.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.endTime.layer.borderWidth = 1.0;
    self.endTime.placeholder = @"2019-08-04";
    self.endTime.text = [self.model.endTime substringToIndex:10];
    self.endTime.font = [UIFont systemFontOfSize:kFirstFont];
    self.endTime.textColor = [UIColor colorWithHexString:kTitleColor];
   
    [self.bgView addSubview:self.endTime];
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(toTimeLabel.mas_right).with.offset(Space/2);
        make.size.mas_equalTo(CGSizeMake(Width*0.3, textFieldHeight));
    }];
    
    UILabel *useTimeLabel = [UILabel new];
    useTimeLabel.text = @"使用时间:";
    useTimeLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    useTimeLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:useTimeLabel];
    [useTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startTime.mas_bottom).with.offset(Space);
        make.left.equalTo(self.bgView).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(80, textFieldHeight));
    }];
    
    self.useStartTime = [UITextField new];
    self.useStartTime.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.useStartTime.placeholder = @"如:12:00";
    self.useStartTime.text = self.model.startuseTime;
    self.useStartTime.layer.borderWidth = 1.0;
    self.useStartTime.font = [UIFont systemFontOfSize:kFirstFont];
    self.useStartTime.textColor = [UIColor colorWithHexString:kTitleColor];
    
    [self.bgView addSubview:self.useStartTime];
    [self.useStartTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(useTimeLabel);
        make.left.equalTo(useTimeLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(Width*0.3, textFieldHeight));
    }];
    
   
    
    UILabel *toUseTimeLabel = [UILabel new];
    toUseTimeLabel.text = @"到";
    toUseTimeLabel.textAlignment = NSTextAlignmentCenter;
    toUseTimeLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    toUseTimeLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:toUseTimeLabel];
    [toUseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(useTimeLabel);
        make.left.equalTo(self.useStartTime.mas_right).with.offset(Space/2);
        make.size.mas_equalTo(CGSizeMake(20, textFieldHeight));
    }];
    
    
    self.useEndTime = [UITextField new];
    self.useEndTime.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.useEndTime.placeholder = @"23:59";
    self.useEndTime.text = self.model.enduseTime;
    self.useEndTime.layer.borderWidth = 1.0;
    self.useEndTime.font = [UIFont systemFontOfSize:kFirstFont];
    self.useEndTime.textColor = [UIColor colorWithHexString:kTitleColor];
    
    [self.bgView addSubview:self.useEndTime];
    
    
    [self.useEndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(useTimeLabel);
        make.left.equalTo(toUseTimeLabel.mas_right).with.offset(Space/2);
        make.size.mas_equalTo(CGSizeMake(Width*0.3, textFieldHeight));
    }];
    self.startTimeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //self.startTimeBtn.backgroundColor = [UIColor blueColor];
    [self.bgView addSubview:_startTimeBtn];
    [_startTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(timeLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(Width*0.3, textFieldHeight));
    }];
    [_startTimeBtn addTarget:self action:@selector(ChoseDate:) forControlEvents:(UIControlEventTouchUpInside)];
    self. endTimeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //self.endTimeBtn.backgroundColor = [UIColor blueColor];
    [self.bgView addSubview:_endTimeBtn];
    [_endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(toTimeLabel.mas_right).with.offset(Space/2);
        make.size.mas_equalTo(CGSizeMake(Width*0.3, textFieldHeight));
    }];
    [_endTimeBtn addTarget:self action:@selector(ChoseDate:) forControlEvents:(UIControlEventTouchUpInside)];
    self. useStartTimeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //self.useStartTimeBtn.backgroundColor = [UIColor blueColor];
    [self.bgView addSubview:_useStartTimeBtn];
    [_useStartTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(useTimeLabel);
        make.left.equalTo(useTimeLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(Width*0.3, textFieldHeight));
    }];
    [_useStartTimeBtn addTarget:self action:@selector(ChoseTime:) forControlEvents:(UIControlEventTouchUpInside)];
    self. useEndTimeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //self.useEndTimeBtn.backgroundColor = [UIColor blueColor];
    [self.bgView addSubview:_useEndTimeBtn];
    [_useEndTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(useTimeLabel);
        make.left.equalTo(toUseTimeLabel.mas_right).with.offset(Space/2);
        make.size.mas_equalTo(CGSizeMake(Width*0.3, textFieldHeight));
    }];
    [_useEndTimeBtn addTarget:self action:@selector(ChoseTime:) forControlEvents:(UIControlEventTouchUpInside)];
    UILabel *UseNum = [UILabel new];
    UseNum.text = @"使用人数:";
    UseNum.textAlignment = NSTextAlignmentLeft;
    UseNum.textColor = [UIColor colorWithHexString:kTitleColor];
    UseNum.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:UseNum];
    [UseNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.useStartTime.mas_bottom).with.offset(Space);
        make.left.equalTo(self.view).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(80, textFieldHeight));
    }];
    
    self.useNumber = [[UITextField alloc] init];
    self.useNumber.delegate= self;
    self.useNumber.text = self.model.suggestPeople;
    //self.useNumber.borderStyle = UITextBorderStyleLine;
     self.useNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.useNumber.font = [UIFont systemFontOfSize:kFirstFont];
    self.useNumber.placeholder = @"";
    self.useNumber.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.useNumber.layer.borderWidth = 1.0;
    self.useNumber.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.bgView addSubview:self.useNumber];
    [self.useNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(UseNum);
        make.left.equalTo(UseNum.mas_right);
        make.right.equalTo(self.bgView).with.offset(-20);
        make.height.mas_equalTo(@(textFieldHeight));
    }];
    
    UILabel *goodsNum = [UILabel new];
    goodsNum.text = @"库存(件):";
    goodsNum.textAlignment = NSTextAlignmentLeft;
    goodsNum.textColor = [UIColor colorWithHexString:kTitleColor];
    goodsNum.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:goodsNum];
    [goodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.useNumber.mas_bottom).with.offset(Space);
        make.left.equalTo(self.view).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(80, textFieldHeight));
    }];
    self.goodsNum = [[UITextField alloc] init];
    self.goodsNum.delegate = self;
    self.goodsNum.borderStyle = UITextBorderStyleLine;
    self.goodsNum.keyboardType = UIKeyboardTypeNumberPad;
     
    self.goodsNum.font = [UIFont systemFontOfSize:kFirstFont];
    self.goodsNum.placeholder = @"如:1000";
    self.goodsNum.text = [NSString stringWithFormat:@"%ld", (long)self.model.stock];
    self.goodsNum.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    self.goodsNum.layer.borderWidth = 1.0;
    self.goodsNum.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.bgView addSubview:self.goodsNum];
    [self.goodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodsNum);
        make.left.equalTo(goodsNum.mas_right);
        make.right.equalTo(self.bgView).with.offset(-20);
        make.height.mas_equalTo(@(textFieldHeight));
    }];
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.text = @"使用规则:";
    messageLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    messageLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [self.bgView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsNum.mas_bottom).with.offset(Space);
        make.left.equalTo(self.bgView).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(80, textFieldHeight));
    }];
    
    self.useTextView = [UITextView new];
    self.useTextView.delegate = self;
    self.useTextView.textColor = [UIColor colorWithHexString:kTitleColor];
    self.useTextView.text = @"";
    self.useTextView.font = [UIFont systemFontOfSize:kFirstFont];
    self.useTextView.layer.borderWidth = 1.0;
    self.useTextView.text =self.model.useRule;
    self.useTextView.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    [self.bgView addSubview:self.useTextView];
    [self.useTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLabel.mas_bottom).with.offset(Space/2);
        make.left.equalTo(self.view).with.offset(Space);
        make.right.equalTo(self.view).with.offset(-Space);
        make.height.mas_equalTo(@(80));
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.bgView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.useTextView.mas_bottom).with.offset(Space);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(Width-20, 40));
    }];
    
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 2;
    
//    CGRect rect = [[UIScreen mainScreen] bounds];
//    rect = CGRectMake(0.0, 0.0, rect.size.width, 216.0);
//    KMDatePicker *datePicker = [[KMDatePicker alloc]
//                                initWithFrame:rect
//                                delegate:self
//                                datePickerStyle:KMDatePickerStyleYearMonthDay];
//    self.startTime.inputView = datePicker;
//    self.startTime.delegate = self;
//    
//    datePicker =[[KMDatePicker alloc]
//                 initWithFrame:rect
//                 delegate:self
//                 datePickerStyle:KMDatePickerStyleYearMonthDay];
//    self.endTime.inputView = datePicker;
//    self.endTime.delegate = self;
//    
//    datePicker =[[KMDatePicker alloc]
//                 initWithFrame:rect
//                 delegate:self
//                 datePickerStyle:KMDatePickerStyleHourMinute];
//    self.useStartTime.inputView = datePicker;
//    self.useStartTime.delegate = self;
//    
//    datePicker =[[KMDatePicker alloc]
//                 initWithFrame:rect
//                 delegate:self
//                 datePickerStyle:KMDatePickerStyleHourMinute];
//    self.useEndTime.inputView = datePicker;
//    self.useEndTime.delegate = self;
//    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(10);
    }];


    
}
//设置选择照片的个数

- (void)selectedLogoAction:(UIButton *)sender {
    
    
    
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//    VC.imageType= OriginalImage;
    VC.zoom = 0.4;
    __weak typeof(self) weakSelf = self;
    
    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
//        _isiconUrl  = YES;
//        [weakSelf.iconUrlArr removeAllObjects];
//        [weakSelf.iconUrlArr addObject:image];
//        weakSelf. iconUrl.image = image;
        self.logoBtn.image = image;
    };
    [self presentViewController:VC animated:NO completion:^{
    }];
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [alertC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self selectedCameraOrLibray:UIImagePickerControllerSourceTypeCamera];
//    }]];
//    
//    [alertC addAction:[UIAlertAction actionWithTitle:@"相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self selectedCameraOrLibray:UIImagePickerControllerSourceTypePhotoLibrary];
//    }]];
//    
//    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }]];
//    
//    [self presentViewController:alertC animated:YES completion:nil];
}


- (void)selectedCameraOrLibray:(UIImagePickerControllerSourceType)type {
    //1.创建UIImagePickerController
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //2.设置图片选着的来源
    imagePicker.sourceType  = type;
    //3.设置代理人
    imagePicker.delegate = self;
    //4.确定当前选择的图片是否进行剪辑
    imagePicker.allowsEditing = YES;
    //5.进行界面间切换
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.logoBtn.image = image;
    
    
    
    //    [self saveImage:image withName:@"currentImage.png"];
}
//#pragma mark - 保存图片到本地
//- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
//    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    //将文件写入
//    [imageData writeToFile:fullPath atomically:NO];
//}


- (void)sureAction:(UIButton *)sender {
    [self.view endEditing:NO];
    
    
    
    if ([self.logoBtn.image isEqual:[UIImage imageNamed:@"icon_shangpingguanli_zutu_jiahao-拷贝"]]){
        [self showToast:@"请选择logo图片"];
        return;
    }
    if (self.goodsName.text.length == 0) {
        [self showToast:@"请输入商品名称"];
        return;
    }
    if (self.priceText.text.length == 0||[self.priceText.text isEqualToString:@"0"]) {
        [self showToast:@"请输入商品价格"];
        return;
    }
    if (self.newpriceText.text.length == 0||[self.newpriceText.text isEqualToString:@"0"]) {
        [self showToast:@"请输入门市价格"];
        return;
    }
    if (self.textView.text.length == 0) {
        [self showToast:@"请输入商品描述"];
        return;
    }
    if (self.startTime.text.length == 0) {
        [self showToast:@"请选择开始时间"];
        return;
    }
    if (self.endTime.text.length == 0) {
        [self showToast:@"请输入结束时间"];
        return;
    }
    
    NSString * startTimeStr = [self.startTime.text substringToIndex:10];
    
    NSString *a = [startTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];//该方法是去掉指定符号
    NSString * endTimeStr = [self.endTime.text substringToIndex:10];
    NSString *b = [endTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];//该方法是去掉指定符号
    
    
    if ([a intValue]>[b intValue  ]) {
        [self showToast:@"上架时间不能晚于下架时间"];
        return;
    }else{
        
    }
    
    
    if (self.useStartTime.text.length == 0) {
        [self showToast:@"请选择开始使用时间"];
        return;
    }
    if (self.useEndTime.text.length == 0) {
        [self showToast:@"请选择结束使用时间"];
        return;
    }
    if (self.goodsNum.text.length == 0) {
        [self showToast:@"请输入库存数量"];
        return;
    }
    if (self.goodsNum.text.length == 0) {
        [self showToast:@"请输入库存数量"];
        return;
    }
    if (self.useTextView.text.length == 0) {
        [self showToast:@"请输入使用规则"];
        return;
    }
    if (self.priceText.text.length == 0){
        [self showToast:@"请输入金额"];
        
        return;
        //        NSString *price = self.priceText.text;
        //        NSRange range  = [price rangeOfString:@"."];
        //        NSString *priceFloat = [price substringFromIndex:range.location+1];
        //        NSString *newPrice = self.newpriceText.text;
        //        NSRange newRange = [newPrice rangeOfString:@"."];
        //        NSString *newPriceF = [newPrice substringToIndex:newRange.location+1];
        //        if (priceFloat.length > 2 || newPriceF.length > 2) {
        //            [self showToast:@"输入金额只能精确到角"];
        //            return;
        //        }
    }
    if (self.newpriceText.text.length == 0){
        [self showToast:@"请输入金额"];
        return;
    }

//    if ([self.logoBtn.image isEqual:[UIImage imageNamed:@"icon_shangpingguanli_zutu_jiahao-拷贝"]]){
//        [self showToast:@"请选择logo图片"];
//        return;
//    }
    [self.imagesArr removeAllObjects];
    for (NSDictionary * dic in self.changeImages) {
        [self.imagesArr addObject:dic];
    }
    self.imagesArr = [self LQPhotoPicker_getSmallImageArray];
    [self.imagesArr addObject:self.logoBtn.image];
    [self commitImage];
}

- (void)commitImage {
    [self showProgress];
    DWHelper *helper = [DWHelper shareHelper];
    NSLog(@"%@, %@", helper.configModel.image_password, helper.configModel.image_account);
    [self showProgress];
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
     self.view.userInteractionEnabled = NO;
    [manager POST:helper.configModel.image_hostname parameters:[upload yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < self.imagesArr.count; i++) {
            //NSData *data = UIImageJPEGRepresentation(self.imagesArr[i], 0.5);
            UIImage * image =  [UIImage scaleImageAtPixel:self.imagesArr [i] pixel:1024];
            //1.把图片转换成二进制流
            NSData *imageData= [ UIImage scaleImage:image toKb:70];
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d", i] fileName:[NSString stringWithFormat:@"curr%d.png", i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:responseObject];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:baseRes.data];
        [self settingMessage:arr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         self.view.userInteractionEnabled = YES;
        [self hideProgress];
    }];
    
}

- (void)settingMessage:(NSMutableArray *)imageArr {
    RequestUpdateGoods *goods = [[RequestUpdateGoods alloc] init];
    goods.goodsName = self.goodsName.text;
    //    goods.price = [self.priceText.text floatValue];
    goods.price = self.priceText.text ;
    goods.discountedPrice = self.newpriceText.text ;
    goods.content = self.textView.text;
    goods.stock = self.goodsNum.text;
    goods.suggestPeople = self.useNumber.text;
    goods.startTime = self.startTime.text;
    goods.endTime = self.endTime.text;
    goods.useRule = self.useTextView.text;
    goods.startuseTime = self.useStartTime.text;
    goods.enduseTime = self.useEndTime.text;
    goods.goodsId =self.model.goodsId;
    goods.originUrl = [[imageArr objectAtIndex:imageArr.count-1] objectForKey:@"originUrl"];
    goods.smallUrl = [[imageArr objectAtIndex:imageArr.count-1] objectForKey:@"smallUrl"];
    goods.middleUrl = [[imageArr objectAtIndex:imageArr.count-1] objectForKey:@"middleUrl"];
    [imageArr removeLastObject];
    for (NSDictionary *dic in self.changeImages) {
        [imageArr addObject:dic];
    }
    goods.images = [NSArray arrayWithArray:imageArr];
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[goods yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestUpdateGoods" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self hideProgress];
            [self showToast:@"修改成功"];
            self.backBlackAction(nil);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
             self.view.userInteractionEnabled = YES;
            [ self showToast:baseRes.msg];
            [self hideProgress];

        }
        
    } faild:^(id error) {
         self.view.userInteractionEnabled = YES;
         [self hideProgress];
    }];
}


- (void)LQPhotoPicker_pickerViewFrameChanged {
   // self.bgView.backgroundColor = [UIColor yellowColor];
    self.bgView.frame = CGRectMake(0, LQFrameY+LQHeight, Width, 700);
}

- (void)showToast:(NSString *)text{
    [self.view hideToastActivity];
    [self.view makeToast:text duration:1.5 position:CSToastPositionCenter];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
     _txtFCurrent = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  
}

- (void)textViewDidEndEditing:(UITextView *)textView {
}


#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    if ([self.txtFCurrent isEqual:self.startTime] || [self.txtFCurrent isEqual:self.endTime]) {
        _txtFCurrent.text = [NSString stringWithFormat:@"%@-%@-%@", datePickerDate.year,
                             datePickerDate.month,
                             datePickerDate.day];
    }
    if ([self.txtFCurrent isEqual:self.useStartTime] || [self.txtFCurrent isEqual:self.useEndTime]) {
        _txtFCurrent.text = [NSString stringWithFormat:@"%@:%@", datePickerDate.hour,
                             datePickerDate.minute];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)imagesArr {
    if (!_imagesArr) {
        self.imagesArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesArr;
}

- (NSMutableArray *)changeImages {
    if (!_changeImages) {
        self.changeImages = [NSMutableArray arrayWithCapacity:0];
    }
    return _changeImages;
}


- (void)hideProgress{
    [SVProgressHUD dismiss];
}
- (void)showProgress{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"修改商品中..."];
}
#pragma mark - 日期
- (void)ChoseDate:(UIButton *)sender {
    [self.view endEditing:NO];
    if ([sender isEqual: self.startTimeBtn]) {
        self.dateStr = @"1";
    }else if([sender isEqual: self.endTimeBtn]){
        self.dateStr = @"2";

    }
    if (!dater) {
        dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
        dater.delegate=self;
        [dater showInView:self.view animated:YES];
        dater.dateViewType=XFDateViewTypeDate;
    }else{
        [dater showInView:self.view animated:YES];
    }
    
}
#pragma mark - 时间
- (void)ChoseTime:(UIButton *)sender {
    [self.view endEditing:NO];
    if ([sender isEqual: self.useStartTimeBtn]) {
        self.timeStr = @"1";
    }else if([sender isEqual: self.useEndTimeBtn]){
        self.timeStr = @"2";
        
    }
    if (!timer) {
        timer=[[XFDaterView alloc]initWithFrame:CGRectZero];
        timer.delegate=self;
        [timer showInView:self.view animated:YES];
        timer.dateViewType=XFDateViewTypeTime;
    }else{
        [timer showInView:self.view animated:YES];
    }
}

#pragma mark -
- (void)daterViewDidClicked:(XFDaterView *)daterView{
    if ([daterView isEqual:dater]) {
        if ([self.dateStr isEqualToString:@"1"]) {
            self.startTime.text =daterView.dateString;
        }else if([self.dateStr isEqualToString:@"2"]){
            self.endTime.text =daterView.dateString;

        }
       
        
    }
    if ([daterView isEqual:timer]) {
        if ([self.timeStr isEqualToString:@"1"]) {
            self.useStartTime.text =[NSString stringWithFormat:@"%@",[daterView.timeString substringToIndex:5]] ;
        }else if([self.timeStr isEqualToString:@"2"]){
                self.useEndTime.text =[NSString stringWithFormat:@"%@",[daterView.timeString substringToIndex:5]];
        }

        //self.time.text = [NSString stringWithFormat:@"%@",[daterView.timeString substringToIndex:5]] ;
    }
    
    
}
#pragma mark -  日历取消
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    
    
    
    
}



//判断输入钱的正则表达式，可输入正负，小数点前5位，小数点后2位，位数可控
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.priceText isEqual:textField]||[self.newpriceText isEqual:textField]) {
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toString.length > 0) {
            NSString *stringRegex = @"(\\+)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
            BOOL flag = [phoneTest evaluateWithObject:toString];
            if (!flag) {
                return NO;
            }
        }
        return YES;
    }
    
    if ([self.useNumber isEqual:textField]||[self.goodsNum isEqual:textField]) {
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toString.length > 0) {
            NSString *stringRegex = @"^([1-9]\\d{0,9})$";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
            BOOL flag = [phoneTest evaluateWithObject:toString];
            if (!flag) {
                return NO;
            }
        }
        return YES;
    }

    
    
    
    return YES;
    
    
    
}



@end

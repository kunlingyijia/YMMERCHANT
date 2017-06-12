//
//  CompletionDataVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "CompletionDataVC.h"

//
//  WriteMessageViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/8/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "WriteMessageViewController.h"
#import "ShopKindView.h"
#import "ShopGroupView.h"
#import "SettingShowView.h"
#import "RequestCateAndBusinessarea.h"
#import "RequestCateAndBusinessareaModel.h"
#import "BusinessareaModel.h"
#import "Imageupload.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "RequestMerchantCompleteInfo.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "KindView.h"
#import "GroupVC.h"
#import "BusinessVC.h"
#define LQHeight [self LQPhotoPicker_getPickerViewFrame].size.height
#define LQFrameY [self LQPhotoPicker_getPickerViewFrame].origin.y
@interface CompletionDataVC ()<LQPhotoPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,AMapLocationManagerDelegate>{
    KindView * kindView;
}
//定位
@property (nonatomic ,strong) AMapLocationManager *locationManager;

//@property (nonatomic, strong) ShopKindView *kindBgview;
//@property (nonatomic, strong) ShopGroupView *groupBgview;
@property (nonatomic, strong) UIImageView *logoImage;

@property (nonatomic, strong) SettingShowView *settingBgview;
@property (nonatomic, strong) UIView *bottomBgview;
@property (nonatomic, strong) UITextField *longText;
@property (nonatomic, strong) UITextField *latText;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *selectedLogo;
@property (nonatomic, strong) NSMutableArray *kindArr;
@property (nonatomic, assign) NSInteger kindIndex;
@property (nonatomic, strong) NSMutableArray *groupArr;
@property (nonatomic, assign) NSInteger groupIndex;
@property (nonatomic, strong) UILabel *shopImageArr;
@property (nonatomic, strong) NSMutableArray *commitImageArr;
@property (nonatomic, strong) NSMutableArray *bmChild;
//商家设置
@property (nonatomic, assign) NSInteger haveWifi;
@property (nonatomic, assign) NSInteger havaNoSmokingRoom;
@property (nonatomic, assign) NSInteger havaAirCondition;
@property (nonatomic, assign) NSInteger haveParking;
@property (nonatomic, assign) NSInteger have24hourWater;
//分类Id
@property(nonatomic,strong)NSString * merchantCategoryId;
//商圈id(非必填)
@property(nonatomic,strong)NSString *businessAreaId;


@end

@implementation CompletionDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"补全资料";
    self.merchantCategoryId = @"";
    self.businessAreaId = @"";
    [self showBackBtn];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollerView.backgroundColor = [UIColor whiteColor];
    self.scrollerView = [UIScrollView new];
    self.scrollerView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollerView];
    __weak typeof(self) weakSelf = self;

    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    self.container = [UIView new];
    //self.container.backgroundColor = [UIColor redColor];
    self.container.userInteractionEnabled = YES;
    [self.scrollerView addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollerView);
        make.width.equalTo(weakSelf.scrollerView);
    }];
    
    //[self getKindData];
    //获取商圈和分类
    [self requestCateAndBusinessarea];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopSetting:) name:@"商家设置" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopKind:) name:@"商户类型" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupKind:) name:@"商户类型" object:nil];
    //创建观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SubGroupVC:) name:@"SubGroupVC" object:nil];
    //创建观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BusinessVC:) name:@"BusinessVC" object:nil];
    
}
#pragma mark - 创建观察者返回数据
-(void)SubGroupVC:(NSNotification*)sender{
    NSDictionary * dic = [sender.userInfo objectForKey:@"SubGroupVC"];
    NSLog(@"%@",dic);
    [kindView.OneBtn setTitle:dic[@"categoryName"] forState:(UIControlStateNormal)];
     self.merchantCategoryId = dic[@"merchantCategoryId"];
    

}
#pragma mark - 创建观察者返回数据
-(void)BusinessVC:(NSNotification*)sender{
    NSDictionary * dic = [sender.userInfo objectForKey:@"BusinessVC"];
    NSLog(@"%@",dic);
    [kindView.TwoBtn setTitle:dic[@"name"] forState:(UIControlStateNormal)];
   self.businessAreaId = dic[@"businessAreaId"];
    
}
- (void)groupKind:(NSNotification *)sender {
    NSDictionary *dic = sender.userInfo;
    NSNumber *numberTag = dic[@"商户类型"];
    self.groupIndex = [numberTag integerValue];
}
- (void)shopKind:(NSNotification *)sender {
    NSDictionary *dic = sender.userInfo;
    NSNumber *numberTag = dic[@"商户类型"];
    self.kindIndex = [numberTag integerValue];
}
- (void)shopSetting:(NSNotification *)sender {
    NSDictionary *dic = sender.userInfo;
    NSNumber *numberTag = dic[@"商家设置"];
    NSInteger btnTag = [numberTag integerValue];
    switch (btnTag/100) {
        case 2:
            if (btnTag%100 == 0) {
                self.haveWifi = 0;
            }else {
                self.haveWifi = 1;
            }
            break;
        case 3:
            if (btnTag%100 == 0) {
                self.havaNoSmokingRoom = 0;
            }else {
                self.havaNoSmokingRoom = 1;
            }
            break;
        case 4:
            if (btnTag%100 == 0) {
                self.havaAirCondition = 0;
            }else {
                self.havaAirCondition = 1;
            }
            break;
        case 5:
            if (btnTag%100 == 0) {
                self.haveParking = 0;
            }else {
                self.haveParking = 1;
            }
            break;
        case 6:
            if (btnTag%100 == 0) {
                self.have24hourWater = 0;
            }else {
                self.have24hourWater = 1;
            }
            break;
        default:
            break;
    }
}

- (void)createView {
    [self initView];
}

- (void)initView {
    self.haveWifi = 0;
    self.havaNoSmokingRoom = 0;
    self.haveParking = 0;
    self.havaAirCondition = 0;
    self.have24hourWater = 0;
    self.kindIndex = 0;
    
    
    
    
    
    __weak typeof(self) weakSelf = self;

    DWHelper *helper = [DWHelper shareHelper];
    if (helper.shopType == 2) {
        kindView  =   [NIBHelper instanceFromNib:@"KindView"];
        
        
        [self.container addSubview:kindView];
        
        
        
        [kindView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.container).with.offset(5);
            make.right.equalTo(weakSelf.container);
            make.left.equalTo(weakSelf.container);
            make.height.mas_equalTo(0.2*Width+1.5);
            
            
        }];
    }else {
        kindView  =   [NIBHelper instanceFromNib:@"KindView"];
        [self.container addSubview:kindView];
        
        
        
        [kindView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.container).with.offset(5);
            make.right.equalTo(weakSelf.container);
            make.left.equalTo(weakSelf.container);
            make.height.mas_equalTo(0.2*Width+1.5);
            
            
        }];
        
    }
    
    kindView.KindViewBlock= ^(NSInteger tag){
        switch (tag) {
            case 0:
            {
                //Push 跳转
                GroupVC * VC = [[GroupVC alloc]initWithNibName:@"GroupVC" bundle:nil];
                VC.dataArray = weakSelf.kindArr;
                NSLog(@"%@",VC.dataArray);
                [weakSelf.navigationController  pushViewController:VC animated:YES];

                
                
                break;
            }
                
            case 1:
            {
                
                //Push 跳转
                BusinessVC * VC = [[BusinessVC alloc]initWithNibName:@"BusinessVC" bundle:nil];
                VC.dataArray = weakSelf.groupArr;
                NSLog(@"%@",VC.dataArray);
                [weakSelf.navigationController  pushViewController:VC animated:YES];
                break;
            }
                
                
                
                
            default:{
                
                break;
                
            }
        }
        
        
    };

    
    
    UILabel *shopLogo = [UILabel new];
    shopLogo.text = @"店铺logo";
    shopLogo.textAlignment = NSTextAlignmentRight;
    shopLogo.textColor = [UIColor colorWithHexString:@"#333333"];
    shopLogo.font  = [UIFont systemFontOfSize:14];
    [self.container addSubview:shopLogo];
    [shopLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kindView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.container).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    [shopLogo layoutIfNeeded];
    
    
    
    self.logoImage = [UIImageView new];
    self.logoImage.image = [UIImage imageNamed:@"plus"];
    [self.container addSubview:self.logoImage];
    
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.container.mas_centerX);
        make.top.equalTo(shopLogo.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [self.logoImage layoutIfNeeded];

    self.selectedLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectedLogo.backgroundColor = [UIColor clearColor];
//    self.selectedLogo.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    //[self.selectedLogo setTitle:@"上传图片" forState:UIControlStateNormal];
    [self.selectedLogo addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.selectedLogo setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.selectedLogo.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.selectedLogo.layer.masksToBounds = YES;
//    self.selectedLogo.layer.cornerRadius = 4;
//    self.selectedLogo.layer.borderColor = [UIColor colorWithHexString:@"#aaaaaa"].CGColor;
//    self.selectedLogo.layer.borderWidth = 1;
    [self.container addSubview:self.selectedLogo];
    [self.selectedLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.logoImage.mas_centerX);
        make.top.equalTo(weakSelf.logoImage.mas_top).offset(0);
       
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [self.selectedLogo layoutIfNeeded];
    self.shopImageArr = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.2*Width+ 160, 60, 20)];
    
    self.shopImageArr.text = @"店铺相册";
    self.shopImageArr.textAlignment = NSTextAlignmentRight;
    self.shopImageArr.textColor = [UIColor colorWithHexString:@"#333333"];
    self.shopImageArr.font  = [UIFont systemFontOfSize:14];
    [self.container addSubview:self.shopImageArr];
    
    
    self.LQPhotoPicker_superView = self.container;
    self.LQPhotoPicker_imgMaxCount = 10;
    [self LQPhotoPicker_initPickerView];
    self.LQPhotoPicker_delegate = self;
    [self.logoImage layoutIfNeeded];
    [self lLQPhotoPicker_updatePickerViewFrameY:self.shopImageArr.frame.origin.y];
    self.settingBgview = [[SettingShowView alloc] initWithFrame:CGRectMake(0, LQFrameY+LQHeight+20, Width, 190) withIsBm:1];
    [self.container addSubview:self.settingBgview];
    
    
    self.bottomBgview = [[UIView alloc] init];
    [self.container addSubview:self.bottomBgview];
    [self.bottomBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.settingBgview.mas_bottom);
        make.right.left.equalTo(weakSelf.container);
        make.height.mas_equalTo(@(400));
    }];
    UIView *foruLine = [UIView new];
    foruLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.bottomBgview addSubview:foruLine];
    [foruLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(weakSelf.bottomBgview);
        make.height.mas_equalTo(@(1));
    }];
    
    UIButton *getAdress = [UIButton buttonWithType:UIButtonTypeCustom];
    getAdress.backgroundColor = [UIColor colorWithHexString:@"#fc9e18"];
    getAdress.titleLabel.font = [UIFont systemFontOfSize:12];
    [getAdress setTitle:@"点击自动获取经纬度" forState:UIControlStateNormal];
    [getAdress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getAdress.layer.masksToBounds = YES;
    getAdress.layer.cornerRadius = 4;
    [getAdress addTarget:self action:@selector(getAdressAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBgview addSubview:getAdress];
    [getAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(foruLine).with.offset(10);
        make.left.equalTo(weakSelf.bottomBgview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 35));
    }];
    
    UILabel *longLabel = [UILabel new];
    longLabel.text = @"经度";
    longLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    longLabel.font = [UIFont systemFontOfSize:14];
    longLabel.textAlignment = NSTextAlignmentRight;
    [self.bottomBgview addSubview:longLabel];
    [longLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getAdress.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.bottomBgview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    self.longText = [UITextField new];
    self.longText.placeholder = @"例:125.333";
    self.latText.userInteractionEnabled = NO;
    self.longText.textColor = [UIColor colorWithHexString:kTitleColor];
    self.longText.font = [UIFont systemFontOfSize:14];
    self.longText.borderStyle = UITextBorderStyleNone;
    self.longText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.longText.leftViewMode = UITextFieldViewModeAlways;
    self.longText.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
    self.longText.layer.borderWidth = 1;
    [self.bottomBgview addSubview:self.longText];
    [self.longText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(longLabel);
        make.left.equalTo(longLabel.mas_right).with.offset(5);
        make.right.equalTo(weakSelf.bottomBgview).with.offset(-10);
        make.height.mas_equalTo(@(40));
    }];
    
    UILabel *lonShow = [UILabel new];
    lonShow.text = @"*经度,例:125.333,必须含小数且小数位数1-6位数";
    lonShow.font = [UIFont systemFontOfSize:12];
    lonShow.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    [self.bottomBgview addSubview:lonShow];
    [lonShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.longText.mas_bottom);
        make.left.right.equalTo(weakSelf.longText);
        make.height.mas_equalTo(@(20));
    }];
    
    UILabel *latLabel = [UILabel new];
    latLabel.text = @"纬度";
    latLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    latLabel.font = [UIFont systemFontOfSize:14];
    latLabel.textAlignment = NSTextAlignmentRight;
    [self.bottomBgview addSubview:latLabel];
    [latLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lonShow.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.bottomBgview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    self.latText = [UITextField new];
    self.latText.placeholder = @"例:125.333";
    self.latText.userInteractionEnabled = NO;
    self.latText.textColor = [UIColor colorWithHexString:kTitleColor];
    self.latText.font = [UIFont systemFontOfSize:14];
    self.latText.borderStyle = UITextBorderStyleNone;
    self.latText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.latText.leftViewMode = UITextFieldViewModeAlways;
    self.latText.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
    self.latText.layer.borderWidth = 1;
    [self.bottomBgview addSubview:self.latText];
    [self.latText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(latLabel);
        make.left.equalTo(latLabel.mas_right).with.offset(5);
        make.right.equalTo(weakSelf.bottomBgview).with.offset(-10);
        make.height.mas_equalTo(@(40));
    }];
    
    UILabel *latShow = [UILabel new];
    latShow.text = @"*纬度,例:125.333,必须含小数且小数位数1-6位数";
    latShow.font = [UIFont systemFontOfSize:12];
    latShow.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    [self.bottomBgview addSubview:latShow];
    [latShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.latText.mas_bottom);
        make.left.right.equalTo(weakSelf.latText);
        make.height.mas_equalTo(@(20));
    }];
    
    
    UILabel *shopMessage = [UILabel new];
    shopMessage.text = @"门店介绍";
    shopMessage.textColor = [UIColor colorWithHexString:@"#333333"];
    shopMessage.font = [UIFont systemFontOfSize:14];
    shopMessage.textAlignment = NSTextAlignmentRight;
    [self.bottomBgview addSubview:shopMessage];
    [shopMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(latShow.mas_bottom).with.offset(10);
        make.left.equalTo(self.bottomBgview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    self.textView = [UITextView new];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#aaaaaa"].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.bottomBgview addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopMessage);
        make.left.equalTo(shopMessage.mas_right).with.offset(5);
        make.right.equalTo(self.bottomBgview.mas_right).with.offset(-10);
        make.height.mas_equalTo(@(100));
    }];
    
    UILabel *textShow = [UILabel new];
    textShow.text = @"*必填";
    textShow.font = [UIFont systemFontOfSize:12];
    textShow.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    [self.bottomBgview addSubview:textShow];
    [textShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.left.right.equalTo(self.textView);
        make.height.mas_equalTo(@(20));
    }];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [sureBtn setTitle:@"立即申请" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    [sureBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBgview addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textShow.mas_bottom).with.offset(10);
        make.left.equalTo(self.bottomBgview).with.offset(20);
        make.right.equalTo(self.bottomBgview).with.offset(-20);
        make.height.mas_equalTo(@(40));
    }];
    
    
    [self.bottomBgview layoutIfNeeded];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomBgview.mas_bottom);
    }];
    
}
- (void)commitAction:(UIButton *)sender {
    if (self.logoImage.image ==  nil){
        [self showToast:@"请选择logo图片"];
        return;
    }
    if (self.merchantCategoryId.length==0) {
        [self showToast:@"请选择分类"];
        return;
    }
    if (self.latText.text.length==0) {
        [self showToast:@"请选择经纬度"];
        return;
    }
    if (self.textView.text.length==0) {
        [self showToast:@"请输入门店介绍"];
        return;
    }
    
    self.commitImageArr = [self LQPhotoPicker_getSmallImageArray];
    [self.commitImageArr addObject:self.logoImage.image];
    [self commitImage];
}

- (void)commitImage {
    
    DWHelper *helper = [DWHelper shareHelper];
    NSLog(@"%@, %@", helper.configModel.image_password, helper.configModel.image_account);
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
    //    NSString *pram = [phothBaseReq yy_modelToJSONString];
    [self showProgress];
    [manager POST:helper.configModel.image_hostname parameters:[upload yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < self.commitImageArr.count; i++) {
            //NSData *data = UIImageJPEGRepresentation(self.commitImageArr[i], 0.5);
            UIImage * image =  [UIImage scaleImageAtPixel:self.commitImageArr[i] pixel:1024];
            //1.把图片转换成二进制流
            NSData *imageData= [ UIImage scaleImage:image toKb:70];
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d", i] fileName:[NSString stringWithFormat:@"commit%d.png", i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:responseObject];
        NSLog(@"%@", responseObject);
        NSMutableArray *arr = [NSMutableArray arrayWithArray:baseRes.data];
        [self settingMessage:arr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgress];
    }];
}
- (void)settingMessage:(NSMutableArray *)arr {
    RequestMerchantCompleteInfo *info = [[RequestMerchantCompleteInfo alloc] init];
    NSLog(@"self.kindArr---%@",self.kindArr) ;
//    RequestCateAndBusinessareaModel *model;
//    if (self.kindArr.count != 0) {
//        model = self.kindArr[self.kindIndex];
//    }
//    
//    if (self.groupArr.count == 0) {
//        
//    }else {
//        BusinessareaModel *bussModel = self.groupArr[self.groupIndex];
//        info.businessAreaId = bussModel.businessAreaId;
//    }
    
   
    info.merchantCategoryId = self.merchantCategoryId;
    info.businessAreaId = self.businessAreaId;
    info.iconUrl = [arr lastObject];
    [arr removeLastObject];
    info.images = arr;
    info.haveWifi = self.haveWifi;
    info.havaNoSmokingRoom = self.havaNoSmokingRoom;
    info.havaAirCondition = self.havaAirCondition;
    info.haveParking = self.haveParking;
    info.have24hourWater = self.have24hourWater;
    info.lng = [self.longText.text doubleValue];
    info.lat = [self.latText.text doubleValue];
    info.content = self.textView.text;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token= [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[info yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestMerchantCompleteInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self hideProgress];
            [self showToast:@"提交成功"];
            self.backAction(nil);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [self showToast:baseRes.msg];
            [self hideProgress];

        }
        
    } faild:^(id error) {
        [self hideProgress];
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - 获取当前经纬度
- (void)getAdressAction:(UIButton *)sender {
    [self.locationManager startUpdatingLocation];
    [self showAdressProgress];
}

- (void)locationAction {
    
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    self.longText.text = [NSString stringWithFormat:@"%.6f", location.coordinate.longitude];
    self.latText.text = [NSString stringWithFormat:@"%.6f", location.coordinate.latitude];
    [self hideProgress];
    [self showToast:@"定位成功"];
    [self.locationManager stopUpdatingLocation];
    
}
#pragma mark - 选择商户logo
- (void)selectedAction:(UIButton*)sender{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addAction:[UIAlertAction actionWithTitle:@"选择相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectedCameraOrLibray:UIImagePickerControllerSourceTypeCamera];
        
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"选择相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectedCameraOrLibray:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alertC animated:YES completion:nil];
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
    self.logoImage.image = image;
    
    [self lLQPhotoPicker_updatePickerViewFrameY:self.logoImage.frame.origin.y+self.logoImage.frame.size.height+5];
    [self settingFrame];
}

- (void)settingFrame {
    self.shopImageArr.frame = CGRectMake(10, self.logoImage.frame.origin.y+self.logoImage.frame.size.height+35, 60, 20);
    self.settingBgview.frame = CGRectMake(0, LQFrameY+LQHeight, Width, 190);
}

#pragma mark - 添加相册方法
- (void)lLQPhotoPicker_updatePickerViewFrameY:(CGFloat)Y{
    self.collectionFrameY = Y;
    self.pickerCollectionView.frame = CGRectMake(75, self.collectionFrameY, [UIScreen mainScreen].bounds.size.width-75, (((float)[UIScreen mainScreen].bounds.size.width-64.0-75) /3.0 +20.0)* ((int)(self.LQPhotoPicker_selectedAssetArray.count)/3 +1)+20.0);
    
}

- (void)LQPhotoPicker_pickerViewFrameChanged {
    self.settingBgview.frame = CGRectMake(0, LQFrameY+LQHeight, Width, 200);
    [self.bottomBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settingBgview.mas_bottom);
        make.right.left.equalTo(self.container);
        make.height.mas_equalTo(@(400));
    }];
}
#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight{
    if (self.collectionFrameY) {
        self.pickerCollectionView.frame = CGRectMake(75, self.collectionFrameY, [UIScreen mainScreen].bounds.size.width-75, (((float)[UIScreen mainScreen].bounds.size.width-64.0-75) /3.0 +20.0)* ((int)(self.LQPhotoPicker_selectedAssetArray.count)/3 +1)+20.0);
    }
    else{
        self.pickerCollectionView.frame = CGRectMake(75, 0, [UIScreen mainScreen].bounds.size.width-75, (((float)[UIScreen mainScreen].bounds.size.width-64.0-75) /3.0 +20.0)* ((int)(self.LQPhotoPicker_selectedAssetArray.count)/3 +1)+20.0);
    }
    if (self.LQPhotoPicker_delegate && [self.LQPhotoPicker_delegate respondsToSelector:@selector(LQPhotoPicker_pickerViewFrameChanged)]) {
        [self.LQPhotoPicker_delegate LQPhotoPicker_pickerViewFrameChanged];
    }
}

- (void)LQPhotoPicker_updatePickerViewFrameY:(CGFloat)Y{
    self.collectionFrameY = Y;
    self.pickerCollectionView.frame = CGRectMake(75, Y, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /3.0 +20.0)* ((int)(self.LQPhotoPicker_selectedAssetArray.count)/3 +1)+20.0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-64 - 75) /3 ,([UIScreen mainScreen].bounds.size.width-64 - 75) /3);
}


#pragma mark - Networking
//获取商圈 商家分类
- (void)getKindData {
    RequestCateAndBusinessarea *cate = [[RequestCateAndBusinessarea alloc] init];
    cate.regionId = self.shopModel.regionId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.data = cate;
    baseReq.encryptionType = RequestMD5;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestCateAndBusinessarea" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        
        if (baseRes.resultCode == 1) {
            NSArray *category = baseRes.data[@"category"];
            for (NSDictionary *dic in category) {
                RequestCateAndBusinessareaModel *categoryModel = [RequestCateAndBusinessareaModel yy_modelWithDictionary:dic];
                if (categoryModel.isBmin == 1) {
                    for (NSDictionary *bmdic in categoryModel._child) {
                        RequestCateAndBusinessareaModel *bmModel = [RequestCateAndBusinessareaModel yy_modelWithDictionary:bmdic];
                        [self.bmChild addObject:bmModel];
                    }
                }else {
                    [self.kindArr addObject:categoryModel];
                }
            }
            NSArray *businessarea = baseRes.data[@"businessarea"];
            for (NSDictionary *dic in businessarea) {
                BusinessareaModel *model = [BusinessareaModel yy_modelWithDictionary:dic];
                [self.groupArr addObject:model];
            }
        }
        [self createView];
    } faild:^(id error) {
        
    }];
    
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


#pragma mark - PrivateFun

- (NSMutableArray *)kindArr {
    if (!_kindArr) {
        self.kindArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _kindArr;
}
- (NSMutableArray *)groupArr {
    if (!_groupArr) {
        self.groupArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _groupArr;
}
- (NSMutableArray *)commitImageArr {
    if (!_commitImageArr) {
        self.commitImageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _commitImageArr;
}


- (NSMutableArray *)bmChild {
    if (!_bmChild) {
        self.bmChild = [NSMutableArray arrayWithCapacity:0];
    }
    return _bmChild;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)showToast:(NSString *)text{
    [self.view hideToastActivity];
    [self.view makeToast:text duration:1.5 position:CSToastPositionCenter];
}
- (void)hideProgress{
    [SVProgressHUD dismiss];
}
- (void)showProgress{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中..."];
}
- (void)showAdressProgress{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"定位中..."];
}
#pragma mark -  获取商家分类以及商圈(新增)
-(void)requestCateAndBusinessarea{
    ;
    RequestCateAndBusinessarea *cate = [[RequestCateAndBusinessarea alloc] init];
    cate.regionId = self.shopModel.regionId;
    cate.industry = [NSString stringWithFormat:@"%ld",(long)[DWHelper shareHelper].shopType];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.data = cate;
    baseReq.encryptionType = RequestMD5;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchantcategory/requestCateAndBusinessarea" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"-----%@",response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        
        if (baseRes.resultCode == 1) {
            [self.kindArr removeAllObjects];
            NSArray *category = baseRes.data[@"category"];
            for (NSDictionary *dic in category) {
                RequestCateAndBusinessareaModel *categoryModel = [RequestCateAndBusinessareaModel yy_modelWithDictionary:dic];
               
                    [self.kindArr addObject:categoryModel];
                }
            }
            NSArray *businessarea = baseRes.data[@"businessarea"];
            for (NSDictionary *dic in businessarea) {
                RequestCateAndBusinessareaModel *model = [RequestCateAndBusinessareaModel yy_modelWithDictionary:dic];
                [self.groupArr addObject:model];
            }
        
        [self createView];
    } faild:^(id error) {
        
    }];

    
}


@end

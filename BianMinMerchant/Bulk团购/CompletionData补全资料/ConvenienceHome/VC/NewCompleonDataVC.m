//
//  NewCompleonDataVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/25.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "NewCompleonDataVC.h"
#import "TZTestCell.h"
#import "LxGridViewFlowLayout.h"
#import "TZImagePickerController.h"
#import "SDWebImageManager.h"
#import "GroupVC.h"
#import "BusinessVC.h"
#import "RequestCateAndBusinessarea.h"
#import "RequestCateAndBusinessareaModel.h"
#import "ImageChooseVC.h"
#import "RequestMerchantCompleteInfo.h"
#import "XFDaterView.h"
#import "RequestMerchantData.h"
@interface NewCompleonDataVC ()<UICollectionViewDataSource,UICollectionViewDelegate,  TZImagePickerControllerDelegate, UITextFieldDelegate,AMapLocationManagerDelegate,XFDaterViewDelegate>{
    XFDaterView*dater;
    XFDaterView*timer;
}

//定位
@property (nonatomic ,strong) AMapLocationManager *locationManager;
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *imageArray;
/** asset 数组，用以确定已选中的图片 */
@property (nonatomic, strong) NSMutableArray *assetArray;
@property(nonatomic,strong) NSMutableArray * Arr;
@property(nonatomic,strong) NSMutableArray *iconUrlArr;
@property(nonatomic,assign)BOOL isiconUrl;
@property(nonatomic,strong)NSDictionary * iconUrlDic;
@property (nonatomic, strong) NSMutableArray *kindArr;
@property (nonatomic, strong) NSMutableArray *groupArr;
@property(nonatomic,strong)NSString*  timeStr;
//@property (nonatomic,strong)RequestMerchantCompleteInfo *completeInfo;
@end

@implementation NewCompleonDataVC
-(NSMutableArray *)Arr{
    if (!_Arr) {
        self.Arr = [NSMutableArray arrayWithCapacity:0];
        
    }return _Arr;
}
#pragma mark - lazy init
- (NSMutableArray *)iconUrlArr {
    if (!_iconUrlArr) {
        self. iconUrlArr = [[NSMutableArray alloc] init];
    }
    return _iconUrlArr;
}
- (NSMutableArray *)kindArr {
    if (!_kindArr) {
        self. kindArr = [[NSMutableArray alloc] init];
    }
    return _kindArr;
}
- (NSMutableArray *)groupArr {
    if (!_groupArr) {
        self. groupArr = [[NSMutableArray alloc] init];
    }
    return _groupArr;
}

- (NSMutableArray *)assetArray {
    if (!_assetArray) {
        self. assetArray = [[NSMutableArray alloc] init];
    }
    return _assetArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        self. imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopSetting:) name:@"商家设置" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopKind:) name:@"商户类型" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupKind:) name:@"商户类型" object:nil];
    //创建观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SubGroupVC:) name:@"SubGroupVC" object:nil];
    //创建观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BusinessVC:) name:@"BusinessVC" object:nil];
    



}
#pragma mark - 创建观察者返回数据
-(void)SubGroupVC:(NSNotification*)sender{
    NSDictionary * dic = [sender.userInfo objectForKey:@"SubGroupVC"];
    NSLog(@"%@",dic);
    [self.merchantCategory setTitle:dic[@"categoryName"] forState:(UIControlStateNormal)];
    
    self.shopModel.merchantCategoryId =[NSString stringWithFormat:@"%@" , dic[@"merchantCategoryId"]  ];
    NSLog(@"---%@,====%@",self.shopModel.merchantCategoryId,dic[@"merchantCategoryId"]);
    
    
}
#pragma mark - 创建观察者返回数据
-(void)BusinessVC:(NSNotification*)sender{
    NSDictionary * dic = [sender.userInfo objectForKey:@"BusinessVC"];
    NSLog(@"%@",dic);
    [self.businessArea setTitle:dic[@"name"] forState:(UIControlStateNormal)];
    
    self.shopModel.businessAreaId = dic[@"businessAreaId"];
    
    
}


#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"补全资料";
    self.startTime.layer.borderWidth = 1.0f;
    self.startTime.layer.borderColor = [UIColor grayColor].CGColor;
    self.endTime.layer.borderWidth = 1.0f;
    self.endTime.layer.borderColor = [UIColor grayColor].CGColor;
    self.content.layer.borderWidth = 1.0f;
    self.content.layer.borderColor = [UIColor grayColor].CGColor;
    self.  DingWeiBtn.layer.masksToBounds = YES;
    self.  DingWeiBtn.layer.cornerRadius = 5;
    //定位
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.content
    .placeholder = @"请输入店铺简介";
    [self setupCollectionView];
    

    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    //商户状态 1-正常 2-待补全质料x,3-待审核
    switch (self.shopModel.status) {
        case 0:
        {
            
            
            
            break;
        }
            
        case 1:
        {
            [self kongjianfuzhi];
            break;
        }
            
        case 2:
        {
            self.shopModel.have24hourWater =0;
            self.shopModel.haveWifi = 0;
            self.shopModel.havaAirCondition = 0;
            self.shopModel.havaNoSmokingRoom  =0;
            self.shopModel.haveParking = 0;
             _isiconUrl = NO;
            [self.startTime setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
             [self.endTime setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [self.startTime setTitle:@" 例: 08:00" forState:(UIControlStateNormal)];
            [self.endTime setTitle:@" 例: 22:30" forState:(UIControlStateNormal)];
           
            break;
        }
            
            
        case 3:
        {
            [self kongjianfuzhi];
            break;
        }
            
        default:{
            
            break;
            
        }
    }

   
    //获取商圈和分类
    [self requestCateAndBusinessarea];

    
    
}

-(void)kongjianfuzhi{
    [_merchantCategory setTitle:self.shopModel.merchantCategoryId forState:(UIControlStateNormal)];
    [_businessArea setTitle:self.shopModel.businessAreaId forState:(UIControlStateNormal)];
    [DWHelper SD_WebImage:self.iconUrl imageUrlStr:self.shopModel.iconUrl placeholderImage:@""];
    
    for (NSDictionary  *dic in self.shopModel.images) {
        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
        [mgr downloadImageWithURL:[NSURL URLWithString:dic[@"middleUrl"]] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image && !error) {
                [self.imageArray addObject:image];
                [self.Arr addObject:image];
                [self.imageCollectionView reloadData];
                [self setupCollectionViewHeight];
            }
        }];
        
        
        //[self setupCollectionView];
    }
    
    if (self.shopModel.haveWifi ==0) {
        [self.haveWifiNO setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
        [self.haveWifiYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
    }else{
        [self.haveWifiNO setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        [self.haveWifiYES setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
    }
    if (self.shopModel.havaNoSmokingRoom ==0) {
        [self.havaNoSmokingRoomNO setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
        [self.havaNoSmokingRoomYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
    }else{
        [self.havaNoSmokingRoomNO setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
        [self.havaNoSmokingRoomYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
    }
    
    if (self.shopModel.havaAirCondition ==0) {
        [self.havaAirConditionNO setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
        [self.havaAirConditionYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
    }else{
        [self.havaAirConditionNO setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
        [self.havaAirConditionYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
    }
    
    if (self.shopModel.haveParking ==0) {
        [self.haveParkingNO setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
        [self.haveParkingYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
    }else{
        [self.haveParkingNO setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
        [self.haveParkingYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
    }
    if (self.shopModel.have24hourWater ==0) {
        [self.have24hourWaterNO setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
        [self.have24hourWaterYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
    }else{
        [self.have24hourWaterNO setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
        [self.have24hourWaterYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
    }

    self.lat.text = self.shopModel.lat;
    self.lng.text = self.shopModel.lng;
    self.content.text = self.shopModel.content;
    [self.startTime setTitle:self.shopModel.openStartTime forState:(UIControlStateNormal)];
    [self.endTime setTitle:self.shopModel.openEndTime forState:(UIControlStateNormal)];
    
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
    __weak typeof(self) weakSelf = self;

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
            
            NSArray *businessarea = baseRes.data[@"businessarea"];
            for (NSDictionary *dic in businessarea) {
                RequestCateAndBusinessareaModel *model = [RequestCateAndBusinessareaModel yy_modelWithDictionary:dic];
                [self.groupArr addObject:model];
            }
        }else {
            [weakSelf showToast:baseRes.msg];
        }
       
        
        //[self createView];
    } faild:^(id error) {
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 设置 collectionView 的各属性
 */
- (void)setupCollectionView {
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    CGFloat WH = (Width - 50) / 4.f;
    layout.itemSize = CGSizeMake(WH, WH);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource =self;
    [self.imageCollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"image_collectionviewcell"];
    self.imageCollectionView.collectionViewLayout = layout;
    [self setupCollectionViewHeight];
}
#pragma mark - others
/**
 push 图片选择控制器
 */
- (void)pushImagePickerViewController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = self.assetArray;
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image_collectionviewcell" forIndexPath:indexPath];
    if (indexPath.row == self.imageArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"goods_add_plus"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = self.imageArray[indexPath.row];
        cell.deleteBtn.hidden = NO;
        
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.imageArray.count) {
        [self pushImagePickerViewController];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.imageArray = [NSMutableArray arrayWithArray:photos];
    [self.imageArray addObjectsFromArray:self.Arr];

    self.assetArray = [NSMutableArray arrayWithArray:assets];
    [self.imageCollectionView reloadData];
    [self setupCollectionViewHeight];
}


#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.imageArray.count;
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.imageArray.count && destinationIndexPath.item < self.imageArray.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = self.imageArray[sourceIndexPath.item];
    PHAsset *asset = self.assetArray[sourceIndexPath.item];
    [self.imageArray removeObjectAtIndex:sourceIndexPath.item];
    [self.imageArray insertObject:image atIndex:destinationIndexPath.item];
    [self.assetArray removeObjectAtIndex:sourceIndexPath.item];
    [self.assetArray insertObject:asset atIndex:destinationIndexPath.item];
    [self.imageCollectionView reloadData];
}



/**
 更新 collectionView 高度
 */
- (void)setupCollectionViewHeight {
    NSInteger row = ceil((self.imageArray.count + 1) / 4.0);
    
    self.collectionViewHeight.constant = (Width - 20) / 4.0 * row + 20;
    NSLog(@"%f",self.collectionViewHeight.constant);
    NSLog(@"---%f",self.bottomHeight.constant);
    self.bottomHeight.constant =  (Width - 20) / 4.0 * row;
    NSLog(@"++++%f",self.bottomHeight.constant);
    
}
/**
 collectionView 图片删除按钮点击事件处理
 
 @param btn 删除按钮
 */
- (void)deleteBtnClik:(UIButton *)btn {
    NSInteger index = btn.tag;
    for (int i = 0; i< self.Arr.count; i++) {
        UIImage *assetimage = self.Arr[i];
        if (assetimage == self.imageArray[index]) {
            [self.Arr removeObjectAtIndex:i];
            
        }
    }
    
    
    [self.imageArray removeObjectAtIndex:index];
    if (self.assetArray.count>=index+1) {
        [self.assetArray removeObjectAtIndex:index];
    }

    [self.imageCollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.imageCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.imageCollectionView reloadData];
        [self setupCollectionViewHeight];
    }];
}


#pragma mark - 否的点击事件
- (IBAction)NOAction:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
    if ([self.haveWifiNO isEqual:sender]) {
        self.shopModel.haveWifi =0;
         [self.haveWifiYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }
    if ([self.havaNoSmokingRoomNO isEqual:sender]) {
        self.shopModel.havaNoSmokingRoom =0;
        [self.havaNoSmokingRoomYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }
    if ([self.havaAirConditionNO isEqual:sender]) {
        self.shopModel.havaAirCondition =0;
        [self.havaAirConditionYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }
    if ([self.haveParkingNO isEqual:sender]) {
        self.shopModel.haveParking =0;
        [self.haveParkingYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }
    if ([self.have24hourWaterNO isEqual:sender]) {
        self.shopModel.have24hourWater =0;
        [self.have24hourWaterYES setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }
    
    

    
    
    
    
}
#pragma mark - 是的点击事件
- (IBAction)YESAction:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@"椭圆-2"] forState:(UIControlStateNormal)];
    if ([self.haveWifiYES isEqual:sender]) {
        self.shopModel.haveWifi =1;
        [self.haveWifiNO setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }
    if ([self.havaNoSmokingRoomYES isEqual:sender]) {
        self.shopModel.havaNoSmokingRoom =1;

        [self.havaNoSmokingRoomNO setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }
    if ([self.havaAirConditionYES isEqual:sender]) {
        self.shopModel.havaAirCondition =1;

        [self.havaAirConditionNO setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }
    if ([self.haveParkingYES isEqual:sender]) {
        self.shopModel.haveParking =1;

        [self.haveParkingNO setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }
    if ([self.have24hourWaterYES isEqual:sender]) {
        self.shopModel.have24hourWater =1;

        [self.have24hourWaterNO setImage:[UIImage imageNamed:@"椭圆-1"] forState:(UIControlStateNormal)];
        
    }

    
    
    
    
    
    
}

#pragma mark - 分类的点击事件
- (IBAction)merchantCategoryAction:(UIButton *)sender {
    //Push 跳转
    GroupVC * VC = [[GroupVC alloc]initWithNibName:@"GroupVC" bundle:nil];
    VC.dataArray = self.kindArr;
    NSLog(@"%@",VC.dataArray);
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - 商圈的点击事件
- (IBAction)businessAreaAction:(UIButton *)sender {
    //Push 跳转
    BusinessVC * VC = [[BusinessVC alloc]initWithNibName:@"BusinessVC" bundle:nil];
    VC.dataArray = self.groupArr;
    NSLog(@"%@",VC.dataArray);
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - 店铺主图点击事件
- (IBAction)iconUrlAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    //VC.imageType= OriginalImage;
    VC.zoom = 0.4 ;
    __weak typeof(self) weakSelf = self;
        VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        _isiconUrl  = YES;
        [weakSelf.iconUrlArr removeAllObjects];
        [weakSelf.iconUrlArr addObject:image];
        weakSelf. iconUrl.image = image;
    };
    [self presentViewController:VC animated:NO completion:^{
    }];
    
}
#pragma mark - 定位点击事件
- (IBAction)DingWeiAction:(UIButton *)sender {
    
    [self.locationManager startUpdatingLocation];
    [self showProgressWithText:@"定位中..."];
    
}


- (void)locationAction {
    
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    self.lng.text = [NSString stringWithFormat:@"%.6f", location.coordinate.longitude];
    self.lat.text = [NSString stringWithFormat:@"%.6f", location.coordinate.latitude];
    [self hideProgress];
    [self showToast:@"定位成功"];
    [self.locationManager stopUpdatingLocation];
    
}

#pragma mark - 提交
- (IBAction)submitBtnAction:(PublicBtn *)sender {
    if ([self IF]) {
        __weak typeof(self) weakSelf = self;

        [[DWHelper shareHelper]UPImageToServer:self.iconUrlArr success:^(id response) {
            //weakSelf.iconUrlDic = [NSDictionary dictionary];
            //weakSelf.iconUrlDic = response[0];
            if (_isiconUrl ==YES) {
                weakSelf.iconUrlDic = response[0];
                 //weakSelf.shopModel.iconUrl = response[0][@"originUrl"];
                NSLog(@"-----%@",weakSelf.shopModel.iconUrl);
            }
           

            [[DWHelper shareHelper]UPImageToServer:weakSelf.imageArray success:^(id response) {
            weakSelf.shopModel.images = response;
                [weakSelf settingMessage];
            } faild:^(id error) {
                
            }];
            
            
        } faild:^(id error) {
            
        }];
        
        
        
        
        
    }
    
    
}


#pragma mark - 条件判断
-(BOOL)IF{
   
    NSLog(@"------%@",[self.shopModel yy_modelToJSONObject]);
    self.shopModel.content = self.content.text;
    self.shopModel.lng = self.lng.text;
    self.shopModel.lat =self.lat.text ;
    BOOL YESORNO = YES;
    if (self.shopModel.merchantCategoryId.length ==0 ||[self.merchantCategory.titleLabel.text isEqualToString:@"请选择分类"]) {
        [self showToast:@"请选择分类"];
        return NO;
    }
//    if (self.completeInfo.businessAreaId.length ==0) {
//        [self showToast:@"请选择商圈"];
//        return NO;
//    }
    NSLog(@"%d",_isiconUrl);
    //|| self.completeInfo.iconUrl.count ==0
    if (self.shopModel.iconUrl.length == 0) {
        if ( self.isiconUrl == NO ) {
            [self showToast:@"请选择店铺logo"];
            return NO;
        }
    }else{
        
    }
    
    if (self.imageArray.count ==0) {
        [self showToast:@"请选择店铺相册"];
        return NO;
    }
    if (self.lat.text.length==0||self.lng.text.length==0) {
        [self showToast:@"请填写经纬度"];
        return NO;
    }
    if (self.shopModel.content.length ==0) {
        [self showToast:@"请输入店铺详情"];
        return NO;
    }
    if (self.shopModel.openStartTime.length ==0) {
        [self showToast:@"请选择营业开始时间"];
        return NO;
    }
    if (self.shopModel.openEndTime.length ==0) {
        [self showToast:@"请选择营业结束时间"];
        return NO;
    }
    NSString * start  = [self.shopModel.openStartTime stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * end  = [self.shopModel.openEndTime stringByReplacingOccurrencesOfString:@":" withString:@""];
    if ([start intValue]>= [end intValue]){
        
        [self showToast:@"开始时间不能早于结束时间"];
        return NO;
    }
    return YESORNO;
    
    
}
- (void)settingMessage{
    
    NSLog(@"%@",[self.shopModel yy_modelToJSONObject]);
    
    RequestMerchantData  *model = [RequestMerchantData new];
    model.merchantCategoryId = self.shopModel.merchantCategoryId;
    model.businessAreaId = self.shopModel.businessAreaId;
    model.images = self.shopModel.images;
    model.iconUrl = self.iconUrlDic;
    model.haveWifi = self.shopModel.haveWifi;
    model.havaNoSmokingRoom = self.shopModel.havaNoSmokingRoom;
    model.havaAirCondition =self.shopModel.havaAirCondition;
    model.haveParking = self.shopModel.haveParking;
    model.have24hourWater =self.shopModel.have24hourWater;
    model.lng = [self.shopModel.lng doubleValue];
    model.lat = [self.shopModel.lat doubleValue];
    model.content = self.shopModel.content;
    model.openStartTime = self.shopModel.openStartTime;
     model.openEndTime = self.shopModel.openEndTime;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token= [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    
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
#pragma mark - 开始时间
- (IBAction)stastTimeAction:(UIButton *)sender {
    
    [self.view endEditing:NO];
    self.timeStr = @"1";
    if (!timer) {
        timer=[[XFDaterView alloc]initWithFrame:CGRectZero];
        timer.delegate=self;
        [timer showInView:self.view animated:YES];
        timer.dateViewType=XFDateViewTypeTime;
    }else{
        [timer showInView:self.view animated:YES];
    }


    
}
#pragma mark - 结束时间
- (IBAction)endTimeAction:(UIButton *)sender {
    [self.view endEditing:NO];

    self.timeStr = @"2";
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
       if ([daterView isEqual:timer]) {
        if ([self.timeStr isEqualToString:@"1"]) {
            [self.startTime setTitle:[NSString stringWithFormat:@"%@",[daterView.timeString substringToIndex:5]] forState:(UIControlStateNormal)]  ;
            self.shopModel.openStartTime =[NSString stringWithFormat:@" %@",[daterView.timeString substringToIndex:5]];
        }else if([self.timeStr isEqualToString:@"2"]){
            [self.endTime setTitle:[NSString stringWithFormat:@"%@",[daterView.timeString substringToIndex:5]] forState:(UIControlStateNormal)]  ;
             self.shopModel.openEndTime =[NSString stringWithFormat:@" %@",[daterView.timeString substringToIndex:5]];
        }
        
        //self.time.text = [NSString stringWithFormat:@"%@",[daterView.timeString substringToIndex:5]] ;
    }
    
    
}
#pragma mark -  日历取消
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

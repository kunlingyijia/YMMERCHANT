//
//  ChangeMerchantsDataVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/31.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ChangeMerchantsDataVC.h"
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
@interface ChangeMerchantsDataVC ()<UICollectionViewDataSource,UICollectionViewDelegate,  TZImagePickerControllerDelegate, UITextFieldDelegate,AMapLocationManagerDelegate,XFDaterViewDelegate>{
    XFDaterView*dater;
    XFDaterView*timer;
}

//定位
@property (nonatomic ,strong) AMapLocationManager *locationManager;
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *imageArray;
/** asset 数组，用以确定已选中的图片 */
@property (nonatomic, strong) NSMutableArray *assetArray;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong) NSMutableArray *iconUrlArr;
@property(nonatomic,assign)BOOL isiconUrl;
@property(nonatomic,strong)NSDictionary * iconUrlDic;
@property (nonatomic, strong) NSMutableArray *kindArr;
@property (nonatomic, strong) NSMutableArray *groupArr;
@property(nonatomic,strong)NSString*  timeStr;

@end

@implementation ChangeMerchantsDataVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
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
        self. assetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _assetArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        self. imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
    
    
    
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"修改商户信息";
    self.startTime.layer.borderWidth = 1.0f;
    self.startTime.layer.borderColor = [UIColor grayColor].CGColor;
    self.endTime.layer.borderWidth = 1.0f;
    self.endTime.layer.borderColor = [UIColor grayColor].CGColor;
   
    self.  DingWeiBtn.layer.masksToBounds = YES;
    self.  DingWeiBtn.layer.cornerRadius = 5;
    //定位
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
        [self setupCollectionView];
    
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    _isiconUrl  = NO;
    [BackgroundService requestPushVC:self MyselfAction:^{
       
    }];
    DWHelper *helper = [DWHelper shareHelper];
    self.shopModel = [RequestMerchantInfoModel new];
     _shopModel  =helper.shopModel;
    [self kongjianfuzhi];
    
}


-(void)kongjianfuzhi{
      [DWHelper SD_WebImage:self.iconUrl imageUrlStr:self.shopModel.iconUrl placeholderImage:@""];
     [self .imageArray removeAllObjects];
    for (NSDictionary  *dic in self.shopModel.images) {
        NSLog(@"%@",dic);
        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
        [mgr downloadImageWithURL:[NSURL URLWithString:dic[@"originUrl"]] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image && !error) {
               
                [self.dataArray addObject:image];
                [self.imageArray addObject:image];
                [self.imageCollectionView reloadData];
                [self setupCollectionViewHeight];
                 NSLog(@"----休息休息%@",self.imageArray);
            }
        }];
        
                //[self setupCollectionView];
    }
    
   

    self.lat.text = self.shopModel.lat;
    self.lng.text = self.shopModel.lng;
    self.area.text = _shopModel.area;
    self.address.text = _shopModel.address;
    
    
//    self.iconUrlDic = self.shopModel.iconUrl;
    [self.startTime setTitle:self.shopModel.openStartTime forState:(UIControlStateNormal)];
    [self.endTime setTitle:self.shopModel.openEndTime forState:(UIControlStateNormal)];
    
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
   //imagePickerVc.maxImagesCount = 9- self.imageArray.count;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"----休息休息%@",self.imageArray);

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
    //self.imageArray = [NSMutableArray arrayWithArray:photos];
    self.imageArray = [NSMutableArray arrayWithArray:photos];
    self.assetArray = [NSMutableArray arrayWithArray:assets];
//    for (UIImage *ima in self.dataArray) {
        [self.imageArray addObjectsFromArray:self.dataArray];
   // }
    // [self.imageArray insertObject:image atIndex:0];
    
//    for (UIImage * image in photos) {
//        BOOL dd = false;
//        for (UIImage *img in self.imageArray) {
//            if (image == img) {
//                dd = YES;
//            }
//        }
//        if (!dd) {
//            [self.imageArray insertObject:image atIndex:0];
//        }
//    }
//    
//    BOOL dd;
//    for (UIImage *ima in self.imageArray) {
    //}
    
//    for (UIImage * image in photos) {
//        [self.imageArray insertObject:image atIndex:0];
//    }
//        NSMutableArray *listAry = [[NSMutableArray alloc]init];
//    for (UIImage *image in self.imageArray) {
//        if (![listAry containsObject:image]) {
//            [listAry addObject:image];
//        }
//    }
//    [self.imageArray removeAllObjects];
//    self.imageArray = [NSMutableArray arrayWithArray:listAry];
    NSLog(@"%@",self.assetArray);

    [self.imageCollectionView reloadData];
    [self setupCollectionViewHeight];
}


#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
    //return indexPath.item < self.imageArray.count;
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
    
//    UIImage * image = self.imageArray[index];
//    NSData *data1 = UIImagePNGRepresentation(image);
    NSLog(@"%@",self.dataArray);
    for (int i = 0; i< self.dataArray.count; i++) {
        UIImage *assetimage = self.dataArray[i];
        if (assetimage == self.imageArray[index]) {
            [self.dataArray removeObjectAtIndex:i];
            
        }
    }
    

    [self.imageArray removeObjectAtIndex:index];
    if (self.assetArray.count>=index+1) {
        [self.assetArray removeObjectAtIndex:index];
    }
     //编辑时无 asset 对象
    [self.imageCollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.imageCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.imageCollectionView reloadData];
        [self setupCollectionViewHeight];
    }];
}





#pragma mark - 店铺主图点击事件
- (IBAction)iconUrlAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//    VC.imageType= OriginalImage;
    VC.zoom = 0.4;
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
            if (_isiconUrl ==YES) {
                weakSelf.shopModel.iconUrl = response[0][@"originUrl"];
            }
            
            [[DWHelper shareHelper]UPImageToServer:weakSelf.imageArray success:^(id response) {
                weakSelf.shopModel.images = response;
                NSLog(@"%@",weakSelf.shopModel.images);
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
    self.shopModel.lng = self.lng.text;
    self.shopModel.lat =self.lat.text ;
    self.shopModel.address = self.address.text;
    BOOL YESORNO = YES;
   
    //|| self.completeInfo.iconUrl.count ==0
    NSLog(@"%ld", self.shopModel.iconUrl.length);
    if (self.shopModel.iconUrl.length == 0  ) {
        [self showToast:@"请选择店铺logo"];
        return NO;
    }
    if (self.imageArray.count ==0) {
        [self showToast:@"请选择店铺相册"];
        return NO;
    }
    if (self.address.text.length ==0) {
        [self showToast:@"请输入详细地址"];
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
    RequestMerchantCompleteInfo  *model = [RequestMerchantCompleteInfo new];
    model.images = self.shopModel.images;
    model.iconUrl = self.shopModel.iconUrl;
    model.lng = [self.shopModel.lng doubleValue];
    model.lat = [self.shopModel.lat doubleValue];
    model.openStartTime = self.shopModel.openStartTime;
    model.openEndTime = self.shopModel.openEndTime;
    model.address =self.shopModel.address;
    
    model.area =self.shopModel.area;

    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token= [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestEditMerchantInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [weakSelf hideProgress];
            weakSelf.backAction(@"");
            [weakSelf showToast:@"提交成功"];
           // self.backAction(nil);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [weakSelf showToast:baseRes.msg];
            [weakSelf hideProgress];
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

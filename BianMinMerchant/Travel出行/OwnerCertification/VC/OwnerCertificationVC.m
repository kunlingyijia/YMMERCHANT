//
//  OwnerCertificationVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OwnerCertificationVC.h"
#import "OwnerCOneCell.h"
#import "OwnerCTwoCell.h"
#import "TravelSetFourCell.h"
#import "ChangeOwnerVC.h"
#import "UpdateSexController.h"
#import "CarListVC.h"
#import "OwnerModel.h"
#import "OwenrPictureVC.h"
#import "Imageupload.h"

@interface OwnerCertificationVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * LeftArray;

@property (nonatomic,strong) OwnerModel *ownerModel;
///更新车主信息公共参数
@property(nonatomic,strong)NSString *UpdateStr;
@property(nonatomic,strong)NSString * CellIndex;
@end

@implementation OwnerCertificationVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ///获取车主信息
    [self requestAction];
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
    [self ShowNodataView];
    self.title = @"车主认证";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [self.tableView tableViewregisterNibArray:@[@"OwnerCOneCell",@"OwnerCTwoCell",@"TravelSetFourCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.LeftArray = [@[@[@""],@[@"真实姓名",@"身份证号码",@"性别"],@[@"车牌号",@"品牌型号",@"车辆颜色",@"爱车靓照",@"行驶证",@"驾驶证",@"所属车行"],@[@""]]mutableCopy];
    self.ownerModel = [[OwnerModel alloc]init];
    
}
#pragma mark - 车主信息
-(void)requestAction{
    
    NSString *Token =[AuthenticationModel getLoginToken];
    ;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelDriver/requestDriverInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"获取车主信息----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSMutableDictionary *dic = response[@"data"];
                    weakself.ownerModel = [OwnerModel
                yy_modelWithJSON:dic];
            //刷新
                [weakself.tableView reloadData];
                [weakself HiddenNodataView];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    

    
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 4;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            
            return 1;
            
            break;
        }
            
        case 1:
        {
             return 3;
            break;
        }
            
        case 2:
        {
             return 7;
            break;
        }
            
            
        case 3:
        {
             return 1;
            break;
        }
            
        default:{
             return 0;
            break;
            
        }
    }

    return 10;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    switch (indexPath.section) {
        case 0:
        {
            ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
            if ([self.ownerModel.status isEqualToString:@"4"]) {
                OwnerCOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OwnerCOneCell" forIndexPath:indexPath];
                [cell CellgetData:self.ownerModel];
                
                return cell;
            }else{
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                return  cell;
            }
            
            
            
            break;
        }
            
        case 1:
        {
            OwnerCTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OwnerCTwoCell" forIndexPath:indexPath];
           cell.OKImag.hidden = YES;
            cell.label.text = self.LeftArray[indexPath.section][indexPath.row];
            if (indexPath.row==0) {
                if (self.ownerModel.realName.length==0) {
                    cell.rightLabel.text =@"请输入";
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                }else{
                    cell.rightLabel.text =self.ownerModel.realName;
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                }
                
            }else if (indexPath.row==1){
                if (self.ownerModel.idCard.length==0) {
                    cell.rightLabel.text =@"请输入";
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                }else{
                    cell.rightLabel.text =self.ownerModel.idCard;
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                }
                
            }else if (indexPath.row==2){
                if ([self.ownerModel.gender isEqualToString:@"0"]) {
                     cell.rightLabel.text =@"女";
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                }else{
                     cell.rightLabel.text =@"男";
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                }
               
            }
          
            return cell;
            break;
        }
            
        case 2:
        {
            OwnerCTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OwnerCTwoCell" forIndexPath:indexPath];
            cell.OKImag.hidden = YES;
             cell.label.text = self.LeftArray[indexPath.section][indexPath.row];
            if (indexPath.row==0) {
                if (self.ownerModel.carNo.length==0) {
                    cell.rightLabel.text =@"请输入";
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                    cell.OKLabel.text =@"";
                }else{
                    cell.rightLabel.text =self.ownerModel.carNo;
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                }

                
            }else if (indexPath.row==1){
                if (self.ownerModel.carBrand.length==0) {
                    cell.rightLabel.text =@"请输入";
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                }else{
                   cell.rightLabel.text =self.ownerModel.carBrand;
                    cell.OKLabel.text =@"";
                    cell.OKImag.hidden = YES;
                }
                
            }else if (indexPath.row==2){
                if (self.ownerModel.carColor.length==0) {
                    cell.rightLabel.text =@"请输入";
                    cell.OKLabel.text =@"";
                 cell.OKImag.hidden = YES;
                }else{
                    cell.rightLabel.text =self.ownerModel.carColor;
                        cell.OKLabel.text =@"";
                        cell.OKImag.hidden = YES;
                }

                
            }else if (indexPath.row==3){
                if (self.ownerModel.carPhotoUrl.length==0) {
                    cell.rightLabel.text =@"未上传";
                }else{
             cell.rightLabel.text =@"";
             cell.OKLabel.text =@"已上传";
            cell.OKImag.hidden = NO;
                }
                
            }else if (indexPath.row==4){
                if (self.ownerModel.carLicenseUrl.length==0) {
                    cell.rightLabel.text =@"未上传";
                }else{
                    cell.rightLabel.text =@"";
                    cell.OKLabel.text =@"已上传";
                    cell.OKImag.hidden = NO;
                }

                
            }else if (indexPath.row==5){
                if (self.ownerModel.driverLicenseUrl.length==0) {
                    cell.rightLabel.text =@"未上传";
                }else{
                    cell.rightLabel.text =@"";
                    cell.OKLabel.text =@"已上传";
                    cell.OKImag.hidden = NO;
                }
                
            }else if (indexPath.row==6){
                if (self.ownerModel.companyName.length==0) {
                    cell.rightLabel.text =@"请选择";
                    cell.OKLabel.text =@"";
                }else{
                    cell.rightLabel.text =self.ownerModel.companyName;
                }
                
            }

            
            return cell;

            break;
        }
            
            
        case 3:
        {
            TravelSetFourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelSetFourCell" forIndexPath:indexPath];
            [cell.LoginOutBtn addTarget:self action:@selector(requestApplyCertification:) forControlEvents:(UIControlEventTouchUpInside)];
            if ([self.ownerModel.status isEqualToString:@"4"]) {
                [cell.LoginOutBtn setTitle:@"重新认证" forState:(UIControlStateNormal)];
            }else  {
                [cell.LoginOutBtn setTitle:@"车主认证" forState:(UIControlStateNormal)];
            
                
            }
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

            break;
        }
            
        default:{
            return nil;
            break;
            
        }
    }

}
#pragma mark - 车主申请认证
-(void)requestApplyCertification:(UIButton*)sender{
    if (self.ownerModel.realName.length==0) {
        [self showToast:@"请输入真实姓名"];
        return;
    }else if (self.ownerModel.idCard.length==0) {
        [self showToast:@"请输入身份号码"];
        return;
    }else if (self.ownerModel.carNo.length==0) {
        [self showToast:@"请输入车牌号"];
        return;
    }else if (self.ownerModel.carBrand.length==0) {
        [self showToast:@"请输入品牌型号"];
        return;
    }else if (self.ownerModel.carColor.length==0) {
        [self showToast:@"请输入爱车颜色"];
        return;
    }else if (self.ownerModel.carPhotoUrl.length==0) {
        [self showToast:@"请上传爱车靓照"];
        return;
    }else if (self.ownerModel.carLicenseUrl.length==0) {
        [self showToast:@"请上传机动车行驶证件"];
        return;
    }else if (self.ownerModel.driverLicenseUrl.length==0) {
        [self showToast:@"请上传驾驶执照"];
        return;
    }else if (self.ownerModel.companyName.length==0) {
        [self showToast:@"请选择所属车行"];
        return;
    }
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    ;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelDriver/requestApplyCertification" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"车主申请认证----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                weakself.OwnerCertificationVCBlock();
                [weakself alertWithTitle:@"温馨提示" message:@"您的申请认证已提交,我们的工作人员会在2-4个工作日内给您回复,请耐心等候..." OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
                     [weakself.navigationController popViewControllerAnimated:YES];
                }];
               

            }else{
                weakself.view.userInteractionEnabled = YES;
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
             weakself.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }
 
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
    if ([self.ownerModel.status isEqualToString:@"3"]) {
        switch (indexPath.section) {
            case 0:
            {
                
                break;
            }
                
            case 1:
            {
             break;
            }
                
            case 2:
            {
                 if(indexPath.row==3){
                    
                    if (self.ownerModel.carPhotoUrl.length==0) {
                        //拍照
                        self.CellIndex = @"爱车靓照";
                        [self addImageOFaddressPerson];
                        
                        
                    }else{
#warning 跳转
                        //Push 跳转
                        OwenrPictureVC * VC = [[OwenrPictureVC alloc]initWithNibName:@"OwenrPictureVC" bundle:nil];
                        VC.titleStr = self.LeftArray[indexPath.section][indexPath.row];
                        VC.ownerModel = self.ownerModel;
                        [self.navigationController  pushViewController:VC animated:YES];
                        
                    }
                    
                    
                    
                }else if(indexPath.row==4){
                    
                    if (self.ownerModel.carLicenseUrl.length==0) {
                        self.CellIndex = @"行驶证";
                                                //拍照
                        [self addImageOFaddressPerson];
                    }else{
#warning 跳转
                        //Push 跳转
                        OwenrPictureVC * VC = [[OwenrPictureVC alloc]initWithNibName:@"OwenrPictureVC" bundle:nil];
                        VC.titleStr = self.LeftArray[indexPath.section][indexPath.row];
                        VC.ownerModel = self.ownerModel;
                        [self.navigationController  pushViewController:VC animated:YES];
                    }
                    
                    
                    
                }else if(indexPath.row==5){
                    
                    if (self.ownerModel.driverLicenseUrl.length==0) {
                        self.CellIndex = @"驾驶证";
                        //拍照
                       [self addImageOFaddressPerson];
                        
                    }else{
#warning 跳转                    //Push 跳转
                        OwenrPictureVC * VC = [[OwenrPictureVC alloc]initWithNibName:@"OwenrPictureVC" bundle:nil];
                        VC.titleStr = self.LeftArray[indexPath.section][indexPath.row];
                        VC.ownerModel = self.ownerModel;
                        [self.navigationController  pushViewController:VC animated:YES];
                    }
                    
                    
                }
                
                break;
            }
                
                
            case 3:
            {
                
                break;
            }
                
            default:{
                
                break;
                
            }
        }

    }else{
    switch (indexPath.section) {
        case 0:
        {
    
            break;
        }
            
        case 1:
        {
            if (indexPath.row==2) {
                //Push 跳转
                UpdateSexController * VC = [[UpdateSexController alloc]initWithNibName:@"UpdateSexController" bundle:nil];
                VC.titleStr = self.LeftArray[indexPath.section][indexPath.row];
                VC.ownerModel = self.ownerModel;
                [self.navigationController  pushViewController:VC animated:YES];

            }else{
                //Push 跳转
                ChangeOwnerVC * VC = [[ChangeOwnerVC alloc]initWithNibName:@"ChangeOwnerVC" bundle:nil];
                VC.titleStr = self.LeftArray[indexPath.section][indexPath.row];
                VC.ownerModel = self.ownerModel;
                [self.navigationController  pushViewController:VC animated:YES];

            }
            break;
        }
            
        case 2:
        {
            if (indexPath.row==0||indexPath.row==1||indexPath.row==2) {
                //Push 跳转
                ChangeOwnerVC * VC = [[ChangeOwnerVC alloc]initWithNibName:@"ChangeOwnerVC" bundle:nil];
                VC.titleStr = self.LeftArray[indexPath.section][indexPath.row];
                VC.ownerModel = self.ownerModel;
                [self.navigationController  pushViewController:VC animated:YES];
                
            }else if(indexPath.row==3){
                
                if (self.ownerModel.carPhotoUrl.length==0) {
                    //拍照
                    self.CellIndex = @"爱车靓照";
                 [self addImageOFaddressPerson];
                    
                }else{
#warning 跳转
                    //Push 跳转
                    OwenrPictureVC * VC = [[OwenrPictureVC alloc]initWithNibName:@"OwenrPictureVC" bundle:nil];
                    VC.titleStr = self.LeftArray[indexPath.section][indexPath.row];
                    VC.ownerModel = self.ownerModel;
                    [self.navigationController  pushViewController:VC animated:YES];

                }

               
                
            }else if(indexPath.row==4){
                
                if (self.ownerModel.carLicenseUrl.length==0) {
                    self.CellIndex = @"行驶证";
                    //拍照
                    [self addImageOFaddressPerson];
                    

                }else{
                  #warning 跳转
                    //Push 跳转
                    OwenrPictureVC * VC = [[OwenrPictureVC alloc]initWithNibName:@"OwenrPictureVC" bundle:nil];
                    VC.titleStr = self.LeftArray[indexPath.section][indexPath.row];
                    VC.ownerModel = self.ownerModel;
                    [self.navigationController  pushViewController:VC animated:YES];
                }
                

                
            }else if(indexPath.row==5){
                
                if (self.ownerModel.driverLicenseUrl.length==0) {
                    self.CellIndex = @"驾驶证";
                    //拍照
                    [self addImageOFaddressPerson];
                   

                }else{
#warning 跳转                    //Push 跳转
                    OwenrPictureVC * VC = [[OwenrPictureVC alloc]initWithNibName:@"OwenrPictureVC" bundle:nil];
                    VC.titleStr = self.LeftArray[indexPath.section][indexPath.row];
                    VC.ownerModel = self.ownerModel;
                    [self.navigationController  pushViewController:VC animated:YES];
                }

                
            }else if(indexPath.row==6){
                //Push 跳转
                CarListVC * VC = [[CarListVC alloc]initWithNibName:@"CarListVC" bundle:nil];
                [self.navigationController  pushViewController:VC animated:YES];

            }

            break;
        }
            
            
        case 3:
        {
            
            break;
        }
            
        default:{
            
            break;
            
        }
    }
}
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
        if ([self.ownerModel.status isEqualToString:@"4"]) {
            //用storyboard 进行自适应布局
            self.tableView.estimatedRowHeight = 300;
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            return  self.tableView.rowHeight;
        }else{
            return 0.01;

        }

    }else if (indexPath.section==3){
        ///车主状态：1-待认证，2-审核中，3-认证通过，4-认证失败
        if ([self.ownerModel.status isEqualToString:@"3"]) {
            return 0;
        }else  {
            return 88+60;
            
            
        }
    }else{
        return 44;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==1) {
        return 10;
    }else{
        return 0;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark--拍摄照片上传图像
-(void)addImageOFaddressPerson{
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    //    VC.imageType= OriginalImage;
    VC.zoom = 0.6;
    __weak typeof(self) weakSelf = self;
    
    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        
        [weakSelf imageRequestAction:image];
        
    };
    [self presentViewController:VC animated:NO completion:^{
    }];
    
    
}



//#pragma mark--拍摄照片上传图像
////拍摄照片上传图像
//-(void)addImageOFaddressPerson{
//    //提供相册 以及拍照两种读取图片的方式
//    //创建
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
//    [sheet showInView:self.view];
//}
//-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
//
//{
//    
//    SEL selector = NSSelectorFromString(@"_alertController");
//    
//    if ([actionSheet respondsToSelector:selector])//ios8
//        
//    {
//        
//        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
//        
//        if ([alertController isKindOfClass:[UIAlertController class]])
//            
//        {
//            
//           alertController.view.tintColor = [UIColor colorWithHexString:kNavigationBgColor];
//            
//        }
//        
//    }
//    
//    else//ios7
//        
//    {
//        
//        for( UIView * subView in actionSheet.subviews )
//            
//        {
//            
//            if( [subView isKindOfClass:[UIButton class]] )
//                
//            {
//                
//                UIButton * btn = (UIButton*)subView;
//                
//                
//                
//                [btn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor]forState:UIControlStateNormal];
//                
//            }
//            
//        }
//        
//    }
//    
//}
//
//#pragma mark-----UIActionSheetDelegate
//
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    switch (buttonIndex) {
//        case 0:{
//            //判断相册权限
//            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//            if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
//                
//                //无权限
//                
//                if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
//                    
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"照片权限被禁用" message:@"请在iPhone的'设置-隐私-照片'中允许易民商户访问你的照片" preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        //跳入当前App设置界面,
//                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                    }];
//                    
//                    [alertController addAction:cancelAction];
//                    
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    
//                    return;
//                    
//                    
//                    
//                }else{
//                    
//                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"照片权限被禁用" message:@"请在iPhone的'设置-隐私-照片'中允许易民商户访问你的照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alertView show];
//                    return;
//                    
//                }
//                
//            }else{
//                //从相册中去读取
//                [self readImageFromAlbum];
//                
//            }
//            
//            
//        }
//            break;
//            
//        case 1:{
//            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//            
//            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
//                //无权限
//                if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相机被禁用" message:@"请在iPhone的'设置-隐私-相机'中允许易民商户访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        //跳入当前App设置界面,
//                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                    }];
//                    [alertController addAction:cancelAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    
//                    return;
//                    
//                    
//                    
//                }else{
//                    
//                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"相机被禁用" message:@"请在iPhone的'设置-隐私-相机'中允许易民商户访问你的相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    
//                    [alertView show];
//                    
//                    return;
//                    
//                }
//                
//            }else{
//                
//                //有相机权限
//                
//                //拍照
//                [self readImageFromCamera];
//                
//            }
//            
//            
//            
//        }
//            break;
//            
//            
//        default:
//            break;
//    }
//    
//}
//
////从相册中读取照片
//- (void)readImageFromAlbum {
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];//创建对象
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//（选择类型）表示仅仅从相册中选取照片
//    imagePicker.delegate = self;//指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
//    imagePicker.allowsEditing = YES;//设置在相册选完照片后，是否跳到编辑模式进行图片剪裁。(允许用户编辑)
//    [self presentViewController:imagePicker animated:YES completion:nil];//显示相册
//}
////拍照
//- (void)readImageFromCamera {
//    //判断选择的模式是否为相机模式，如果没有弹窗警告
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.allowsEditing = YES;//允许编辑
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.delegate = self;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    } else {
//        //弹出窗口响应点击事件
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];//警告。。确认按钮
//        [alert show];
//    }
//}
//#pragma mark --- UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImage *img = [self fixOrientation:image];
//    [self imageRequestAction:img];
//}
//
//- (UIImage *)fixOrientation:(UIImage *)aImage {
//    
//    // No-op if the orientation is already correct
//    if (aImage.imageOrientation == UIImageOrientationUp)
//        return aImage;
//    
//    // We need to calculate the proper transformation to make the image upright.
//    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationDown:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//            
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//        default:
//            break;
//    }
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationUpMirrored:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//        default:
//            break;
//    }
//    
//    // Now we draw the underlying CGImage into a new context, applying the transform
//    // calculated above.
//    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
//                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
//                                             CGImageGetColorSpace(aImage.CGImage),
//                                             CGImageGetBitmapInfo(aImage.CGImage));
//    CGContextConcatCTM(ctx, transform);
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            // Grr...
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
//            break;
//            
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
//            break;
//    }
//    
//    // And now we just create a new UIImage from the drawing context
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
//    return img;
//}
//


#pragma mark ---    //图片上传请求
//图片上传请求
-(void)imageRequestAction:(UIImage*)image{
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
    __weak typeof(self) weakSelf = self;

    [manager POST:helper.configModel.image_hostname parameters:[upload yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)  {
        //1.把图片转换成二进制流
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        UIImage * image1 =  [UIImage scaleImageAtPixel:image pixel:1024];
        //1.把图片转换成二进制流
        NSData *imageData= [ UIImage scaleImage:image1 toKb:70];
        //2.上传图片
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"img.jpg" mimeType:@"jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"resultCode"]isEqualToString:@"1"]) {
            [weakSelf hideProgress];
            NSMutableArray * arr =responseObject[@"data"];
            NSDictionary * dic = arr[0];
            weakSelf.UpdateStr =dic[@"originUrl"];
            //更新车主信息
            [weakSelf requestUpdateDriverInfo];
        }
                
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
#pragma mark - 更新车主信息
-(void)requestUpdateDriverInfo{
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    OwnerModel *model = [[OwnerModel alloc]init];
    if ([self.CellIndex isEqualToString:@"爱车靓照"]) {
        model.carPhotoUrl = self.UpdateStr;

    }else if([self.CellIndex isEqualToString:@"行驶证"]) {
        model.carLicenseUrl = self.UpdateStr;
        
    }else if([self.CellIndex isEqualToString:@"驾驶证"]) {
        model.driverLicenseUrl = self.UpdateStr;
        
    }
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/TravelDriver/requestUpdateDriverInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@"更新车主信息----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                 weakself.view.userInteractionEnabled = YES;
                [weakself requestAction];
                
            }else{
                weakself.view.userInteractionEnabled = YES;
                
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            weakself.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }else{
        
    }
    
    
    
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

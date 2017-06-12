//
//  OwenrPictureVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OwenrPictureVC.h"
#import "OwnerModel.h"
#import "Imageupload.h"
@interface OwenrPictureVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

///更新车主信息公共参数
@property(nonatomic,strong)NSString *UpdateStr;
@end

@implementation OwenrPictureVC

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
       if ([self.ownerModel.status isEqualToString:@"3"]) {}else{
           [self AddRightBtn];

    }
    self.title = self.titleStr;
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
        if ([self.titleStr isEqualToString:@"爱车靓照"]) {
            self.UpdateStr = self.ownerModel.carPhotoUrl;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.UpdateStr] placeholderImage:[UIImage imageNamed:@""]];
        }else if ([self.titleStr isEqualToString:@"行驶证"]) {
            self.UpdateStr = self.ownerModel.carLicenseUrl;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.UpdateStr] placeholderImage:[UIImage imageNamed:@""]];
        }
        else if ([self.titleStr isEqualToString:@"驾驶证"]) {
            self.UpdateStr = self.ownerModel.driverLicenseUrl;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.UpdateStr] placeholderImage:[UIImage imageNamed:@""]];
        }
    
    
}
#pragma mark - 添加保存
-(void)AddRightBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitle:@"重新" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [backBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    
}
#pragma mark - 保存
-(void)save:(UIButton*)sender{
    [self addImageOFaddressPerson];
}
#pragma mark--拍摄照片上传图像
//拍摄照片上传图像
-(void)addImageOFaddressPerson{
    //提供相册 以及拍照两种读取图片的方式
    //创建
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"获取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [sheet showInView:self.view];
}

#pragma mark-----UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            //判断相册权限
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
                
                //无权限
                
                if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"照片权限被禁用" message:@"请在iPhone的'设置-隐私-照片'中允许易民商户访问你的照片" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        //跳入当前App设置界面,
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                    
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    return;
                    
                    
                    
                }else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"照片权限被禁用" message:@"请在iPhone的'设置-隐私-照片'中允许易民商户访问你的照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                    
                }
                
            }else{
                //从相册中去读取
                [self readImageFromAlbum];
                
            }
            
            
        }
            break;
            
        case 1:{
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
                //无权限
                if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相机被禁用" message:@"请在iPhone的'设置-隐私-相机'中允许易民商户访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        //跳入当前App设置界面,
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    return;
                    
                    
                    
                }else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"相机被禁用" message:@"请在iPhone的'设置-隐私-相机'中允许易民商户访问你的相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    return;
                    
                }
                
            }else{
                
                //有相机权限
                
                //拍照
                [self readImageFromCamera];
                
            }
            
            
            
        }
            break;
            
            
        default:
            break;
    }
    
}

//从相册中读取照片
- (void)readImageFromAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];//创建对象
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//（选择类型）表示仅仅从相册中选取照片
    imagePicker.delegate = self;//指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
    imagePicker.allowsEditing = YES;//设置在相册选完照片后，是否跳到编辑模式进行图片剪裁。(允许用户编辑)
    [self presentViewController:imagePicker animated:YES completion:nil];//显示相册
}
//拍照
- (void)readImageFromCamera {
    //判断选择的模式是否为相机模式，如果没有弹窗警告
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;//允许编辑
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        //弹出窗口响应点击事件
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];//警告。。确认按钮
        [alert show];
    }
}
#pragma mark --- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self imageRequestAction:image];
}

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
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
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
    if ([self.title isEqualToString:@"爱车靓照"]) {
        model.carPhotoUrl = self.UpdateStr;
        
    }else if([self.title isEqualToString:@"行驶证"]) {
        model.carLicenseUrl = self.UpdateStr;
        
    }else if([self.title isEqualToString:@"驾驶证"]) {
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
                [weakself.navigationController popViewControllerAnimated:YES];
                
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

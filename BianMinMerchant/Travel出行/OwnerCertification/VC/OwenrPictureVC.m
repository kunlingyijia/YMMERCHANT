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
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 80, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitle:@"重新上传" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [backBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    //[backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    
}
#pragma mark - 保存
-(void)save:(UIButton*)sender{
    
    
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


#pragma mark ---    //图片上传请求
//图片上传请求
-(void)imageRequestAction:(UIImage*)image{
    [self showProgress];
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
    __weak typeof(self) weakSelf = self;
    [manager POST:helper.configModel.image_hostname parameters:[upload yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)  {
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
    }
    
    
    
}


@end

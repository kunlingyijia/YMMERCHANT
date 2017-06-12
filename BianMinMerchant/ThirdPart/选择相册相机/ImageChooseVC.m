//
//  ImageChooseVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ImageChooseVC.h"
#import "GKImagePicker.h"

@interface ImageChooseVC ()<GKImagePickerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImagePickerController *ctr;

//@property (nonatomic, strong) UIButton *customCropButton;
//@property (nonatomic, strong) UIButton *normalCropButton;
//@property (nonatomic, strong) UIImageView *imgView;
//@property (nonatomic, strong) UIButton* resizableButton;
@end


@implementation ImageChooseVC
@synthesize imagePicker;
//@synthesize imgView;
@synthesize popoverController;
@synthesize ctr;
//@synthesize customCropButton, normalCropButton, resizableButton;
-(void)loadView{
    [super loadView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //控制器通明的关键代码
    self.modalPresentationStyle =UIModalPresentationCustom;
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf addImageOFaddressPerson];
        
    });
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark--拍摄照片上传图像
//拍摄照片上传图像
-(void)addImageOFaddressPerson{
    
    __weak typeof(self) weakSelf = self;
    
    [self alertActionSheetWithTitle:@"获取图片" message:nil OKWithTitleOne:@"相册" OKWithTitleTwo:@"拍照" CancelWithTitle:@"取消" withOKDefaultOne:^(UIAlertAction *defaultaction) {
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
                
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                
                return;
                
                
                
            }else{
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"照片权限被禁用" message:@"请在iPhone的'设置-隐私-照片'中允许易民商户访问你的照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                return;
                
            }
            
        }else{
            if (_zoom ==0) {
                [self  readImageFromAlbum];
            }else{
                //有相册权限
                //从相册中去读取
                [weakSelf readImageFromAlbumIsPhoto:YES];
            }
            
        }
        
    } withOKDefaultTwo:^(UIAlertAction *defaultaction) {
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
                weakSelf.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                
                return;
                
                
                
            }else{
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"相机被禁用" message:@"请在iPhone的'设置-隐私-相机'中允许易民商户访问你的相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                return;
                
            }
            
        }else{
            
            //有相机权限
            if (_zoom ==0) {
                [self  readImageFromCamera];
            }else{
                [weakSelf readImageFromAlbumIsPhoto:NO];
            }
            //拍照
            
        }
        
    } withCancel:^(UIAlertAction *cancelaction) {
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    
    
    
    
}

//从相册中读取照片
- (void)readImageFromAlbum {
    UIImagePickerController *ImagePicker = [[UIImagePickerController alloc] init];//创建对象
    ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//（选择类型）表示仅仅从相册中选取照片
    ImagePicker.delegate = self;//指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
    ImagePicker.allowsEditing = YES;//设置在相册选完照片后，是否跳到编辑模式进行图片剪裁。(允许用户编辑)
    [self presentViewController:ImagePicker animated:YES completion:^{
        //iOS 8 bug.  the status bar will sometimes not be hidden after the camera is displayed, which causes the preview after an image is captured to be black
        if (ImagePicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
    }];
    //[self presentViewController:imagePicker animated:YES completion:nil];//显示相册
}
//拍照
- (void)readImageFromCamera {
    //判断选择的模式是否为相机模式，如果没有弹窗警告
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *ImagePicker = [[UIImagePickerController alloc] init];
        ImagePicker.allowsEditing = YES;//允许编辑
        ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        ImagePicker.delegate = self;
        [self presentViewController:ImagePicker animated:YES completion:nil];
    } else {
        //弹出窗口响应点击事件
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];//警告。。确认按钮
        [alert show];
    }
}
#pragma mark --- UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    if (self.imageType ==EditedImage ) {
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage * img = [self fixOrientation:image];
        self.ImageChooseVCBlock( img);
    }else if (self.imageType ==OriginalImage){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage * img = [self fixOrientation:image];
        self.ImageChooseVCBlock( img);
    }else{
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage * img = [self fixOrientation:image];
        self.ImageChooseVCBlock( img);
        
    }
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)readImageFromAlbumIsPhoto:(BOOL)Y{
    NSLog(@"%f",_zoom);
    
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(Width-20, (Width-20)*_zoom);
    self.imagePicker.delegate = self;
    self.imagePicker.IsPhoto =Y;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
        //[self.popoverController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        
        [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:^{
            
        }  ];
        
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}



# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    
    
    UIImage * img = [self fixOrientation:image];
    self.ImageChooseVCBlock(img);
    
    
    [self hideImagePicker];
    
    
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
        
    }
}
- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker{
    [self hideImagePicker];
}
# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //    self.imgView.image = image;
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
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

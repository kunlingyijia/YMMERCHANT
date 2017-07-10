//  DWHelper.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWHelper.h"
#import "AFNetworking.h"
#import "DWTools.h"
#import "Imageupload.h"
#import "SVProgressHUD.h"
#import "LoginController.h"
#import "SelectedShopKindController.h"

//#import "DWDeviceInfo.h"
@implementation DWHelper

+ (DWHelper *)shareHelper {
    static DWHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DWHelper alloc] init];
    });
    return helper;
}

- (void)requestDataWithParm:(id)parm act:(NSString *)actName sign:(id)sign requestMethod:(RequestMethod)method success:(SuccessCallback)success faild:(FaildCallback)faild {
    
    //系统版本
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    //设备类型
    NSString * phoneModel =[[UIDevice currentDevice] model];
    //
    NSString *appVersion =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceNo = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if (method == GET) {
        NSString *url = [NSString stringWithFormat:@"%@%@&sign=%@",kServerUrl, actName,sign];
        //NSLog(@"%@",url);
        AFHTTPSessionManager *Session = [AFHTTPSessionManager manager];
        //缓存策略
//        Session.requestSerializer.cachePolicy = 0;
        Session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
//        [Session.requestSerializer setValue:@"1" forHTTPHeaderField:@"clientOS"];
//        [Session.requestSerializer setValue:[DWTools getXKVersion] forHTTPHeaderField:@"appVersion"];
//        [Session.requestSerializer setValue:[[UIDevice currentDevice].identifierForVendor UUIDString] forHTTPHeaderField:@"deviceNo"];
//        [Session.requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"systemVersion"];
//        if ([DWDeviceInfo getDeviceName]) {
//            [Session.requestSerializer setValue:[NSString stringWithFormat:@"%@",[DWDeviceInfo getDeviceName]] forHTTPHeaderField:@"phoneModel"];
//        }

        [Session.requestSerializer
         setValue:appVersion
         forHTTPHeaderField:@"appVersion"];
        [Session.requestSerializer
         setValue:@"1"
         forHTTPHeaderField:@"clientOS"];
        [Session.requestSerializer
         setValue:deviceNo
         forHTTPHeaderField:@"deviceNo"];
        [Session.requestSerializer
         setValue:systemVersion
         forHTTPHeaderField:@"systemVersion"];
        [Session.requestSerializer
         setValue:phoneModel
         forHTTPHeaderField:@"phoneModel"];
        [Session GET:url parameters:[NSDictionary dictionaryWithObject:parm forKey:@"request"] progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
       if([responseObject[@"resultCode"]isEqualToString:@"14"]) {
       //设置别名
        [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"pushAlias"]];
           //UIViewController * viewControllerNow = [self currentViewController];
           
//           for (UIViewController *tempVC in viewControllerNow.navigationController.viewControllers) {
//               if ([tempVC isKindOfClass:[LoginController class]]) {
//                   [viewControllerNow.navigationController popToViewController:tempVC animated:YES];
//               }
//           }
           
          
           __weak typeof(self) weakSelf = self;
            weakSelf.BaseVC.view.userInteractionEnabled = NO;
            for (UIViewController *tempVC in weakSelf.BaseVC.navigationController.viewControllers) {
            if ([tempVC isKindOfClass:[SelectedShopKindController class]]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.BaseVC.navigationController popToViewController:tempVC animated:NO];
            });
                             
                          }
            }
    }
            
            
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(error);
            NSString * errorStr =error.localizedDescription;
            if (errorStr.length>1) {
                [SVProgressHUD showErrorWithStatus:  [error.localizedDescription   substringToIndex:error.localizedDescription.length-1]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                
            }
        }];
    }else if (method == POST) {
        NSString *url = [NSString stringWithFormat:@"%@%@&sign=%@",kServerUrl, actName,sign];
        AFHTTPSessionManager *Session = [AFHTTPSessionManager manager];
        //缓存策略
        Session.requestSerializer.cachePolicy = 0;
        Session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [Session POST:url parameters:[NSDictionary dictionaryWithObject:parm forKey:@"request"] progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if([responseObject[@"resultCode"]isEqualToString:@"14"]) {
                //设置别名
                [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"pushAlias"]];
            }

            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(error);
            [SVProgressHUD showErrorWithStatus:@"网络请求失败"];

        }];
        
    }

}
//上传图片
-(void)UPImageToServer:(NSArray*)imageArr success:(SuccessImageArr)success faild:(FaildCallback)faild{
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
    //    NSString *pram = [phothBaseReq yy_modelToJSONString];
   
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"上传中..."];
    [manager POST:helper.configModel.image_hostname parameters:[upload yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArr.count; i++) {
            UIImage * image =  [UIImage scaleImageAtPixel:imageArr [i] pixel:1024];
            //1.把图片转换成二进制流
            NSData *imageData= [ UIImage scaleImage:image toKb:70];
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d", i] fileName:[NSString stringWithFormat:@"commit%d.png", i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:responseObject];
        success(baseRes.data);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild(error);
      [SVProgressHUD dismiss];
      [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
    }];
    

}
///图片展示
+(void)SD_WebImage:(UIImageView*)imageView imageUrlStr:(NSString*)urlStr placeholderImage:(NSString*)placeholder{
    
    if (placeholder==nil) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"敬请期待"]];
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",placeholder]]];
    }
    
    
    
}


-(UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

-(UIViewController*) currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
    
}

@end

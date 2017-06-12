//
//  DW-Prefix.h
//  BianMinMerchant
//
//  Created by kkk on 16/5/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#ifndef DW_Prefix_h
#define DW_Prefix_h

#import "BaseViewController.h"
#import "NSString+DWString.h"
#import "UIColor+DWColor.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "DWHelper.h"
#import "YYModel.h"
#import "AuthenticationModel.h"
#import "AESCrypt.h"
#import "MJRefresh.h"
#import "ProcessResultCode.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DWCacheManager.h"
#import "UIButton+LXMImagePosition.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "LineView.h"

#import "RequestConfigModel.h"
#import "CityModel.h"
#import "UITableView+NoData.h"
#import "UICollectionView+NoData.h"
#import "PublicBtn.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "NIBHelper.h"
#import "YanZhengOBject.h"
#import "EZTextView.h"
#import "BackgroundService.h"
#import "UIImage+DWImage.h"
#import "ImageChooseVC.h"
#import "APICount.h"
//#define GDKey @"e0d178746d6055ac6fae8ac58e11dbba"


// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define Bounds [UIScreen mainScreen].bounds
//正式
//#define kServerUrl @"http://api.bmin.wang/?"
///测试
//#define kServerUrl @"http://test.bmin.wang/?"
///开发
#define kServerUrl @"http://test.bmin.dongwuit.com/?"
#define GDKey @"6ab283311b81de8c1ac2d843244b2966"
#define kTitleColor @"#676767"
#define kSubTitleColor @"#aaaaaa"
#define kNavigationTitleColor @"#ffffff"
#define kViewBg @"#f5f5f5"
#define kNavigationBgColor @"#06c1ae"
#define kLineColor @"#EDEDED"
#define kBorderColor @"#dddddd"
#define kUserName @"dwusername"
#define kPassword @"dwpassword"

#define kFirstFont 15

#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width

#ifdef DEBUG
#define OKLog(s,...) NSLog( @"%@:%d : %@/%@\n **** %@ ****", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#   define OKLog(...)
#endif


#endif /* DW_Prefix_h */

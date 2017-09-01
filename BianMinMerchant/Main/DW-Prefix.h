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
#define kServerUrl @"http://bmin.dongwuit.com/?"
//地图
#define GDKey  [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] isEqualToString:@"com.dw.merchant"] ? @"6ab283311b81de8c1ac2d843244b2966" : @"9dd7acc47456a8294c0deb319d591741"
//极光
#define JGKey  [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] isEqualToString:@"com.dw.merchant"] ? @"f2fbd2d88f92b5a6a836a4ef" : @"4faae306e8ea7918f81df6ba"


/////正式地图
//#define GDKey @"6ab283311b81de8c1ac2d843244b2966"
/////极光正式
//#define JGKey @"f2fbd2d88f92b5a6a836a4ef"
//测试地图
//#define GDKey @"9dd7acc47456a8294c0deb319d591741"
//极光测试
//#define JGKey @"4faae306e8ea7918f81df6ba"
    

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

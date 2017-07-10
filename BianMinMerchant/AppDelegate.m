//
//  AppDelegate.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/27.
//  Copyright © 2016年 bianming. All rights reserved.
//
#import "AppDelegate.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "LoginController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SelectedShopKindController.h"
#import "PublicMessageVC.h"
#import "SVProgressHUD.h"
@interface AppDelegate ()<UIScrollViewDelegate,JPUSHRegisterDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) AVPlayer *player;

@property(nonatomic,strong) NSDictionary * userInfo;
///推送别名（新增）
@property (nonatomic, strong) NSString  *pushAlias;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    self.window.backgroundColor = [UIColor whiteColor];
    NSNumber *firstLoad = [DWCacheManager getPrivateCacheByKey:@"firstLoad"];
    if (firstLoad) {
        SelectedShopKindController *selectedC = [[SelectedShopKindController alloc] initWithNibName:@"SelectedShopKindController" bundle:nil];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:selectedC];
        self.window.rootViewController = navC;
    }else {
        [DWCacheManager setPrivateCache:@(1) key:@"firstLoad"];
       [self addScrollView];
    }
    [AMapServices sharedServices].apiKey =GDKey;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [self.window makeKeyWindow];
    [application setApplicationIconBadgeNumber:0];
    NSLog(@"%ld", (long)application.applicationIconBadgeNumber);
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    //设置第三方
    [self SetUpThirdParty:launchOptions];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    UILocalNotification * LocalNotification = [UILocalNotification new];
    LocalNotification.applicationIconBadgeNumber = -1;
    [application presentLocalNotificationNow: LocalNotification];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)addScrollView {
//    LoginController *loginC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginController"];
    SelectedShopKindController *selectedC = [[SelectedShopKindController alloc] initWithNibName:@"SelectedShopKindController" bundle:nil];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:selectedC];
    self.window.rootViewController = navC;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:Bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(Width*4, Height);
    [self.window.rootViewController.view addSubview:scrollView];
    for (int i = 0;i < 4 ; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*Width, 0, Width, Height)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"WelcomePage%d.jpg",i+1]];
        [scrollView addSubview:iv];
        if (i == 3) {
            iv.backgroundColor = [UIColor clearColor];
        }
    }
}

//欢迎页跳转至登录页面
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"%f", offset.x);
    
    if (3*Width == offset.x) {
        [scrollView removeFromSuperview];
    }
}
#pragma mark - 设置所有第三方
-(void)SetUpThirdParty:(NSDictionary *)launchOptions{
    //极光推送
    [self JGPush:launchOptions];
    UILocalNotification * LocalNotification = [UILocalNotification new];
    LocalNotification.applicationIconBadgeNumber = -1;
    [[UIApplication sharedApplication] presentLocalNotificationNow: LocalNotification];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (launchOptions) {
            // apn 内容获取：
            NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
            //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
            if (remoteNotification) {
                NSLog(@"推送消息==== %@",remoteNotification);
                self.userInfo = remoteNotification;
                [self receivePushMessage];
            }
        }
    });
}
#pragma mark - 极光推送
-(void)JGPush:(NSDictionary *)launchOptions{
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
      #ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
       #endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    //    [JPUSHService setupWithOption:launchOptions appKey:appKey
    //                          channel:channel
    //                 apsForProduction:isProduction
    //            advertisingIdentifier:advertisingId];
    //    //如不需要使用IDFA，advertisingIdentifier 可为nil
        [JPUSHService setupWithOption:launchOptions appKey:JGKey
                              channel:@"官网"
                     apsForProduction:false
                advertisingIdentifier:advertisingId];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            //            [USER setObject:registrationID forKey:@"deviceToken"];
            //            [USER synchronize];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
             NSLog(@"registrationID获取失败，%@",registrationID);
        }
    }];
    //设置别名
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SetUpAlias:) name:@"设置别名" object:nil];
}
#pragma mark -  设置别名
-(void)SetUpAlias:(NSNotification*)sender{
    NSDictionary * dic = sender.userInfo;
    self.pushAlias =dic[@"pushAlias"];
    //self.pushAlias = [NSString stringWithFormat:@"%@%@",[JPUSHService registrationID],dic[@"pushAlias"]];
    __weak typeof(self) weakSelf = self;
    [JPUSHService setAlias:weakSelf.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:weakSelf];
//     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    [JPUSHService setAlias:weakSelf.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:weakSelf];
//    });
}
#pragma mark - 推送别名
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    if (iResCode == 0) {
        
    }
    if (iResCode == 6002) {
        [JPUSHService setAlias:self.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    else{
        
    }
    NSLog(@"push set alias success alisa = %@", alias);
}
#pragma mark - 注册通知

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    [JPUSHService registerDeviceToken:deviceToken];
    
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //    [SVProgressHUD showInfoWithStatus:@"注册推送失败"];
    NSLog(@"注册推送失败------------------");
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
    
    self.userInfo = userInfo;
    [self receivePushMessage];
}
//前台收到通知
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
        UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
//        self.userInfo = userInfo;
//        [self receivePushMessage];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
//后台收到推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    [JPUSHService setBadge: [content.badge integerValue]-1];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        self.userInfo = userInfo;
        [self receivePushMessage];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


#pragma mark - APP运行中接收到通知(推送)处理

///** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        [self receiveRemoteNotificationReset:userInfo];
    }else  if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        [self receiveRemoteNotificationReset:userInfo];
    }else if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        self.userInfo = userInfo;
        [self receivePushMessage];
    } else{
        //        self.userInfo = userInfo;
        //        [self receivePushMessage];
        
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark------------------收到通知的页面处理
-(void)receivePushMessage {
    NSDictionary *dic =self.userInfo;
    if (dic.count==0) {
        return;
    }
    //用户类型：0-用户，1-团购 2-便民 3-出行
    NSNumber *  industry =dic[@"industry"];
   // 1-消息列表
    NSNumber * transferType =dic[@"transferType"];
    switch ([industry intValue]) {
        case 0:
        {
            break;
        }
        case 1:
        {
            if ([transferType intValue]==1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"团购消息列表" object:@"团购消息列表" userInfo:@{}];
                return;
            }
            break;
        }
        case 2:
        {
            if ([transferType intValue]==1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"便民消息列表" object:@"便民消息列表" userInfo:@{}];
                return;
            }
            break;
        }
            case 3:
        {
            if ([transferType intValue]==1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"出行消息列表" object:@"出行消息列表" userInfo:@{}];
                return;
            }
            break;
        }
        default:{
            break;
        }
    }
 }
#pragma mark - 运行在前台时的提示框提醒
-(void)receiveRemoteNotificationReset:(NSDictionary *)userInfo{
    if (userInfo) {
        self.userInfo = userInfo;
    }
    NSString *typeStirng=userInfo[@"type"];
    if(typeStirng==nil||[typeStirng integerValue]==0){
        [self showReceiveMessage:userInfo[@"title"]];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:userInfo[@"title"] message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"稍后"
                                                  otherButtonTitles:@"立即前往", nil];
        [alertView show];
    }
    
}
#pragma mark-------------------------------推送处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self receivePushMessage];
    }
}
#pragma mark - 设置推送内容的展示
-(void)showReceiveMessage:(NSString *)message{
//        [JDStatusBarNotification showWithStatus:message
//                                   dismissAfter:2.0
//                                      styleName:@"SBStyle"];
//    
}



@end

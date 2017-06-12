//
//  ShopViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ShopViewController.h"
#import "LBXScanWrapper.h"
#import "LBXScanViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXViewController.h"
#import "MessageCenterViewController.h"
#import "TardeViewController.h"
#import "MoneyCenterViewController.h"
#import "TicketViewController.h"
#import "ShopCenterViewController.h"
#import "SettingViewController.h"
#import "MerchantModel.h"
#import "JPUSHService.h"
#import "RequestGoodsOrderUser.h"
#import "RequestMerchantInfoModel.h"
#import "WriteMessageViewController.h"
#import "TravelwithdrawalVC.h"
#import "BulkHomeVC.h"
#define Space 40
#define ImageW (Width - (Space * 4))/3

@interface ShopViewController ()<LBXscanViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cornerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cornerHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;



@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNumber;
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImage;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (nonatomic, strong) RequestMerchantInfoModel *shopModel;
@property(nonatomic,strong)MerchantModel *merchantModel;
@end

@implementation ShopViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Do any additional setup after loading the view.
    UIView *notView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    notView.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:notView];
    self.navigationItem.leftBarButtonItem = backItem;
    self.barcodeImage.contentMode = UIViewContentModeScaleAspectFit;
    self.cornerHeight.constant = Height-64;
    
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    NSString *monthly = [locationString substringToIndex:2];
    if ([[monthly substringToIndex:1] isEqualToString:@"0"]) {
        monthly = [monthly substringFromIndex:1];
        
    }
    NSString *day = [locationString substringFromIndex:2];
    if ([[day substringToIndex:1] isEqualToString:@"0"]) {
        day = [day substringFromIndex:1];
    }
    self.logoimg.layer.masksToBounds = YES;
    self.logoimg.layer.cornerRadius = Width*0.2/2;
    //self.logoimg.backgroundColor = [UIColor redColor];
    self.logoimg.contentMode = UIViewContentModeScaleAspectFill;
    //self.dateLabel.text = [NSString stringWithFormat:@"今日交易(%@月%@号)", monthly,day];
    self.dateLabel.text = [NSString stringWithFormat:@"今日交易额"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopData) name:@"修改商户资料" object:nil];
    [self createView];
    [self naviagtionRightView];
    //[self requestUserInfo];
    [self getShopData];
    //获取配置信息
    [self getConfig];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService removeNotification:nil];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataOrderData) name:@"刷新订单" object:nil];
    self.scrollerView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getShopData];
    }];
    
    
}


- (void)updataOrderData {
    [self getShopData];
}

- (void)getConfig {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = @[];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestConfig" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        RequestConfigModel *model = [RequestConfigModel yy_modelWithJSON:baseRes.data];
        [DWHelper shareHelper].configModel = model;
    } faild:^(id error) {
        
    }];
}
- (void)naviagtionRightView {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [backBtn setImage:[UIImage imageNamed:@"icon_my_shezhi"] forState:UIControlStateNormal];
    //backBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [backBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}

- (void)settingAction:(UIButton *)sender {
//    SettingViewController *settingC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
//    settingC.shopModel = self.shopModel;
//    [self.navigationController pushViewController:settingC animated:YES];
    
    //Push 跳转
    BulkHomeVC * VC = [[BulkHomeVC alloc]initWithNibName:@"BulkHomeVC" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

    
}

- (IBAction)addMessageAction:(id)sender {
    DWHelper *helper = [DWHelper shareHelper];
    if (helper.messageStatus == 0) {
        [self showToast:@"禁用"];
    }else if (helper.messageStatus == 2) {
//        WriteMessageViewController *messgeC = [[WriteMessageViewController alloc] init];
//        messgeC.shopModel = self.shopModel;
//        __weak typeof(self) weakSelf = self;
//        
//        messgeC.backAction =^(NSString *str){
//            [weakSelf getShopData];
//        };
//
//        [self.navigationController pushViewController:messgeC animated:YES];
    }else if (helper.messageStatus == 3) {
        [self showToast:@"审核中"];
    }
}

- (void)createView {
    UIView *bgView = [[UIView alloc] init];
    [self.cornerView addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cornerView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(@(Space*3 + ImageW*2 + Space));
    }];
    NSArray *nameArr = @[@"扫一扫",@"消息中心",@"交易记录",@"卡券管理",@"提现",@"商品管理"];
    NSArray *pictureArr = @[@"btn_zhuye_saoyisao",@"btn_zhuye_xiaoxizhongxin",@"btn_zhuye_jiaoyijilu",@"btn_zhuye_kaquanguanli",@"btn_denglu_tixian",@"btn_zhuye_guanli"];
    NSInteger count = 0;
    
    for (int i = 0; i<2; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(Space + j * (ImageW+Space), Space + i * (ImageW + 1.5*Space), ImageW, ImageW);
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn setImage:[UIImage imageNamed:pictureArr[count]] forState:UIControlStateNormal];
            btn.tag = 1000+count;
            btn.backgroundColor = [UIColor clearColor];
            [bgView addSubview:btn];
            
            UILabel *numLabel = [UILabel new];
            numLabel.hidden = YES;
            numLabel.textColor = [UIColor colorWithHexString:kNavigationBgColor];
            numLabel.text = @"10";
            numLabel.backgroundColor = [UIColor clearColor];
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.font = [UIFont systemFontOfSize:15];
            [self.cornerView addSubview:numLabel];
            [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(btn.mas_top);
                make.right.equalTo(btn.mas_right).with.offset(5);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
            
            UILabel *nameLabel = [UILabel new];
            nameLabel.text = nameArr[count];
            nameLabel.font = [UIFont systemFontOfSize:12];
            [self.cornerView addSubview:nameLabel];
            nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn.mas_bottom).with.offset(5);
                make.centerX.equalTo(btn);
                make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
            
            count = count+1;
        }
    }
    
}

- (void)btnAction:(UIButton *)sender {
    DWHelper *helper = [DWHelper shareHelper];
    if (helper.messageStatus == 0) {
        [self showToast:@"禁用"];
    }else if (helper.messageStatus == 1) {
        [self pushController:sender];
    }else if (helper.messageStatus == 2) {
//        WriteMessageViewController *writeMessage = [[WriteMessageViewController alloc] init];
//        writeMessage.shopModel = self.shopModel;
//        __weak typeof(self) weakSelf = self;
//        writeMessage.backAction =^(NSString *str){
//            [weakSelf getShopData];
//        };
//
//        [self.navigationController pushViewController:writeMessage animated:YES];
    }else if (helper.messageStatus == 3) {
        [self showToast:@"审核中"];
    }
}
- (void)pushController:(UIButton *)sender {
    if ((sender.tag - 1000) == 0) {
        //设置扫码区域参数设置
        //创建参数对象
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        //矩形区域中心上移，默认中心点为屏幕中心点
        style.centerUpOffset = 44;
        //扫码框周围4个角的类型,设置为外挂式
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
        //扫码框周围4个角绘制的线条宽度
        style.photoframeLineW = 6;
        //扫码框周围4个角的宽度
        style.photoframeAngleW = 24;
        //扫码框周围4个角的高度
        style.photoframeAngleH = 24;
        //扫码框内 动画类型 --线条上下移动
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        //线条上下移动图片
        style.animationImage = [UIImage imageNamed:@"icon_saoyisao_saomiaoxian"];
        //SubLBXScanViewController继承自LBXScanViewController
        //添加一些扫码或相册结果处理
        LBXViewController *vc = [[LBXViewController alloc] init];
        vc.delegate = self;
        vc.style = style;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ((sender.tag - 1000) == 1) {
        MessageCenterViewController *messageController = [[MessageCenterViewController alloc] init];
        [self.navigationController pushViewController:messageController animated:YES];
    }else if ((sender.tag - 1000) == 2) {
        TardeViewController *tarde = [[TardeViewController alloc] init];
        [self.navigationController pushViewController:tarde animated:YES];
    }else if (sender.tag - 1000 == 3) {
        TicketViewController *ticketController = [[TicketViewController alloc] init];
        [self.navigationController pushViewController:ticketController animated:YES];
    }else if (sender.tag - 1000 == 4) {
//        MoneyCenterViewController *moneyC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyCenterViewController"];
//        [self.navigationController pushViewController:moneyC animated:YES];
        //Push 跳转--提现
        TravelwithdrawalVC * VC = [[TravelwithdrawalVC alloc]initWithNibName:@"TravelwithdrawalVC" bundle:nil];
        VC.account = self.shopModel.account;
        [self.navigationController  pushViewController:VC animated:YES];
        
        
    }else if (sender.tag - 1000 == 5) {
        ShopCenterViewController *shopCenterC = [[ShopCenterViewController alloc] init];
        [self.navigationController pushViewController:shopCenterC animated:YES];
    }
}

- (void)backAction:(LBXScanResult *)result {
    NSString *  strone = [result.strScanned substringToIndex:4];
    if (![strone isEqualToString:@"dwbm"]) {
        [self alertWithTitle:@"温馨提示" message:@"目前在不支持" OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
            
        }];
        return;
    }else{

    
        
        
//            NSString *str = [result.strScanned substringFromIndex:7];
//        
//        NSLog(@"%@",str);
//           // NSDictionary * dic1 = [str yy_modelToJSONObject];
//        
//            NSData * data= [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//        
//            NSMutableDictionary * dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//             NSLog(@"%@",dic);
        
       
//        NSRange range = [str rangeOfString:@":"];
//        NSString *str1 = [str substringToIndex:range.location];
//        NSString *str2 = [str substringFromIndex:range.location+1];
//        注意：元素本身就是字符。
    NSString *str = [result.strScanned substringFromIndex:7];
    NSArray * Arr = [str componentsSeparatedByString:@":"];
        __weak typeof(self) weakSelf = self;
        [self alertWithTitle:@"是否消费?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            [self showProgress];
            RequestGoodsOrderUser *orderUse = [[RequestGoodsOrderUser alloc] init];
            //            orderUse.orderNo = str1;
            //            orderUse.couponNo = str2;
            orderUse.orderNo = Arr[0];
            orderUse.couponNo = Arr[1];
            orderUse.goodsOrderId = Arr[2];;
            orderUse.goodsOrderCouponId = Arr[3];;
            BaseRequest *request = [[BaseRequest alloc] init];
            request.encryptionType = AES;
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            request.token = [userD objectForKey:@"loginToken"];
            request.data = [AESCrypt encrypt:[orderUse yy_modelToJSONString] password:[userD objectForKey:@"loginKey"]];
            [[DWHelper shareHelper] requestDataWithParm:[request yy_modelToJSONString] act:@"act=MerApi/Merchant/requestGoodsOrderUser" sign:[request.data MD5Hash] requestMethod:GET success:^(id response) {
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                if (baseRes.resultCode == 1) {
                    [weakSelf hideProgress];
                    [weakSelf showToast:@"消费成功"];
                }else {
                    [weakSelf showToast: baseRes.msg];
                    
                }
                [weakSelf hideProgress];
            } faild:^(id error) {
                [weakSelf hideProgress];
                
            }];
            
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];

        }
}

- (void)useOrderNo:(LBXScanResult *)sender{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)requestUserInfo{
//    BaseRequest *baseRequest = [[BaseRequest alloc] init];
//    baseRequest.token = [AuthenticationModel getLoginToken];
//    baseRequest.encryptionType = AES;
//    baseRequest.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
//    __weak typeof(self) weakSelf = self;
//
//    [[DWHelper shareHelper] requestDataWithParm:[baseRequest yy_modelToJSONString] act:@"act=MerApi/Merchant/requestMerchantInfo" sign:[baseRequest.data  MD5Hash] requestMethod:GET success:^(id response) {
//        
//        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
//      weakSelf.  merchantModel = [MerchantModel yy_modelWithJSON:baseRes.data];
//        
//        [JPUSHService setAlias:weakSelf.merchantModel.merchantNo
//              callbackSelector:@selector(tagsAliasCallback:tags:alias:)
//                        object:self];
//    } faild:^(id error) {
//        
//    }];
//    
//}

- (void)getShopData {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[[NSArray array] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestMerchantInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.shopModel = [RequestMerchantInfoModel yy_modelWithJSON:baseRes.data];
            self.title = self.shopModel.merchantName;
            self.barcodeImage.image = [LBXScanWrapper createQRWithString:self.shopModel.merchantNo size:self.barcodeImage.frame.size];
            self.shopNumber.text = [NSString stringWithFormat:@"商户号:%@", self.shopModel.merchantNo];
            self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f元", self.shopModel.tradeMoneyDay];
            [self loadImageWithView:self.logoimg urlStr:self.shopModel.iconUrl];
            
            //[JPUSHService setAlias:self.shopModel.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            [self loadImageWithView:self.logoimg urlStr:self.shopModel.iconUrl];
            
            DWHelper *helper = [DWHelper shareHelper];
            helper.messageStatus = self.shopModel.status;
            helper.shopModel = self.shopModel;
            if (self.shopModel.status == 1) {
                self.messageBtn.hidden = YES;
                self.rightImage.hidden = YES;
            }else {
                self.messageBtn.hidden = NO;
                self.rightImage.hidden = NO;
            }
            
        }else {
        }
        [self.scrollerView.mj_header endRefreshing];
    } faild:^(id error) {
        [self.scrollerView.mj_header endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
    [self getShopData];
}

#pragma mark - 推送别名
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    if (iResCode == 6002) {
        [JPUSHService setAlias:self.shopModel.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    NSLog(@"push set alias success alisa = %@", alias);
}




@end

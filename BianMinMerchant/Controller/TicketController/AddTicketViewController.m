//
//  AddTicketViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/6/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AddTicketViewController.h"
#import "HZQDatePickerView.h"
#import "RequestAddCoupon.h"
#import "CouponInfoModel.h"
#import "RequestUpdateCoupon.h"
@interface AddTicketViewController ()<HZQDatePickerViewDelegate> {
    
    HZQDatePickerView *_pikerView;
}


@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UITextField *explainText;
@property (weak, nonatomic) IBOutlet UITextField *mPriceTex;
@property (weak, nonatomic) IBOutlet UITextField *mVauleText;
@property (weak, nonatomic) IBOutlet UITextField *lValueText;
@property (weak, nonatomic) IBOutlet UITextField *dValueText;

@property (weak, nonatomic) IBOutlet UIView *mView;
@property (weak, nonatomic) IBOutlet UITextField *goodsName;

@property (weak, nonatomic) IBOutlet UIView *lView;
@property (weak, nonatomic) IBOutlet UIView *zView;

@end

@implementation AddTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];

    NSString *nowDate = [dateFormatter stringFromDate:currentDate];
    self.startTimeLabel.text = [NSString stringWithFormat:@"%@ 00:00:00",nowDate];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@ 23:59:59",nowDate];

    // Do any additional setup after loading the view.
    switch (self.ticketKind) {
        case 0:
            self.title = @"满减券";
            self.lView.hidden = YES;
            self.zView.hidden = YES;
            break;
        case 1:
            self.title = @"立减券";
            self.zView.hidden = YES;
            self.mView.frame = CGRectMake(self.mView.frame.origin.x, self.mView.frame.origin.y, self.mView.frame.size.width, 1);
//            self.mView.hidden = YES;
            break;
        case 2:
            self.title = @"折扣券";
            break;
        default:
            break;
    }

    [self showBackBtn];
    [self createView];
    if (self.isAddMessage == NO) {
        self.startTimeLabel.text = self.model.beginTime;
        self.endTimeLabel.text = self.model.endTime;
        self.numberText.text = [NSString stringWithFormat:@"%ld",(long)self.model.storeAmount];
        self.goodsName.text = self.model.couponName;
      self.explainText.text=  self.model. couponContent;
        switch (self.model.couponType) {
            case 1:
                //self.explainText.text = [NSString stringWithFormat:@"满%.2f元,立减%.2f元", [self.model.mPrice floatValue],[self.model.mVaule floatValue]];
                self.mPriceTex.text = [NSString stringWithFormat:@"%.2f",[self.model.mPrice floatValue]];
                self.mVauleText.text = [NSString stringWithFormat:@"%.2f", [self.model.mVaule floatValue]];
                break;
            case 2:
                //self.explainText.text = [NSString stringWithFormat:@"下单立减%.2f元", [self.model.lValue floatValue]];
                self.lValueText.text = [NSString stringWithFormat:@"%.2f", [self.model.lValue floatValue]];
                break;
            case 3:
                
               // if (self.model.dValue %10==0) {
                    
                //self.explainText.text = [NSString stringWithFormat:@"本商品打%.2f折", [[NSString stringWithFormat:@"%ld", (long)(_model.dValue)] floatValue]/100.0];
                //}
//                self.explainText.text = [NSString stringWithFormat:@"本商品打%ld折", (long)self.model.dValue];
                self.dValueText.text = [NSString stringWithFormat:@"%ld", self.model.dValue];
                break;
            default:
                break;
        }

        
    }
    
}

- (void)createView {
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAction:)];
    self.startTimeLabel.userInteractionEnabled = YES;
    [self.startTimeLabel addGestureRecognizer:startTap];
    
    UITapGestureRecognizer *endTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endAction:)];
    self.endTimeLabel.userInteractionEnabled = YES;
    [self.endTimeLabel addGestureRecognizer:endTap];
    
}

- (void)startAction:(UITapGestureRecognizer *)sender {
    NSLog(@"点击");
    [self setupDateView:DateTypeOfStart];
}
- (void)endAction:(UITapGestureRecognizer *)sender {
    [self setupDateView:DateTypeOfEnd];
}

- (void)setupDateView:(DateType)type {
    
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, Width , Height + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    // 今天开始往后的日期
    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    //    [_pikerView.datePickerView setMaximumDate:[NSDate date]];
    [self.view addSubview:_pikerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    
    switch (type) {
        case DateTypeOfStart:
            self.startTimeLabel.text = [NSString stringWithFormat:@"%@ 00:00:00", date];
            
            break;
            
        case DateTypeOfEnd:
            self.endTimeLabel.text = [NSString stringWithFormat:@"%@ 23:59:59", date];
            
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)sureAction:(id)sender {
    
    
    
    
    if ([self.startTimeLabel.text isEqualToString:@"点击选择时间"]) {
        [self showToast:@"请选择开始时间"];
        return;
    }
    if ([self.endTimeLabel.text isEqualToString:@"点击选择时间"]) {
        [self showToast:@"请选择结束时间"];
        return;
    }
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *nowDate = [dateFormatter stringFromDate:currentDate];
    NSLog(@"%@",nowDate);
   
    NSString * startTimeStr = [self.startTimeLabel.text substringToIndex:10];
    
     NSString *a = [startTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];//该方法是去掉指定符号
     NSString * endTimeStr = [self.endTimeLabel.text substringToIndex:10];
    NSString *b = [endTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];//该方法是去掉指定符号

    
    
    
    if ([a intValue]<[nowDate intValue  ]) {
        [self showToast:@"请不要选择早于今日的日期"];
        return;
    }
    if ([a intValue]>[b intValue  ]) {
        [self showToast:@"开始时间不能晚于结束时间"];
        return;
    }
    
    if (self.isAddMessage) {
        RequestAddCoupon *requestAdd = [[RequestAddCoupon alloc] init];
        
        
        
        if (self.goodsName.text.length==0) {
            [self showToast:@"请填写商品名称"];
            return;
        }
        if (self.explainText.text.length==0) {
            [self showToast:@"请填写卡券描述"];
            return;
        }
        if (self.numberText.text.length==0) {
            [self showToast:@"请填写数量"];
            return;
        }
        switch (self.ticketKind) {
            case 0:
                //self.title = @"满减券";
                if (self.mPriceTex.text.length==0) {
                    [self showToast:@"请输入满:"];
                    return;
                }
                if (self.mVauleText.text.length==0) {
                    [self showToast:@"请输入减:"];
                    return;
                }
                if ([self.mPriceTex.text floatValue]<[self.mVauleText.text floatValue]) {
                    [self showToast:@"满的额度不能小于减的额度"];
                    return;
                }else{
                    
                }
                break;
            case 1:
                //self.title = @"立减券";
                if (self.lValueText.text.length==0) {
                    [self showToast:@"请输入立减劵"];
                    return;
                }
                
                break;
            case 2:
                //self.title = @"折扣券";
                if (self.dValueText.text.length==0) {
                    [self showToast:@"请输入折扣券"];
                    return;
                }
                break;
            default:
                break;
        }

        
        requestAdd.couponType = self.ticketKind+1;
        requestAdd.couponName = self.goodsName.text;
        requestAdd.couponContent = self.explainText.text;
        requestAdd.storeAmount = self.numberText.text ;
        requestAdd.beginTime = self.startTimeLabel.text;
        requestAdd.endTime = self.endTimeLabel.text;
        requestAdd.mPrice = self.mPriceTex.text ;
        requestAdd.mVaule = self.mVauleText.text ;
        requestAdd.lValue = self.lValueText.text ;
        requestAdd.dValue = self.dValueText.text ;
        
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[requestAdd yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        self.view.userInteractionEnabled = NO;
        __weak typeof(self) weakSelf = self;

        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestAddCoupon" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                weakSelf.balkAction(nil);
                
                [weakSelf showSuccessWith:@"添加成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                
                
                [weakSelf showToast:baseRes.msg];
                weakSelf.view.userInteractionEnabled = YES;
            }
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;
        }];

    }else {
        RequestUpdateCoupon *requestAdd = [[RequestUpdateCoupon alloc] init];
        
        
        if (self.goodsName.text.length==0) {
            [self showToast:@"请填写商品名称"];
            return;
        }
        if (self.explainText.text.length==0) {
            [self showToast:@"请填写卡券描述"];
            return;
        }
        if (self.numberText.text.length==0) {
            [self showToast:@"请填写数量"];
            return;
        }
        switch (self.ticketKind) {
            case 0:
                //self.title = @"满减券";
                if (self.mPriceTex.text.length==0) {
                    [self showToast:@"请输入满:"];
                    return;
                }
                if (self.mVauleText.text.length==0) {
                    [self showToast:@"请输入减:"];
                    return;
                }
                if ([self.mPriceTex.text floatValue]<[self.mVauleText.text floatValue]) {
                    [self showToast:@"满的额度不能小于减的额度"];
                    return;
                }else{
                    
                }

                break;
            case 1:
                //self.title = @"立减券";
                if (self.lValueText.text.length==0) {
                    [self showToast:@"请输入立减劵"];
                    return;
                }
                
                break;
            case 2:
                //self.title = @"折扣券";
                if (self.dValueText.text.length==0) {
                    [self showToast:@"请输入折扣券"];
                    return;
                }
                break;
            default:
                break;
        }

        requestAdd.couponName = self.goodsName.text;
        requestAdd.couponId = self.coundID;
        requestAdd.couponContent = self.explainText.text;
        requestAdd.storeAmount = self.numberText.text ;
        requestAdd.beginTime = self.startTimeLabel.text;
        requestAdd.endTime = self.endTimeLabel.text;
        requestAdd.mPrice = self.mPriceTex.text ;
        requestAdd.mVaule = self.mVauleText.text ;
        requestAdd.lValue = self.lValueText.text ;
        requestAdd.dValue = self.dValueText.text ;
        self.view.userInteractionEnabled = NO;
        __weak typeof(self) weakSelf = self;

        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[requestAdd yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestUpdateCoupon" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                weakSelf.settingBlock(@"");
                [weakSelf showSuccessWith:@"修改成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showToast:baseRes.msg];
                weakSelf.view.userInteractionEnabled = YES;
            }
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;
        }];
    }
    
    
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    switch (self.ticketKind) {
        case 0:
            self.lView.hidden = YES;
            self.zView.hidden = YES;
            break;
        case 1:
            self.zView.hidden = YES;
            self.mView.hidden = YES;
            self.lView.frame = self.mView.frame;
            break;
        case 2:
            self.mView.hidden = YES;
            self.lView.hidden = YES;
            self.zView.frame = self.mView.frame;
            break;
        default:
            break;
    }
}

//判断输入钱的正则表达式，可输入正负，小数点前5位，小数点后2位，位数可控
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.mPriceTex isEqual:textField]||[self.mVauleText isEqual:textField]||[self.lValueText isEqual:textField]||[self.dValueText isEqual:textField]) {
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toString.length > 0) {
            NSString *stringRegex = @"(\\+)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
            BOOL flag = [phoneTest evaluateWithObject:toString];
            if (!flag) {
                return NO;
            }
        }
        return YES;
    }
    
    if ([self.numberText isEqual:textField]) {
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //^[0-9]*$
        
        if (toString.length > 0) {
            NSString *stringRegex = @"^([1-9]\\d{0,9})$";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
            BOOL flag = [phoneTest evaluateWithObject:toString];
            if (!flag) {
                return NO;
            }
        }
        return YES;
    }
    
    
    
    
    return YES;
    
    
    
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

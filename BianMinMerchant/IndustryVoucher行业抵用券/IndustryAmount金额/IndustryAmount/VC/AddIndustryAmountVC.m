//
//  AddIndustryAmountVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "AddIndustryAmountVC.h"
#import "XFDaterView.h"
#import "IndustryModel.h"

@interface AddIndustryAmountVC ()<XFDaterViewDelegate,UITextFieldDelegate>{
    XFDaterView*dater;
}
@property(nonatomic,strong)NSString*  timeStr;
@property(nonatomic,strong)IndustryModel *industryModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refuseReasonViewConstraint;

@end

@implementation AddIndustryAmountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.title =self.model ? @"详情": @"添加";
    self.totalFaceAmount.delegate = self;
    [self showBackBtn];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
     self.industryModel = [IndustryModel new];
    if (self.model) {
        self.industryModel =self.model;
        _totalFaceAmount.text = self.industryModel.totalFaceAmount;
        self.refuseReasonViewConstraint.constant = [NSString getTextHight:self.industryModel.refuseReason withSize:Width-100 withFont:15]+20;
        _refuseReason.text =self.industryModel.refuseReason;
        [_beginTime setTitle:self.industryModel.beginTime forState:0];
        [_endTime setTitle:self.industryModel.endTime forState:0];
    }else{
        self.refuseReasonViewConstraint.constant =0.00;
        self.refuseReasonView .hidden = YES;
    }
   
   
}
//判断输入钱的正则表达式，正整数，最多6位。
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 0) {
        NSString *stringRegex = @"^[1-9]\\d{0,5}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:toString];
        if (!flag) {
            return NO;
        }
    }
    return YES;
    
}

#pragma mark - 开始时间
- (IBAction)stastTimeAction:(UIButton *)sender {
    
    [self.view endEditing:NO];
    self.timeStr = @"1";
    if (!dater) {
        dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
        dater.delegate=self;
        [dater showInView:self.view animated:YES];
        dater.dateViewType=XFDateViewTypeDate;
    }else{
        [dater showInView:self.view animated:YES];
    }
}
#pragma mark - 结束时间
- (IBAction)endTimeAction:(UIButton *)sender {
    [self.view endEditing:NO];
    self.timeStr = @"2";
    if (!dater) {
        dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
        dater.delegate=self;
        [dater showInView:self.view animated:YES];
        dater.dateViewType=XFDateViewTypeDate;
    }else{
        [dater showInView:self.view animated:YES];
    }
}



#pragma mark -
- (void)daterViewDidClicked:(XFDaterView *)daterView{
    if ([daterView isEqual:dater]) {
        if ([self.timeStr isEqualToString:@"1"]) {
            [self.beginTime setTitle: daterView.dateString  forState:(UIControlStateNormal)]  ;
            self.industryModel.beginTime =daterView.dateString;
        }else if([self.timeStr isEqualToString:@"2"]){
            [self.endTime setTitle: daterView.dateString  forState:(UIControlStateNormal)];
            self.industryModel.endTime =daterView.dateString;
        }
   }
}
#pragma mark -  日历取消
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    
    
    
    
}

- (IBAction)submitAction:(PublicBtn *)sender {
    if ([self IF]) {
        __weak typeof(self) weakSelf = self;
        [self alertWithTitle:@"是否申请?" message:nil OKWithTitle:@"确认" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            weakSelf.view.userInteractionEnabled = NO;
            NSString *Token =[AuthenticationModel getLoginToken];
            __weak typeof(self) weakself = self;
            if (Token.length!= 0) {
                BaseRequest *baseReq = [[BaseRequest alloc] init];
                baseReq.token = [AuthenticationModel getLoginToken];
                baseReq.encryptionType = AES;
                baseReq.data = [AESCrypt encrypt:[weakself.industryModel yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
                [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:self.model ? @"act=MerApi/IndustryCouponFace/requestUpdateIndustryCouponFace": @"act=MerApi/IndustryCouponFace/requestAddIndustryCouponFace" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                    NSLog(@"申请/修改面额----%@",response);
                    if ([response[@"resultCode"] isEqualToString:@"1"]) {
                        [weakSelf showToast:response[@"msg"]];
                        weakSelf.model.status =weakSelf.model ? @"1" :nil;
                        weakSelf.AddIndustryAmountVCBlock();
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        });
                    }else{
                        weakself.view.userInteractionEnabled = YES;
                        [weakself showToast:response[@"msg"]];
                        
                    }
                    
                } faild:^(id error) {
                    weakself.view.userInteractionEnabled = YES;
                    NSLog(@"%@", error);
                }];
            }
            
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
        
    }

    
}

#pragma mark - 判断条件
-(BOOL)IF{
    BOOL  Y = YES;
    [self.view endEditing:YES];
    self.industryModel.totalFaceAmount =self.totalFaceAmount.text;
    if (self.totalFaceAmount.text.length==0) {
        [self showToast:@"请输入总金额"];
        return NO;
    }
    if ([self.beginTime.titleLabel.text isEqualToString:@"起"]) {
        [self showToast:@"请选择开始日期"];
        return NO;
    }
    if ([self.endTime.titleLabel.text isEqualToString:@"止"]) {
        [self showToast:@"请选择结束日期"];
        return NO;
    }
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *nowDate = [dateFormatter stringFromDate:currentDate];
    NSString *a = [[self.beginTime.titleLabel.text substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@""];//该方法是去掉指定符号
    NSString *b = [[self.endTime.titleLabel.text substringToIndex:10]stringByReplacingOccurrencesOfString:@"-" withString:@""];//该方法是去掉指定符号
       if ([a intValue]<[nowDate intValue  ]) {
        [self showToast:@"请不要选择早于今日的日期"];
        return NO;
    }
    if ([a intValue]>[b intValue  ]) {
        [self showToast:@"起始时间不能晚于结束时间"];
        return NO;
    }

    return Y;
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
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end

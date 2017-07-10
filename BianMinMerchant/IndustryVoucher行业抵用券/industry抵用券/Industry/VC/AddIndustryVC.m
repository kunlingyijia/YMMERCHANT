//
//  AddIndustryVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "AddIndustryVC.h"
#import "XFDaterView.h"
#import "ChooseCarListVC.h"
#import "DhooseFaceListVC.h"
#import "RulesWebVC.h"
#import "IndustryModel.h"
@interface AddIndustryVC ()<XFDaterViewDelegate,UITextFieldDelegate>{
    XFDaterView*dater;
}
@property(nonatomic,strong)NSString*  timeStr;
@property(nonatomic,strong)IndustryModel*  industryModel;
@end
@implementation AddIndustryVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.title = @"添加";
    self.nstockTF.delegate = self;
    self.limitAmount.delegate = self;
    __weak typeof(self) weakSelf = self;
    [self showBackBtn:^{
        [weakSelf alertWithTitle:@"亲,您确定要离开?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }];
    [self showRightBtnTitle:@"规则" Image:nil RightBtn:^{
        //Push 跳转
        RulesWebVC * VC = [[RulesWebVC alloc]initWithNibName:@"RulesWebVC" bundle:nil];
       [weakSelf.navigationController  pushViewController:VC animated:YES];
    }];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.industryModel = [IndustryModel new];
    self.industryModel.faceId = self.faceId;
    if (self.model) {
        self.industryModel = _model;
        self.carImageView.hidden = YES;
        self.yuanImageView.hidden =self.carImageView.hidden;
        self.yuanLabel.hidden =!self.carImageView.hidden;
    }else{
        self.carImageView.hidden = NO;
        self.yuanImageView.hidden =self.carImageView.hidden;
        self.yuanLabel.hidden =!self.carImageView.hidden;
    }
}
#pragma mark - 选择车行
- (IBAction)companyNameBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    //Push 跳转
    ChooseCarListVC * VC = [[ChooseCarListVC alloc]initWithNibName:@"ChooseCarListVC" bundle:nil];
    __weak typeof(self) weakSelf = self;
    VC.ChooseCarListVCBlock =^(NSString *companyId,NSString *companyName){
        [sender setTitle:companyName forState:0];
        //_carImageView.hidden = YES;
        weakSelf.industryModel.companyId  =companyId;
    };
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - 选择面额
- (IBAction)denominationBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    //Push 跳转
    DhooseFaceListVC * VC = [[DhooseFaceListVC alloc]initWithNibName:@"DhooseFaceListVC" bundle:nil];
    __weak typeof(self) weakSelf = self;
    VC.DhooseFaceListVCBlock =^(NSString *faceAmount,NSString *name){
        [sender setTitle:faceAmount forState:0];
//        self.yuanImageView.hidden =YES;
//        self.yuanLabel.hidden =!self.yuanImageView.hidden;
        weakSelf.industryModel.faceAmount  =faceAmount;
    };
    [self.navigationController  pushViewController:VC animated:YES];
}
//判断输入钱的正则表达式，正整数，最多6位。
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.nstockTF isEqual:textField]||[self.limitAmount isEqual:textField]) {
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
//    if ([self.limitAmount isEqual:textField] ) {
//        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        if (toString.length > 0) {
//            NSString *stringRegex = @"(\\+)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,5}(([.]\\d{0,2})?)))?";
//            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
//            BOOL flag = [phoneTest evaluateWithObject:toString];
//            if (!flag) {
//                return NO;
//            }
//        }
//        return YES;
//    }
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
            NSString *a = [[self.BagendTime substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@""];//该方法是去掉指定符号
            NSString *b = [[daterView.dateString substringToIndex:10]stringByReplacingOccurrencesOfString:@"-" withString:@""];//该方法是去掉指定符号
            if ([a intValue]<[b intValue  ]) {
                [self showToast:[NSString stringWithFormat:@"不能晚于%@",self.BagendTime]];
                [self.endTime setTitle: self.BagendTime  forState:(UIControlStateNormal)];
                self.industryModel.endTime =self.BagendTime;
            }else{
                [self.endTime setTitle: daterView.dateString  forState:(UIControlStateNormal)];
                self.industryModel.endTime =daterView.dateString;
            }
        }
    }
}
#pragma mark -  日历取消
- (void)daterViewDidCancel:(XFDaterView *)daterView{
}

- (IBAction)submitAction:(PublicBtn *)sender {
    if ([self IF]) {
        __weak typeof(self) weakSelf = self;
        [self alertWithTitle:@"是否发布?" message:nil OKWithTitle:@"确认" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            weakSelf.view.userInteractionEnabled = NO;
            NSString *Token =[AuthenticationModel getLoginToken];
            __weak typeof(self) weakself = self;
            if (Token.length!= 0) {
                BaseRequest *baseReq = [[BaseRequest alloc] init];
                baseReq.token = [AuthenticationModel getLoginToken];
                baseReq.encryptionType = AES;
                baseReq.data = [AESCrypt encrypt:[weakself.industryModel yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
                [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/IndustryCoupon/requestAddIndustryCoupon" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                    NSLog(@" 发布行业抵用券----%@",response);
                    if ([response[@"resultCode"] isEqualToString:@"1"]) {
                        [weakSelf showToast:response[@"msg"]];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            weakSelf.AddIndustryVCBlock(response[@"data"][@"balanceFaceAmount"]);
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
    [self.view endEditing:YES];
    BOOL  Y = YES;
    self.industryModel.stock = self.nstockTF.text;
    self.industryModel.limitAmount = self.limitAmount.text;
    if ([self.companyNameBtn.titleLabel.text isEqualToString:@"请选择车行"]) {
        [self showToast:@"请选择车行"];
        return NO;
    }
    if (self.nstockTF.text.length==0) {
        [self showToast:@"请输入发放数量"];
        return NO;
    }
    if ([self.faceBtn.titleLabel.text isEqualToString:@"请选择劵的面额"]) {
        [self showToast:@"请选择劵的面额"];
        return NO;
    }
    if (self.limitAmount.text.length==0) {
        [self showToast:@"请输入满足金额"];
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
    if ([self.faceBtn.titleLabel.text intValue]*[self.nstockTF.text intValue]>[self.balanceFaceAmount intValue]) {
        [self showToast:[NSString stringWithFormat: @"当前余额不足,仅剩%@元",self.balanceFaceAmount]];
        return NO;
    }
    if ([self.faceBtn.titleLabel.text intValue]>[self.limitAmount.text floatValue]) {
        [self showToast:[NSString stringWithFormat: @"面额%@元不能大于满足金额%@元",self.faceBtn.titleLabel.text,self.limitAmount.text]];
        return NO;
    }
    return Y;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end

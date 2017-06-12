//
//  ChangeOwnerVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ChangeOwnerVC.h"
#import "OwnerModel.h"
@interface ChangeOwnerVC ()
@property (weak, nonatomic) IBOutlet UILabel *LeftLabel;
@property (weak, nonatomic) IBOutlet UITextField *RightTF;
///更新车主信息公共参数
@property(nonatomic,strong)NSString *UpdateStr;
@end

@implementation ChangeOwnerVC

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
    [self AddRightBtn];
    self.title = self.titleStr;
    self.LeftLabel.text =[NSString stringWithFormat:@"%@:",self.titleStr];
    self.RightTF.placeholder = [NSString stringWithFormat:@"请输入%@",self.titleStr];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    if ([self.titleStr isEqualToString:@"真实姓名"]) {
        self.RightTF.text = self.ownerModel.realName;
    }else if ([self.titleStr isEqualToString:@"身份证号码"]) {
        self.RightTF.text = self.ownerModel.idCard;
    }
    else if ([self.titleStr isEqualToString:@"车牌号"]) {
        self.RightTF.text = self.ownerModel.carNo;
    }
    else if ([self.titleStr isEqualToString:@"品牌型号"]) {
         self.RightTF.text = self.ownerModel.carBrand;
    }
    else if ([self.titleStr isEqualToString:@"车辆颜色"]) {
       self.RightTF.text = self.ownerModel.carColor;
    }

    
}
#pragma mark - 添加保存
-(void)AddRightBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [backBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    
}
/*车牌号验证 MODIFIED BY HELENSONG*/
-(BOOL)validateCarNo:(NSString* )carNo
{
    NSString *carRegex = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
   // NSLog(@"%@",[carTest evaluateWithObject:carNo]);
    BOOL y = [carTest evaluateWithObject:carNo];
    if (!y) {
        return NO;
    }else{
         return YES;
    }
   
}
#pragma mark - 保存
-(void)save:(UIButton*)sender{
    self.UpdateStr = self.RightTF.text;
    if ([self.titleStr isEqualToString:@"真实姓名"]) {
        if (self.UpdateStr.length==0 ) {
            [self showToast:@"请输入真实姓名"];
            return;
        }
    }else if ([self.titleStr isEqualToString:@"身份证号码"]) {
        if (self.UpdateStr.length==0 ) {
            [self showToast:@"身份证号码输入有误"];
            return;
        }
    }
    else if ([self.titleStr isEqualToString:@"车牌号"]) {
        if (self.UpdateStr.length==0 ||[self validateCarNo:self.titleStr]==NO ) {
            [self showToast:@"请输入正确车牌号"];
            return;
        }
    }
    else if ([self.titleStr isEqualToString:@"品牌型号"]) {
        if (self.UpdateStr.length==0 ) {
            [self showToast:@"请输入品牌型号"];
            return;
        }
    }
    else if ([self.titleStr isEqualToString:@"车辆颜色"]) {
        if (self.UpdateStr.length==0 ) {
            [self showToast:@"请输入车辆颜色"];
            return;
        }
    }
  //更新车主信息
  [self requestUpdateDriverInfo];

}
#pragma mark - 更新车主信息
-(void)requestUpdateDriverInfo{
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    OwnerModel *model = [[OwnerModel alloc]init];
    if ([self.titleStr isEqualToString:@"真实姓名"]) {
        model.realName = self.UpdateStr;
    }else if ([self.titleStr isEqualToString:@"身份证号码"]) {
        model.idCard = self.UpdateStr;
    }
    else if ([self.titleStr isEqualToString:@"车牌号"]) {
        model.carNo = self.UpdateStr;
    }
    else if ([self.titleStr isEqualToString:@"品牌型号"]) {
        model.carBrand = self.UpdateStr;
    }
    else if ([self.titleStr isEqualToString:@"车辆颜色"]) {
        model.carColor = self.UpdateStr;
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
                [weakself.navigationController popViewControllerAnimated:YES];
                
            }else{
                weakself.view.userInteractionEnabled = YES;
                
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            weakself.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }else{
        
    }
    
    
    
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

//
//  AddTirpinfoVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/15.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "AddTirpinfoVC.h"

@interface AddTirpinfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *LeftLabel;
@property (weak, nonatomic) IBOutlet UITextField *RightTF;
@end

@implementation AddTirpinfoVC

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
    if (self.RightTFStr.length!=0) {
        self.RightTF.text = self.RightTFStr;

    }
    self.title = self.titleStr;
    if ([self.titleStr isEqualToString:@"座位价格"]) {
        self.LeftLabel.text =@"座位价格:";

        ;
    }else if([self.titleStr isEqualToString:@"座位数量"]){
        self.LeftLabel.text =@"座位数量:";
    }
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    
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
#pragma mark - 保存
-(void)save:(UIButton*)sender{
    if (self.RightTF.text.length==0||[self.RightTF.text floatValue]==0) {
        if ([self.titleStr isEqualToString:@"座位价格"]) {
            [self showToast:@"请输入座位价格"];
            
            return;
        }else if([self.titleStr isEqualToString:@"座位数量"]){
            [self showToast:@"请输入座位数量"];
            return;
        }
        
        
    }else{
        [self.view endEditing:NO];
        self.returnAddTirpinfoVC(self.RightTF.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//block 传值 二  block 作为方法参数传值

-(void)ReturnAddTirpinfoVC:(ReturnAddTirpinfoVC)block{
    self.returnAddTirpinfoVC = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//判断输入钱的正则表达式，可输入正负，小数点前5位，小数点后2位，位数可控
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([self.titleStr isEqualToString:@"座位价格"]) {
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

    }else {
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toString.length > 0) {
            NSString *stringRegex = @"(\\+)?([0-9]\\d{0,1})?";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
            BOOL flag = [phoneTest evaluateWithObject:toString];
            if (!flag) {
                return NO;
            }
        }
        
        return YES;

       
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

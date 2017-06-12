//
//  UpdateSexController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "UpdateSexController.h"
#import "OwnerModel.h"
@interface UpdateSexController ()
///更新车主信息公共参数
@property(nonatomic,strong)NSString *UpdateStr;
@end

@implementation UpdateSexController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showBackBtn];
    [self AddRightBtn];
    self.title = @"修改性别";
    [self addtargetAction];
    //初始化赋值
    [self kongjianfuzhi];
    
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
    
    //更新车主信息
    [self requestUpdateDriverInfo];

    
}

#pragma mark -     //初始化赋值
-(void)kongjianfuzhi{
    if ([self.ownerModel.gender isEqualToString:@"1"]) {
        self.chooseManBtn.hidden = NO;
        self.chooseWomanBtn.hidden = YES;
        self.UpdateStr = self.ownerModel.gender;
    }else if ([self.ownerModel.gender isEqualToString:@"0"]){
        self.chooseWomanBtn.hidden = NO;
        self.chooseManBtn.hidden = YES;
     self.UpdateStr = self.ownerModel.gender;
    }
    
    
}
//为View添加点击事件
- (void)addtargetAction {
    //选择"男"
    UITapGestureRecognizer *chooseManViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseManViewAction:)];
    [self.chooseManView addGestureRecognizer:chooseManViewTap];
    //选择"女"
    UITapGestureRecognizer *chooseWomanViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseWomanViewAction:)];
    [self.chooseWomanView addGestureRecognizer:chooseWomanViewTap];
    
}

//选择"男"的View事件
- (void)chooseManViewAction:(UITapGestureRecognizer *)sender {
    self.chooseManBtn.hidden = NO;
    self.chooseWomanBtn.hidden = YES;
    self.UpdateStr = @"1";
}

//选择"女"的View事件
- (void)chooseWomanViewAction:(UITapGestureRecognizer *)sender {
    self.chooseWomanBtn.hidden = NO;
    self.chooseManBtn.hidden = YES;
    self.UpdateStr = @"0";
    
}



    


#pragma mark - 更新车主信息
-(void)requestUpdateDriverInfo{
    self.view.userInteractionEnabled = NO;
    NSString *Token =[AuthenticationModel getLoginToken];
    OwnerModel *model = [[OwnerModel alloc]init];
    NSLog(@"%@",self.UpdateStr);
        model.gender = self.UpdateStr;
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




@end

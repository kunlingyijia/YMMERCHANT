//
//  AddServiceVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/4/18.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "AddServiceVC.h"
#import "RequestUpdateBminservice.h"
#import "RequestBminserviceListModel.h"
#import "RequestDeleteBminservice.h"
#import "RequestBminserviceListModel.h"
#import "AddSerViceOneCell.h"
@interface AddServiceVC ()<UITextViewDelegate,UITextFieldDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *orderArr;
@property (nonatomic, strong) RequestBminserviceListModel *settingModel;
@property (nonatomic, assign) NSInteger settingIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end

@implementation AddServiceVC

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
     self.title = @"填写信息";
    [self.collectionView collectionViewregisterNibArray:@[@"AddSerViceOneCell"]];
    self.textView.placeholder = @"请输入服务名称";
    self.textView.textColor = [UIColor colorWithHexString:kTitleColor];
    self.textView.layer.borderColor = [UIColor colorWithHexString:kSubTitleColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textField.textColor = [UIColor colorWithHexString:kTitleColor];
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    //self.textField.layer.borderWidth = 1;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.layer.borderColor = [UIColor colorWithHexString:kSubTitleColor].CGColor;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius =3.0;
    self.textField.delegate = self;
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 4;
    self.addBtn.backgroundColor = [UIColor colorWithHexString:@"#fd9e18"];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.orderArr = [NSMutableArray arrayWithCapacity:0];
    self.settingIndex = -1;
    //获取便民服务项目列表
    [self getOrderDataList];
    
    
}
#pragma mark - 获取便民服务项目列表
- (void)getOrderDataList {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[[NSArray array] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.encryptionType = AES;
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestBminserviceList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                RequestBminserviceListModel *model = [RequestBminserviceListModel yy_modelWithDictionary:dic];
                model.Ischoose = @"0";
                [weakSelf.orderArr addObject:model];
            }
            [weakSelf.collectionView reloadData];
           // [weakSelf createOrederList];
        }else {
            [weakSelf showToast:baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
}



#pragma mark --集合视图代理方法
//集合视图分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//集合视图分区内item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.orderArr.count;
}
//item 配置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddSerViceOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddSerViceOneCell" forIndexPath:indexPath];
    //配置item
    cell.deleteBtn.indexPath = indexPath;
    cell.deleteBtn.backgroundColor = [UIColor clearColor];
    cell.model = self.orderArr[indexPath.row];
    [cell.deleteBtn addTarget:self action:@selector(delegateOrderAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return cell;
}
- (void)delegateOrderAction:(PublicBtn *)sender {
    
    __weak typeof(self) weakSelf = self;

    [self alertWithTitle:@"是否删除" message:nil OKWithTitle:@"删除" CancelWithTitle:@"再想想" withOKDefault:^(UIAlertAction *defaultaction) {
        weakSelf.textField.text = @"";
        weakSelf.textView.text = @"";
        NSInteger index = sender.indexPath.row;
        RequestBminserviceListModel *model = weakSelf.orderArr[index];
        RequestDeleteBminservice *bmService = [[RequestDeleteBminservice alloc] init];
        bmService.bminServiceId = model.bminServiceId;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[bmService yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestDeleteBminservice" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [weakSelf.orderArr removeObjectAtIndex:index];
                [weakSelf.addBtn setTitle:@"添加" forState:UIControlStateNormal];
                weakSelf.settingIndex = -1;
                for (int i=0; i<weakSelf.orderArr.count; i++) {
                    
                    RequestBminserviceListModel *model =weakSelf.orderArr[i];
                    model.Ischoose = @"0";
                }
                [weakSelf.collectionView reloadData];
            }else {
                [weakSelf showToast:baseRes.msg];
                //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
            }
        } faild:^(id error) {
            
        }];
    } withCancel:^(UIAlertAction *cancelaction) {
        
    }];
    
    
    
    
    
    
    
    
}

#pragma mark -设置页眉和页脚

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *reusableview = nil;
//    
//    
//    if (kind == UICollectionElementKindSectionHeader){
//        UICollectionReusableView *headerView= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header111" forIndexPath:indexPath];
//        
//        reusableview = headerView;
//        
//    }
//    
//    if (kind == UICollectionElementKindSectionFooter){
//        
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footder111" forIndexPath:indexPath];
//        
//        reusableview = footerview;
//        
//    }
//    
//    return reusableview;
//    
//    
//}

#pragma 集合视图 --约束代理方法
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((Width-30)/2, Width*0.22);
    
}
//设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
//设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10 ;
    
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    for (RequestBminserviceListModel *model in self.orderArr) {
//        model.Ischoose = @"0";
//    }
    for (int i=0; i<self.orderArr.count; i++) {
        if (i!=indexPath.row) {
            RequestBminserviceListModel *model =self.orderArr[i];
             model.Ischoose = @"0";
        }
    }
    RequestBminserviceListModel *model = self.orderArr[indexPath.row];
    if ([model.Ischoose isEqualToString:@"0"]) {
        model.Ischoose = @"1";
        [self.addBtn setTitle:@"修改" forState:(UIControlStateNormal)];
        self.textView.text = model.serviceName;
        self.settingModel = model;
        self.textField.text = [NSString stringWithFormat:@"%.2f",model.price];
        _settingIndex = indexPath.row;
    }else{
        model.Ischoose = @"0";
        [self.addBtn setTitle:@"添加" forState:(UIControlStateNormal)];
        self.textView.text = @"";
        self.textField.text =@"";
        self.settingModel = model;
    }
    
    [self.collectionView reloadData];
}

////灵活的设置每个分区的页眉的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    
//    return  CGSizeMake([UIScreen mainScreen].bounds.size.width, 180);
//    
//}
////灵活的设置每个分区的页脚的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    
//    return CGSizeMake( [UIScreen mainScreen].bounds.size.width ,50);
//    
//    
//}

- (IBAction)addOrderNetworking:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.textView.text.length == 0) {
        [self showToast:@"请输入服务名称"];
        return;
    }else if (self.textField.text.length ==0) {
        [self showToast:@"请输入服务价格"];
        return;
    }
    
    RequestUpdateBminservice *bminservice = [[RequestUpdateBminservice alloc] init];
    bminservice.serviceName = self.textView.text;
    bminservice.price = self.textField.text ;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if ([self.addBtn.titleLabel.text isEqualToString:@"修改"]) {
        bminservice.bminServiceId = self.settingModel.bminServiceId;
    }
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[bminservice yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;
    self.view.userInteractionEnabled = NO;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Bmin/requestUpdateBminservice" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            weakSelf.view.userInteractionEnabled = YES;
            
            weakSelf.textView.text = @"";
            weakSelf.textField.text = @"";
            RequestBminserviceListModel *model = [RequestBminserviceListModel yy_modelWithDictionary:baseRes.data];
            model.Ischoose = @"0";
            if ([weakSelf.addBtn.titleLabel.text isEqualToString:@"修改"]) {
                [weakSelf.addBtn setTitle:@"添加" forState:(UIControlStateNormal)];
                [weakSelf.orderArr replaceObjectAtIndex:weakSelf.settingIndex withObject:model];
            }else {
                [weakSelf.orderArr insertObject:model atIndex:0];
            }
            [weakSelf.collectionView reloadData];
//            for (UIView *view in self.cornerView.subviews) {
//                [view removeFromSuperview];
//            }
            //[self createOrederList];
        }else {
            weakSelf.view.userInteractionEnabled = YES;
            [self showToast:baseRes.msg];
        }
    } faild:^(id error) {
        weakSelf.view.userInteractionEnabled = YES;
        
    }];

    
    
    
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
//判断输入钱的正则表达式，可输入正负，小数点前5位，小数点后2位，位数可控
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 0) {
        NSString *stringRegex = @"(\\+)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,6}(([.]\\d{0,2})?)))?";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:toString];
        if (!flag) {
            return NO;
        }
    }
    return YES;
    
}
@end

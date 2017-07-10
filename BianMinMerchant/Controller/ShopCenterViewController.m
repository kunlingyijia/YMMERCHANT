//
//  ShopCenterViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ShopCenterViewController.h"
#import "AddGoodsViewController.h"
#import "GoodsViewCell.h"
#import "RequestGoodsList.h"
#import "RequestUpdateGoodsStock.h"
#import "RequestGoodsListModel.h"
#import "RequestUpdateGoodsStatus.h"
#import "BuyMessageController.h"
#import "ChangeGoodsController.h"
@interface ShopCenterViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation ShopCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品管理";
    self.pageIndex = 1;
    [self createView];
    [self showBackBtn];
    [self createTableView];
}

- (void)createView {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 50, 30);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barItem;
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 380;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GoodsViewCell"];
    [self.view addSubview:self.tableView];
    [self getDataList];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getDataList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getDataList];
    }];
}

- (void)getDataList {
    RequestGoodsList *requestG = [[RequestGoodsList alloc] init];
    requestG.pageCount = 10;
    requestG.pageIndex = self.pageIndex;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[requestG yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestGoodsList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@",response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestGoodsListModel *model = [RequestGoodsListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
             [self.tableView reloadData];
        }else {
            [self showToast:baseRes.msg];
            
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
       
    } faild:^(id error) {
        
    }];
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestGoodsListModel *model = self.dataSource[indexPath.row];
    NSLog(@"%ld", model.images.count);
    NSArray *arr = model.images;
//    if (arr.count == 0) {
//        return 310;
//    }else if (arr.count < 4) {
//        return 390;
//    }else if (arr.count > 3 && arr.count < 7) {
//         return 390 + 80;
//    }
//    return 390 + 2 * 80;
    if (arr.count < 4 && arr.count > 0) {
        return 465;
    }else if (arr.count > 3 && arr.count < 7) {
        return 465 + 110;
    }else if (arr.count > 6 && arr.count < 10) {
        return 465 + 220;
    }
    return 350;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestGoodsListModel *model = self.dataSource[indexPath.row];
    if ([model.isEdit isEqualToString:@"0"]) {
        
    }else{
        ChangeGoodsController *addGoods = [[ChangeGoodsController alloc] init];
        __weak ShopCenterViewController *weakSelf = self;
        addGoods.backBlackAction = ^(NSString *str) {
            weakSelf.pageIndex = 1;
            [weakSelf getDataList];
        };
        addGoods.isNewC = 6;
        addGoods.model = model;
        [self.navigationController pushViewController:addGoods animated:YES];
    }
   
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsViewCell" forIndexPath:indexPath];
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak ShopCenterViewController *weakSelf = self;
    cell.buyBackAction = ^(NSString *goodsId) {
        [weakSelf buyMessageAction:goodsId];
    };
    cell.changeBackAction = ^(NSString *goodsId) {
        [weakSelf changeNumberAction:goodsId];
    };
    cell.upOrdownBackAction = ^(NSString *goodsId, NSString *name) {
        NSString *nameStr = nil;
        if ([name isEqualToString:@"下架"]) {
            nameStr = @"是否下架";
        }else {
            nameStr = @"是否上架";
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:nameStr preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf upOrDownAction:goodsId withBtnName:name];
        }]];
        
        [weakSelf presentViewController:alertC animated:YES completion:nil];
        
    };
    
    cell.backgroundColor = [UIColor colorWithHexString:kViewBg];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIImageView *image in cell.bgView.subviews) {
        [image removeFromSuperview];
    }
    RequestGoodsListModel *model = self.dataSource[indexPath.row];
    [cell cellGetDataWithModel:model];
    [cell createImageView:model.images];
    
    
    cell.deleteBtnBlock = ^(NSString *goodsId){
        [weakSelf alertWithTitle:@"是否删除" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            RequestUpdateGoodsStock *stock = [[RequestUpdateGoodsStock alloc] init];
            stock.goodsId = goodsId;
           
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.encryptionType = AES;
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.data = [AESCrypt encrypt:[stock yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestDeleteGoods" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                if (baseRes.resultCode == 1) {
                    weakSelf.pageIndex = 1;
                    [weakSelf getDataList];
                    [weakSelf showToast:@"商品删除成功"];
                }else {
                    
                    [ weakSelf showToast:baseRes.msg];
                }
            } faild:^(id error) {
                
            }];

        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    };
    
    
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

    }
}



- (void)addAction:(UIButton *)sender {
    AddGoodsViewController *addGoodsC = [[AddGoodsViewController alloc] init];
    __weak ShopCenterViewController *weakSelf = self;
    addGoodsC.backBlackAction = ^(NSString *str) {
        weakSelf.pageIndex = 1;
        [weakSelf getDataList];
    };
    [self.navigationController pushViewController:addGoodsC animated:YES];
}

- (void)buyMessageAction:(NSString *)goodsId {
    BuyMessageController *buyC = [[BuyMessageController alloc] init];
    buyC.goodsId = goodsId;
    [self.navigationController pushViewController:buyC animated:YES];
}

- (void)changeNumberAction:(NSString *)goodsId {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入库存" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;

    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        weakSelf.textField = textField;
        weakSelf.textField.delegate = weakSelf;
    }];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    }]];
     UITextField *textField = alertC.textFields[0];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.textField resignFirstResponder];
        [self networkingChangeNum:goodsId withNum:textField.text];
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)upOrDownAction:(NSString *)goodsId withBtnName:(NSString *)name {
    [self showProgress];
    RequestUpdateGoodsStatus *goodsStatus = [[RequestUpdateGoodsStatus alloc] init];
    goodsStatus.goodsId = goodsId;
    if ([name isEqualToString:@"下架"]) {
        goodsStatus.status = 2;
    }else {
        goodsStatus.status = 1;
    }
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[goodsStatus yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestUpdateGoodsStatus" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.pageIndex = 1;
            [self hideProgress];
            [self getDataList];
        }else {
            [self hideProgress];
            [ self showToast:baseRes.msg];
        }
    } faild:^(id error) {
         [self hideProgress];
    }];
}


- (void)networkingChangeNum:(NSString *)goodsId withNum:(NSString *)num{
    
    
    RequestUpdateGoodsStock *stock = [[RequestUpdateGoodsStock alloc] init];
    stock.goodsId = goodsId;
    stock.stock = num;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[stock yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestUpdateGoodsStock" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.pageIndex = 1;
            [self getDataList];
            [self showToast:@"修改库存成功"];
        }else {
            
           [ self showToast:baseRes.msg];
        }
    } faild:^(id error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}



//判断输入钱的正则表达式，可输入正负，小数点前5位，小数点后2位，位数可控
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    if ([self.priceText isEqual:textField]||[self.newpriceText isEqual:textField]) {
    //        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //        if (toString.length > 0) {
    //            NSString *stringRegex = @"(\\+)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
    //            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    //            BOOL flag = [phoneTest evaluateWithObject:toString];
    //            if (!flag) {
    //                return NO;
    //            }
    //        }
    //        return YES;
    //    }
    
    if ([self.textField isEqual:textField]) {
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
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
@end

//
//  TicketViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "TicketViewController.h"
#import "AddTicketViewController.h"
#import "TicketListViewCell.h"
#import "RequestCouponList.h"
#import "CouponListModel.h"
#import "ReceiveViewController.h"
#import "RequestUpdateCouponStore.h"
#import "RequestUpdateCouponStatus.h"
#import "TicketMessageController.h"
@interface TicketViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
//标示当钱选择的哪个优惠券
@property (nonatomic, assign) NSInteger selectedTicket;

@property (nonatomic, strong) UIButton *ticketBtn;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *mDataSource;
@property (nonatomic, strong) NSMutableArray *zDataSource;
@property (nonatomic, assign) NSInteger mCount;
@property (nonatomic, assign) NSInteger lCount;
@property (nonatomic, assign) NSInteger zCount;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation TicketViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (NSMutableArray *)mDataSource {
    if (!_mDataSource) {
        self.mDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _mDataSource;
}

- (NSMutableArray *)zDataSource {
    if (!_zDataSource) {
        self.zDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _zDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"卡券管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.mCount = 1;
    self.lCount = 1;
    self.zCount = 1;
    self.selectedTicket = 0;
    [self createView];
    [self showBackBtn];
    [self getDataList:1];
}

- (void)getDataList:(NSInteger)type {
    RequestCouponList *requestCoup = [[RequestCouponList alloc] init];
    requestCoup.pageCount = 10;
    
    switch (type) {
        case 1:
            requestCoup.pageIndex = self.mCount;
            break;
        case 2:
            requestCoup.pageIndex = self.lCount;
            break;
        case 3:
            requestCoup.pageIndex = self.zCount;
            break;
            
        default:
            break;
    }
    
    requestCoup.couponType = type;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[requestCoup yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.encryptionType = AES;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestCouponList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.mCount == 1) {
                [self.dataSource removeAllObjects];
            }
            if (self.zCount == 1) {
                [self.zDataSource removeAllObjects];
            }
            if (self.lCount == 1) {
                [self.mDataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                CouponListModel *model = [CouponListModel yy_modelWithDictionary:dic];
                switch (type) {
                    case 1:
                        [self.dataSource addObject:model];
                        break;
                    case 2:
                        [self.mDataSource addObject:model];
                        break;
                    case 3:
                        [self.zDataSource addObject:model];
                        break;
                        
                    default:
                        break;
                }
            }
            [self.tableView reloadData];

        }else {
            [self showToast: baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
       
    } faild:^(id error) {
    }];
}


- (void)createView {
    NSArray *arr = @[@"满减券",@"立减券",@"折扣券"];
    UISegmentedControl *segmentC = [[UISegmentedControl alloc] initWithItems:arr];
    segmentC.frame = CGRectMake(10, 10, Width - 20, Width/10);
    segmentC.backgroundColor = [UIColor whiteColor];
    segmentC.selectedSegmentIndex = 0;
    [segmentC addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    [segmentC setTitleTextAttributes:dic forState:UIControlStateNormal];
    segmentC.tintColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.view addSubview:segmentC];
    
    
    [self.ticketBtn setTitle:@"+添加满减券" forState:UIControlStateNormal];
    [self.view addSubview:self.ticketBtn];
    self.ticketBtn.backgroundColor = [UIColor colorWithHexString:kViewBg];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30+Width*0.2, Width, Height-30-Width*0.2-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 190;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketListViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TicketListViewCell"];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        switch (self.selectedTicket) {
            case 0:
                self.mCount = 1;
                break;
            case 1:
                self.lCount = 1;
                break;
            case 2:
                self.zCount = 1;
                break;
            default:
                break;
        }
        [self getDataList:self.selectedTicket+1];
        
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        switch (self.selectedTicket) {
            case 0:
                self.mCount = self.mCount + 1;
                break;
            case 1:
                self.lCount = self.lCount + 1;
                break;
            case 2:
                self.zCount = self.zCount + 1;
                break;
            default:
                break;
        }
        [self getDataList:self.selectedTicket+1];
    }];
    
//    for (int i = 0; i < 3; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:arr[i] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        btn.frame = CGRectMake(10 + i *(btnW + 10), 10, btnW, 30);
//        btn.backgroundColor = [UIColor colorWithHexString:kSubTitleColor];
//        [self.view addSubview:btn];
//    }
    
//    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addBtn setTitle:@"添加优惠券" forState:UIControlStateNormal];
//    addBtn.backgroundColor = [UIColor colorWithHexString:kSubTitleColor];
//    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:addBtn];
//    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(50);
//        make.right.equalTo(self.view).with.offset(-10);
//        make.left.equalTo(self.view).with.offset(10);
//        make.height.mas_equalTo(@(30));
//    }];
//    
}

- (void)btnAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.ticketBtn setTitle:@"+添加满减券" forState:UIControlStateNormal];
            if (self.dataSource.count == 0) {
                 [self getDataList:1];
            }
           
            break;
        case 1:
            [self.ticketBtn setTitle:@"+添加立减券" forState:UIControlStateNormal];
            if (self.mDataSource.count ==0) {
                [self getDataList:2];
            }
            break;
        case 2:
            [self.ticketBtn setTitle:@"+添加折扣券" forState:UIControlStateNormal];
            if (self.zDataSource.count == 0) {
                [self getDataList:3];
            }
            break;
        default:
            break;
    }
    self.selectedTicket = sender.selectedSegmentIndex;
    [self.tableView reloadData];
    OKLog(@"优惠券%ld", (long)sender.selectedSegmentIndex);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TicketMessageController *messageC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TicketMessageController"];
    __weak TicketViewController *weakSelf = self;
    messageC.balkTicket = ^(NSString *str) {
        switch (self.selectedTicket) {
            case 0:
                [weakSelf.dataSource removeAllObjects];
                break;
            case 1:
                [weakSelf.mDataSource removeAllObjects];
                break;
            case 2:
                [weakSelf.zDataSource removeAllObjects];
                break;
            default:
                break;
        }
        [weakSelf getDataList:self.selectedTicket+1];
    };
    CouponListModel *model = [CouponListModel new];
    switch (self.selectedTicket + 1) {
        case 1:
            model = self.dataSource[indexPath.row];
            break;
        case 2:
            model = self.mDataSource[indexPath.row];
            break;
        case 3:
            
            model = self.zDataSource[indexPath.row];
            break;
        default:
            break;
    }
    NSLog(@"%@",[model yy_modelToJSONObject]);
    
    
    messageC.couponId = model.couponId;
    [self.navigationController pushViewController:messageC animated:YES];
}

- (void)addAction:(UIButton *)sender {
    AddTicketViewController *addC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddTicketViewController"];
    addC.isAddMessage = YES;
    switch (self.selectedTicket) {
        case 0:
            addC.ticketKind = fullTicket;
            break;
        case 1:
            addC.ticketKind = erectTicket;
            break;
        case 2:
            addC.ticketKind = discountTicket;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:addC animated:YES];
    __weak TicketViewController *weakSelf = self;
    addC.balkAction = ^(NSString *str) {
        [self showToast:@"添加成功"];
        switch (weakSelf.selectedTicket) {
            case 0:
                [weakSelf.dataSource removeAllObjects];
                break;
            case 1:
                [weakSelf.mDataSource removeAllObjects];
                break;
            case 2:
                [weakSelf.zDataSource removeAllObjects];
                break;
            default:
                break;
        }
        [weakSelf getDataList:self.selectedTicket+1];
    };
    OKLog(@"添加优惠券");
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.selectedTicket + 1) {
        case 1:
            
            [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
            return self.dataSource.count;
            
            break;
        case 2:
            [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.mDataSource.count];
            return self.mDataSource.count;
            break;
        case 3:
            [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.zDataSource.count];
            return self.zDataSource.count;
            break;
        default:
            break;
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketListViewCell"];
    CouponListModel *model = nil;
    switch (self.selectedTicket + 1) {
        case 1:
            model = self.dataSource[indexPath.row];
            break;
        case 2:
            model = self.mDataSource[indexPath.row];
            break;
        case 3:
            model = self.zDataSource[indexPath.row];
            break;
        default:
            break;
    }
    __weak TicketViewController *weakSelf = self;
    cell.detailAction = ^(NSString *strID) {
        ReceiveViewController *receiveC = [[ReceiveViewController alloc] init];
        receiveC.couponId = strID;
        [weakSelf.navigationController pushViewController:receiveC animated:YES];
    };
    cell.buyGoods = ^(NSString *strID, NSString *status) {
        RequestUpdateCouponStatus *updateStatus = [[RequestUpdateCouponStatus alloc] init];
        updateStatus.couponId = strID;
        updateStatus.status = status;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[updateStatus yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestUpdateCouponStatus" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                
                
                
                switch (self.selectedTicket) {
                    case 0:
                        [self.dataSource removeAllObjects];
                        break;
                    case 1:
                        [self.mDataSource removeAllObjects];
                        break;
                    case 2:
                        [self.zDataSource removeAllObjects];
                        break;
                    default:
                        break;
                }
                [weakSelf getDataList:self.selectedTicket+1];
            }else{                 [weakSelf showToast:baseRes.msg];
            }
        } faild:^(id error) {
            
            
            
        }];
    };
    
    cell.changeNumber = ^(NSString *strID) {
      UIAlertController *alertC = [UIAlertController  alertControllerWithTitle:@"提示" message:@"请输入修改数量" preferredStyle:UIAlertControllerStyleAlert];
        //为弹出框 添加一个输入框
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        //获取弹出框上得输入框
        weakSelf. textField = alertC.textFields.firstObject;
        weakSelf.textField.delegate = weakSelf;
       weakSelf.textField.keyboardType = UIKeyboardTypeNumberPad;
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            RequestUpdateCouponStore *store = [[RequestUpdateCouponStore alloc] init];
            store.couponId = strID;
            store.storeAmount = [weakSelf.textField.text integerValue];
            
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = AES;
            baseReq.data = [AESCrypt encrypt:[store yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestUpdateCouponStore" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
                NSLog(@"%@", response);
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                if (baseRes.resultCode == 1) {
                    switch (self.selectedTicket) {
                        case 0:
                            [self.dataSource removeAllObjects];
                            break;
                        case 1:
                            [self.mDataSource removeAllObjects];
                            break;
                        case 2:
                            [self.zDataSource removeAllObjects];
                            break;
                        default:
                            break;
                    }
                    [weakSelf getDataList:self.selectedTicket+1];
                }else{
                    [weakSelf showToast:baseRes.msg];
                }
            } faild:^(id error) {
                
            }];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:sure];
        [alertC addAction:cancel];
        [weakSelf.navigationController presentViewController:alertC animated:YES completion:nil];

    };

    ///删除
    cell.deleteBlock = ^(NSString *strID){
        [weakSelf alertWithTitle:@"是否删除?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            RequestUpdateCouponStore *store = [[RequestUpdateCouponStore alloc] init];
            store.couponId = strID;
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = AES;
            baseReq.data = [AESCrypt encrypt:[store yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestDeleteCoupon" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
                NSLog(@"%@", response);
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                if (baseRes.resultCode == 1) {
//                    switch (self.selectedTicket) {
//                        case 0:
//                            [self.dataSource removeAllObjects];
//                            break;
//                        case 1:
//                            [self.mDataSource removeAllObjects];
//                            break;
//                        case 2:
//                            [self.zDataSource removeAllObjects];
//                            break;
//                        default:
//                            break;
//                    }
                    [weakSelf getDataList:self.selectedTicket+1];
                } else{
                    [weakSelf showToast:baseRes.msg];
                }

            } faild:^(id error) {
                
            }];

        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    };
    
    
    [cell cellGetDataWithModel:model];
    return cell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIButton *)ticketBtn {
    if (!_ticketBtn) {
        self.ticketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.ticketBtn.backgroundColor = [UIColor whiteColor];
        [self.ticketBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.ticketBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
        self.ticketBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.ticketBtn.frame = CGRectMake(20, 20+Width*0.1, Width - 40, Width*0.1);
    }
    return _ticketBtn;
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  TicketViewController.m
//  BianMinMerchant
//
//  Created by kkk on 16/5/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "TicketViewController.h"
#import "AddTicketViewController.h"


@interface TicketViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//标示当钱选择的哪个优惠券
@property (nonatomic, assign) NSInteger selectedTicket;
@property (nonatomic, strong) UIButton *ticketBtn;
@end

@implementation TicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedTicket = 0;
    [self createView];
    [self showBackBtn];
}

- (void)createView {
    NSArray *arr = @[@"满减券",@"立减券",@"折扣券"];
    UISegmentedControl *segmentC = [[UISegmentedControl alloc] initWithItems:arr];
    segmentC.frame = CGRectMake(10, 10, Width - 20, 25);
    segmentC.backgroundColor = [UIColor whiteColor];
    segmentC.selectedSegmentIndex = 0;
    [segmentC addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventValueChanged];
    segmentC.tintColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.view addSubview:segmentC];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, Width, Height-45) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
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
            break;
        case 1:
            [self.ticketBtn setTitle:@"+添加立减券" forState:UIControlStateNormal];
            break;
        case 2:
            [self.ticketBtn setTitle:@"+添加折扣券" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    self.selectedTicket = sender.selectedSegmentIndex;
    OKLog(@"优惠券%ld", (long)sender.selectedSegmentIndex);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 30)];
    headerV.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.ticketBtn setTitle:@"+添加满减券" forState:UIControlStateNormal];
    [headerV addSubview:self.ticketBtn];
    return headerV;
}
- (void)addAction:(UIButton *)sender {
    AddTicketViewController *addC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddTicketViewController"];
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
    OKLog(@"添加优惠券");
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text =@"这是测试";
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
        self.ticketBtn.frame = CGRectMake(20, 5, Width - 40, 30);
    }
    return _ticketBtn;
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

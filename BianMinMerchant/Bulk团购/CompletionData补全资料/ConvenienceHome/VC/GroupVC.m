//
//  GroupVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/3/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "GroupVC.h"
#import "GroupOneCell.h"
#import "RequestCateAndBusinessareaModel.h"
#import "SubGroupVC.h"

@interface GroupVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GroupVC
//-(NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        self.dataArray = [NSMutableArray arrayWithCapacity:1];
//    }return _dataArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    NSLog(@"%@",[self.dataArray yy_modelToJSONObject]);
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"分类";
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView tableViewregisterNibArray:@[@"GroupOneCell"]];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GroupOneCell" forIndexPath:indexPath];
    RequestCateAndBusinessareaModel * model =self.dataArray[indexPath.row];
    NSLog(@"----%@",model.categoryName);
    cell.label.text =[NSString stringWithFormat:@"%@", model.categoryName];
   
    
    //cell 赋值
    
    
    // cell 其他配置
    
    
    /*
     //cell选中时的颜色 无色
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     //cell 背景颜色
     cell.backgroundColor = [UIColor yellowColor];
     //分割线
     tableView.separatorStyle = UITableViewCellSelectionStyleNone;
     */
    return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RequestCateAndBusinessareaModel * model = self.dataArray[indexPath.row];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in model._child ) {
        RequestCateAndBusinessareaModel * model = [RequestCateAndBusinessareaModel yy_modelWithJSON:dic];
        [arr addObject:model];
    }
    
    //Push 跳转
    SubGroupVC * VC = [[SubGroupVC alloc]initWithNibName:@"SubGroupVC" bundle:nil];
    VC.dataArray = arr;
    [self.navigationController  pushViewController:VC animated:YES];

}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Width*0.1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

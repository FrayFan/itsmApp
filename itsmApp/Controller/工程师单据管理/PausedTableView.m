//
//  PausedTableView.m
//  itsmApp
//
//  Created by admin on 2016/12/6.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "PausedTableView.h"
#import "OtherTableViewCell.h"
#import "BillsDetailController.h"
#import "UIView+ViewController.h"

@implementation PausedTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.contentInset = UIEdgeInsetsMake(49, 0, 49, 0);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self createRefreshNormalHeader];
        [self createRefreshAutoNormalFooter];
    }
    return self;
    
}


- (void)createRefreshNormalHeader
{
    _normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _upRefresh = YES;
        [self.refreshDelegate pausedTableViewIsUpRefreshData:_upRefresh];
        
    }];
    [_normalHeader setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [_normalHeader setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [_normalHeader setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [_normalHeader setLastUpdatedTimeKey:@"上次刷新时间"];
    
}

- (void)createRefreshAutoNormalFooter
{
    [_normalFooter setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [_normalFooter setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [_normalFooter setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    
}

//下拉刷新
- (void)upRefreshData
{
    self.mj_header = _normalHeader;
    [_normalHeader beginRefreshing];
}

//上拉加载
- (void)loadMoreData
{
    _normalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _upRefresh = NO;
        [self.refreshDelegate pausedTableViewIsUpRefreshData:_upRefresh];
        
    }];
    self.mj_footer = _normalFooter;
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _orderModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OTHERCELL"];
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"OtherTableViewCell" owner:nil options:nil].lastObject;
    }
    if (_orderModels.count>0) {
        cell.orderModel = _orderModels[indexPath.row];
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersModel *orderModel = _orderModels[indexPath.row];
    return 117+orderModel.contentHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BillsDetail" bundle:nil];
    BillsDetailController *billsDetailVC = [storyboard instantiateInitialViewController];
    UIViewController *selfC = [self viewController];
    if (billsDetailVC&&_orderModels.count>0) {
        
        billsDetailVC.orderModel = _orderModels[indexPath.row];
        [selfC.navigationController pushViewController:billsDetailVC animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = LightGrayColor;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

@end

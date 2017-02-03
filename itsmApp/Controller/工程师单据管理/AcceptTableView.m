//
//  AcceptTableView.m
//  itsmApp
//
//  Created by admin on 2016/12/6.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "AcceptTableView.h"
#import "BillsDetailController.h"
#import "UIView+ViewController.h"
#import "FFLabel.h"
#import "UIView+Additions.h"
#import "common.h"

@implementation AcceptTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.tag = 300;
        self.delegate = self;
        self.dataSource = self;
        self.contentInset = UIEdgeInsetsMake(49, 0, 49, 0);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self createRefreshNormalHeader];
        [self createRefreshAutoNormalFooter];
        [self upRefreshData];
        
        
    }
    return self;
    
}

- (void)createRefreshNormalHeader
{
    _normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _upRefresh = YES;
        [self.refreshDelegate acceptTableViewIsUpRefreshData:_upRefresh];
        
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
        [self.refreshDelegate acceptTableViewIsUpRefreshData:_upRefresh];

    }];
    self.mj_footer = _normalFooter;
    
}


#pragma  mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //_orderModels.count
    return _orderModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"ACCEPTCELL"];
    if (!_cell) {
        
        _cell = [[NSBundle mainBundle] loadNibNamed:@"AcceptTableViewCell" owner:nil options:nil].lastObject;
    }
    _cell.dalegate = self;
    if (_orderModels.count>0) {
        _cell.orderMdeol = _orderModels[indexPath.row];
    }
    _cell.contactedButton.tag = indexPath.row;
    UILabel *lable = [_cell viewWithTag:666];
    lable.numberOfLines = 0;
    
    return _cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersModel *orderModel = _orderModels[indexPath.row];
    return 165+orderModel.contentHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BillsDetail" bundle:nil];
    BillsDetailController *billsDetailVC = [storyboard instantiateInitialViewController];
    UIViewController *selfC = [self viewController];
    if (billsDetailVC&&_orderModels != nil) {
        
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



-(void)setOrderModels:(NSMutableArray *)orderModels
{
    _orderModels = orderModels;
    [self reloadData];
    
}

#pragma mark - AcceptTableViewCellDelegate
- (void)removeIndexPathCellWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:index];
    NSArray *indexPathArray = [NSArray arrayWithObject:indexPath];
    [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:YES];
    [self upRefreshData];
    
}





@end

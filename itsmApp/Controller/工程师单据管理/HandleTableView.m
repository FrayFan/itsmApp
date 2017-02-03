//
//  HandleTableView.m
//  itsmApp
//
//  Created by admin on 2016/12/6.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "HandleTableView.h"
#import "UIView+Additions.h"
#import "BillsDetailController.h"
#import "UIView+ViewController.h"
#import "FFLabel.h"
#import "common.h"


@interface HandleTableView ()
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,assign) BOOL upRefresh;

@end

@implementation HandleTableView
{
    BOOL openState[50];
    NSInteger lastSection;
    HandleTableViewCell *mycell;
    MJRefreshNormalHeader *_normalHeader;
    MJRefreshAutoNormalFooter *_normalFooter;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor greenColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sectionFooterHeight = 0.0;
        self.contentInset = UIEdgeInsetsMake(49, 0, 300, 0);
        lastSection = 100;
        
    }
    return self;
    
}


//下拉刷新
- (void)upRefreshData
{
    //设置单元格显示关闭状态
    for (int con = 0; con<50; con++) {
        openState[con] = NO;
    }
    
    _normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _upRefresh = YES;
        [_dataArray removeAllObjects];
        [self.refreshDelegate handleTableViewIsUpRefreshData:_upRefresh];
    }];
    self.mj_header = _normalHeader;
    [_normalHeader setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [_normalHeader setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [_normalHeader setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [_normalHeader setLastUpdatedTimeKey:@"上次刷新时间"];
    [_normalHeader beginRefreshing];
}

//上拉加载
- (void)loadMoreData
{
    _normalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _upRefresh = NO;
        [self.refreshDelegate handleTableViewIsUpRefreshData:_upRefresh];
        
    }];
    self.mj_footer = _normalFooter;
    [_normalFooter setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [_normalFooter setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [_normalFooter setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    
}


#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //_orderModels.count
    return _orderModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL a = openState[section];
    if (!a) {
        
        return 0;
    }else{
     
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HandleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HANDELELL"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HandleTableViewCell" owner:nil options:nil].lastObject;
    }
    if (_orderModels.count>0) {
        cell.orderModel = _orderModels[indexPath.section];
    }
    if (openState[indexPath.section]) {
        cell.textView.text = @"";
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 145;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HandleheadView *handleHeadView = [[NSBundle mainBundle] loadNibNamed:@"HandleheadView" owner:nil options:nil].lastObject;
    handleHeadView.delegate = self;
    UIButton *quickButton = [handleHeadView viewWithTag:550];
    quickButton.tag = section;
    if (_orderModels.count>0) {
     handleHeadView.orderModel = _orderModels[section];
    }
    
    return handleHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    OrdersModel *orderModel;
    if (_orderModels.count>0) {
        orderModel = _orderModels[section];
    }
    return 150+orderModel.contentHeight;
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



#pragma mark - HandleheadViewDelegate

-(void)updateSectionOfTableView:(NSInteger)section
{
    openState[section] = !openState[section];
    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:section];
    [self reloadSections:set withRowAnimation:UITableViewRowAnimationNone];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    mycell = [self cellForRowAtIndexPath:indexPath];
    

}

-(void)setOrderModels:(NSMutableArray *)orderModels
{
    _orderModels = orderModels;

}


@end

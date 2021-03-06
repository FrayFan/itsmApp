//
//  ProblemOrderController.m
//  itsmApp
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "ProblemOrderController.h"
#import "ProblemTableViewCell.h"
#import "AppealViewController.h"
#import "GetComplainListHandle.h"
#import "UIView+Additions.h"
#import "MJRefresh.h"
#import "GraycoverPromptView.h"

@interface ProblemOrderController ()<UITableViewDelegate,UITableViewDataSource,NetworkHandleDelegate>
@property (weak, nonatomic) IBOutlet UITableView *problemTableView;
@property (strong,nonatomic) GetComplainListHandle *ordersHandle;
@property (nonatomic,strong) MJRefreshNormalHeader *normalHeader;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *normalFooter;
@property (strong,nonatomic) NSMutableArray *dataArray;//数据
@property (nonatomic,assign) BOOL upRefresh;
@property (copy,nonatomic) NSString *lastDate;
@property (copy,nonatomic) NSString *lastUpdataTime;

- (IBAction)backAction:(id)sender;//返回

@end

@implementation ProblemOrderController
{
    GraycoverPromptView *warningPromptView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRefreshNormalHeader];
    [self createRefreshAutoNormalFooter];
    [self upRefreshData];
    
    _problemTableView.backgroundColor = [UIColor clearColor];
    _problemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _problemTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _problemTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 8)];
    _problemTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
}

- (void)sendRequestWithPage:(NSString *)endTime withLastUpdataTime:(NSString *)lastUpData
{
    //发送单据列表数据请求
    _ordersHandle = [[GetComplainListHandle alloc]init];
    _ordersHandle.requestObj.p.e = endTime;
    _ordersHandle.requestObj.p.l = lastUpData;
    [_ordersHandle sendRequest];
    _ordersHandle.delegate = self;

}

- (void)createRefreshNormalHeader
{
    _normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _upRefresh = YES;
        [_dataArray removeAllObjects];
        [self sendRequestWithPage:nil withLastUpdataTime:nil];
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
    _problemTableView.mj_header = _normalHeader;
    [_normalHeader beginRefreshing];
}

//上拉加载
- (void)loadMoreData
{
    _normalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _upRefresh = NO;
        [self sendRequestWithPage:_lastDate withLastUpdataTime:_lastUpdataTime];
        
    }];
    _problemTableView.mj_footer = _normalFooter;
    
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PROBLEMCELL"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProblemTableViewCell" owner:nil options:nil].lastObject;
    }
    
    cell.orderModel = _dataArray[indexPath.row];
    if (cell.orderModel.engineerModel.engineerName != nil) {
        
        cell.scrollTextView.hidden = NO;
        
        if (cell.scrollTextView.textWidth <cell.scrollTextView.width) {
            cell.scrollTextView.contentLabel2.hidden = YES;
        }else{
            cell.scrollTextView.contentLabel2.hidden = NO;
        }

        [cell.scrollTextView startScrollWithText:[NSString stringWithFormat:@"%@ %@ %@",cell.orderModel.engineerModel.engineerDept,cell.orderModel.engineerModel.engineerName,cell.orderModel.engineerModel.engineerPhone] textColor:GrayColor font:[UIFont systemFontOfSize:13]];
        
    }else{
        cell.scrollTextView.hidden = YES;
    }
    cell.scrollTextView.contentLabel1.backgroundColor = [UIColor whiteColor];
    cell.scrollTextView.contentLabel2.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppealViewController *appealC = [[NSBundle mainBundle] loadNibNamed:@"AppealViewController" owner:nil options:nil].lastObject;
    appealC.orderModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:appealC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark - NetworkHandleDelegate

- (void)successed:(id)handle response:(id)response
{
    if (handle == _ordersHandle) {
        
        _lastDate = ((ResponseObject *)response).p.e;
        _lastUpdataTime = ((ResponseObject *)response).p.l;
        
        if (_upRefresh) {
            self.dataArray = _ordersHandle.orderModels;
        }else{
            [self.dataArray addObjectsFromArray:self.ordersHandle.orderModels];
        }
        
        if ([((ResponseObject *)response).p.t integerValue] > self.dataArray.count) {
            [self loadMoreData];
        }else{
            [_normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
        }
        
        [_problemTableView reloadData];
        [_normalHeader endRefreshing];
        [_normalFooter endRefreshing];
    }
    
}

- (void)failured:(id)handle error:(NSError *)error
{
    [_normalHeader endRefreshing];
    [_normalFooter endRefreshing];
    [self getWarningPromptViewWithText:@"加载失败" TextWidth:100];
}

- (void)getWarningPromptViewWithText:(NSString *)text TextWidth:(CGFloat)textWidth
{
    //提示输入评价内容
    warningPromptView = [[GraycoverPromptView alloc]initWithFrame:self.view.frame getWarningViewWidth:textWidth withWarningText:text];
    [UIView animateWithDuration:1.5 animations:^{
        [self.view.window addSubview:warningPromptView];
        warningPromptView.alpha = 1;
        warningPromptView.alpha = 0.9;
        warningPromptView.alpha = 0;
    }];
    
}


- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end

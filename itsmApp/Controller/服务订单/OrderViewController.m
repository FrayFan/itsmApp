//
//  OrderViewController.m
//  itsmApp
//
//  Created by itp on 2016/11/16.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "OrderViewController.h"
#import "ServiceOrderTableCell.h"
#import "SelectActionView.h"
#import "GraycoverPromptView.h"
#import "UIView+Additions.h"
#import "GetOrdersHandle.h"
#import "AssessmentController.h"
#import "MyOrderViewController.h"
#import "common.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

#define HProportion (8.0/667.0)*([[UIScreen mainScreen] bounds].size.height)

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,SelectActionViewDelegate,NetworkHandleDelegate>
@property (strong,nonatomic) MyOrderViewController *myOrderVC;
@property (strong,nonatomic) AssessmentController *assesmentVC;
@property (weak, nonatomic) IBOutlet UITableView *oderTableView;
@property (weak, nonatomic) IBOutlet UIButton *selButton;
@property (strong,nonatomic) GraycoverPromptView *grayCoverView;
@property (strong,nonatomic) GraycoverPromptView *promptLable;
@property (weak, nonatomic) IBOutlet UIButton *rightNavButton;
@property (strong,nonatomic) GetOrdersHandle *ordersHandle;
@property (assign,nonatomic) NSInteger index;
@property (copy,nonatomic) NSString *lastDate;//第一次加载返回结束时间
@property (copy,nonatomic) NSString *lastUpDataTime;//最后刷新时间
@property (strong,nonatomic) NSMutableArray *dataArray;//数据
@property (assign,nonatomic) BOOL upRefresh;

- (IBAction)allOrder:(id)sender;

@end

@implementation OrderViewController
{
    MJRefreshNormalHeader *normalHeader;
    MJRefreshAutoNormalFooter *normalFooter;
    GraycoverPromptView *warningPromptView;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SUBMITEVARELOAD" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _oderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    //提示暂无订单
    _promptLable = [[GraycoverPromptView alloc]initWithFrame:CGRectMake((KScreenWidth-150)/2, (KScreenHeight-30)/2, 150, 30) withPromptText:@"暂无此类订单"];
    _promptLable.hidden = YES;
    [self.view addSubview:_promptLable];
    
    _lastUpDataTime = nil;
    _lastDate = nil;
    _dataArray = [NSMutableArray array];
    
    [self createRefreshNormalHeader];
    [self createRefreshAutoNormalFooter];
    [self upRefreshData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"SUBMITEVARELOAD" object:nil];
}



- (void)createRefreshNormalHeader
{
    normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _upRefresh = YES;
        [_dataArray removeAllObjects];
        [self sendRequestWithPage:nil withLastUpdataTime:nil];
        
    }];
    [normalHeader setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [normalHeader setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [normalHeader setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [normalHeader setLastUpdatedTimeKey:@"上次刷新时间"];
}

- (void)createRefreshAutoNormalFooter
{
    normalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _upRefresh = NO;
        [self sendRequestWithPage:_lastDate withLastUpdataTime:_lastUpDataTime];
        
    }];
    [normalFooter setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [normalFooter setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [normalFooter setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
}

//下拉刷新
- (void)upRefreshData
{
    _oderTableView.mj_header = normalHeader;
    [normalHeader beginRefreshing];
}

//上拉加载
- (void)loadMoreData
{
    _oderTableView.mj_footer = normalFooter;
}

- (void)sendRequestWithPage:(NSString*)pageLastDate withLastUpdataTime:(NSString *)lastUPdata
{
    //发送单据列表数据请求
    _ordersHandle = [[GetOrdersHandle alloc]init];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_ordersHandle.requestObj.d];
    _ordersHandle.requestObj.p.e = pageLastDate;
    _ordersHandle.requestObj.p.l = lastUPdata;
    [tempDic setObject:[NSString stringWithFormat:@"0%ld",(long)_index]forKey:@"TS"];
    _ordersHandle.requestObj.d = tempDic;
    [_ordersHandle sendRequest];
    _ordersHandle.delegate = self;
    
}



#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordercell"];
    if (!cell) {
        cell = [[ServiceOrderTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ordercell"];
    }
    if (self.dataArray.count>0) {
        cell.ordersModel = self.dataArray[indexPath.row];
    }
    cell.CommentButton.tag = indexPath.row;
    cell.orderSource.width =cell.ordersModel.orginalTypeWidth;
    
    if ([cell.ordersModel.isAccepted integerValue]) {//工程师已接单
        
        cell.userTel.hidden = NO;
    }else{
        
        cell.userTel.hidden = YES;
    }
    
    if ((![cell.ordersModel.ticketStatus isEqualToString:@"已完成"]&&
        ![cell.ordersModel.ticketStatus isEqualToString:@"已关闭"])||
        (![cell.ordersModel.orginalType isEqualToString:@"手机APP"])) {
        
        cell.CommentButton.hidden = YES;
    }else{
        cell.CommentButton.hidden = NO;
        if ([cell.ordersModel.ticketStatus isEqualToString:@"已关闭"]) {
            [cell.CommentButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [cell.CommentButton setTitle:@"已评价" forState:UIControlStateNormal];
            [cell.CommentButton setTitleColor:BlueColor forState:UIControlStateNormal];
            cell.CommentButton.enabled = NO;
        }else{
            [cell.CommentButton setImage:[UIImage imageNamed:@"Comment_picture"] forState:UIControlStateNormal];
            [cell.CommentButton setTitle:@"评一下" forState:UIControlStateNormal];
            [cell.CommentButton setTitleColor:BlueColor forState:UIControlStateNormal];
            cell.CommentButton.enabled = YES;
        }

    }
    
    if ([cell.ordersModel.ticketStatus isEqualToString:@""]) {
        
        cell.sourceState = YES;
    }else{
        cell.sourceState = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count>0) {
        _assesmentVC.orderModel = self.dataArray[indexPath.row];
        _myOrderVC.orderModel = self.dataArray[indexPath.row];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return HProportion;
}


- (IBAction)allOrder:(id)sender {
    
    _grayCoverView = [[GraycoverPromptView alloc]initWithFrame:self.view.frame getSelectActionView:nil];
    _grayCoverView.selectActionView.delagate = self;
    [UIView animateWithDuration:.2 animations:^{
        _grayCoverView.selectActionView.alpha = 1;
        _grayCoverView.alpha = 0.5;
        _grayCoverView.alpha = 1;
        [self.view.window addSubview:_grayCoverView];
        [self.view.window insertSubview:_grayCoverView.selectActionView aboveSubview:_grayCoverView];
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeGrayCoverView)];
    [_grayCoverView addGestureRecognizer:tap];

}

#pragma mark - SelectActionViewDelegate

//移除灰色覆盖视图及状态选择视图
- (void)removeGrayCoverView
{
    [_grayCoverView removeFromSuperview];
    [_grayCoverView.selectActionView removeFromSuperview];

}

//改变导航栏右边按钮名称
- (void)changeRightButtonTitle:(NSString *)title withIndex:(NSInteger)index
{
    _index = index;
    [_rightNavButton setTitle:KUserStatus[_index] forState:UIControlStateNormal];
    [self upRefreshData];
}

#pragma mark - NetworkHandleDelegate
- (void)successed:(id)handle response:(id)response
{
    if (handle == _ordersHandle) {
        
        _lastDate = ((ResponseObject *)response).p.e;
        _lastUpDataTime = ((ResponseObject *)response).p.l;
        
        if (_upRefresh) {
            self.dataArray = _ordersHandle.orderModels;
            self.dataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
            
        }else{
            [self.dataArray addObjectsFromArray:self.ordersHandle.orderModels];
        }
        
        if ([((ResponseObject *)response).p.t integerValue] > self.dataArray.count) {
            [self loadMoreData];
        }else{
            [normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
            if (self.dataArray.count == 0) {
                [normalFooter setTitle:@"" forState:MJRefreshStateIdle];
            }
        }
        
        [_oderTableView reloadData];
        [normalHeader endRefreshing];
        [normalFooter endRefreshing];
        
    }
}

- (void)failured:(id)handle error:(NSError *)error
{
    [normalHeader endRefreshing];
    [normalFooter endRefreshing];
    [self getWarningPromptViewWithText:@"加载失败" TextWidth:100];
}

- (void)getWarningPromptViewWithText:(NSString *)text TextWidth:(CGFloat)textWidth
{
    //提示加载失败
    warningPromptView = [[GraycoverPromptView alloc]initWithFrame:self.view.frame getWarningViewWidth:textWidth withWarningText:text];
    [UIView animateWithDuration:1.5 animations:^{
        [self.view.window addSubview:warningPromptView];
        warningPromptView.alpha = 1;
        warningPromptView.alpha = 0.9;
        warningPromptView.alpha = 0;
    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
{

    if ([segue.identifier isEqualToString:@"showEvaluateController"]) {
        
        OrdersModel *orderModel = self.dataArray[sender.tag];
        _assesmentVC = segue.destinationViewController;
        _assesmentVC.orderModel = orderModel;
    }else{
        
        _myOrderVC =  segue.destinationViewController;
        
    }
    
}


- (void)refreshTableView
{
    [self upRefreshData];
}


@end

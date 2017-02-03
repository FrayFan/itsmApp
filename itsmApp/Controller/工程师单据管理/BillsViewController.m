//
//  BillsViewController.m
//  itsmApp
//
//  Created by itp on 2016/11/17.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BillsViewController.h"
#import "UIView+Additions.h"
#import "GetOrdersHandle.h"
#import "GraycoverPromptView.h"
#import "common.h"
#import "MJRefresh.h"

#define Kgap 49

@interface BillsViewController ()<UIScrollViewDelegate,NetworkHandleDelegate,AcceptTableViewDelgate,HandleTableViewDelegate,CompleteTableViewDelgate,ClosedTableViewDelgate,PausedTableViewDelgate,CancelledTableViewDelgate,SubmitPromptViewDelegate>

@property (strong,nonatomic) GraycoverPromptView *acceptedPromptView;
@property (strong,nonatomic) GraycoverPromptView *promptLable;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollButtons;//滑动按钮
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;//滑动视图
@property (nonatomic,strong) UIButton *statusButton;
@property (nonatomic,strong) GetOrdersHandle *ordersHandle;
@property (nonatomic,assign) NSInteger index;//表视图页签
@property (nonatomic,assign) BOOL upRefresh;
@property (nonatomic,copy) NSString *acceptEndTime;//结束时间
@property (nonatomic,copy) NSString *handleEndTime;
@property (nonatomic,copy) NSString *completeEndTime;
@property (nonatomic,copy) NSString *closeEndTime;
@property (nonatomic,copy) NSString *pausedEndTime;
@property (nonatomic,copy) NSString *cancelEndTime;
@property (nonatomic,copy) NSString *acceptUpdataTime;//刷新时间
@property (nonatomic,copy) NSString *handleUpdataTime;
@property (nonatomic,copy) NSString *completeUpdataTime;
@property (nonatomic,copy) NSString *closeUpdataTime;
@property (nonatomic,copy) NSString *pausedUpdataTime;
@property (nonatomic,copy) NSString *cancelUpdataTime;
@property (nonatomic,assign) NSInteger acceptOneTime;//执行一次
@property (nonatomic,assign) NSInteger handleOneTime;
@property (nonatomic,assign) NSInteger completeOneTime;
@property (nonatomic,assign) NSInteger closedOneTime;
@property (nonatomic,assign) NSInteger pausedOneTime;
@property (nonatomic,assign) NSInteger cancelledOneTime;
@property (nonatomic,strong) NSMutableArray *acceptDataArray;//数据数组
@property (nonatomic,strong) NSMutableArray *handleDataArray;
@property (nonatomic,strong) NSMutableArray *completeDataArray;
@property (nonatomic,strong) NSMutableArray *closedDataArray;
@property (nonatomic,strong) NSMutableArray *pausedDataArray;
@property (nonatomic,strong) NSMutableArray *cancelDataArray;

@end

@implementation BillsViewController{
    
    NSMutableArray *buttonArray;
    MJRefreshNormalHeader *normalHeader;
    MJRefreshAutoNormalFooter *normalFooter;
    GraycoverPromptView *warningPromptView;
    BOOL _isConneted;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddAcceptedPrompt" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshDataFromDetailVC" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 1;
    [self createSubViews];
}


- (void)createSubViews
{
    _scrollview.contentSize = CGSizeMake(6*KScreenWidth, 0);
    _scrollview.alwaysBounceHorizontal = NO;
    _scrollview.bounces = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.pagingEnabled = YES;
    _scrollview.delegate = self;
    _scrollview.tag = 1111;
    _scrollButtons.delegate =self;
    
    [_scrollview addSubview:self.acceptTableView];
    [_scrollview addSubview:self.handleTableView];
    [_scrollview addSubview:self.completeTableView];
    [_scrollview addSubview:self.closedTableView];
    [_scrollview addSubview:self.pausedTableView];
    [_scrollview addSubview:self.cancelledTableView];
    
    //添加滑动点击按钮
    buttonArray = [NSMutableArray array];
    _scrollButtons.contentSize = CGSizeMake(2*KScreenWidth, 0);
    _scrollButtons.bounces = NO;
    NSArray *buttonTitleArray =
    @[@"已受理",@"进行中",@"已处理",@"已关闭",@"待决",@"已取消"];
    for (int a = 0; a < 6; a++) {
        
        _statusButton = [[UIButton alloc]initWithFrame:CGRectMake(a*KScreenWidth/3, 0, KScreenWidth/3, _scrollButtons.height-0.5)];
        _statusButton.tag = 100 + a;
        _statusButton.backgroundColor = [UIColor whiteColor];
        [_statusButton setTitle:buttonTitleArray[a] forState:UIControlStateNormal];
        [_statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_statusButton setTitleColor:BlueColor forState:UIControlStateSelected];
        _statusButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_statusButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:_statusButton];
        [_scrollButtons addSubview:_statusButton];
        
        if (a == 0) {
            //进入页面默认选中状态
            _statusButton.selected = YES;
        }
        
        if ((a+1)%3 != 0) {
            UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/3-1, 14, 1, 20)];
            splitLine.backgroundColor = LightGrayColor;
            [_statusButton insertSubview:splitLine atIndex:0];
        }
    }
        
    //已与用户联系提示框
    _acceptedPromptView = [[GraycoverPromptView alloc]initWithFrame:self.view.frame getSubmitPromptView:@"已与用户联系" buttonTitle:@"返回首页"];
    _acceptedPromptView.submitPromptView.delegate = self;
    
    //暂无此类订单提示
    CGRect frame = CGRectMake((KScreenWidth-150)/2, (KScreenHeight-30)/2, 150, 30);
    _promptLable = [[GraycoverPromptView alloc]initWithFrame:frame  withPromptText:@"暂无此类订单"];
    _promptLable.hidden = YES;
    [self.view insertSubview:_promptLable aboveSubview:_scrollview];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataOfHandle) name:@"RefreshDataFromDetailVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAcceptedPrompt) name:@"AddAcceptedPrompt" object:nil];

}


- (void)sendBillsOrderRequestWithStatus:(NSInteger)tag withEndTime:(NSString *)endTime withLastUpDataTime:(NSString *)lastUpdata
{
    //工程师单据管理请求
    _ordersHandle = [[GetOrdersHandle alloc]init];
    NSMutableDictionary *proDic = [NSMutableDictionary dictionaryWithDictionary:_ordersHandle.requestObj.d];
    _ordersHandle.requestObj.p.e = endTime;
    _ordersHandle.requestObj.p.l = lastUpdata;
    [proDic setObject:[NSString stringWithFormat:@"0%ld",tag] forKey:@"TS"];
    [proDic setObject:@"02" forKey:@"RK"];
    _ordersHandle.requestObj.d = proDic;
    [_ordersHandle sendRequest];
    _ordersHandle.delegate = self;
}



- (void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 100:
        {
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag != button.tag) {
                    butt.selected = NO;
                }
            }
            //关联下方tableView
//            _acceptOneTime++;
            [_acceptTableView upRefreshData];
            [_scrollview setContentOffset:CGPointMake(0, -65) animated:YES];
        }
            break;
        case 101:
        {
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag != button.tag) {
                    butt.selected = NO;
                }
            }
            _handleOneTime++;
            [_scrollview setContentOffset:CGPointMake(KScreenWidth, -65) animated:YES];
            [_handleTableView upRefreshData];
            
        }
            break;
        case 102:
        {
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag != button.tag) {
                    butt.selected = NO;
                }
            }
            [_scrollview setContentOffset:CGPointMake(2*KScreenWidth, -65) animated:YES];
            [_completeTableView upRefreshData];
        }
            break;
        case 103:
        {
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag != button.tag) {
                    butt.selected = NO;
                }
            }
            [_scrollview setContentOffset:CGPointMake(3*KScreenWidth, -65) animated:YES];
            [_closedTableView upRefreshData];

        }
            break;
        case 104:
        {
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag != button.tag) {
                    butt.selected = NO;
                }
            }
            [_scrollview setContentOffset:CGPointMake(4*KScreenWidth, -65) animated:YES];
            [_pausedTableView upRefreshData];
        }
            break;
        case 105:
        {
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag != button.tag) {
                    butt.selected = NO;
                }
            }
            [_scrollview setContentOffset:CGPointMake(5*KScreenWidth, -65) animated:YES];
            [_cancelledTableView upRefreshData];

        }
            break;
            
        default:
            break;
    }
}

#pragma - mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if (scrollView.tag == 1111) {//滑动的是下方滑动视图
        //关联上方视图滑动
        if (scrollView.contentOffset.x > 2*KScreenWidth) {
            
            _scrollButtons.contentOffset= CGPointMake(KScreenWidth, 0);
        }else{
            
            _scrollButtons.contentOffset= CGPointMake(0, 0);
        }
        
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        CGFloat acceptOffsetY = _acceptTableView.contentOffset.y;
        CGFloat handleOffsetY = _handleTableView.contentOffset.y;
        CGFloat completeOffsetY = _completeTableView.contentOffset.y;
        CGFloat closedOffsetY = _closedTableView.contentOffset.y;
        CGFloat pausedOffsetY = _pausedTableView.contentOffset.y;
        CGFloat cancellOffsetY = _cancelledTableView.contentOffset.y;
        
        //关联滑动按钮选中状态
        //acceptTableView
        if (contentOffsetX == 0&&acceptOffsetY == -49) {
            UIButton *button = buttonArray[0];
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag != 100) {
                    butt.selected = NO;
                }
            }
            self.acceptDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
            if (!_isConneted) {
                _promptLable.hidden = YES;
            }
            
        }else if (contentOffsetX == 0&&acceptOffsetY!= -49){
            UIButton *button = buttonArray[0];
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag != 100) {
                    butt.selected = NO;
                }
            }
        }
        
        //handleTableView
        if (contentOffsetX == KScreenWidth&&handleOffsetY == -49){
            UIButton *button = buttonArray[1];
            if (_handleOneTime == 0) {
                [self buttonAction:button];
            }else{
                button.selected = YES;
            }

            for (UIButton *butt in buttonArray) {
                if (butt.tag !=101) {
                    butt.selected = NO;
                }
            }
            _handleOneTime++;
            self.handleDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
            if (!_isConneted) {
                _promptLable.hidden = YES;
            }
            
        }else if (contentOffsetX == KScreenWidth&&handleOffsetY!= -49){
            UIButton *button = buttonArray[1];
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=101) {
                    butt.selected = NO;
                }
            }
        }
        
        //completeTableView
        if (contentOffsetX == 2*KScreenWidth&&completeOffsetY == -49){
            UIButton *button = buttonArray[2];
            if (_completeOneTime == 0) {
                [self buttonAction:button];
            }else{
                button.selected = YES;
            }
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=102) {
                    butt.selected = NO;
                }
            }
            _completeOneTime++;
            self.completeDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
            if (!_isConneted) {
                _promptLable.hidden = YES;
            }
            
        }else if (contentOffsetX == 2*KScreenWidth&&completeOffsetY!= -49){
            UIButton *button = buttonArray[2];
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=102) {
                    butt.selected = NO;
                }
            }
        }
        
        //closedTableView
        if (contentOffsetX == 3*KScreenWidth&&closedOffsetY == -49){
            UIButton *button = buttonArray[3];
            if (_closedOneTime == 0) {
                [self buttonAction:button];
            }else{
                button.selected = YES;
            }
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=103) {
                    butt.selected = NO;
                }
            }
            _closedOneTime++;
            self.closedDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
            if (!_isConneted) {
                _promptLable.hidden = YES;
            }
            
        }else if (contentOffsetX == 3*KScreenWidth&&closedOffsetY!= -49){
            UIButton *button = buttonArray[3];
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=103) {
                    butt.selected = NO;
                }
            }
        }
        
        //pausedTableView
        if (contentOffsetX == 4*KScreenWidth&&pausedOffsetY == -49){
            UIButton *button = buttonArray[4];
            if (_pausedOneTime == 0) {
                [self buttonAction:button];
            }else{
                button.selected = YES;
            }
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=104) {
                    butt.selected = NO;
                }
            }
            _pausedOneTime++;
            self.pausedDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
            if (!_isConneted) {
                _promptLable.hidden = YES;
            }
            
        }else if (contentOffsetX == 4*KScreenWidth&&pausedOffsetY!= -49){
            UIButton *button = buttonArray[4];
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=104) {
                    butt.selected = NO;
                }
            }
        }
        
        //canceledTableView
        if (contentOffsetX == 5*KScreenWidth&&cancellOffsetY == -49){
            UIButton *button = buttonArray[5];
            if (_cancelledOneTime == 0) {
                [self buttonAction:button];
            }else{
                button.selected = YES;
            }
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=105) {
                    butt.selected = NO;
                }
            }

            _cancelledOneTime++;
            self.cancelDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
            if (!_isConneted) {
                _promptLable.hidden = YES;
            }
            
        }else if (contentOffsetX == 5*KScreenWidth&&cancellOffsetY!= -49){
            UIButton *button = buttonArray[5];
            button.selected = YES;
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=105) {
                    butt.selected = NO;
                }
            }
        }
        
    }else{//滑动的是上方滑动按钮视图，关联按钮
        
        if (scrollView.contentOffset.x == KScreenWidth) {
            UIButton *button = buttonArray[3];
            [self buttonAction:button];
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=103) {
                    butt.selected = NO;
                }
            }
        }else if (scrollView.contentOffset.x == 0){
            
            UIButton *button = buttonArray[1];
            [self buttonAction:button];
            for (UIButton *butt in buttonArray) {
                if (butt.tag !=101) {
                    butt.selected = NO;
                }
            }

        }
    }
}


//加载多个tableView
- (AcceptTableView *)acceptTableView
{
    if (!_acceptTableView) {
        
        AcceptTableView *acceptTable = [[AcceptTableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        acceptTable.backgroundColor = LightGrayColor;
        self.acceptTableView = (AcceptTableView*)acceptTable;
        _acceptTableView.refreshDelegate = self;
        
    }
    
    return _acceptTableView;
}


- (HandleTableView *)handleTableView
{
    if (!_handleTableView) {
        
        HandleTableView *handleTable = [[HandleTableView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight)  style:UITableViewStyleGrouped];
        handleTable.backgroundColor = LightGrayColor;
        self.handleTableView = (HandleTableView *)handleTable;
        _handleTableView.refreshDelegate = self;
    }
    
    return _handleTableView;
}

- (CompleteTableView *)completeTableView
{
    if (!_completeTableView) {
        
        CompleteTableView *completeTable = [[CompleteTableView alloc]initWithFrame:CGRectMake(2*KScreenWidth, 0, KScreenWidth, KScreenHeight)  style:UITableViewStyleGrouped];
        completeTable.backgroundColor = LightGrayColor;
        self.completeTableView = (CompleteTableView *)completeTable;
        _completeTableView.refreshDelegate = self;
        
    }
    
    return _completeTableView;
}


- (ClosedTabbleView *)closedTableView
{
    if (!_closedTableView) {
        
        ClosedTabbleView *closedTable = [[ClosedTabbleView alloc]initWithFrame:CGRectMake(3*KScreenWidth, 0, KScreenWidth, KScreenHeight)  style:UITableViewStyleGrouped];
        closedTable.backgroundColor = LightGrayColor;
        self.closedTableView = (ClosedTabbleView *)closedTable;
        _closedTableView.refreshDelegate = self;
    }
    
    return _closedTableView;
}

- (PausedTableView *)pausedTableView
{
    if (!_pausedTableView) {
        
        PausedTableView *pausedTable = [[PausedTableView alloc]initWithFrame:CGRectMake(4*KScreenWidth, 0, KScreenWidth, KScreenHeight)  style:UITableViewStyleGrouped];
        pausedTable.backgroundColor = LightGrayColor;
        self.pausedTableView = (PausedTableView *)pausedTable;
        _pausedTableView.refreshDelegate = self;
    }
    
    return _pausedTableView;
}

- (CancelledTableView *)cancelledTableView
{
    if (!_cancelledTableView) {
        
        CancelledTableView *cancelledTable = [[CancelledTableView alloc]initWithFrame:CGRectMake(5*KScreenWidth, 0, KScreenWidth, KScreenHeight)  style:UITableViewStyleGrouped];
        cancelledTable.backgroundColor = LightGrayColor;
        self.cancelledTableView = (CancelledTableView *)cancelledTable;
        _cancelledTableView.refreshDelegate = self;
    }
    
    return _cancelledTableView;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *clearView = [self.view viewWithTag:1001];
    [clearView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVECLEARVIEW" object:nil];
}

#pragma mark - NetworkHandleDelegate
- (void)successed:(id)handle response:(id)response
{
    if (handle == _ordersHandle) {
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_ordersHandle.requestObj.d];
        NSString *tag = [tempDic valueForKey:@"TS"];
        
        switch ([tag integerValue]) {
            case 01:
            {
                _acceptEndTime = ((ResponseObject *)response).p.e;
                _acceptUpdataTime = ((ResponseObject *)response).p.l;
                if (_upRefresh) {
                    
                    self.acceptDataArray = _ordersHandle.orderModels;
                }else{
                    [self.acceptDataArray addObjectsFromArray:self.ordersHandle.orderModels];
                }
                if ([((ResponseObject *)response).p.t integerValue] > self.acceptDataArray.count) {
                    [_acceptTableView loadMoreData];
                }else{
                    [_acceptTableView.normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
                    if (self.acceptDataArray.count == 0) {
                        [normalFooter setTitle:@"" forState:MJRefreshStateIdle];
                    }

                }
                
                _acceptTableView.orderModels = self.acceptDataArray;
                self.acceptDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
                [_acceptTableView reloadData];
                [_acceptTableView.normalHeader endRefreshing];
                [_acceptTableView.normalFooter endRefreshing];

            }
                break;
            case 02:
            {
                _handleEndTime = ((ResponseObject *)response).p.e;
                _handleUpdataTime = ((ResponseObject *)response).p.l;
                if (_upRefresh) {
                    self.handleDataArray = _ordersHandle.orderModels;
                }else{
                    [self.handleDataArray addObjectsFromArray:self.ordersHandle.orderModels];
                }
                if ([((ResponseObject *)response).p.t integerValue] > self.handleDataArray.count) {
                    [_handleTableView loadMoreData];
                }else{
                    [_handleTableView.normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
                    if (self.handleDataArray.count == 0) {
                        [normalFooter setTitle:@"" forState:MJRefreshStateIdle];
                    }

                }
                
                _handleTableView.orderModels = self.handleDataArray;
                [_handleTableView reloadData];
                self.handleDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
                [_handleTableView.normalHeader endRefreshing];
                [_handleTableView.normalFooter endRefreshing];
    

            }
                break;
            case 03:
            {
                _completeEndTime = ((ResponseObject *)response).p.e;
                _completeUpdataTime = ((ResponseObject *)response).p.l;
                if (_upRefresh) {
                    
                    self.completeDataArray = _ordersHandle.orderModels;
                }else{
                    [self.completeDataArray addObjectsFromArray:self.ordersHandle.orderModels];
                }
                if ([((ResponseObject *)response).p.t integerValue] > self.completeDataArray.count) {
                    [_completeTableView loadMoreData];
                }else{
                    [_completeTableView.normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
                    if (self.completeDataArray.count == 0) {
                        [normalFooter setTitle:@"" forState:MJRefreshStateIdle];
                    }

                }
                
                _completeTableView.orderModels = self.completeDataArray;
                self.completeDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
                [_completeTableView reloadData];
                [_completeTableView.normalHeader endRefreshing];
                [_completeTableView.normalFooter endRefreshing];

            }
                break;
            case 04:
            {
                _closeEndTime = ((ResponseObject *)response).p.e;
                _closeUpdataTime = ((ResponseObject *)response).p.l;
                if (_upRefresh) {
                    
                    self.closedDataArray = _ordersHandle.orderModels;
                }else{
                    [self.closedDataArray addObjectsFromArray:self.ordersHandle.orderModels];
                }
                if ([((ResponseObject *)response).p.t integerValue] > self.closedDataArray.count) {
                    [_closedTableView loadMoreData];
                }else{
                    [_closedTableView.normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
                    if (self.closedDataArray.count == 0) {
                        [normalFooter setTitle:@"" forState:MJRefreshStateIdle];
                    }

                }
                
                _closedTableView.orderModels = self.closedDataArray;
                self.closedDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
                [_closedTableView reloadData];
                [_closedTableView.normalHeader endRefreshing];
                [_closedTableView.normalFooter endRefreshing];

            }
                break;
            case 05:
            {
                _pausedEndTime = ((ResponseObject *)response).p.e;
                _pausedUpdataTime = ((ResponseObject *)response).p.l;
                if (_upRefresh) {
                    
                    self.pausedDataArray = _ordersHandle.orderModels;
                }else{
                    [self.pausedDataArray addObjectsFromArray:self.ordersHandle.orderModels];
                }
                if ([((ResponseObject *)response).p.t integerValue] > self.pausedDataArray.count) {
                    [_pausedTableView loadMoreData];
                }else{
                    [_pausedTableView.normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
                    if (self.pausedDataArray.count == 0) {
                        [normalFooter setTitle:@"" forState:MJRefreshStateIdle];
                    }

                }
                
                _pausedTableView.orderModels = self.pausedDataArray;
               self.pausedDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
                [_pausedTableView reloadData];
                [_pausedTableView.normalHeader endRefreshing];
                [_pausedTableView.normalFooter endRefreshing];

            }
                break;
            default:
            {
                _cancelEndTime = ((ResponseObject *)response).p.e;
                _cancelUpdataTime = ((ResponseObject *)response).p.l;
                if (_upRefresh) {
                    
                    self.cancelDataArray = _ordersHandle.orderModels;
                }else{
                    [self.cancelDataArray addObjectsFromArray:self.ordersHandle.orderModels];
                }
                if ([((ResponseObject *)response).p.t integerValue] > self.cancelDataArray.count) {
                    [_cancelledTableView loadMoreData];
                }else{
                    [_cancelledTableView.normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
                    if (self.cancelDataArray.count == 0) {
                        [normalFooter setTitle:@"" forState:MJRefreshStateIdle];
                    }

                }
                
                _cancelledTableView.orderModels = self.cancelDataArray;
                self.cancelDataArray.count>0?(_promptLable.hidden = YES):(_promptLable.hidden = NO);
                [_cancelledTableView reloadData];
                [_cancelledTableView.normalHeader endRefreshing];
                [_cancelledTableView.normalFooter endRefreshing];
    

            }
                break;
        }
        
    }
}

- (void)failured:(id)handle error:(NSError *)error
{
    [_acceptTableView.normalHeader endRefreshing];
    [_acceptTableView.normalFooter endRefreshing];
    [_handleTableView.normalHeader endRefreshing];
    [_handleTableView.normalFooter endRefreshing];
    [_completeTableView.normalHeader endRefreshing];
    [_completeTableView.normalFooter endRefreshing];
    [_closedTableView.normalHeader endRefreshing];
    [_closedTableView.normalFooter endRefreshing];
    [_pausedTableView.normalHeader endRefreshing];
    [_pausedTableView.normalFooter endRefreshing];
    [_cancelledTableView.normalHeader endRefreshing];
    [_cancelledTableView.normalFooter endRefreshing];
    [self getWarningPromptViewWithText:@"加载失败" TextWidth:100];
    _isConneted = NO;
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



#pragma mark - AcceptTableViewDelgate
- (void)acceptTableViewIsUpRefreshData:(BOOL)refreshBool
{
    _upRefresh = refreshBool;
    if (_upRefresh == YES) {
        _acceptEndTime = nil;
        _acceptUpdataTime = nil;
        [self.acceptDataArray removeAllObjects];
    }
    [self sendBillsOrderRequestWithStatus:1 withEndTime:_acceptEndTime withLastUpDataTime:_acceptUpdataTime];

}

#pragma mark - HandleTableViewDelegate
- (void)handleTableViewIsUpRefreshData:(BOOL)refreshBool
{
    _upRefresh = refreshBool;
    if (_upRefresh == YES) {
        _handleEndTime = nil;
        _handleUpdataTime = nil;
        [self.handleDataArray removeAllObjects];
    }
    [self sendBillsOrderRequestWithStatus:2 withEndTime:_handleEndTime withLastUpDataTime:_handleUpdataTime];

}

#pragma mark - completeTableViewDelegate
- (void)completeTableViewIsUpRefreshData:(BOOL)refreshBool
{
    _upRefresh = refreshBool;
    if (_upRefresh == YES) {
        _completeEndTime = nil;
        _completeUpdataTime = nil;
        [self.completeDataArray removeAllObjects];
    }
    [self sendBillsOrderRequestWithStatus:3 withEndTime:_completeEndTime withLastUpDataTime:_completeUpdataTime];
}

#pragma mark - closedTableViewDelegate
- (void)closedTableViewIsUpRefreshData:(BOOL)refreshBool
{
    _upRefresh = refreshBool;
    if (_upRefresh == YES) {
        _closeEndTime = nil;
        _closeUpdataTime = nil;
        [self.closedDataArray removeAllObjects];
    }
    [self sendBillsOrderRequestWithStatus:4 withEndTime:_closeEndTime withLastUpDataTime:_closeUpdataTime];
}

#pragma mark - pausedTableViewDelegate
- (void)pausedTableViewIsUpRefreshData:(BOOL)refreshBool
{
    _upRefresh = refreshBool;
    if (_upRefresh == YES) {
        _pausedEndTime = nil;
        _pausedUpdataTime = nil;
        [self.pausedDataArray removeAllObjects];
    }
    [self sendBillsOrderRequestWithStatus:5 withEndTime:_pausedEndTime withLastUpDataTime:_pausedUpdataTime];
}

#pragma mark - cancelledTableViewDelegate
- (void)cancelledTableViewIsUpRefreshData:(BOOL)refreshBool
{
    _upRefresh = refreshBool;
    if (_upRefresh == YES) {
        _cancelEndTime = nil;
        _cancelUpdataTime = nil;
        [self.cancelDataArray removeAllObjects];
    }
    [self sendBillsOrderRequestWithStatus:6 withEndTime:_cancelEndTime withLastUpDataTime:_cancelUpdataTime];
}

//提交解决返回刷新handleTableView
-(void)refreshDataOfHandle
{
    [_scrollview setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
    [_handleTableView upRefreshData];
}

#pragma mark - SubmitPromptViewDelegate
- (void)removeSubmitPromptView
{
    [_acceptedPromptView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addAcceptedPrompt
{
    [self.view.window addSubview:_acceptedPromptView];
}


@end

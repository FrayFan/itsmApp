//
//  MyFeedbackController.m
//  itsmApp
//
//  Created by admin on 2016/12/25.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "MyFeedbackController.h"
#import "MyFeedbackCell.h"
#import "MyFBDetailController.h"
#import "GetFeedbackHandle.h"
#import "MJRefresh.h"
#import "common.h"
#import "GraycoverPromptView.h"

@interface MyFeedbackController ()<UITableViewDelegate,UITableViewDataSource,NetworkHandleDelegate>
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong,nonatomic) GetFeedbackHandle *feedBackHandle;
@property (nonatomic,strong) MJRefreshNormalHeader *normalHeader;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *normalFooter;
@property (assign,nonatomic) NSInteger pNO;
@property (assign,nonatomic) BOOL upRefresh;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (copy,nonatomic) NSString *lastDate;

@end

@implementation MyFeedbackController
{
    GraycoverPromptView *warningPromptView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myTableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    _myTableView.backgroundColor = LightGrayColor;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _pNO = 1;
    [self createRefreshNormalHeader];
    [self createRefreshAutoNormalFooter];
    [self upRefreshData];
    
}

- (void)sendRequestWithPage:(NSString*)pageLastDate withPNO:(NSInteger)pNO
{
    //发送请求
    _feedBackHandle = [[GetFeedbackHandle alloc]init];
    _feedBackHandle.requestObj.p.e = pageLastDate;
    _feedBackHandle.requestObj.p.pno = pNO;
    [_feedBackHandle sendRequest];
    _feedBackHandle.delegate = self;
    
}

- (void)createRefreshNormalHeader
{
    _normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _upRefresh = YES;
        [_dataArray removeAllObjects];
        [self sendRequestWithPage:nil withPNO:0];
        
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
    _myTableView.mj_header = _normalHeader;
    [_normalHeader beginRefreshing];
}

//上拉加载
- (void)loadMoreData
{
    _normalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _upRefresh = NO;
        [self sendRequestWithPage:_lastDate withPNO:_pNO];
        
    }];
    _myTableView.mj_footer = _normalFooter;
    
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYFEEDBACK"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyFeedbackCell" owner:nil options:nil].lastObject;
    }
    cell.listCell = YES;
    CGRect cellFrame = cell.frame;
    cellFrame.size.height += HProportion;
    [cell setFrame:cellFrame];
    
    cell.feedBackModel = _dataArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFBDetailController *myFBVC = [[NSBundle mainBundle] loadNibNamed:@"MyFBDetailController" owner:nil options:nil].lastObject;
    [self.navigationController pushViewController:myFBVC animated:YES];
    myFBVC.FBModel = _dataArray[indexPath.row];
}


#pragma mark - NetworkHandleDelegate
- (void)successed:(id)handle response:(id)response
{
    if (handle == _feedBackHandle) {
        _lastDate = ((ResponseObject *)response).p.e;
        _pNO++;
        
        if (_upRefresh) {
            self.dataArray = _feedBackHandle.myFBModels;
        }else{
            [self.dataArray addObjectsFromArray:self.feedBackHandle.myFBModels];
        }
        
        if ([((ResponseObject *)response).p.t integerValue] > self.dataArray.count) {
            [self loadMoreData];
        }else{
            [_normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
        }
        
        [_myTableView reloadData];
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

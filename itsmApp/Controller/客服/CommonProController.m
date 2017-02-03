//
//  CommonProController.m
//  itsmApp
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "CommonProController.h"
#import "CommonProblemCell.h"
#import "CommonDetailController.h"
#import "GetFAQListHandle.h"
#import "common.h"
#import "MJRefresh.h"
#import "GraycoverPromptView.h"

@interface CommonProController ()<UITableViewDelegate,UITableViewDataSource,NetworkHandleDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) GetFAQListHandle *FAQHandle;
@property (nonatomic,strong) MJRefreshNormalHeader *normalHeader;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *normalFooter;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (copy,nonatomic) NSString *lastDate;
@property (assign,nonatomic) NSInteger pNO;
@property (nonatomic,assign) BOOL upRefresh;
- (IBAction)backAction:(id)sender;//返回

@end

@implementation CommonProController
{
    UITableView *commonTableView;
    GraycoverPromptView *warningPromptView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pNO = 1;
    [self createRefreshNormalHeader];
    [self createRefreshAutoNormalFooter];
    [self upRefreshData];
    
    commonTableView = [self.view viewWithTag:770];
    commonTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    commonTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    commonTableView.tableHeaderView.backgroundColor = LightGrayColor;
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 150, 13)];
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor grayColor];
    title.text = @"请选择遇到的问题";
    commonTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [commonTableView.tableHeaderView addSubview:title];
}

- (void)sendRequestWithPage:(NSString*)pageLastDate withPNO:(NSInteger)pNO
{
    //发送请求
    _FAQHandle = [[GetFAQListHandle alloc]init];
    _FAQHandle.requestObj.p.e = pageLastDate;
    _FAQHandle.requestObj.p.psize = 13;
    _FAQHandle.requestObj.p.pno = pNO;
    [_FAQHandle sendRequest];
    _FAQHandle.delegate = self;
    
}

- (void)createRefreshNormalHeader
{
    _normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _upRefresh = YES;
        [_dataArray removeAllObjects];
        [self sendRequestWithPage:nil withPNO:1];
        
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
    _tableView.mj_header = _normalHeader;
    [_normalHeader beginRefreshing];
}

//上拉加载
- (void)loadMoreData
{
    _normalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _upRefresh = NO;
        [self sendRequestWithPage:_lastDate withPNO:_pNO];
        
    }];
    _tableView.mj_footer = _normalFooter;
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonProblemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"COMMONPROBLEMCELL"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CommonProblemCell" owner:nil options:nil].lastObject;
        FAQListModel *FAQModel = _dataArray[indexPath.row];
        cell.textLabel.text = FAQModel.FAQTitle;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonDetailController *commondetailC = [[NSBundle mainBundle] loadNibNamed:@"CommonDetailController" owner:nil options:nil].lastObject;
    commondetailC.FAQlistModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:commondetailC animated:YES];
    
}

#pragma mark - NetworkHandleDelegate

- (void)successed:(id)handle response:(id)response
{
    if (handle == _FAQHandle) {
        _lastDate = ((ResponseObject *)response).p.e;
        
        if (_upRefresh) {
            self.dataArray = _FAQHandle.FAQModels;
        }else{
            [self.dataArray addObjectsFromArray:self.FAQHandle.FAQModels];
        }
        
        if ([((ResponseObject *)response).p.t integerValue] > self.dataArray.count) {
            
            [self loadMoreData];
        }else{
            [_normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
        }
        _pNO++;
        [_tableView reloadData];
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

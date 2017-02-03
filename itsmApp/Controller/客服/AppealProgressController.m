//
//  AppealProgressController.m
//  itsmApp
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "AppealProgressController.h"
#import "ProgressTableViewCell.h"
#import "ProgressHeadView.h"
#import "GetComplainHandle.h"
#import "GetComProcessHandle.h"
#import "MJRefresh.h"
#import "GraycoverPromptView.h"

@interface AppealProgressController ()<UITableViewDelegate,UITableViewDataSource,ProgressHeadViewDelegate,NetworkHandleDelegate>

@property (weak, nonatomic) IBOutlet UITableView *progressTableView;
@property (nonatomic,strong) ProgressHeadView *headView;
@property (nonatomic,strong) GetComplainHandle *complainHandle;
@property (nonatomic,strong) GetComProcessHandle *comProcessHandle;
@property (nonatomic,strong) MJRefreshNormalHeader *normalHeader;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *normalFooter;
@property (strong,nonatomic) NSMutableArray *dataArray;//数据
@property (nonatomic,assign) BOOL upRefresh;
@property (copy,nonatomic) NSString *lastDate;
@property (copy,nonatomic) NSString *lastUpDataTime;


- (IBAction)backAction:(id)sender;//返回
@end

@implementation AppealProgressController
{
    BOOL openState[100];
    NSInteger newSection;
    GraycoverPromptView *warningPromptView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRefreshNormalHeader];
    [self createRefreshAutoNormalFooter];
    [self upRefreshData];
    
    _progressTableView = [self.view viewWithTag:550];
    _progressTableView.backgroundColor = LightGrayColor;
    _progressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _progressTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _progressTableView.sectionFooterHeight = 0.0;
}

- (void)sendRequestWithPage:(NSString *)endTime withLastUpDataTime:(NSString *)lastUpData
{
    //发送投诉单列表请求
    _complainHandle = [[GetComplainHandle alloc]init];
    _complainHandle.requestObj.p.e = endTime;
    _complainHandle.requestObj.p.l = lastUpData;
    [_complainHandle sendRequest];
    _complainHandle.delegate = self;
    
}

- (void)createRefreshNormalHeader
{
    _normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _upRefresh = YES;
        [_dataArray removeAllObjects];
        [self sendRequestWithPage:nil withLastUpDataTime:nil];
    }];
    [_normalHeader setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [_normalHeader setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [_normalHeader setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [_normalHeader setLastUpdatedTimeKey:@"上次刷新时间"];
    _progressTableView.mj_header = _normalHeader;
    [_normalHeader beginRefreshing];
    
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
    _progressTableView.mj_header = _normalHeader;
    [_normalHeader beginRefreshing];
}

//上拉加载
- (void)loadMoreData
{
    _normalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _upRefresh = NO;
        [self sendRequestWithPage:_lastDate withLastUpDataTime:_lastUpDataTime];
        
    }];
    _progressTableView.mj_footer = _normalFooter;
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _complainHandle.complainModels.count;
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
    ProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PROGRESSCELL"];
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProgressTableViewCell" owner:nil options:nil].lastObject;
    }
    if (_complainHandle.complainModels.count>0) {
        cell.comProcessModel = _comProcessHandle.comProcessModels[indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 125;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headView = [[NSBundle mainBundle] loadNibNamed:@"ProgressHeadView" owner:nil options:nil].lastObject;
    _headView.button.tag = section;
    _headView.delegate = self;
    
    ComplainModel *complainModel = _complainHandle.complainModels[section];
    _headView.complainModel = complainModel;
    
    return _headView;
}

#pragma mark - ProgressHeadViewDelegatef

-(void)openProgressViewForSection:(NSInteger)section
{
    newSection = section;
    openState[section] = !openState[section];
    
    //发送投诉进度查询详情请求
    ComplainModel *complainModel = _complainHandle.complainModels[section];
    _comProcessHandle = [[GetComProcessHandle alloc]init];
    NSMutableDictionary *proDic = [NSMutableDictionary dictionaryWithDictionary:_comProcessHandle.requestObj.d];
    [proDic setObject:complainModel.receiptId forKey:@"RID"];
    _comProcessHandle.requestObj.d = proDic;
    [_comProcessHandle sendRequest];
    _comProcessHandle.delegate = self;
    
}

#pragma mark - NetworkHandleDelegate
- (void)successed:(id)handle response:(id)response
{
    if (handle == _complainHandle) {
        _lastDate = ((ResponseObject *)response).p.e;
        _lastUpDataTime = ((ResponseObject *)response).p.l;
        
        if (_upRefresh) {
            self.dataArray = _complainHandle.complainModels;
        }else{
            [self.dataArray addObjectsFromArray:self.complainHandle.complainModels];
        }
        
        if ([((ResponseObject *)response).p.t integerValue] > self.dataArray.count) {
            [self loadMoreData];
        }else{
            [_normalFooter setTitle:@"无更多数据" forState:MJRefreshStateIdle];
        }
        
        [_progressTableView reloadData];
        [_normalHeader endRefreshing];
        [_normalFooter endRefreshing];
        
    }
    
    if (handle == _comProcessHandle) {

        NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:newSection];
        [_progressTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        
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
